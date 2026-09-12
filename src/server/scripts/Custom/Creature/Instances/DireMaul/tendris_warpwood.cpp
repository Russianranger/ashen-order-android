#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "TemporarySummon.h"
#include "../scripts/Custom/Timewalking/10Man.h"


enum TendrisWarpwoodSpells
{
    SPELL_TRAMPLE = 5568,
    SPELL_GRASPING_VINES = 22924,
    SPELL_ENTANGLE = 22994
};

enum TendrisWarpwoodEvents
{
    EVENT_TRAMPLE = 1,
    EVENT_GRASPING_VINES = 2,
    EVENT_ENTANGLE = 3,
    EVENT_SPAWN_TENDRIS_TREE = 4,
    EVENT_PULL_WISPS = 5,
};

const Position spawnPositions[] = {
    {-33.0573f, 473.154f, -23.3031f, 6.26014f},
    {-32.8612f, 481.663f, -23.2998f, 6.26014f},
    {-4.01656f, 487.900f, -23.2970f, 0.0780372f},
    {24.7697f, 490.735f, -23.2894f, 0.0780372f},
    {54.1363f, 489.047f, -23.2821f, 6.12537f},
    {56.0848f, 468.986f, -23.2973f, 4.67654f},
    {44.5210f, 456.983f, -23.3171f, 3.61649f},
    {14.289f, 453.3568f, -23.3278f, 1.4468f},
    {-33.3068f, 462.327f, -23.3033f, 6.18488f}
};

class boss_tendris_warpwood : public CreatureScript
{
public:
    boss_tendris_warpwood() : CreatureScript("boss_tendris_warpwood") { }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_tendris_warpwoodAI(creature);
    }

    struct boss_tendris_warpwoodAI : public ScriptedAI
    {
        boss_tendris_warpwoodAI(Creature* creature) : ScriptedAI(creature), _summonedTreeGUID() { }

        EventMap events;
        ObjectGuid _summonedTreeGUID; 

        void Reset() override
        {
            events.Reset();
            DespawnTendrisTree();
            DespawnIronbark(11458, 200.0f);
            DespawnWisps(883681, 200.0f);
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("You do not belong here! Ancients, rise against these intruders!", LANG_UNIVERSAL);
            DoCast(me, 826049, true);
            events.ScheduleEvent(EVENT_TRAMPLE, Seconds(5), Seconds(9));
            events.ScheduleEvent(EVENT_GRASPING_VINES, Seconds(2), Seconds(4));
            events.ScheduleEvent(EVENT_ENTANGLE, Seconds(6), Seconds(12));
            events.ScheduleEvent(EVENT_SPAWN_TENDRIS_TREE, Seconds(5));
            events.ScheduleEvent(EVENT_PULL_WISPS, Seconds(10));

            std::list<Creature*> creatures;
            GetCreatureListWithEntryInGrid(creatures, me, 11459, 500.0f);

            for (Creature* creature : creatures)
            {
                creature->SetInCombatWithZone();
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_TRAMPLE:
                    DoCastSelf(SPELL_TRAMPLE);
                    events.ScheduleEvent(EVENT_TRAMPLE, Seconds(9), Seconds(14));
                    break;
                case EVENT_GRASPING_VINES:
                    DoCastSelf(SPELL_GRASPING_VINES);
                    events.ScheduleEvent(EVENT_GRASPING_VINES, Seconds(16), Seconds(20));
                    break;
                case EVENT_ENTANGLE:
                    DoCastRandomTarget(SPELL_ENTANGLE, 0, 100.0f, false, true);
                    events.ScheduleEvent(EVENT_ENTANGLE, Seconds(15), Seconds(20));
                    break;
                case EVENT_SPAWN_TENDRIS_TREE:
                    SpawnTendrisTree();
                    events.ScheduleEvent(EVENT_SPAWN_TENDRIS_TREE, Seconds(31));
                    break;
                case EVENT_PULL_WISPS:
                    PullWisps();
                    events.ScheduleEvent(EVENT_PULL_WISPS, Seconds(4));
                    break;
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void PullWisps()
        {
            std::list<Creature*> wisps;
            GetCreatureListWithEntryInGrid(wisps, me, 883681, 250.0f); 

            for (Creature* wisp : wisps)
            {
                float x = me->GetPositionX();
                float y = me->GetPositionY();
                float z = me->GetPositionZ();

                wisp->GetMotionMaster()->MoveJump(x, y, z, 20.0f, 10.0f);
            }
        }

        void SpawnTendrisTree()
        {
            const Position& spawnPos = spawnPositions[urand(0, (sizeof(spawnPositions) / sizeof(Position)) - 1)];

            if (Creature* tendrisTree = me->SummonCreature(885782, spawnPos, TEMPSUMMON_TIMED_DESPAWN, 600000))
            {
                _summonedTreeGUID = tendrisTree->GetGUID();

                Acore::AnyPlayerInObjectRangeCheck checker(tendrisTree, 150.0f); 
                std::list<Player*> players;
                Acore::PlayerListSearcher<Acore::AnyPlayerInObjectRangeCheck> searcher(tendrisTree, players, checker);
                Cell::VisitWorldObjects(tendrisTree, searcher, 150.0f); 

                for (Player* player : players)
                {
                    if (player && player->GetSession())
                    {
                        player->GetSession()->SendAreaTriggerMessage("A menacing Tendris Tree has taken root!");
                    }
                }
            }
        }

        void DespawnTendrisTree()
        {
            if (Creature* tendrisTree = ObjectAccessor::GetCreature(*me, _summonedTreeGUID))
            {
                tendrisTree->DespawnOrUnsummon(); 
            }
            _summonedTreeGUID.Clear(); 
        }

        void JustDied(Unit* /*killer*/) override
        {
            DespawnTendrisTree();
            DespawnIronbark(11458, 200.0f);
            DespawnWisps(883681, 200.0f);
            events.Reset();
            Map::PlayerList const& players = me->GetMap()->GetPlayers();
            if (players.begin() != players.end())
            {
                uint32 baseRewardLevel = 1;
                bool isDungeon = me->GetMap()->IsDungeon();

                Player* player = players.begin()->GetSource();
                if (player)
                {
                    DistributeChallengeRewards(player, me, baseRewardLevel, isDungeon);
                }
            }
        }
        void DespawnIronbark(uint32 entry, float range)
        {
            std::list<Creature*> creatures;
            GetCreatureListWithEntryInGrid(creatures, me, entry, range);
            for (Creature* creature : creatures)
            {
                creature->DespawnOrUnsummon();
            }
        }
        void DespawnWisps(uint32 entry, float range)
        {
            std::list<Creature*> creatures;
            GetCreatureListWithEntryInGrid(creatures, me, entry, range);
            for (Creature* creature : creatures)
            {
                creature->DespawnOrUnsummon();
            }
        }
    };
};

class tendris_tree : public CreatureScript
{
public:
    tendris_tree() : CreatureScript("tendris_tree") {}

    struct tendris_treeAI : public ScriptedAI
    {
        tendris_treeAI(Creature* creature) : ScriptedAI(creature) {}

        void Reset() override
        {
            me->SetReactState(REACT_PASSIVE); 
            DoCast(me, 870854, false); 
        }

        void JustDied(Unit* /*killer*/) override
        {
            if (!me->HasAura(870855)) 
            {
                if (Creature* summoned = me->SummonCreature(11458, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), me->GetOrientation(), TEMPSUMMON_CORPSE_DESPAWN))
                {
                    summoned->SetInCombatWithZone(); 
                }
            }
            else
            {
                me->SummonCreature(883681, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), me->GetOrientation(), TEMPSUMMON_TIMED_DESPAWN, 600000); 
            }
        }

        void UpdateAI(uint32 /*diff*/) override
        {
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new tendris_treeAI(creature);
    }
};


