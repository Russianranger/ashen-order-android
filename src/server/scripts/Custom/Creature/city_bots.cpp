#include "ScriptMgr.h"
#include "Creature.h"
#include "CreatureAI.h"
#include "Player.h"
#include "ObjectAccessor.h"
#include "World.h"
#include "Chat.h"
#include <random>
#include <algorithm> 

enum HordeDancerIds
{
    HDANCER_ONE = 815371,
    HDANCER_TWO = 815372,
    HDANCER_THREE = 815373,
    HDANCER_FOUR = 815374,
    HDANCER_FIVE = 815375,

};

enum AllianceDancerIds
{
    ADANCER_ONE = 825372,
    ADANCER_TWO = 825373,
    ADANCER_THREE = 825374,
    ADANCER_FOUR = 825375,
    ADANCER_FIVE = 825376,
    ADANCER_SIX = 825377,
    ADANCER_SEVEN = 825378,
    ADANCER_EIGHT = 825379,

};

const char* RandomSayings[] =
{
    "|cFFFFFFFFNeed gold for epic mount!|r",
    "|cFFFFFFFFWill dance for tips!|r",
    "|cFFFFFFFFThrow me some gold!|r",
    "|cFFFFFFFFCheck out these moves!|r",
    "|cFFFFFFFFDancing for donations!|r",
    "|cFFFFFFFFHey there good lookin'|r",
    "|cFFFFFFFFWho wants to see a special move?|r",
    "|cFFFFFFFFSupport your local dancer!|r",
    "|cFFFFFFFFTip me and I'll keep dancing!|r",
    "|cFFFFFFFFAny generous souls out there?|r",
    "|cFFFFFFFFI'm the best dancer in town!|r",
    "|cFFFFFFFFDance with me and let's have fun!|r",
    "|cFFFFFFFFFeeling generous today?|r",
    "|cFFFFFFFFShow some love with gold!|r",
    "|cFFFFFFFFHey there good lookin'|r",
};

class horde_city_dancers : public CreatureScript
{
public:
    horde_city_dancers() : CreatureScript("horde_city_dancers") { }

    struct horde_city_dancersAI : public ScriptedAI
    {
        horde_city_dancersAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            // Check if another dancer is already alive
            if (IsAnotherDancerAlive())
            {
                me->DespawnOrUnsummon();
                return;
            }

            DoCastSelf(836);

            // 13% chance to despawn immediately
            if (urand(1, 100) <= 13)
            {
                me->DespawnOrUnsummon();
                return;
            }

            // Randomly despawn and summon a different dancer
            if (urand(1, 100) <= 34)
            {
                uint32 newId = GetNewDancerId(me->GetEntry());
                float x = me->GetPositionX();
                float y = me->GetPositionY();
                float z = me->GetPositionZ();
                float o = me->GetOrientation();
                me->DespawnOrUnsummon();
                me->SummonCreature(newId, x, y, z, o, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 1800000);
            }

            _laughTimer = urand(10000, 15000);
            _flirtTimer = urand(20000, 25000);
            _sayTimer = urand(15000, 20000);
            _cheerTimer = urand(12000, 18000);
            _whistleTimer = urand(30000, 45000);
            _jumpTimer = urand(60000, 90000);
            _jumpEndTimer = 0;
        }

        void UpdateAI(uint32 diff) override
        {
            if (_laughTimer <= diff)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                _laughTimer = urand(38000, 80000);
            }
            else
                _laughTimer -= diff;

            if (_flirtTimer <= diff)
            {
                me->HandleEmoteCommand(TEXT_EMOTE_FLIRT);
                _flirtTimer = urand(90000, 160000);
            }
            else
                _flirtTimer -= diff;

            if (_sayTimer <= diff)
            {
                me->Say(RandomSayings[urand(0, 14)], LANG_UNIVERSAL, nullptr);
                _sayTimer = urand(60000, 120000);
            }
            else
                _sayTimer -= diff;

