#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class chance_to_not_proc_periodic : public AuraScript
{
    PrepareAuraScript(chance_to_not_proc_periodic);

    void OnPeriodic(AuraEffect const* aurEff)
    {
        if (roll_chance_i(50)) // 50% chance to prevent the trigger
        {
            PreventDefaultAction();
        }
    }

    void Register() override
    {
        OnEffectPeriodic += AuraEffectPeriodicFn(chance_to_not_proc_periodic::OnPeriodic, EFFECT_0, SPELL_AURA_PERIODIC_TRIGGER_SPELL);
    }
};

class chance_to_not_proc_periodic_loader : public SpellScriptLoader
{
public:
    chance_to_not_proc_periodic_loader() : SpellScriptLoader("chance_to_not_proc_periodic") {}

    AuraScript* GetAuraScript() const override
    {
        return new chance_to_not_proc_periodic();
    }
};

void AddSC_encroaching_enfeeblement()
{
    new chance_to_not_proc_periodic_loader();
}
