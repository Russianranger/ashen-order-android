#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

enum TouchOfTheMagiSpells
{
    SPELL_TOUCH_OF_THE_MAGI_AURA = 844457,
    SPELL_TOUCH_OF_THE_MAGI_EXPLOSION = 844461
};

class spell_touch_of_the_magi_aura : public AuraScript
{
    PrepareAuraScript(spell_touch_of_the_magi_aura);

private:
    int32 damageTaken = 1; // Tracks accumulated damage during the aura

public:
    void HandleProc(AuraEffect const* /*aurEff*/, ProcEventInfo& eventInfo)
    {
        DamageInfo* damageInfo = eventInfo.GetDamageInfo();
        Unit* caster = GetCaster();
        Unit* target = GetTarget();

        if (caster && target && damageInfo)
        {
            // Accumulate damage dealt by the caster to the target
            if (damageInfo->GetAttacker() == caster && damageInfo->GetVictim() == target)
            {
                int32 damage = damageInfo->GetDamage();
                damageTaken += damage;

                LOG_ERROR("spells", "Touch of the Magi: Accumulated {} damage. Total: {}.", damage, damageTaken);
            }
        }
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Unit* caster = GetCaster();
        Unit* target = GetTarget();

        if (!caster || !target)
            return;

        // Retrieve the accumulated damage from the AuraEffect
        if (AuraEffect* effect = GetAura()->GetEffect(EFFECT_0))
        {
            int32 totalDamage = effect->GetAmount();

            if (totalDamage > 0)
            {
                caster->CastCustomSpell(target, SPELL_TOUCH_OF_THE_MAGI_EXPLOSION, &totalDamage, nullptr, nullptr, true);

                // Convert ObjectGuid to string and log properly
                LOG_ERROR("spells", "Touch of the Magi: Exploded for {} damage by caster {}.",
                    totalDamage, caster->GetGUID().ToString());
            }
            else
            {
                LOG_ERROR("spells", "Touch of the Magi: No accumulated damage to explode for caster {}.",
                    caster->GetGUID().ToString());
            }
        }
        else
        {
            LOG_ERROR("spells", "Touch of the Magi: AuraEffect not found at removal.");
        }
    }

    void Register() override
    {
        OnEffectProc += AuraEffectProcFn(spell_touch_of_the_magi_aura::HandleProc, EFFECT_0, SPELL_AURA_DUMMY);
        AfterEffectRemove += AuraEffectRemoveFn(spell_touch_of_the_magi_aura::AfterRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

class player_learn_icicle_spells : public PlayerScript
{
public:
    player_learn_icicle_spells() : PlayerScript("player_learn_icicle_spells") { }

    void OnLearnSpell(Player* player, uint32 spellId) override
    {
        std::unordered_set<uint32> triggerSpells = { 44572 };

        if (triggerSpells.find(spellId) != triggerSpells.end())
        {
            uint8 playerLevel = player->getLevel();

            if (playerLevel <= 69)
            {
                if (!player->HasSpell(100241))
                {
                    player->learnSpell(100241, false);
                }
            }
            else if (playerLevel >= 70 && playerLevel <= 77)
            {
                if (!player->HasSpell(100242))
                {
                    player->learnSpell(100242, false);
                }
            }
            else if (playerLevel >= 78 && playerLevel <= 80)
            {
                if (!player->HasSpell(100243))
                {
                    player->learnSpell(100243, false);
                }
            }
        }
    }
};

class spell_icicles_validator : public SpellScriptLoader
{
public:
    spell_icicles_validator() : SpellScriptLoader("spell_icicles_validator") { }

    class spell_icicles_validator_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_icicles_validator_SpellScript);

        void HandleAfterCast()
        {
            Unit* caster = GetCaster();
            if (caster && caster->IsPlayer())
            {
                Player* player = caster->ToPlayer();
                if (Aura* aura = player->GetAura(100240))
                {
                    uint8 stackCount = aura->GetStackAmount();
                    if (stackCount > 5)
                    {
                        player->CastSpell(player, 801240, true);

                        player->RemoveAura(100240);
                    }
                }
            }
        }

        void Register() override
        {
            AfterCast += SpellCastFn(spell_icicles_validator_SpellScript::HandleAfterCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_icicles_validator_SpellScript();
    }
};

class spell_mage_arcane_barrage : public SpellScript
{
    PrepareSpellScript(spell_mage_arcane_barrage);

    void HandleOnHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!caster || !target)
            return;

        // Increase damage by 50% if target is at or below 35% health
        if (target->GetHealthPct() <= 35.0f)
        {
            int32 damage = GetHitDamage();
            damage += CalculatePct(damage, 50);
            SetHitDamage(damage);

            LOG_INFO("spells", "Arcane Barrage: Increased damage to {} for low health target.", damage);
        }

        // Add damage to Touch of the Magi pool if aura is present
        if (Aura* aura = target->GetAura(SPELL_TOUCH_OF_THE_MAGI_AURA, caster->GetGUID()))
        {
            // Double-check the caster GUID
            if (aura->GetCasterGUID() != caster->GetGUID())
                return;

            if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
            {
                // 75% of the damage
                int32 partialDamage = CalculatePct(GetHitDamage(), 75);

                int32 damagePool = effect->GetAmount();
                damagePool += partialDamage;
                effect->SetAmount(damagePool);

            }
        }
    }

    void Register() override
    {
        OnHit += SpellHitFn(spell_mage_arcane_barrage::HandleOnHit);
    }
};

class spell_mage_arcane_blast : public SpellScript
{
    PrepareSpellScript(spell_mage_arcane_blast);