            if (_cheerTimer <= diff)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
                _cheerTimer = urand(120000, 240000);
            }
            else
                _cheerTimer -= diff;

            if (_whistleTimer <= diff)
            {
                me->HandleEmoteCommand(TEXT_EMOTE_WHISTLE);
                _whistleTimer = urand(300000, 600000);
            }
            else
                _whistleTimer -= diff;

            if (_jumpTimer <= diff)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_JUMPSTART);
                _jumpEndTimer = 700;
                _jumpTimer = urand(600000, 1200000);
            }
            else
                _jumpTimer -= diff;

            if (_jumpEndTimer > 0)
            {
                if (_jumpEndTimer <= diff)
                {
                    me->HandleEmoteCommand(EMOTE_ONESHOT_JUMPEND);
                    _jumpEndTimer = 0;
                }
                else
                {
                    _jumpEndTimer -= diff;
                }
            }
        }

        bool IsAnotherDancerAlive()
        {
            std::list<Creature*> creatures;
            me->GetCreatureListWithEntryInGrid(creatures, HDANCER_ONE, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, HDANCER_TWO, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, HDANCER_THREE, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, HDANCER_FOUR, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, HDANCER_FIVE, 5.0f);

            for (Creature* creature : creatures)
            {
                if (creature && creature->IsAlive() && creature != me)
                {
                    return true;
                }
            }
            return false;
        }

        uint32 GetNewDancerId(uint32 currentId)
        {
            std::vector<uint32> possibleIds = { HDANCER_ONE, HDANCER_TWO, HDANCER_THREE, HDANCER_FOUR, HDANCER_FIVE };
            possibleIds.erase(std::remove(possibleIds.begin(), possibleIds.end(), currentId), possibleIds.end());
            return possibleIds[urand(0, possibleIds.size() - 1)];
        }

    private:
        uint32 _laughTimer;
        uint32 _flirtTimer;
        uint32 _sayTimer;
        uint32 _cheerTimer;
        uint32 _whistleTimer;
        uint32 _jumpTimer;
        uint32 _jumpEndTimer;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new horde_city_dancersAI(creature);
    }
};

class alliance_city_dancers : public CreatureScript
{
public:
    alliance_city_dancers() : CreatureScript("alliance_city_dancers") { }

    struct alliance_city_dancersAI : public ScriptedAI
    {
        alliance_city_dancersAI(Creature* creature) : ScriptedAI(creature) { }

        void Reset() override
        {
            // Check if another dancer is already alive
            if (IsAnotherDancerAlive())
            {
                me->DespawnOrUnsummon();
                return;
            }

            DoCastSelf(836);

            // 13% chance to despawn immediately
            if (urand(1, 100) <= 13)
            {
                me->DespawnOrUnsummon();
                return;
            }

            // Randomly despawn and summon a different dancer
            if (urand(1, 100) <= 34)
            {
                uint32 newId = GetNewDancerId(me->GetEntry());
                float x = me->GetPositionX();
                float y = me->GetPositionY();
                float z = me->GetPositionZ();
                float o = me->GetOrientation();
                me->DespawnOrUnsummon();
                me->SummonCreature(newId, x, y, z, o, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 1800000);
            }

            _laughTimer = urand(10000, 15000);
            _flirtTimer = urand(20000, 25000);
            _sayTimer = urand(15000, 20000);
            _cheerTimer = urand(12000, 18000);
            _whistleTimer = urand(30000, 45000);
            _jumpTimer = urand(60000, 90000);
            _jumpEndTimer = 0;
        }

        void UpdateAI(uint32 diff) override
        {
            if (_laughTimer <= diff)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                _laughTimer = urand(38000, 80000);
            }
            else
                _laughTimer -= diff;

            if (_flirtTimer <= diff)
            {
                me->HandleEmoteCommand(TEXT_EMOTE_FLIRT);
                _flirtTimer = urand(90000, 160000);
            }
            else
                _flirtTimer -= diff;

            if (_sayTimer <= diff)
            {
                me->Say(RandomSayings[urand(0, 14)], LANG_UNIVERSAL, nullptr);
                _sayTimer = urand(60000, 120000);
            }
            else
                _sayTimer -= diff;

            if (_cheerTimer <= diff)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
                _cheerTimer = urand(120000, 240000);
            }
            else
                _cheerTimer -= diff;

            if (_whistleTimer <= diff)
            {
                me->HandleEmoteCommand(TEXT_EMOTE_WHISTLE);
                _whistleTimer = urand(300000, 600000);
            }
            else
                _whistleTimer -= diff;

