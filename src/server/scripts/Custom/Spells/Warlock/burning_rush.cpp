#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Player.h"

class spell_warl_burning_rush : public SpellScriptLoader
{
public:
    spell_warl_burning_rush() : SpellScriptLoader("spell_warl_burning_rush") { }

    class spell_warl_burning_rush_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_warl_burning_rush_AuraScript);

        void HandleOnEffectPeriodic(AuraEffect const* aurEff)
        {
            PreventDefaultAction();
            if (Unit* caster = GetCaster())
            {
                uint32 damage = CalculatePct(caster->GetMaxHealth(), 4);

                if (damage >= caster->GetHealth())
                {
                    caster->SetHealth(1);
                }
                else
                {
                    caster->ModifyHealth(-int32(damage));
                }
            }
        }

        void Register() override
        {
            OnEffectPeriodic += AuraEffectPeriodicFn(spell_warl_burning_rush_AuraScript::HandleOnEffectPeriodic, EFFECT_1, SPELL_AURA_PERIODIC_DAMAGE_PERCENT);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_warl_burning_rush_AuraScript();
    }
};


class spell_warl_burning_rush_positive : public SpellScriptLoader
{
public:
    spell_warl_burning_rush_positive() : SpellScriptLoader("spell_warl_burning_rush_positive") { }

    class spell_warl_burning_rush_positive_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_warl_burning_rush_positive_AuraScript);

        void OnApply(AuraEffect const* aurEff, AuraEffectHandleModes mode)
        {
            if (Unit* caster = GetCaster())
            {
                // Cast the primary aura when the positive aura is applied
                caster->CastSpell(caster, 845416, true);
            }
        }

        void OnRemove(AuraEffect const* aurEff, AuraEffectHandleModes mode)
        {
            if (Unit* caster = GetCaster())
            {
                // Remove the primary aura when the positive aura is removed
                caster->RemoveAurasDueToSpell(845416);
            }
        }

        void Register() override
        {
            AfterEffectApply += AuraEffectApplyFn(spell_warl_burning_rush_positive_AuraScript::OnApply, EFFECT_0, SPELL_AURA_ANY, AURA_EFFECT_HANDLE_REAL);
            AfterEffectRemove += AuraEffectRemoveFn(spell_warl_burning_rush_positive_AuraScript::OnRemove, EFFECT_0, SPELL_AURA_ANY, AURA_EFFECT_HANDLE_REAL);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_warl_burning_rush_positive_AuraScript();
    }
};

void AddSC_spell_burning_rush()
{
    new spell_warl_burning_rush();
    new spell_warl_burning_rush_positive();
}
