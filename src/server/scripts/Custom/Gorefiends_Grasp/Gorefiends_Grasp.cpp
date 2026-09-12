#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Unit.h"
#include "GridNotifiers.h"
#include "Creature.h"
#include <string>


// 1190009 - Gorefiend's Grasp (grip effect)
class spell_dk_gorefiends_grasp : public SpellScript
{
    PrepareSpellScript(spell_dk_gorefiends_grasp);

    void HandleScript(SpellEffIndex /*effIndex*/)
    {
        if (Unit* target = GetHitUnit())
        {
            Unit* caster = GetCaster();
            std::list<Unit*> targetList;
            uint32 mechanicImmuneGrip = (1 << MECHANIC_GRIP); // Assuming GRIP is defined appropriately in the enum

            // Check if the target is a boss
            bool isTargetBoss = target->ToCreature() && target->ToCreature()->GetCreatureTemplate()->rank == 3;

            if (isTargetBoss)
            {
                // Target is a boss: pull units friendly to the boss, hostile to the player
                Acore::AnyFriendlyUnitInObjectRangeCheck checker(target, target, 15.0f);
                Acore::UnitListSearcher<Acore::AnyFriendlyUnitInObjectRangeCheck> searcher(target, targetList, checker);
                Cell::VisitAllObjects(target, searcher, 15.0f);
            }
            else if (target->IsFriendlyTo(caster))
            {
                // Target is friendly to the caster: pull unfriendly units to the friendly target
                Acore::AnyUnfriendlyUnitInObjectRangeCheck checker(target, caster, 15.0f);
                Acore::UnitListSearcher<Acore::AnyUnfriendlyUnitInObjectRangeCheck> searcher(target, targetList, checker);
                Cell::VisitAllObjects(target, searcher, 15.0f);
            }
            else
            {
                // Target is unfriendly to the caster: pull units friendly to the unfriendly target
                Acore::AnyFriendlyUnitInObjectRangeCheck checker(target, target, 15.0f);
                Acore::UnitListSearcher<Acore::AnyFriendlyUnitInObjectRangeCheck> searcher(target, targetList, checker);
                Cell::VisitAllObjects(target, searcher, 15.0f);
            }

            for (Unit* unit : targetList)
            {
                if (unit->HasUnitFlag(UNIT_FLAG_DISABLE_MOVE) ||
                    unit->HasUnitFlag(UNIT_FLAG_PACIFIED) ||
                    unit->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_PC) ||
                    unit->HasUnitFlag(UNIT_FLAG_IMMUNE_TO_NPC) ||
                    unit->HasUnitFlag(UNIT_FLAG_NON_ATTACKABLE) ||
                    unit->HasUnitFlag(UNIT_FLAG_NOT_ATTACKABLE_1) ||
                    unit->HasUnitFlag(UNIT_FLAG_NOT_SELECTABLE))
                    continue;

                if (unit == target || unit == caster)
                    continue;

                if (Creature* creature = unit->ToCreature())
                {
                    // Check for mechanic immunity and other creature specifics
                    if ((creature->GetCreatureTemplate()->MechanicImmuneMask & mechanicImmuneGrip) ||
                        creature->GetCreatureTemplate()->rank == 3 || // Boss check
                        creature->GetCreatureTemplate()->flags_extra & (CREATURE_FLAG_EXTRA_TRIGGER | CREATURE_FLAG_EXTRA_CIVILIAN))
                        continue;
                }

                if (!unit->IsWithinLOSInMap(target))
                    continue;

                // original was spell 1190010 on the main target from each unit. This makes targets movejump to main target
                unit->CastSpell(target, 1190010, true);

                // If the target is unfriendly, make the unit start attacking the caster
                if (!target->IsFriendlyTo(caster))
                {
                    unit->Attack(caster, true);
                }
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_dk_gorefiends_grasp::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

void AddSC_spell_dk_gorefiends_grasp()
{
    RegisterSpellScript(spell_dk_gorefiends_grasp);
}