            if (_jumpTimer <= diff)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_JUMPSTART);
                _jumpEndTimer = 700;
                _jumpTimer = urand(600000, 1200000);
            }
            else
                _jumpTimer -= diff;

            if (_jumpEndTimer > 0)
            {
                if (_jumpEndTimer <= diff)
                {
                    me->HandleEmoteCommand(EMOTE_ONESHOT_JUMPEND);
                    _jumpEndTimer = 0;
                }
                else
                {
                    _jumpEndTimer -= diff;
                }
            }
        }

        bool IsAnotherDancerAlive()
        {
            std::list<Creature*> creatures;
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_ONE, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_TWO, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_THREE, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_FOUR, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_FIVE, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_SIX, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_SEVEN, 5.0f);
            me->GetCreatureListWithEntryInGrid(creatures, ADANCER_EIGHT, 5.0f);

            for (Creature* creature : creatures)
            {
                if (creature && creature->IsAlive() && creature != me)
                {
                    return true;
                }
            }
            return false;
        }

        uint32 GetNewDancerId(uint32 currentId)
        {
            std::vector<uint32> possibleIds = { ADANCER_ONE, ADANCER_TWO, ADANCER_THREE, ADANCER_FOUR, ADANCER_FIVE, ADANCER_SIX, ADANCER_SEVEN, ADANCER_EIGHT };
            possibleIds.erase(std::remove(possibleIds.begin(), possibleIds.end(), currentId), possibleIds.end());
            return possibleIds[urand(0, possibleIds.size() - 1)];
        }

    private:
        uint32 _laughTimer;
        uint32 _flirtTimer;
        uint32 _sayTimer;
        uint32 _cheerTimer;
        uint32 _whistleTimer;
        uint32 _jumpTimer;
        uint32 _jumpEndTimer;
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new alliance_city_dancersAI(creature);
    }
};

#define INTERACTION_DELAY 12000 
#define MOVEMENT_RANGE 60.0f
#define RANDOM_IDLE_CHANCE 10 
#define IDLE_TIME 10000 
#define POST_REACH_DELAY 750 
#define MAX_DISTANCE_FROM_HOME 150.0f 
#define STUCK_THRESHOLD 30000 
#define LOS_MOVE_DISTANCE 3.0f 

class npc_city_bot : public CreatureScript
{
public:
    npc_city_bot() : CreatureScript("npc_city_bot") { }

    struct npc_city_botAI : public ScriptedAI
    {
        npc_city_botAI(Creature* creature) : ScriptedAI(creature), interactTimer(INTERACTION_DELAY), idleTimer(0), stuckTimer(0), idling(false), postReachDelayTimer(0)
        {
            homePosition = creature->GetPosition(); 
        }

        uint32 interactTimer;
        uint32 idleTimer;
        uint32 postReachDelayTimer;
        uint32 stuckTimer; 
        bool idling;
        Creature* targetNpc;
        std::list<Creature*> nearbyNpcs;
        std::deque<Creature*> lastNpcs; 
        Position homePosition; 

        void Reset() override
        {
            interactTimer = INTERACTION_DELAY + (urand(0, 1000) * (urand(0, 1) ? 1 : -1)); 
            idleTimer = 0;
            stuckTimer = 0;
            postReachDelayTimer = 0;
            idling = false;
            targetNpc = nullptr;
            nearbyNpcs.clear();
        }

        void UpdateAI(uint32 diff) override
        {
            if (me->GetExactDist2d(homePosition) > MAX_DISTANCE_FROM_HOME)
            {
                me->NearTeleportTo(
                    homePosition.GetPositionX(),
                    homePosition.GetPositionY(),
                    homePosition.GetPositionZ(),
                    homePosition.GetOrientation()
                );
                SelectNewTarget();
                return;
            }

            if (idling)
            {
                if (idleTimer <= diff)
                {
                    idling = false;
                    idleTimer = 0;
                }
                else
                {
                    idleTimer -= diff;
                    return;
                }
            }

            if (targetNpc && !me->IsWithinDistInMap(targetNpc, 1.5f))
            {
                stuckTimer += diff;
                if (stuckTimer >= STUCK_THRESHOLD)
                {
                    me->NearTeleportTo(
                        homePosition.GetPositionX(),
                        homePosition.GetPositionY(),
                        homePosition.GetPositionZ(),
                        homePosition.GetOrientation()
                    );
                    stuckTimer = 0; 
                    SelectNewTarget(); 
                    return;
                }
            }
            else
            {
                stuckTimer = 0; 
            }

            if (postReachDelayTimer > 0)
            {
                if (postReachDelayTimer <= diff)
                {
                    postReachDelayTimer = 0;
                    me->SetFacingToObject(targetNpc); 
                    DoInteract(); 
                }
                else
                {
                    postReachDelayTimer -= diff;
                    return;
                }
            }

            if (interactTimer <= diff)
            {
                if (!targetNpc)
                {
                    SelectNewTarget();
                }

                if (targetNpc)
                {
                    if (me->IsWithinDistInMap(targetNpc, 1.25f))
                    {
                        postReachDelayTimer = POST_REACH_DELAY; 
                        interactTimer = INTERACTION_DELAY + (urand(0, 1000) * (urand(0, 1) ? 1 : -1));
                    }
                    else
                    {
                        float x, y, z;
                        targetNpc->GetClosePoint(x, y, z, 1.5f);
                        me->GetMotionMaster()->MovePoint(1, x, y, z, true, true, MOTION_SLOT_ACTIVE, 0.0f);
                    }
                }
            }
            else
            {
                interactTimer -= diff;
            }
        }

