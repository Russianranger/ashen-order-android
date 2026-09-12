#include "ScriptedCreature.h"
#include <vector>
#include "../scripts/Custom/Timewalking/10Man.h"

enum Spells
{
    SPELL_VOID_BOLT = 50796,
    SPELL_SHADOW_BOLT_VOLLEY = 14887,
    SPELL_IMMOLATE = 20787,
    SPELL_ENLARGE = 22710,
    SPELL_CURSE_OF_THORNS = 16247,
    SPELL_CURSE_OF_TONGUES = 13338
};

enum Events
{
    EVENT_VOID_BOLT = 1,
    EVENT_SHADOW_BOLT_VOLLEY,
    EVENT_IMMOLATE,
    EVENT_ENLARGE,
    EVENT_CURSE_OF_THORNS,
    EVENT_CURSE_OF_TONGUES,
    EVENT_SPAWN_VOIDWALKER 
};


class boss_lethtendris : public CreatureScript
{
public:
    boss_lethtendris() : CreatureScript("boss_lethtendris") {}

    struct boss_lethtendrisAI : public ScriptedAI
    {
        boss_lethtendrisAI(Creature* creature) : ScriptedAI(creature), spawnPosition(creature->GetPosition()) {}

        Position spawnPosition;
        std::vector<ObjectGuid> ritualSummoningGUIDs;
        std::vector<ObjectGuid> summonedVoidwalkersGUIDs;
        std::vector<Position> spawnPoints = {
            {-47.539245605469f, -450.19821166992f, 16.401742935181f, 6.2483553886414f},
            {-23.67557144165f, -433.24621582031f, 16.413509368896f, 4.8283429145813f},
            {-16.906826019287f, -466.80062866211f, 16.39567565918f, 1.6210817098618f}
        };

        void Reset() override
        {
            events.Reset();
            DespawnRitualSummoning();
            DespawnVoidwalkers();
        }

        void DespawnRitualSummoning()
        {
            for (auto& guid : ritualSummoningGUIDs)
            {
                if (GameObject* ritualSummoning = ObjectAccessor::GetGameObject(*me, guid))
                {
                    ritualSummoning->Delete();
                }
            }
            ritualSummoningGUIDs.clear();
        }

        void JustEngagedWith(Unit* /*who*/) override
        {
            me->Yell("Foolish mortals, the shadows call to me... and now, they shall consume you!", LANG_UNIVERSAL);
            SpawnRitualSummoning();

            events.ScheduleEvent(EVENT_VOID_BOLT, 0);
            events.ScheduleEvent(EVENT_SHADOW_BOLT_VOLLEY, 3 * IN_MILLISECONDS);
            events.ScheduleEvent(EVENT_IMMOLATE, urand(5, 11) * IN_MILLISECONDS);
            events.ScheduleEvent(EVENT_ENLARGE, 11 * IN_MILLISECONDS);
            events.ScheduleEvent(EVENT_CURSE_OF_THORNS, urand(11, 20) * IN_MILLISECONDS);
            events.ScheduleEvent(EVENT_CURSE_OF_TONGUES, urand(11, 20) * IN_MILLISECONDS);
            events.ScheduleEvent(EVENT_SPAWN_VOIDWALKER, 10 * IN_MILLISECONDS); 
        }

        void SpawnRitualSummoning()
        {
            uint32 respawnTime = 900000; 
            for (auto& point : spawnPoints)
            {
                if (GameObject* ritualSummoning = me->SummonGameObject(185127, point.GetPositionX(), point.GetPositionY(), point.GetPositionZ(), point.GetOrientation(), 0, 0, 0, 0, respawnTime, false, GO_SUMMON_TIMED_OR_CORPSE_DESPAWN))
                {
                    ritualSummoningGUIDs.push_back(ritualSummoning->GetGUID());
                }
            }
        }

