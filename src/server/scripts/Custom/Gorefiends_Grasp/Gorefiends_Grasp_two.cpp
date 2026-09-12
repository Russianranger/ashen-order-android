#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "Creature.h"
#include <cmath>

// Assuming the spell ID is correct, modify it if necessary
class spell_gorefiends_grasp_damage : public SpellScript
{
    PrepareSpellScript(spell_gorefiends_grasp_damage);

    void HandleDamage(SpellEffIndex /*effIndex*/)
    {
        if (Unit* caster = GetCaster())
        {
            // Get target of the spell
            Unit* target = GetHitUnit();
            int32 damage = 0;

            if (target && target->ToCreature() && target->ToCreature()->IsNPCBot()) // Check if the target is an NPC bot
            {
                // Calculate 3% of the target's total health
                float healthPercentage = 0.03f;
                damage = std::ceil(target->GetMaxHealth() * healthPercentage);
            }
            else
            {
                // Standard damage calculation based on caster's attack power
                float rawDamage = caster->GetTotalAttackPowerValue(BASE_ATTACK) * 0.085f + 23;
                damage = std::ceil(rawDamage);
            }

            // Set the damage for the spell
            SetHitDamage(damage);
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_gorefiends_grasp_damage::HandleDamage, EFFECT_0, SPELL_EFFECT_SCHOOL_DAMAGE);
    }
};

// Register the spell script
void AddSC_spell_gorefiends_grasp_damage()
{
    new spell_gorefiends_grasp_damage();
}