        void StartIdling()
        {
            idling = true;
            idleTimer = IDLE_TIME + (urand(0, 1000) * (urand(0, 1) ? 1 : -1));

            uint32 randomEmoteChance = urand(0, 99);
            if (randomEmoteChance < 10)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
            }
            else if (randomEmoteChance < 20)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
            }
        }

        void SelectNewTarget()
        {
            nearbyNpcs.clear();
            targetNpc = nullptr;

            std::vector<uint32> npcFlags = {
                0x00000002, // Quest Giver
                0x00000010, // Trainer
                0x00000020, // Class Trainer
                0x00000040, // Profession Trainer
                0x00000080, // Vendor (generic)
                0x00000100, // Vendor Ammo
                0x00000200, // Vendor Food
                0x00000400, // Vendor Poison
                0x00000800, // Vendor Reagent
                0x00001000, // Repairer
                0x00002000, // Flight Master
                0x00010000, // Innkeeper
                0x00020000, // Banker
                0x00040000, // Petitioner
                0x00080000, // Tabard Designer
                0x00100000, // Battlemaster
                0x00200000, // Auctioneer
                0x00400000, // Stable Master
                0x00800000, // Guild Banker
                0x01000000, // Spellclick
                0x04000000  // Mailbox
            };

            CellCoord p(Acore::ComputeCellCoord(me->GetPositionX(), me->GetPositionY()));
            Cell cell(p);
            cell.SetNoCreate();

            Acore::AnyUnitInObjectRangeCheck checker(me, MOVEMENT_RANGE);
            Acore::CreatureListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(me, nearbyNpcs, checker);

            TypeContainerVisitor<Acore::CreatureListSearcher<Acore::AnyUnitInObjectRangeCheck>, GridTypeMapContainer> visitor(searcher);
            cell.Visit(p, visitor, *me->GetMap(), *me, MOVEMENT_RANGE);

            std::vector<Creature*> shuffledNpcs(nearbyNpcs.begin(), nearbyNpcs.end());
            std::random_device rd;
            std::default_random_engine rng(rd());
            std::shuffle(shuffledNpcs.begin(), shuffledNpcs.end(), rng);

            for (auto* npc : shuffledNpcs)
            {
                if (npc == me || std::find(lastNpcs.begin(), lastNpcs.end(), npc) != lastNpcs.end())
                    continue;

                if (npc->GetMotionMaster()->GetCurrentMovementGeneratorType() == RANDOM_MOTION_TYPE ||
                    npc->GetMotionMaster()->GetCurrentMovementGeneratorType() == WAYPOINT_MOTION_TYPE)
                {
                    continue;
                }

                if (homePosition.GetExactDist2d(npc->GetPosition()) > MAX_DISTANCE_FROM_HOME)
                    continue;

                uint32 flags = npc->GetUInt32Value(UNIT_NPC_FLAGS);
                for (uint32 flag : npcFlags)
                {
                    if (flags & flag)
                    {
                        targetNpc = npc;
                        lastNpcs.push_back(targetNpc);
                        if (lastNpcs.size() > 3)
                            lastNpcs.pop_front();

                        return;
                    }
                }
            }
        }

        void DoInteract()
        {
            if (urand(0, 99) < 75)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
            }

            uint32 randomEmoteChance = urand(0, 99);
            if (randomEmoteChance < 10)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
            }
            else if (randomEmoteChance < 20)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
            }

            DoRandomChat();

            if (urand(0, 99) < RANDOM_IDLE_CHANCE)
            {
                StartIdling();
            }
            else
            {
                interactTimer = INTERACTION_DELAY + (urand(0, 1000) * (urand(0, 1) ? 1 : -1));
                SelectNewTarget();
            }
        }

        void MoveToRandomLOSPosition()
        {
            float angle = frand(0.0f, static_cast<float>(2 * M_PI));
            float distance = frand(0.5f, LOS_MOVE_DISTANCE);
            float newX = me->GetPositionX() + distance * cos(angle);
            float newY = me->GetPositionY() + distance * sin(angle);
            float newZ = me->GetMap()->GetHeight(newX, newY, me->GetPositionZ());

            me->GetMotionMaster()->Clear();
            me->GetMotionMaster()->MovePoint(1, newX, newY, newZ);
        }

        void DoRandomChat()
        {
            static const std::vector<std::string> randomChats = {
                "Hello there!",
                "Nice weather we're having, isn't it?",
                "Just browsing...",
                "I wonder if there's something new today.",
                "What a busy day in the city!",
                "Need any help, friend?"
            };

            if (urand(0, 99) < 10)
            {
                std::string message = randomChats[urand(0, randomChats.size() - 1)];
                me->Say(message, LANG_UNIVERSAL);
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_city_botAI(creature);
    }
};

