#include "ScriptMgr.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "SpellScript.h"

enum SetisEvents
{
    EVENT_SPAWN_MINIONS = 1,
    EVENT_CAST_SHADOWBOLT_VOLLEY,
    EVENT_CAST_BELLOWING_ROAR,
    EVENT_CAST_ENRAGE,
    EVENT_SANDS_OF_TIME,
    EVENT_CAST_BLACK_CLEAVE
};

enum SetisSpells
{
    SPELL_SHADOWBOLT_VOLLEY = 835586,
    SPELL_BELLOWING_ROAR = 22686,
    SPELL_ENRAGE = 54287,
    SPELL_TIME_ACCELERATION = 864371,
    SPELL_TIME_DECELERATION = 864372,
    SPELL_BLACK_CLEAVE = 33480
};

enum NpcEntries
{
    NPC_CREATURE1 = 15324,
    NPC_CREATURE2 = 15338,
    NPC_CREATURE3 = 15462
};

const float SPAWN_DISTANCE = 10.0f;
const float ANGLE_INCREMENT = M_PI / 2.5f;

class boss_setis : public CreatureScript
{
public:
    boss_setis() : CreatureScript("boss_setis") {}

    struct boss_setisAI : public ScriptedAI
    {
        boss_setisAI(Creature* creature) : ScriptedAI(creature), hasEnraged(false) {}

        void Reset() override
        {
            hasEnraged = false;
            DespawnMinions();
            events.Reset();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("Your doom is upon you!", LANG_UNIVERSAL);
            events.ScheduleEvent(EVENT_SPAWN_MINIONS, 100);
            events.ScheduleEvent(EVENT_SPAWN_MINIONS, 45000, 0);
            events.ScheduleEvent(EVENT_CAST_SHADOWBOLT_VOLLEY, 14000);
            events.ScheduleEvent(EVENT_CAST_BELLOWING_ROAR, 24000);
            events.ScheduleEvent(EVENT_SANDS_OF_TIME, 20000);
            events.ScheduleEvent(EVENT_CAST_ENRAGE, 1000);
            events.ScheduleEvent(EVENT_CAST_BLACK_CLEAVE, 12000);
        }

        void JustDied(Unit* /*killer*/) override
        {
            me->Say("My death is... only the beginning...", LANG_UNIVERSAL);
            DespawnMinions();
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            hasEnraged = false;
            DespawnMinions();
            ScriptedAI::EnterEvadeMode();
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
                case EVENT_SPAWN_MINIONS:
                    SpawnMinions();
                    break;
                case EVENT_CAST_SHADOWBOLT_VOLLEY:
                    DoCastSelf(SPELL_SHADOWBOLT_VOLLEY, true);
                    events.ScheduleEvent(EVENT_CAST_SHADOWBOLT_VOLLEY, 14000);
                    break;
                case EVENT_CAST_BELLOWING_ROAR:
                    DoCastVictim(SPELL_BELLOWING_ROAR);
                    events.ScheduleEvent(EVENT_CAST_BELLOWING_ROAR, 24000);
                    break;
                case EVENT_CAST_ENRAGE:
                    if (!hasEnraged && me->HealthBelowPct(30))
                    {
                        me->Yell("My power surges! None shall stand before me!", LANG_UNIVERSAL);
                        DoCast(me, SPELL_ENRAGE, true);
                        hasEnraged = true;
                    }
                    break;
                case EVENT_SANDS_OF_TIME:
                    if (urand(0, 1)) {
                        me->CastSpell(me, SPELL_TIME_ACCELERATION, true);
                        me->Yell("Time bends to my will, quickening your demise!", LANG_UNIVERSAL);
                    }
                    else {
                        me->CastSpell(me, SPELL_TIME_DECELERATION, true);
                        me->Yell("Time crawls, your doom approaches slowly!", LANG_UNIVERSAL);
                    }
                    events.ScheduleEvent(EVENT_SANDS_OF_TIME, 30000); 
                    break;
                case EVENT_CAST_BLACK_CLEAVE:   
                    if (Unit* target = me->GetVictim())
                    {
                        DoCast(target, SPELL_BLACK_CLEAVE, true);
                    }
                    events.ScheduleEvent(EVENT_CAST_BLACK_CLEAVE, 9000);
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void SpawnMinions()
        {
            std::vector<uint32> npcs = { NPC_CREATURE1, NPC_CREATURE2, NPC_CREATURE3 };
            for (int i = 0; i < 3; ++i)
            {
                float angle = ANGLE_INCREMENT * i;
                float x = me->GetPositionX() + SPAWN_DISTANCE * cos(angle);
                float y = me->GetPositionY() + SPAWN_DISTANCE * sin(angle);
                me->SummonCreature(npcs[i % npcs.size()], x, y, me->GetPositionZ(), me->GetOrientation(), TEMPSUMMON_CORPSE_TIMED_DESPAWN, 180000);
            }
        }

        void DespawnMinions()
        {
            std::vector<uint32> minionIDs = { NPC_CREATURE1, NPC_CREATURE2, NPC_CREATURE3 };
            for (uint32 id : minionIDs)
            {
                std::list<Creature*> minions;
                me->GetCreatureListWithEntryInGrid(minions, id, 150.0f);
                for (Creature* minion : minions)
                    minion->DespawnOrUnsummon();
            }
        }

    private:
        bool hasEnraged;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_setisAI(creature);
    }
};

void AddSC_boss_setis()
{
    new boss_setis();
}
