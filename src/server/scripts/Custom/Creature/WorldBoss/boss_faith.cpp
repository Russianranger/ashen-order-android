#include "ScriptMgr.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "SpellScript.h"
#include "GossipDef.h"
#include "MiscPackets.h"

enum FaithEvents
{
    EVENT_LAUGH_1 = 1,
    EVENT_LAUGH_2,
    EVENT_DELAY_AFTER_LAUGH,
    EVENT_WALK_TO_CENTER,
    EVENT_CAST_SPELLS,
    EVENT_START_COMBAT,
    EVENT_CHECK_DISTANCE
};

enum FaithSpells
{
    SPELL_SPELL1 = 72523,
    SPELL_SPELL2 = 72521,
    SPELL_SPELL3 = 51126,
    SPELL_SPELL4 = 863289,
    SPELL_SPELL5 = 863290,
    SPELL_SPELL6 = 67040
};

enum NpcEntries
{
    NPC_FAITH = 851019 // Replace with actual NPC ID
};

const float CENTER_X = 3715.6948242188f;
const float CENTER_Y = -5106.6870117188f;
const float CENTER_Z = 141.28868103027f;
const float CENTER_O = 2.8253583908081f;

const uint32 MUSIC_SOUND_ID = 188047; // Sound entry ID for the music

class boss_faith : public CreatureScript
{
public:
    boss_faith() : CreatureScript("boss_faith") {}

    struct boss_faithAI : public ScriptedAI
    {
        boss_faithAI(Creature* creature) : ScriptedAI(creature), eventStarted(false) {}

        void InitializeAI() override
        {
            ScriptedAI::InitializeAI();
            me->SetStandState(UNIT_STAND_STATE_SIT_HIGH_CHAIR);
        }

        void Reset() override
        {
            events.Reset();
            eventStarted = false;
            me->SetReactState(REACT_PASSIVE);
            me->SetFlag(UNIT_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP); // Re-enable gossip
            me->SetFaction(84); // Set faction to 84 on reset
            me->SetStandState(UNIT_STAND_STATE_SIT_HIGH_CHAIR);
        }

        void EnterEvadeMode(EvadeReason /*why*/) override
        {
            ResetFight();
        }

        void DoAction(int32 action) override
        {
            if (action == 1 && !eventStarted) // Gossip selection action
            {
                eventStarted = true;
                me->RemoveFlag(UNIT_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP); // Remove gossip flag

                // Play music
                std::list<Unit*> targetList;
                Acore::AnyUnitInObjectRangeCheck mchecker(me, 100.0f);
                Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targetList, mchecker);
                Cell::VisitAllObjects(me, searcher, 100.0f);

                for (Unit* unit : targetList)
                {
                    if (Player* player = unit->ToPlayer())
                    {
                        if (player->GetSession())
                            player->SendPlayMusic(MUSIC_SOUND_ID, false);
                    }
                }

                events.ScheduleEvent(EVENT_LAUGH_1, 500); // 500 ms delay before laughing
            }
        }

        void UpdateAI(uint32 diff) override
        {
            events.Update(diff);

            if (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_LAUGH_1:
                    me->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                    events.ScheduleEvent(EVENT_LAUGH_2, 2000);
                    break;
                case EVENT_LAUGH_2:
                    me->Say("Allow me to show you...", LANG_UNIVERSAL);
                    events.ScheduleEvent(EVENT_DELAY_AFTER_LAUGH, 1000); // Delay before walking to center
                    break;
                case EVENT_DELAY_AFTER_LAUGH:
                    me->SetWalk(true); // Explicitly set to walk
                    me->SetStandState(UNIT_STAND_STATE_STAND); // Make sure the boss stands up before walking
                    me->GetMotionMaster()->MovePoint(0, CENTER_X, CENTER_Y, CENTER_Z);
                    events.ScheduleEvent(EVENT_WALK_TO_CENTER, 1000);
                    break;
                case EVENT_WALK_TO_CENTER:
                    if (me->GetExactDist2d(CENTER_X, CENTER_Y) <= 1.0f)
                    {
                        me->SetFacingTo(CENTER_O);
                        me->SetFaction(21);
                        DoCast(me, SPELL_SPELL1, true);
                        DoCast(me, SPELL_SPELL2, true);
                        DoCast(me, SPELL_SPELL3, true);
                        DoCast(me, SPELL_SPELL4, true);
                        DoCast(me, SPELL_SPELL5, true);
                        DoCast(me, 929467, true);
                        DoCast(me, SPELL_SPELL6, false); // Not triggered
                        me->SetInCombatWithZone();
                        events.ScheduleEvent(EVENT_START_COMBAT, 2000);
                    }
                    else
                    {
                        events.ScheduleEvent(EVENT_WALK_TO_CENTER, 1000);
                    }
                    break;
                case EVENT_START_COMBAT:
                    DoCast(me, SPELL_SPELL6, false); // Continue channeling SPELL_SPELL6
                    events.ScheduleEvent(EVENT_CHECK_DISTANCE, 1000);
                    break;
                case EVENT_CHECK_DISTANCE:
                    CheckDistance();
                    events.ScheduleEvent(EVENT_CHECK_DISTANCE, 1000);
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

        void CheckDistance()
        {
            std::list<Unit*> targetList;
            Acore::AnyUnitInObjectRangeCheck checker(me, 100.0f);
            Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, targetList, checker);
            Cell::VisitAllObjects(me, searcher, 100.0f);

            bool hasNearbyEntity = false;

            for (Unit* unit : targetList)
            {
                if ((unit->IsPlayer() || (unit->ToCreature() && unit->ToCreature()->IsNPCBot())) && unit->IsAlive())
                {
                    hasNearbyEntity = true;
                    break;
                }
            }

            if (!hasNearbyEntity)
            {
                ResetFight();
            }
        }

        void ResetFight()
        {
            me->DespawnOrUnsummon();
            me->Respawn();
            Reset();
        }

    private:
        EventMap events;
        bool eventStarted;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new boss_faithAI(creature);
    }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        ClearGossipMenuFor(player);
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, "Who are you?", GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
        SendGossipMenuFor(player, 1, creature->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 sender, uint32 action) override
    {
        if (action == GOSSIP_ACTION_INFO_DEF + 1)
        {
            ClearGossipMenuFor(player);
            CloseGossipMenuFor(player);
            creature->AI()->DoAction(1);
        }
        return true;
    }
};

void AddSC_boss_faith()
{
    new boss_faith();
}