//@TODO: Fix guide bunny 
class npc_city_bot_small : public CreatureScript
{
public:
    npc_city_bot_small() : CreatureScript("npc_city_bot_small") { }

    struct npc_city_bot_smallAI : public ScriptedAI
    {
        npc_city_bot_smallAI(Creature* creature)
            : ScriptedAI(creature), interactTimer(INTERACTION_DELAY), idleTimer(0), stuckTimer(0), idling(false), postReachDelayTimer(0), isGuideBunny(false)
        {
            homePosition = creature->GetPosition();
        }

        uint32 interactTimer;
        uint32 idleTimer;
        uint32 postReachDelayTimer;
        uint32 stuckTimer;
        bool idling;
        bool isGuideBunny;
        Creature* targetNpc;
        Creature* intermediaryBunny;
        std::vector<Creature*> nearbyNpcs;
        std::deque<Creature*> lastNpcs;
        Position homePosition;

        void Reset() override
        {
            interactTimer = INTERACTION_DELAY + urand(0, 1000);
            idleTimer = 0;
            stuckTimer = 0;
            postReachDelayTimer = 0;
            idling = false;
            targetNpc = nullptr;
            intermediaryBunny = nullptr;
            isGuideBunny = false;
            nearbyNpcs.clear();
        }

        void UpdateAI(uint32 diff) override
        {
            if (me->GetExactDist2d(homePosition) > MAX_DISTANCE_FROM_HOME)
            {
                float homeX = homePosition.GetPositionX() + frand(-1.0f, 1.0f);
                float homeY = homePosition.GetPositionY() + frand(-1.0f, 1.0f);
                me->NearTeleportTo(homeX, homeY, homePosition.GetPositionZ(), homePosition.GetOrientation());
                SelectNewTarget();
                return;
            }

            if (idling)
            {
                if (idleTimer <= diff)
                {
                    idling = false;
                    idleTimer = 0;
                }
                else
                {
                    idleTimer -= diff;
                    return;
                }
            }

            // Enforce bunny navigation if bunnies are set as intermediaries
            if (isGuideBunny && targetNpc)
            {
                if (!me->IsWithinDistInMap(targetNpc, 1.5f))
                {
                    float x, y, z;
                    targetNpc->GetClosePoint(x, y, z, 1.5f);
                    me->GetMotionMaster()->MovePoint(1, x, y, z);
                }
                else
                {
                    if (intermediaryBunny) // Move to the second bunny if it’s the next step
                    {
                        targetNpc = intermediaryBunny;
                        intermediaryBunny = nullptr; // Clear intermediary after reaching it
                    }
                    else
                    {
                        targetNpc = nullptr;
                        isGuideBunny = false;
                        SelectNewTarget(); // Reassess the intended NPC target after reaching the last bunny
                    }
                }
                return;
            }

            // Standard NPC interaction logic
            if (targetNpc && !me->IsWithinDistInMap(targetNpc, 1.5f))
            {
                stuckTimer += diff;
                if (stuckTimer >= 12000)
                {
                    MoveToRandomLOSPosition();
                    stuckTimer = 0;
                }
            }
            else
            {
                stuckTimer = 0;
            }

            if (postReachDelayTimer > 0)
            {
                if (postReachDelayTimer <= diff)
                {
                    postReachDelayTimer = 0;
                    me->SetFacingToObject(targetNpc);
                    DoInteract();
                }
                else
                {
                    postReachDelayTimer -= diff;
                    return;
                }
            }

            if (interactTimer <= diff)
            {
                if (!targetNpc)
                {
                    SelectNewTarget();
                }

                if (targetNpc)
                {
                    if (me->IsWithinDistInMap(targetNpc, 1.25f))
                    {
                        postReachDelayTimer = POST_REACH_DELAY;
                        interactTimer = INTERACTION_DELAY + urand(0, 4500);
                    }
                    else
                    {
                        float x, y, z;
                        targetNpc->GetClosePoint(x, y, z, 1.5f);
                        me->GetMotionMaster()->MovePoint(1, x, y, z, true, true, MOTION_SLOT_ACTIVE, 0.0f);
                    }
                }
            }
            else
            {
                interactTimer -= diff;
            }
        }