//Movement not working. idk why. I just ended up putting a pull mechanic on the boss
class tendris_wisp : public CreatureScript
{
public:
    tendris_wisp() : CreatureScript("tendris_wisp") {}

    struct tendris_wispAI : public ScriptedAI
    {
        tendris_wispAI(Creature* creature) : ScriptedAI(creature), moveCheckTimer(1000)
        {
            creature->SetReactState(REACT_PASSIVE);
        }

        uint32 moveCheckTimer;

        void Reset() override
        {
            MoveToBoss();
        }

        void MoveToBoss()
        {
            if (Creature* boss = me->FindNearestCreature(11489, 250.0f))
            {
                me->GetMotionMaster()->MoveChase(boss);
            }
        }

        void UpdateAI(uint32 diff) override
        {
            if (moveCheckTimer <= diff)
            {
                if (Creature* boss = me->FindNearestCreature(11489, 250.0f))
                {
                    if (me->GetDistance(boss) <= 5.0f)
                    {
                        ApplyAuraToBoss(boss);
                    }
                    else
                    {
                        MoveToBoss();
                    }
                }
                moveCheckTimer = 1000;
            }
            else
            {
                moveCheckTimer -= diff;
            }
        }

        void ApplyAuraToBoss(Creature* boss)
        {
            if (boss->HasAura(864162))
            {
                boss->GetAura(864162)->ModStackAmount(1);
            }
            else
            {
                boss->AddAura(864162, boss);
            }

            me->DespawnOrUnsummon();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new tendris_wispAI(creature);
    }
};

void AddSC_boss_tendris_warpwood()
{
    new tendris_tree();
    new boss_tendris_warpwood();
    new tendris_wisp();
}