    bool Load() override
    {
        _triggerSpellId = 0;
        return true;
    }

    void HandleTriggerSpell(SpellEffIndex effIndex)
    {
        _triggerSpellId = GetSpellInfo()->Effects[effIndex].TriggerSpell;
        PreventHitDefaultEffect(effIndex);
    }

    void HandleAfterHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!caster || !target)
            return;

        // Check if the target has the Touch of the Magi aura
        if (Aura* aura = target->GetAura(SPELL_TOUCH_OF_THE_MAGI_AURA, caster->GetGUID()))
        {
            // Double-check the caster GUID
            if (aura->GetCasterGUID() != caster->GetGUID())
                return;

            if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
            {
                // 75% of the damage
                int32 partialDamage = CalculatePct(GetHitDamage(), 75);

                int32 damagePool = effect->GetAmount();
                damagePool += partialDamage;
                effect->SetAmount(damagePool);

            }
        }
    }

    void HandleAfterCast()
    {
        // Original functionality: Trigger any additional effects
        if (_triggerSpellId)
            GetCaster()->CastSpell(GetCaster(), _triggerSpellId, TRIGGERED_FULL_MASK);
    }

    // Handle healing the caster for 15% of the damage done
    void HandleHealCaster(SpellEffIndex /*effIndex*/)
    {
        if (Unit* caster = GetCaster())
        {
            if (Unit* target = GetHitUnit())
            {
                // Get the actual damage done by this effect
                int32 damageDone = GetHitDamage();
                if (damageDone > 0)
                {
                    // Calculate 15% of damage done
                    int32 healAmount = CalculatePct(damageDone, 15);
                    // Cast the heal on the caster using spell ID 888824
                    caster->CastCustomSpell(caster, 888824, &healAmount, nullptr, nullptr, true);
                }
            }
        }
    }

    void Register() override
    {
        OnEffectLaunch += SpellEffectFn(spell_mage_arcane_blast::HandleTriggerSpell, EFFECT_1, SPELL_EFFECT_TRIGGER_SPELL);
        AfterHit += SpellHitFn(spell_mage_arcane_blast::HandleAfterHit);
        AfterCast += SpellCastFn(spell_mage_arcane_blast::HandleAfterCast);
        OnEffectHitTarget += SpellEffectFn(spell_mage_arcane_blast::HandleHealCaster, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }

private:
    uint32 _triggerSpellId;
};

class spell_mage_arcane_missiles : public SpellScript
{
    PrepareSpellScript(spell_mage_arcane_missiles);

    void HandleAfterHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!caster || !target)
            return;

        // Check if the target has Touch of the Magi aura
        if (Aura* aura = target->GetAura(SPELL_TOUCH_OF_THE_MAGI_AURA, caster->GetGUID()))
        {
            if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
            {
                // No direct damage handling here; delegate to the triggered spell. Dinkle: Idk why you made this script, Belgarth
                LOG_INFO("spells", "Arcane Missiles hit the target, delegating damage tracking to triggered spell.");
            }
        }
    }

    void Register() override
    {
        AfterHit += SpellHitFn(spell_mage_arcane_missiles::HandleAfterHit);
    }
};

class spell_mage_arcane_missiles_damage : public SpellScript
{
    PrepareSpellScript(spell_mage_arcane_missiles_damage);

    void HandleAfterHit()
    {
        Unit* caster = GetCaster();
        Unit* target = GetHitUnit();

        if (!caster || !target)
            return;

        // Check if the target has Touch of the Magi aura
        if (Aura* aura = target->GetAura(SPELL_TOUCH_OF_THE_MAGI_AURA, caster->GetGUID()))
        {
            // Double-check the caster GUID
            if (aura->GetCasterGUID() != caster->GetGUID())
                return;

            if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
            {
                // 75% of the damage
                int32 partialDamage = CalculatePct(GetHitDamage(), 75);

                int32 damagePool = effect->GetAmount();
                damagePool += partialDamage;
                effect->SetAmount(damagePool);

            }
        }
    }

    void Register() override
    {
        AfterHit += SpellHitFn(spell_mage_arcane_missiles_damage::HandleAfterHit);
    }
};

void AddSC_spell_touch_of_the_magi()
{
    RegisterSpellScript(spell_touch_of_the_magi_aura);
    new player_learn_icicle_spells();
    new spell_icicles_validator();
    RegisterSpellScript(spell_mage_arcane_barrage);
    RegisterSpellScript(spell_mage_arcane_blast);
    RegisterSpellScript(spell_mage_arcane_missiles);
    RegisterSpellScript(spell_mage_arcane_missiles_damage);
}