        void StartIdling()
        {
            idling = true;
            idleTimer = IDLE_TIME + urand(0, 2000);

            uint32 randomEmoteChance = urand(0, 99);
            if (randomEmoteChance < 15)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
            }
            else if (randomEmoteChance < 25)
            {
                me->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
            }
        }

        void SelectNewTarget()
        {
            nearbyNpcs.clear();
            targetNpc = nullptr;
            isGuideBunny = false;

            std::vector<uint32> npcFlags = {
                0x00000002, // Quest Giver
                0x00000010, // Trainer
                0x00000020, // Class Trainer
                0x00000040, // Profession Trainer
                0x00000080, // Vendor (generic)
                0x00000100, // Vendor Ammo
                0x00000200, // Vendor Food
                0x00000400, // Vendor Poison
                0x00000800, // Vendor Reagent
                0x00001000, // Repairer
                0x00002000, // Flight Master
                0x00007000, // Guard
                0x00010000, // Innkeeper
                0x00020000, // Banker
                0x00040000, // Petitioner
                0x00080000, // Tabard Designer
                0x00100000, // Battlemaster
                0x00200000, // Auctioneer
                0x00400000, // Stable Master
                0x00800000, // Guild Banker
                0x00100000, // Battlemaster
                0x04000000  // Mailbox
            };

            CellCoord p(Acore::ComputeCellCoord(me->GetPositionX(), me->GetPositionY()));
            Cell cell(p);
            cell.SetNoCreate();

            Acore::AnyUnitInObjectRangeCheck fullRangeChecker(me, MOVEMENT_RANGE);
            Acore::CreatureListSearcher<Acore::AnyUnitInObjectRangeCheck> fullRangeSearcher(me, nearbyNpcs, fullRangeChecker);

            TypeContainerVisitor<Acore::CreatureListSearcher<Acore::AnyUnitInObjectRangeCheck>, GridTypeMapContainer> fullRangeVisitor(fullRangeSearcher);
            cell.Visit(p, fullRangeVisitor, *me->GetMap(), *me, MOVEMENT_RANGE);

            // Select random NPC target
            std::shuffle(nearbyNpcs.begin(), nearbyNpcs.end(), std::default_random_engine(std::random_device{}()));

            std::vector<Creature*> potentialTargets;

            // Filter NPCs by criteria and populate potentialTargets, enforcing strict Z-axis check
            for (auto* npc : nearbyNpcs)
            {
                if (npc == me || std::find(lastNpcs.begin(), lastNpcs.end(), npc) != lastNpcs.end())
                    continue;

                // Absolute Z-axis check: Skip if outside ±2.5f from bot’s Z position
                float zDiff = npc->GetPositionZ() - me->GetPositionZ();
                if (zDiff > 2.5f || zDiff < -2.5f)
                    continue;

                if (homePosition.GetExactDist2d(npc->GetPosition()) > MAX_DISTANCE_FROM_HOME)
                    continue;

                uint32 flags = npc->GetUInt32Value(UNIT_NPC_FLAGS);
                for (uint32 flag : npcFlags)
                {
                    if (flags & flag)
                    {
                        potentialTargets.push_back(npc);
                        break;
                    }
                }
            }

            if (!potentialTargets.empty())
            {
                targetNpc = potentialTargets[urand(0, potentialTargets.size() - 1)];

                // If in LOS, no need for bunnies
                if (me->IsWithinLOSInMap(targetNpc))
                {
                    isGuideBunny = false;
                    lastNpcs.push_back(targetNpc);
                    if (lastNpcs.size() > 3 )
                        lastNpcs.pop_front();
                    return;
                }
            }

            // Check for bunnies if target is out of LOS
            for (auto* bunny : nearbyNpcs)
            {
                if (bunny->GetEntry() == 812222 && me->IsWithinLOSInMap(bunny) && bunny->IsWithinLOSInMap(targetNpc))
                {
                    targetNpc = bunny;
                    isGuideBunny = true;
                    lastNpcs.push_back(targetNpc);
                    if (lastNpcs.size() > 3)
                        lastNpcs.pop_front();
                    return;
                }
            }

            // Two-bunny path search
            Creature* firstBunny = nullptr;
            Creature* secondBunny = nullptr;
            for (auto* firstCandidate : nearbyNpcs)
            {
                if (firstCandidate->GetEntry() == 812222 && me->IsWithinLOSInMap(firstCandidate))
                {
                    for (auto* secondCandidate : nearbyNpcs)
                    {
                        if (secondCandidate != firstCandidate && secondCandidate->GetEntry() == 812222 &&
                            firstCandidate->IsWithinLOSInMap(secondCandidate) && secondCandidate->IsWithinLOSInMap(targetNpc))
                        {
                            firstBunny = firstCandidate;
                            secondBunny = secondCandidate;
                            break;
                        }
                    }
                }
                if (firstBunny && secondBunny)
                    break;
            }

            if (firstBunny && secondBunny)
            {
                targetNpc = firstBunny;
                intermediaryBunny = secondBunny;
                isGuideBunny = true;
                lastNpcs.push_back(targetNpc);
                if (lastNpcs.size() > 3)
                    lastNpcs.pop_front();
            }
        }

