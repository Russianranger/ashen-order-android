#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_cast_on_aura_remove : public SpellScriptLoader
{
public:
    spell_cast_on_aura_remove() : SpellScriptLoader("spell_cast_on_aura_remove") { }

    class spell_cast_on_aura_remove_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_cast_on_aura_remove_AuraScript);

        void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
        {
            Unit* target = GetTarget();
            if (!target || !target->IsPlayer())
                return;

            target->CastSpell(target, 88774, true); 
        }

        void Register() override
        {
            OnEffectRemove += AuraEffectRemoveFn(spell_cast_on_aura_remove_AuraScript::OnRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_cast_on_aura_remove_AuraScript();
    }
};

void AddSC_custom_symbiosis_remover()
{
    new spell_cast_on_aura_remove();
}
