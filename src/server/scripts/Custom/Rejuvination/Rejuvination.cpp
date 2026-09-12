#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_dru_rejuvenation : public SpellScriptLoader
{
public:
    spell_dru_rejuvenation() : SpellScriptLoader("spell_dru_rejuvenation") { }

    class spell_dru_rejuvenation_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_dru_rejuvenation_SpellScript);

        void HandleOnSpellHit()
        {
            Unit* caster = GetCaster();
            Unit* target = GetHitUnit();

            // Ensure the target of the spell is the caster themselves.
            if (!caster || !target || caster != target)
                return;

            if (caster->HasAura(37286))
                caster->CastSpell(caster, 813671, true);

            if (caster->HasAura(837286))
                caster->CastSpell(caster, 837287, true);
        }

        void Register() override
        {
            OnHit += SpellHitFn(spell_dru_rejuvenation_SpellScript::HandleOnSpellHit);
        }
    };

    class spell_dru_rejuvenation_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_dru_rejuvenation_AuraScript);

        void OnRemove(AuraEffect const* aurEff, AuraEffectHandleModes mode)
        {
            Unit* target = GetTarget();
            if (!target || target != GetCaster())
                return;

            // Check for Druid spell family and the specific flag (0x000000010) at the first index.
            if (aurEff->GetSpellInfo()->SpellFamilyName == SPELLFAMILY_DRUID && (aurEff->GetSpellInfo()->SpellFamilyFlags[0] & 0x000000010))
            {
                target->RemoveAura(837287);
                target->RemoveAura(813671);
            }
        }

        void Register() override
        {
            OnEffectRemove += AuraEffectRemoveFn(spell_dru_rejuvenation_AuraScript::OnRemove, EFFECT_0, SPELL_AURA_ANY, AURA_EFFECT_HANDLE_REAL_OR_REAPPLY_MASK);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_dru_rejuvenation_SpellScript();
    }

    AuraScript* GetAuraScript() const override
    {
        return new spell_dru_rejuvenation_AuraScript();
    }
};

void AddSC_spell_dru_rejuvenation()
{
    new spell_dru_rejuvenation();
}
