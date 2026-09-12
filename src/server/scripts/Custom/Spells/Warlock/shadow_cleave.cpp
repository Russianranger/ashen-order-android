#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraDefines.h"
#include "SpellAuras.h"
#include "ScriptedCreature.h"

enum ShadowCleaveSpells
{
    SPELL_HEAL_CASTER = 888825 // Heal Spell ID
};

class spell_lock_shadow_cleave : public SpellScript
{
    PrepareSpellScript(spell_lock_shadow_cleave);

    bool Load() override
    {
        return true;
    }

    void HandleDamage(SpellEffIndex /*effIndex*/)
    {
        if (Unit* caster = GetCaster())
        {
            if (Unit* target = GetHitUnit())
            {
                int32 damageDone = GetHitDamage();
                if (damageDone > 0)
                {
                    // Calculate 75% of damage
                    int32 healAmount = CalculatePct(damageDone, 75);

                    // Cast the heal on the caster using spell ID 888825
                    caster->CastCustomSpell(caster, SPELL_HEAL_CASTER, &healAmount, nullptr, nullptr, true);
                }
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_lock_shadow_cleave::HandleDamage, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};

void AddSC_spell_lock_shadow_cleave()
{
    RegisterSpellScript(spell_lock_shadow_cleave);
}
