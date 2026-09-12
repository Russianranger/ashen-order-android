#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "Log.h"

enum MissDannaWaypoints
{
    PATH_ID = 3513,
    WP_CATHEDRAL = 20,
    WP_KEEP = 36,
    WP_KEEP_REBUILD = 37,
    WP_KEEP_CHILD = 38,
    WP_CATHEDRAL_RETURN = 54
};

enum MissDannaEvents
{
    EVENT_CATHEDRAL_1 = 1,
    EVENT_CATHEDRAL_2,
    EVENT_CATHEDRAL_3,
    EVENT_KEEP_CHILD_1,
    EVENT_KEEP_CHILD_2,
    EVENT_CATHEDRAL_RETURN_1,
    EVENT_CATHEDRAL_RETURN_2,
    EVENT_CATHEDRAL_RETURN_3
};

class npc_miss_danna : public CreatureScript
{
public:
    npc_miss_danna() : CreatureScript("npc_miss_danna") { }

    struct npc_miss_dannaAI : public ScriptedAI
    {
        npc_miss_dannaAI(Creature* creature) : ScriptedAI(creature)
        {
            Initialize();
        }

        void Initialize()
        {
            if (me->GetMotionMaster()->GetCurrentMovementGeneratorType() == WAYPOINT_MOTION_TYPE)
                me->GetMotionMaster()->MovePath(PATH_ID, true);
        }

        void MovementInform(uint32 type, uint32 pointId) override
        {
            if (type != WAYPOINT_MOTION_TYPE)
                return;


            switch (pointId)
            {
            case WP_CATHEDRAL:
                me->SetFacingTo(0.663f);
                SetOrientationForNearbyCreatures(0.663f);
                me->Say("Here we have the Cathedral of Light, the center of spiritual enlightenment here in Stormwind.", LANG_UNIVERSAL);
                me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                events.ScheduleEvent(EVENT_CATHEDRAL_1, 8000);
                events.ScheduleEvent(EVENT_CATHEDRAL_2, 12000);
                events.ScheduleEvent(EVENT_CATHEDRAL_3, 26000);
                break;
            case WP_KEEP:
                me->Say("Here we have Stormwind Keep. Built upon the ruins of Stormwind Castle, which was destroyed by the Horde in the first Great War.", LANG_UNIVERSAL);
                break;
            case WP_KEEP_REBUILD:
                me->Say("When the Horde was shattered, men returned here and began to rebuild the once great city as a testament to our own survival.", LANG_UNIVERSAL);
                break;
            case WP_KEEP_CHILD:
                me->SetFacingTo(5.433f);
                SetOrientationForNearbyCreatures(5.433f);
                events.ScheduleEvent(EVENT_KEEP_CHILD_1, 8000);
                events.ScheduleEvent(EVENT_KEEP_CHILD_2, 16000);
                break;
            case WP_CATHEDRAL_RETURN:
                me->SetFacingTo(3.589f);
                SetOrientationForNearbyCreatures(3.589f);
                events.ScheduleEvent(EVENT_CATHEDRAL_RETURN_1, 50);
                events.ScheduleEvent(EVENT_CATHEDRAL_RETURN_2, 6000);
                events.ScheduleEvent(EVENT_CATHEDRAL_RETURN_3, 12000);
                break;
            }
        }

        void SetOrientationForNearbyCreatures(float orientation)
        {
            std::list<Creature*> creatures;
            me->GetCreatureListWithEntryInGrid(creatures, 3505, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3506, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3507, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3508, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3509, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3510, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3511, 30.0f);
            me->GetCreatureListWithEntryInGrid(creatures, 3512, 30.0f);

            for (Creature* creature : creatures)
            {
                if (creature && creature->IsAlive())
                {
                    creature->SetFacingTo(orientation);
                }
            }
        }

        void UpdateAI(uint32 diff) override
        {
            events.Update(diff);

            while (uint32 eventId = events.ExecuteEvent())
            {
                switch (eventId)
                {
                case EVENT_CATHEDRAL_1:
                    if (Creature* creature = GetClosestCreatureWithEntry(me, 3512, 30.0f))
                        creature->Say("Is it true that the paladins train here?", LANG_UNIVERSAL);
                    break;
                case EVENT_CATHEDRAL_2:
                    me->Say("Yes, that is true. Paladins and priests alike train their skills and research great truths behind the walls of the Cathedral.", LANG_UNIVERSAL);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    break;
                case EVENT_CATHEDRAL_3:
                    me->Say("Children if you would please follow me, we will now be going to see the keep where King Anduin Wrynn himself sits on his throne.", LANG_UNIVERSAL);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    break;
                case EVENT_KEEP_CHILD_1:
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    if (Creature* creature = GetClosestCreatureWithEntry(me, 3511, 30.0f))
                    {
                        std::vector<std::string> lines = {
                            "It's better than the drawings in the history tomes.",
                            "Teacher, he keeps poking me!",
                            "Teacher, I have to pee!",
                            "Teacher, when are we gonna see the sparkly Mage Tower?",
                            "Why do we have to learn this stuff anyway?"
                        };
                        creature->Say(lines[urand(0, lines.size() - 1)], LANG_UNIVERSAL);
                    }
                    break;
                case EVENT_KEEP_CHILD_2:
                    me->Say("Yes, well... let's head on to the monument dedicated to the heroes of the two Great Wars, the Valley of Heroes. Follow me.", LANG_UNIVERSAL);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    break;
                case EVENT_CATHEDRAL_RETURN_1:
                    me->Say("Isn't it amazing, children? All who enter the city must walk beneath the watchful eyes of the greatest heroes of our lands.", LANG_UNIVERSAL);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    break;
                case EVENT_CATHEDRAL_RETURN_2:
                    me->Say("Breathtaking. Children, when we return to the school, you will each give an oral report on one of these legendary people.", LANG_UNIVERSAL);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    break;
                case EVENT_CATHEDRAL_RETURN_3:
                    me->Say("Now, take another long look before we make our way to the Holy District and the great Cathedral of Light.", LANG_UNIVERSAL);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                    break;
                }
            }

            DoMeleeAttackIfReady();
        }

    private:
        EventMap events;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_miss_dannaAI(creature);
    }
};

void AddSC_npc_miss_danna()
{
    new npc_miss_danna();
}
