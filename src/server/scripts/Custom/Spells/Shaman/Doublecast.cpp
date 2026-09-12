#include "ScriptMgr.h"
#include "Player.h"
#include "SpellScript.h"
#include "bot_ai.h"
#include "SpellAuraEffects.h"
#include <algorithm> 
#include <random> 

class Spell_DoubleCast : public SpellScript
{
    PrepareSpellScript(Spell_DoubleCast);

    enum CustomSpellIds
    {
        SPELL_DOUBLECAST_MARKER = 883054,
        DISABLING_AURA = 16166
    };

    void HandleAfterHit()
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        if (caster->HasAura(DISABLING_AURA))
            return;

        if (caster->HasAura(SPELL_DOUBLECAST_MARKER))
            return;

        if (roll_chance_f(17.5f))
        {
            SpellInfo const* spellInfo = GetSpellInfo();
            if (!spellInfo)
                return;

            Unit* target = GetHitUnit();
            if (!target)
                return;

            caster->CastSpell(target, spellInfo->Id, true);

            caster->AddAura(SPELL_DOUBLECAST_MARKER, caster);
        }
    }

    void HandleOnEffectHitTarget(SpellEffIndex effIndex)
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        if (caster->HasAura(SPELL_DOUBLECAST_MARKER))
        {
            int32 damage = GetHitDamage();
            int32 adjustedDamage = CalculatePct(damage, 75);
            SetHitDamage(adjustedDamage);
        }
    }

    void HandleAfterCast()
    {
        Unit* caster = GetCaster();
        if (!caster)
            return;

        if (caster->HasAura(SPELL_DOUBLECAST_MARKER))
            caster->RemoveAura(SPELL_DOUBLECAST_MARKER);
    }

    void Register() override
    {
        OnHit += SpellHitFn(Spell_DoubleCast::HandleAfterHit);
        OnEffectHitTarget += SpellEffectFn(Spell_DoubleCast::HandleOnEffectHitTarget, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
        AfterCast += SpellCastFn(Spell_DoubleCast::HandleAfterCast);
    }
};

class spell_sha_ancestral_guardian : public AuraScript
{
    PrepareAuraScript(spell_sha_ancestral_guardian);

    bool CheckProc(ProcEventInfo& eventInfo)
    {
        return eventInfo.GetActor() && eventInfo.GetProcTarget();
    }

    void HandleProc(AuraEffect const* aurEff, ProcEventInfo& eventInfo)
    {
        PreventDefaultAction();

        uint32 triggered_spell_id = 80809;
        SpellInfo const* triggeredSpell = sSpellMgr->GetSpellInfo(triggered_spell_id);

        HealInfo* healInfo = eventInfo.GetHealInfo();

        if (!healInfo || !triggeredSpell)
        {
            return;
        }

        Unit* target = eventInfo.GetProcTarget();
        if (!target)
        {
            return;
        }

        target->RemoveAura(triggered_spell_id);

        int32 amount = CalculatePct(healInfo->GetHeal(), aurEff->GetAmount()) / triggeredSpell->GetMaxTicks();
        target->CastDelayedSpellWithPeriodicAmount(GetTarget(), triggered_spell_id, SPELL_AURA_PERIODIC_HEAL, amount, EFFECT_0);
    }

    void Register() override
    {
        DoCheckProc += AuraCheckProcFn(spell_sha_ancestral_guardian::CheckProc);
        OnEffectProc += AuraEffectProcFn(spell_sha_ancestral_guardian::HandleProc, EFFECT_0, SPELL_AURA_DUMMY);
    }
};

class spell_elemental_blast : public SpellScriptLoader
{
public:
    spell_elemental_blast() : SpellScriptLoader("spell_elemental_blast") { }