        void JustDied(Unit* /*killer*/) override
        {
            DespawnRitualSummoning();
            DespawnVoidwalkers();
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

        void DespawnVoidwalkers()
        {
            for (auto& guid : summonedVoidwalkersGUIDs)
            {
                if (Creature* voidwalker = ObjectAccessor::GetCreature(*me, guid))
                {
                    voidwalker->DespawnOrUnsummon();
                }
            }
            summonedVoidwalkersGUIDs.clear(); 
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (me->GetDistance(spawnPosition) > 39.0f)
            {
                EnterEvadeMode();
                return;
            }

            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_VOID_BOLT:
                    DoCastVictim(SPELL_VOID_BOLT);
                    events.ScheduleEvent(EVENT_VOID_BOLT, urand(5, 6) * IN_MILLISECONDS);
                    break;
                case EVENT_SHADOW_BOLT_VOLLEY:
                    DoCastAOE(SPELL_SHADOW_BOLT_VOLLEY, true);
                    events.ScheduleEvent(EVENT_SHADOW_BOLT_VOLLEY, urand(11, 14) * IN_MILLISECONDS);
                    break;
                case EVENT_IMMOLATE:
                    DoCastRandomTarget(SPELL_IMMOLATE, 0, 65.0f, false, false);
                    events.ScheduleEvent(EVENT_IMMOLATE, urand(14, 20) * IN_MILLISECONDS);
                    break;
                case EVENT_ENLARGE:
                    DoCastSelf(SPELL_ENLARGE, true);
                    events.ScheduleEvent(EVENT_ENLARGE, 30 * IN_MILLISECONDS);
                    break;
                case EVENT_CURSE_OF_THORNS:
                    DoCastVictim(SPELL_CURSE_OF_THORNS, true);
                    events.ScheduleEvent(EVENT_CURSE_OF_THORNS, urand(11, 20) * IN_MILLISECONDS);
                    break;
                case EVENT_CURSE_OF_TONGUES:
                    DoCastRandomTarget(SPELL_CURSE_OF_TONGUES, 0, 65.0f, false, true);
                    events.ScheduleEvent(EVENT_CURSE_OF_TONGUES, urand(11, 20) * IN_MILLISECONDS);
                    break;
                case EVENT_SPAWN_VOIDWALKER:
                {
                    me->Yell("From the void, I summon thee!", LANG_UNIVERSAL);
                    Position& spawnPoint = spawnPoints[urand(0, spawnPoints.size() - 1)];
                    if (Creature* voidwalker = me->SummonCreature(889178, spawnPoint))
                    {
                        summonedVoidwalkersGUIDs.push_back(voidwalker->GetGUID());
                    }
                    events.ScheduleEvent(EVENT_SPAWN_VOIDWALKER, 15 * IN_MILLISECONDS);
                    break;
                }
                default:
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_lethtendrisAI(creature);
    }
};

class npc_greater_voidwalker : public CreatureScript
{
public:
    npc_greater_voidwalker() : CreatureScript("npc_greater_voidwalker") {}

    struct npc_greater_voidwalkerAI : public ScriptedAI
    {
        npc_greater_voidwalkerAI(Creature* creature) : ScriptedAI(creature), moveCheckTimer(1000), startMovingTimer(2000) {}

        void IsSummonedBy(WorldObject* summoner) override
        {
            if (summoner->GetTypeId() != TYPEID_UNIT)
                return;

            lehtendrisGUID = summoner->GetGUID();
            me->SetReactState(REACT_PASSIVE);
            DoCast(me, 19484, true); // Summon visual
            DoCast(me, 88000, true); // Root
        }

        void UpdateAI(uint32 diff) override
        {
            if (!UpdateVictim())
                return;

            if (startMovingTimer > 0)
            {
                if (startMovingTimer <= diff)
                {
                    startMovingTimer = 0; // Start moving towards Lethtendris
                }
                else
                {
                    startMovingTimer -= diff;
                }
            }
            else if (moveCheckTimer <= diff)
            {
                if (Creature* lehtendris = ObjectAccessor::GetCreature(*me, lehtendrisGUID))
                {
                    me->GetMotionMaster()->MovePoint(1, lehtendris->GetPosition());
                }
                moveCheckTimer = 1000; 
            }
            else
            {
                moveCheckTimer -= diff;
            }
        }

        void MovementInform(uint32 type, uint32 id) override
        {
            if (type == POINT_MOTION_TYPE && id == 1)
            {
                if (Creature* lehtendris = ObjectAccessor::GetCreature(*me, lehtendrisGUID))
                {
                    float adjustedMeleeRange = lehtendris->GetMeleeReach() - 2.0f;
                    if (me->IsWithinDistInMap(lehtendris, adjustedMeleeRange))
                    {
                        DoActionsWhenInRange(lehtendris);
                    }
                }
            }
        }

        void DoActionsWhenInRange(Creature* lehtendris)
        {
            DoCastAOE(SPELL_SHADOW_BOLT_VOLLEY, true);
            DoCast(lehtendris, 38899, true);
            if (Aura* aura = lehtendris->GetAura(80248))
            {
                aura->ModStackAmount(1);
            }
            else
            {
                lehtendris->AddAura(80248, lehtendris);
            }

            int32 healAmount = CalculatePct(lehtendris->GetMaxHealth(), 6);
            lehtendris->ModifyHealth(healAmount);

            me->DespawnOrUnsummon();
        }

    private:
        uint32 moveCheckTimer;
        uint32 startMovingTimer;
        ObjectGuid lehtendrisGUID;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_greater_voidwalkerAI(creature);
    }
};

void AddSC_boss_lethtendris()
{
    new boss_lethtendris();
    new npc_greater_voidwalker();
}
