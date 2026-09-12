#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "Unit.h"

class spell_warr_thunderclap : public SpellScriptLoader
{
public:
    spell_warr_thunderclap() : SpellScriptLoader("spell_warr_thunderclap") { }

    class spell_warr_thunderclap_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_warr_thunderclap_SpellScript);

        void HandleOnHit()
        {
            Unit* caster = GetCaster();
            Unit* target = GetHitUnit();

            if (!caster || !target)
                return;

            int32 thunderclapDamage = GetHitDamage();

            float scalingFactor = 0.0f;
            //Imp Thunder Clap
            if (caster->HasAura(12287)) // First rank
                scalingFactor = 0.10f;  // 10% of Thunderclap's damage

            if (caster->HasAura(12665)) // Second rank
                scalingFactor = 0.20f;  // 20% of Thunderclap's damage

            if (caster->HasAura(12666)) // Third rank
                scalingFactor = 0.30f;  // 30% of Thunderclap's damage

            if (scalingFactor > 0.0f)
            {
                int32 totalDotDamage = int32(thunderclapDamage * scalingFactor);

                int32 damagePerTick = totalDotDamage / 3;

                caster->CastCustomSpell(target, 864930, &damagePerTick, nullptr, nullptr, true);
            }
        }

        void Register() override
        {
            OnHit += SpellHitFn(spell_warr_thunderclap_SpellScript::HandleOnHit);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_warr_thunderclap_SpellScript();
    }
};

class spell_warr_ubreakable_will_trigger : public SpellScriptLoader
{
public:
    spell_warr_ubreakable_will_trigger() : SpellScriptLoader("spell_warr_ubreakable_will_trigger") {}

    class spell_warr_ubreakable_will_trigger_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_warr_ubreakable_will_trigger_AuraScript);

        bool CheckProc(ProcEventInfo& eventInfo)
        {
            Unit* caster = GetCaster(); 
            if (!caster)
                return false;

            DamageInfo* damageInfo = eventInfo.GetDamageInfo();
            if (!damageInfo)
                return false;

            int32 damage = damageInfo->GetDamage();
            if (damage <= 0)
                return false;

            int32 remainingHealth = caster->GetHealth() - damage;

            // Check if the incoming damage would kill the caster
            if (remainingHealth <= 0)
            {
                // Set the caster's health to 10% of their maximum health to prevent death
                int32 newHealth = caster->CountPctFromMaxHealth(10);
                caster->SetHealth(newHealth);
                return true;
            }

            return false;
        }

        void Register() override
        {
            DoCheckProc += AuraCheckProcFn(spell_warr_ubreakable_will_trigger_AuraScript::CheckProc);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_warr_ubreakable_will_trigger_AuraScript();
    }
};

class spell_war_unbreakable_absorb : public SpellScriptLoader
{
public:
    spell_war_unbreakable_absorb() : SpellScriptLoader("spell_war_unbreakable_absorb") { }

    class spell_war_unbreakable_absorb_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_war_unbreakable_absorb_SpellScript);

        void HandleAfterCast()
        {
            Player* player = GetCaster()->ToPlayer();
            if (!player || player->IsNPCBotOrPet()) 
                return;

            int32 absorbAmount = static_cast<int32>(round(player->GetMaxHealth() * 0.35));

            Aura* shieldAura = player->GetAura(GetSpellInfo()->Id);
            if (shieldAura)
            {
                AuraEffect* absorbEffect = shieldAura->GetEffect(EFFECT_0);
                if (absorbEffect)
                {
                    absorbEffect->SetAmount(absorbAmount);
                }
            }
        }

        void Register() override
        {
            AfterCast += SpellCastFn(spell_war_unbreakable_absorb_SpellScript::HandleAfterCast);
        }
    };

    class spell_war_unbreakable_absorb_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_war_unbreakable_absorb_AuraScript);

        void OnRemove(AuraEffect const* aurEff, AuraEffectHandleModes /*mode*/)
        {
            Unit* caster = GetCaster();
            if (!caster)
                return;

            caster->CastSpell(caster, 855059, true);
        }

        void Register() override
        {
            AfterEffectRemove += AuraEffectRemoveFn(spell_war_unbreakable_absorb_AuraScript::OnRemove, EFFECT_0, SPELL_AURA_SCHOOL_ABSORB, AURA_EFFECT_HANDLE_REAL);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_war_unbreakable_absorb_SpellScript();
    }

    AuraScript* GetAuraScript() const override
    {
        return new spell_war_unbreakable_absorb_AuraScript();
    }
};

// 880811 - Item - War  T3 Deathwish
class spell_warr_custom_deathwish_reducer : public AuraScript
{
    PrepareAuraScript(spell_warr_custom_deathwish_reducer);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ 12292 });
    }

    void HandleEffectProc(AuraEffect const* aurEff, ProcEventInfo& /*eventInfo*/)
    {
        PreventDefaultAction();
        if (Player* target = GetTarget()->ToPlayer())
            target->ModifySpellCooldown(12292, -2 * IN_MILLISECONDS);
    }

    void Register() override
    {
        OnEffectProc += AuraEffectProcFn(spell_warr_custom_deathwish_reducer::HandleEffectProc, EFFECT_0, SPELL_AURA_DUMMY);
    }
};

class spell_warr_relentless_sacrifice : public SpellScriptLoader
{
public:
    spell_warr_relentless_sacrifice() : SpellScriptLoader("spell_warr_relentless_sacrifice") { }

    class spell_warr_relentless_sacrifice_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_warr_relentless_sacrifice_SpellScript);

        void HandleAfterCast()
        {
            Unit* caster = GetCaster();
            if (!caster)
                return;

            // Deal 5% of the caster's health as damage
            uint32 healthToDamage = caster->CountPctFromMaxHealth(5);
            caster->ModifyHealth(-static_cast<int32>(healthToDamage));

            Unit* target = caster->GetVictim();
            if (!target)
                return;

            // Check if the target's health is 20% or lower
            if (target->HealthBelowPct(20))
            {
                caster->RemoveAura(820021);
            }

            if (Aura* aura = caster->GetAura(820021))
            {
                uint8 stackCount = aura->GetStackAmount();

                // If stacks are greater than 5, cast spell ID 5 on the caster
                if (stackCount > 5)
                {
                    caster->CastSpell(caster, 5, true);
                }
            }
        }

        void Register() override
        {
            AfterCast += SpellCastFn(spell_warr_relentless_sacrifice_SpellScript::HandleAfterCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_warr_relentless_sacrifice_SpellScript();
    }
};

void AddSC_spell_warr_thunderclap()
{
    new spell_warr_thunderclap();
    new spell_warr_ubreakable_will_trigger();
    new spell_war_unbreakable_absorb();
    RegisterSpellScript(spell_warr_custom_deathwish_reducer);
    new spell_warr_relentless_sacrifice();
}
