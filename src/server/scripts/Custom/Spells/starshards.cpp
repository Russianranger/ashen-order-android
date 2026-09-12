#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"

class spell_priest_starshards : public SpellScriptLoader
{
public:
    spell_priest_starshards() : SpellScriptLoader("spell_priest_starshards") { }

    class spell_priest_starshards_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_priest_starshards_AuraScript);

        void CalculateDamage(AuraEffect const* /*aurEff*/, int32& amount, bool& /*canBeRecalculated*/)
        {
            if (Unit* caster = GetCaster())
            {
                uint32 level = caster->getLevel();
                if (level <= 60)
                {
                    amount = 2.5 * level;
                }
                else if (level <= 70)
                {
                    amount = 4 * level;
                }
                else if (level <= 80)
                {
                    amount = 7.5 * level;
                }
                // Adjust for levels above 80 if needed
            }
        }

        void Register() override
        {
            DoEffectCalcAmount += AuraEffectCalcAmountFn(spell_priest_starshards_AuraScript::CalculateDamage, EFFECT_0, SPELL_AURA_PERIODIC_DAMAGE);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_priest_starshards_AuraScript();
    }
};

void AddSC_spell_priest_starshards()
{
    new spell_priest_starshards();
}