        void DoInteract()
        {
            if (!isGuideBunny)
            {
                if (urand(0, 99) < 60)
                {
                    me->HandleEmoteCommand(EMOTE_ONESHOT_TALK);
                }

                if (urand(0, 99) < 15)
                {
                    me->HandleEmoteCommand(EMOTE_ONESHOT_DANCE);
                }
                else if (urand(0, 99) < 25)
                {
                    me->HandleEmoteCommand(EMOTE_ONESHOT_CHEER);
                }

                DoRandomChat();

                if (urand(0, 99) < RANDOM_IDLE_CHANCE)
                {
                    StartIdling();
                }
                else
                {
                    interactTimer = INTERACTION_DELAY + urand(0, 1500);
                    SelectNewTarget();
                }
            }
        }

        void MoveToRandomLOSPosition()
        {
            float angle = frand(0.0f, static_cast<float>(2 * M_PI));
            float distance = frand(0.5f, LOS_MOVE_DISTANCE);
            float newX = me->GetPositionX() + distance * cos(angle);
            float newY = me->GetPositionY() + distance * sin(angle);
            float newZ = me->GetMap()->GetHeight(newX, newY, me->GetPositionZ());

            me->GetMotionMaster()->Clear();
            me->GetMotionMaster()->MovePoint(1, newX, newY, newZ);
        }

        void DoRandomChat()
        {
            static const std::vector<std::string> randomChats = {
                "Hello there!",
                "Nice weather we're having, isn't it?",
                "Just browsing...",
                "I wonder if there's something new today.",
                "What a busy day in the city!",
                "Need any help, friend?"
            };

            if (urand(0, 99) < 10)
            {
                std::string message = randomChats[urand(0, randomChats.size() - 1)];
                me->Say(message, LANG_UNIVERSAL);
            }
        }
    };

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_city_bot_smallAI(creature);
    }
};

void AddSC_fancy_city_npcs()
{
    new horde_city_dancers();
    new alliance_city_dancers();
    new npc_city_bot();
    new npc_city_bot_small();

}
