#include "ScriptMgr.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "ScriptedCreature.h"

enum VolchanEvents
{
    EVENT_SPAWN_LAVA_SPAWNS = 1,
    EVENT_CAST_FIRESHIELD,
    EVENT_CAST_FIRE_NOVA,
    EVENT_CAST_SEARING_STRIKE,
    EVENT_CAST_MOLTEN_CLEAVE
};

class boss_volchan : public CreatureScript
{
public:
    boss_volchan() : CreatureScript("boss_volchan") {}

    struct boss_volchanAI : public ScriptedAI
    {
        boss_volchanAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            DespawnLavaSpawns();
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            events.ScheduleEvent(EVENT_SPAWN_LAVA_SPAWNS, 15000);
            events.ScheduleEvent(EVENT_CAST_FIRESHIELD, 22000);
            events.ScheduleEvent(EVENT_CAST_FIRE_NOVA, 8000);
            events.ScheduleEvent(EVENT_CAST_SEARING_STRIKE, 10000);
            events.ScheduleEvent(EVENT_CAST_MOLTEN_CLEAVE, 12000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            DespawnLavaSpawns();
        }

        void JustReachedHome() override
        {
            DespawnLavaSpawns();
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_SPAWN_LAVA_SPAWNS:
                    SpawnLavaSpawns();
                    events.ScheduleEvent(EVENT_SPAWN_LAVA_SPAWNS, 25000);
                    break;
                case EVENT_CAST_FIRESHIELD:
                    DoCast(me, 13376, true);
                    events.ScheduleEvent(EVENT_CAST_FIRESHIELD, 22000);
                    break;
                case EVENT_CAST_FIRE_NOVA:
                    DoCast(me, 812470, false);
                    events.ScheduleEvent(EVENT_CAST_FIRE_NOVA, 30000);
                    break;
                case EVENT_CAST_SEARING_STRIKE:
                    if (Unit* target = me->GetVictim())
                        DoCast(target, 869308, true);
                    events.ScheduleEvent(EVENT_CAST_SEARING_STRIKE, 10000);
                    break;
                case EVENT_CAST_MOLTEN_CLEAVE:
                    if (Unit* target = me->GetVictim())
                        DoCast(target, 820354, true);
                    events.ScheduleEvent(EVENT_CAST_MOLTEN_CLEAVE, 15000);  
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void SpawnLavaSpawns()
        {
            uint32 spawnCount = urand(3, 5);  

            std::list<Unit*> targets;
            Acore::AnyUnitInObjectRangeCheck check(me, 100.0f); 
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targets, check);
            Cell::VisitAllObjects(me, searcher, 100.0f);

            targets.remove_if([this](Unit* unit) -> bool {
                return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                });

            for (uint32 i = 0; i < spawnCount; ++i)
            {
                if (!targets.empty())
                {
                    Unit* target = Acore::Containers::SelectRandomContainerElement(targets);
                    float x, y, z;
                    target->GetPosition(x, y, z);

                    me->SummonCreature(823085, x, y, z, 0.0f, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 300000);
                }
            }
        }

        void DespawnLavaSpawns()
        {
            std::list<Creature*> lavaSpawns;
            me->GetCreatureListWithEntryInGrid(lavaSpawns, 823085, 100.0f);
            for (Creature* spawn : lavaSpawns)
            {
                spawn->DespawnOrUnsummon();
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_volchanAI(creature);
    }
};

void AddSC_boss_volchan()
{
    new boss_volchan();
}