    class spell_elemental_blast_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_elemental_blast_SpellScript);

        void HandleOnCast()
        {
            Unit* caster = GetCaster();
            Unit* target = GetExplTargetUnit();
            if (!target)
            {
                target = caster->GetVictim();
            }

            if (caster && target)
            {
                int32 intellect = 0;
                int32 spellPower = 0;
                uint32 level = caster->GetLevel();

                if (caster->IsPlayer())
                {
                    Player* player = caster->ToPlayer();
                    intellect = player->GetStat(STAT_INTELLECT);
                    spellPower = player->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_SPELL);
                }
                else if (caster->IsNPCBot())
                {
                    Creature* creature = caster->ToCreature();
                    intellect = creature->GetStat(STAT_INTELLECT);
                    spellPower = creature->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_SPELL);
                }

                if (intellect > 0 || spellPower > 0)
                {
                    // Intellect damage percentage based on level
                    // Essentially I'm trying to be lazy and make intellect the base value of the spell for damage.
                    // This is a rough estimate based on level 60 testing and will need to be adjusted for balance for later levels.
                    int32 intellectPct = 30; // Default for levels <= 60
                    if (level > 60 && level <= 70)
                        intellectPct = 33;
                    else if (level > 70)
                        intellectPct = 37;

                    // Clamp level to a maximum of 60 for scaling calculations
                    uint32 clampedLevel = std::min(level, 60u);

                    // Non-linear scaling for lowbies: quadratic increase for intellect
                    float scalingFactor = 1.0f + pow((60.0f - clampedLevel) / 60.0f, 1.8);

                    // Non-linear scaling for lowbies: quadratic decrease for spell power
                    float spellPowerScalingFactor = 1.0f - pow((60.0f - clampedLevel) / 60.0f, 1.85);

                    // Spell power scaling for higher levels
                    if (level > 60 && level <= 70)
                        spellPowerScalingFactor = 0.94f;
                    else if (level > 70)
                        spellPowerScalingFactor = 1.0f;

                    int32 intellectDamage = CalculatePct(intellect, intellectPct); // Percentage of intellect
                    int32 spellPowerDamage = CalculatePct(spellPower, 87); // 87% of spell power
                    intellectDamage = static_cast<int32>(intellectDamage * scalingFactor);
                    spellPowerDamage = static_cast<int32>(spellPowerDamage * spellPowerScalingFactor);
                    int32 totalDamage = intellectDamage + spellPowerDamage;

                    // Apply 35% more damage if target is at 70% health or above
                    if (target->GetHealthPct() >= 70.0f)
                    {
                        totalDamage = static_cast<int32>(totalDamage * 1.25f);
                    }

                    caster->CastCustomSpell(target, 80088, &totalDamage, nullptr, nullptr, true);
                    caster->CastCustomSpell(target, 88088, &totalDamage, nullptr, nullptr, true);
                    caster->CastCustomSpell(target, 88089, &totalDamage, nullptr, nullptr, true);

                    // Check if caster has T3 2pc
                    if (caster->HasAura(882056))
                    {
                        // Randomly cast two of the buffs on the caster
                        std::vector<uint32> spells = { 88090, 88091, 88092 };
                        std::random_device rd;
                        std::mt19937 g(rd());
                        std::shuffle(spells.begin(), spells.end(), g);
                        caster->CastSpell(caster, spells[0], true);
                        caster->CastSpell(caster, spells[1], true);
                    }
                    else
                    {
                        // Randomly cast one of the buffs on the caster
                        uint32 spells[] = { 88090, 88091, 88092 };
                        uint32 randomSpell = spells[urand(0, 2)];
                        caster->CastSpell(caster, randomSpell, true);
                    }
                }
            }
        }

        void Register() override
        {
            OnCast += SpellCastFn(spell_elemental_blast_SpellScript::HandleOnCast);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_elemental_blast_SpellScript();
    }
};

// 870811 - Item - Shaman T2.5 Elemental 2P Bonus
class spell_sha_item_t25_elemental_2p_bonus : public AuraScript
{
    PrepareAuraScript(spell_sha_item_t25_elemental_2p_bonus);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ 89088 });
    }

    void HandleEffectProc(AuraEffect const* aurEff, ProcEventInfo& /*eventInfo*/)
    {
        PreventDefaultAction();
        if (Player* target = GetTarget()->ToPlayer())
            target->ModifySpellCooldown(89088, -1 * IN_MILLISECONDS);
    }

    void Register() override
    {
        OnEffectProc += AuraEffectProcFn(spell_sha_item_t25_elemental_2p_bonus::HandleEffectProc, EFFECT_0, SPELL_AURA_DUMMY);
    }
};

class spell_sha_lightning_shield : public SpellScriptLoader
{
public:
    spell_sha_lightning_shield() : SpellScriptLoader("spell_sha_lightning_shield") { }

    class spell_sha_lightning_shield_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_sha_lightning_shield_AuraScript);

        void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
        {
            Unit* target = GetTarget();
            if (!target)
                return;
            //shit that should be removed when lightning shield is removed.
            target->RemoveAurasDueToSpell(28821);
            target->RemoveAurasDueToSpell(828821);
            target->RemoveAurasDueToSpell(848053);
        }

        void Register() override
        {
            AfterEffectRemove += AuraEffectRemoveFn(spell_sha_lightning_shield_AuraScript::AfterRemove, EFFECT_0, SPELL_AURA_PROC_TRIGGER_SPELL, AURA_EFFECT_HANDLE_REAL);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_sha_lightning_shield_AuraScript();
    }
};

void AddSC_Spell_DoubleCast()
{
    RegisterSpellScript(Spell_DoubleCast);
    RegisterSpellScript(spell_sha_ancestral_guardian);
    new spell_elemental_blast();
    RegisterSpellScript(spell_sha_item_t25_elemental_2p_bonus);
    new spell_sha_lightning_shield();

}
