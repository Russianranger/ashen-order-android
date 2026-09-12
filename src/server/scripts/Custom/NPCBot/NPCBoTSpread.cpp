#include "ScriptMgr.h"
#include "Chat.h"
#include "Player.h"
#include "botmgr.h"
#include "bot_ai.h"
#include "GridNotifiers.h"
#include "ScriptMgr.h"
#include "SpellScript.h"
#include "Map.h"
#include "Unit.h"
#include "UnitAI.h"


constexpr float INVALID_BOT_HEIGHT = -20000.0f; // A reasonable invalid height value
constexpr int MAX_HEIGHT_ATTEMPTS = 10; // Maximum attempts to find a valid height
constexpr int MAX_POSITION_ATTEMPTS = 10; // Maximum attempts to find a valid position
constexpr int BOT_MOVE_DELAY = 50; // Delay in milliseconds between bot movements

class spread_command : public CommandScript
{
public:
    spread_command() : CommandScript("spread_command") { }

    std::vector<ChatCommand> GetCommands() const override
    {
        static std::vector<ChatCommand> spreadCommandTable =
        {
            { "spread", SEC_PLAYER, false, &HandleSpreadCommand, "" },
            { "spreadio", SEC_PLAYER, false, &HandleSpreadioCommand, "" },
            { "spreadtwo", SEC_PLAYER, false, &HandleSpreadtwoCommand, "" }
        };

        return spreadCommandTable;
    }

    static bool HandleSpreadCommand(ChatHandler* handler, const char* args)
    {
        Player* player = handler->GetSession()->GetPlayer();
        Unit* target = player->GetSelectedUnit();

        if (!target)
        {
            target = player;
        }

        // Check if the target is further than 45.0f away
        if (player->GetDistance(target) > 45.0f)
        {
            handler->SendSysMessage("Target is too far away. Please select a target within 45.0f.");
            return false;
        }

        float initialDistance = 25.0f;
        const float maxSpreadDistance = 50.0f;
        const float searchDistance = 80.0f;
        const float minDistance = 1.0f;

        if (args && *args)
        {
            initialDistance = atof(args);
            if (initialDistance <= 0.0f || initialDistance > maxSpreadDistance)
            {
                handler->SendSysMessage("Invalid distance. Please provide a positive number up to 50.");
                return false;
            }
        }

        std::list<Unit*> targetList;
        Acore::AnyUnitInObjectRangeCheck checker(player, searchDistance);
        Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(player, targetList, checker);
        Cell::VisitAllObjects(player, searcher, searchDistance);

        targetList.remove_if([target](Unit* unit) {
            return !unit->IsNPCBot() || unit == target || (unit->ToCreature() && unit->ToCreature()->IsWandererBot());
            });

        if (targetList.empty())
        {
            handler->SendSysMessage("No valid NPC Bots found.");
            return true;
        }

        std::list<Unit*> rangedBots;

        for (Unit* unit : targetList)
        {
            if (unit->ToCreature()->GetBotAI()->HasRole(BOT_ROLE_RANGED))
            {
                rangedBots.push_back(unit);
            }
        }

        SpreadBots(handler, rangedBots, target, initialDistance, maxSpreadDistance, minDistance);

        return true;
    }

    static bool HandleSpreadioCommand(ChatHandler* handler, const char* args)
    {
        Player* player = handler->GetSession()->GetPlayer();
        Unit* target = player->GetSelectedUnit();

        if (!target)
        {
            target = player;
        }

        // Check if the target is further than 45.0f away
        if (player->GetDistance(target) > 45.0f)
        {
            handler->SendSysMessage("Target is too far away. Please select a target within 45.0f.");
            return false;
        }

        float initialDistance = 25.0f; // Default inner circle distance
        float outerDistance = 35.0f; // Default outer circle distance
        const float maxSpreadDistance = 50.0f;
        const float searchDistance = 80.0f;
        const float minDistance = 1.0f;

        if (args && *args)
        {
            // Parse the distances from the arguments
            char* innerDistStr = strtok((char*)args, " ");
            char* outerDistStr = strtok(nullptr, " ");

            if (innerDistStr)
            {
                initialDistance = atof(innerDistStr);
                if (initialDistance <= 0.0f || initialDistance > maxSpreadDistance)
                {
                    handler->SendSysMessage("Invalid inner distance. Please provide a positive number up to 50.");
                    return false;
                }
            }

            if (outerDistStr)
            {
                outerDistance = atof(outerDistStr);
                if (outerDistance <= 0.0f || outerDistance > maxSpreadDistance)
                {
                    handler->SendSysMessage("Invalid outer distance. Please provide a positive number up to 50.");
                    return false;
                }
            }
        }

        std::list<Unit*> targetList;
        Acore::AnyUnitInObjectRangeCheck checker(player, searchDistance);
        Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(player, targetList, checker);
        Cell::VisitAllObjects(player, searcher, searchDistance);

        targetList.remove_if([target](Unit* unit) {
            return !unit->IsNPCBot() || unit == target || (unit->ToCreature() && unit->ToCreature()->IsWandererBot());
            });

        if (targetList.empty())
        {
            handler->SendSysMessage("No valid NPC Bots found.");
            return true;
        }

        std::list<Unit*> rangedBots;

        for (Unit* unit : targetList)
        {
            if (unit->ToCreature()->GetBotAI()->HasRole(BOT_ROLE_RANGED))
            {
                rangedBots.push_back(unit);
            }
        }

        SpreadBotsInCircles(handler, rangedBots, target, initialDistance, outerDistance, maxSpreadDistance, minDistance);

        return true;
    }

    static bool HandleSpreadtwoCommand(ChatHandler* handler, const char* args)
    {
        Player* player = handler->GetSession()->GetPlayer();
        Unit* target = player->GetSelectedUnit();

        if (!target)
        {
            target = player;
        }

        // Check if the target is further than 45.0f away
        if (player->GetDistance(target) > 45.0f)
        {
            handler->SendSysMessage("Target is too far away. Please select a target within 45.0f.");
            return false;
        }

        float leftRightDistance = 10.0f; // Default distance to the left and right of the player
        float frontBackDistance = 20.0f; // Default distance from the target
        const float maxSpreadDistance = 50.0f;
        const float searchDistance = 80.0f;
        const float minDistance = 1.0f;

        if (args && *args)
        {
            // Parse the distances from the arguments
            char* leftRightDistStr = strtok((char*)args, " ");
            char* frontBackDistStr = strtok(nullptr, " ");

            if (leftRightDistStr)
            {
                leftRightDistance = atof(leftRightDistStr);
                if (leftRightDistance <= 0.0f || leftRightDistance > maxSpreadDistance)
                {
                    handler->SendSysMessage("Invalid left/right distance. Please provide a positive number up to 50.");
                    return false;
                }
            }

            if (frontBackDistStr)
            {
                frontBackDistance = atof(frontBackDistStr);
                if (frontBackDistance > maxSpreadDistance || frontBackDistance < -maxSpreadDistance)
                {
                    handler->SendSysMessage("Invalid front/back distance. Please provide a number between -50 and 50.");
                    return false;
                }
            }
        }

        std::list<Unit*> targetList;
        Acore::AnyUnitInObjectRangeCheck checker(player, searchDistance);
        Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(player, targetList, checker);
        Cell::VisitAllObjects(player, searcher, searchDistance);

        targetList.remove_if([target](Unit* unit) {
            return !unit->IsNPCBot() || unit == target || (unit->ToCreature() && unit->ToCreature()->IsWandererBot());
            });

        if (targetList.empty())
        {
            handler->SendSysMessage("No valid NPC Bots found.");
            return true;
        }

        std::list<Unit*> rangedBots;

        for (Unit* unit : targetList)
        {
            if (unit->ToCreature()->GetBotAI()->HasRole(BOT_ROLE_RANGED))
            {
                rangedBots.push_back(unit);
            }
        }

        SpreadBotsLeftRight(handler, rangedBots, player, target, leftRightDistance, frontBackDistance, maxSpreadDistance, minDistance);

        return true;
    }

private:
    static float GetValidHeight(Unit* target, Unit* unit, float x, float y)
    {
        float z = target->GetMap()->GetHeight(unit->GetPhaseMask(), x, y, target->GetPositionZ() + 2.0f, true);

        if (z <= INVALID_BOT_HEIGHT)
        {
            for (int attempt = 1; attempt <= MAX_HEIGHT_ATTEMPTS; ++attempt)
            {
                z = target->GetMap()->GetHeight(unit->GetPhaseMask(), x, y, target->GetPositionZ() + attempt, true);
                if (z > INVALID_BOT_HEIGHT)
                {
                    break;
                }
            }
        }

        return z;
    }

    static void SpreadBots(ChatHandler* handler, std::list<Unit*>& bots, Unit* target, float initialDistance, float maxDistance, float minDistance)
    {
        float angleStep = 2 * M_PI / bots.size();
        float angle = 0.0f;

        for (Unit* unit : bots)
        {
            float distance = initialDistance;
            float x, y, z;
            bool inLoS;
            int attempts = MAX_POSITION_ATTEMPTS;

            do {
                x = target->GetPositionX() + distance * cos(angle);
                y = target->GetPositionY() + distance * sin(angle);
                z = GetValidHeight(target, unit, x, y);

                inLoS = target->IsWithinLOS(x, y, z);

                if (!inLoS && distance > minDistance)
                {
                    distance -= 5.0f;
                    if (distance < minDistance)
                    {
                        distance = minDistance;
                    }
                }

                attempts--;
                if (attempts <= 0)
                {
                    handler->SendSysMessage("Failed to find a valid position after maximum attempts, skipping.");
                    break;
                }
            } while ((!inLoS || z <= INVALID_BOT_HEIGHT) && attempts > 0);

            if (!inLoS || z <= INVALID_BOT_HEIGHT)
            {
                handler->SendSysMessage("No valid position found, skipping.");
                continue;
            }

            Position targetPosition = { x, y, z, 0.0f };
            unit->ToCreature()->GetBotAI()->MoveToSendPosition(targetPosition);
            angle += angleStep;

            // Delay before moving the next bot to prevent server freezing
            std::this_thread::sleep_for(std::chrono::milliseconds(BOT_MOVE_DELAY));
        }
    }

    static void SpreadBotsInCircles(ChatHandler* handler, std::list<Unit*>& bots, Unit* target, float innerDistance, float outerDistance, float maxDistance, float minDistance)
    {
        size_t halfBots = bots.size() / 2;
        float innerAngleStep = 2 * M_PI / halfBots;
        float outerAngleStep = 2 * M_PI / (bots.size() - halfBots);

        float innerAngle = 0.0f;
        float outerAngle = 0.0f;

        size_t count = 0;
        for (Unit* unit : bots)
        {
            float distance = (count < halfBots) ? innerDistance : outerDistance;
            float angle = (count < halfBots) ? innerAngle : outerAngle;
            float x, y, z;
            bool inLoS;
            int attempts = MAX_POSITION_ATTEMPTS;

            do {
                x = target->GetPositionX() + distance * cos(angle);
                y = target->GetPositionY() + distance * sin(angle);
                z = GetValidHeight(target, unit, x, y);

                inLoS = target->IsWithinLOS(x, y, z);

                if (!inLoS && distance > minDistance)
                {
                    distance -= 5.0f;
                    if (distance < minDistance)
                    {
                        distance = minDistance;
                    }
                }

                attempts--;
                if (attempts <= 0)
                {
                    handler->SendSysMessage("Failed to find a valid position after maximum attempts, skipping.");
                    break;
                }
            } while ((!inLoS || z <= INVALID_BOT_HEIGHT) && attempts > 0);

            if (!inLoS || z <= INVALID_BOT_HEIGHT)
            {
                handler->SendSysMessage("No valid position found, skipping.");
                continue;
            }

            Position targetPosition = { x, y, z, 0.0f };
            unit->ToCreature()->GetBotAI()->MoveToSendPosition(targetPosition);

            if (count < halfBots)
            {
                innerAngle += innerAngleStep;
            }
            else
            {
                outerAngle += outerAngleStep;
            }
            count++;

            // Delay before moving the next bot to prevent server freezing
            std::this_thread::sleep_for(std::chrono::milliseconds(BOT_MOVE_DELAY));
        }
    }

    static void SpreadBotsLeftRight(ChatHandler* handler, std::list<Unit*>& bots, Player* player, Unit* target, float leftRightDistance, float frontBackDistance, float maxDistance, float minDistance)
    {
        size_t halfBots = bots.size() / 2;
        float leftAngle = player->GetOrientation() + M_PI_2; // 90 degrees to the left
        float rightAngle = player->GetOrientation() - M_PI_2; // 90 degrees to the right

        size_t count = 0;
        for (Unit* unit : bots)
        {
            float distanceFromTarget = frontBackDistance;
            float angle = (count < halfBots) ? leftAngle : rightAngle;
            float x, y, z;
            bool inLoS;
            int attempts = MAX_POSITION_ATTEMPTS;

            do {
                x = target->GetPositionX() + distanceFromTarget * cos(player->GetOrientation()) + leftRightDistance * cos(angle);
                y = target->GetPositionY() + distanceFromTarget * sin(player->GetOrientation()) + leftRightDistance * sin(angle);
                z = GetValidHeight(target, unit, x, y);

                inLoS = target->IsWithinLOS(x, y, z);

                if (!inLoS && distanceFromTarget > minDistance)
                {
                    distanceFromTarget -= 5.0f;
                    if (distanceFromTarget < minDistance)
                    {
                        distanceFromTarget = minDistance;
                    }
                }

                attempts--;
                if (attempts <= 0)
                {
                    handler->SendSysMessage("Failed to find a valid position after maximum attempts, skipping.");
                    break;
                }
            } while ((!inLoS || z <= INVALID_BOT_HEIGHT) && attempts > 0);

            if (!inLoS || z <= INVALID_BOT_HEIGHT)
            {
                handler->SendSysMessage("No valid position found, skipping.");
                continue;
            }

            Position targetPosition = { x, y, z, 0.0f };
            unit->ToCreature()->GetBotAI()->MoveToSendPosition(targetPosition);

            count++;

            // Delay before moving the next bot to prevent server freezing
            std::this_thread::sleep_for(std::chrono::milliseconds(BOT_MOVE_DELAY));
        }
    }
};

class stack_command : public CommandScript
{
public:
    stack_command() : CommandScript("stack_command") { }

    std::vector<ChatCommand> GetCommands() const override
    {
        static std::vector<ChatCommand> stackCommandTable =
        {
            { "stack", SEC_PLAYER, false, &HandleStackCommand, "" }
        };

        return stackCommandTable;
    }

    static bool HandleStackCommand(ChatHandler* handler, const char* /*args*/)
    {
        Player* player = handler->GetSession()->GetPlayer();
        Unit* target = player->GetSelectedUnit();

        if (!target)
        {
            target = player;
        }

        std::list<Unit*> targetList;
        Acore::AnyUnitInObjectRangeCheck checker(player, 80.0f); // Arbitrary large range to find bots
        Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(player, targetList, checker);
        Cell::VisitAllObjects(player, searcher, 80.0f);

        targetList.remove_if([target](Unit* unit) {
            return !unit->IsNPCBot() || unit == target ||
                (unit->ToCreature() && unit->ToCreature()->IsWandererBot()) ||
                (unit->ToCreature() && unit->ToCreature()->GetBotAI()->HasRole(BOT_ROLE_TANK));
            });

        if (targetList.empty())
        {
            handler->SendSysMessage("No valid NPC Bots found.");
            return true;
        }

        StackBots(handler, targetList, target);

        return true;
    }

private:
    static float GetValidHeight(Unit* target, Unit* unit, float x, float y)
    {
        float z = target->GetMap()->GetHeight(unit->GetPhaseMask(), x, y, target->GetPositionZ() + 2.0f, true);

        if (z <= INVALID_BOT_HEIGHT)
        {
            for (int attempt = 1; attempt <= MAX_HEIGHT_ATTEMPTS; ++attempt)
            {
                z = target->GetMap()->GetHeight(unit->GetPhaseMask(), x, y, target->GetPositionZ() + attempt, true);
                if (z > INVALID_BOT_HEIGHT)
                {
                    break;
                }
            }
        }

        return z;
    }

    static void StackBots(ChatHandler* handler, std::list<Unit*>& bots, Unit* target)
    {
        for (Unit* unit : bots)
        {
            float x, y, z;
            if (target->GetTypeId() == TYPEID_PLAYER || !target)
            {
                x = target->GetPositionX();
                y = target->GetPositionY();
                z = target->GetPositionZ();
            }
            else
            {
                float myangle = Position::NormalizeOrientation(target->GetAbsoluteAngle(unit) + float(M_PI));
                float mydist = unit->GetCombatReach();
                Position position;
                target->GetNearPoint(unit, position.m_positionX, position.m_positionY, position.m_positionZ, 0.f, mydist, myangle);

                x = position.m_positionX;
                y = position.m_positionY;
                z = GetValidHeight(target, unit, x, y);

                if (z <= INVALID_BOT_HEIGHT)
                {
                    handler->SendSysMessage("No valid position found, skipping.");
                    continue;
                }
            }

            Position targetPosition = { x, y, z, target->GetOrientation() };
            unit->ToCreature()->GetBotAI()->MoveToSendPosition(targetPosition);

            // Delay before moving the next bot to prevent server freezing
            std::this_thread::sleep_for(std::chrono::milliseconds(BOT_MOVE_DELAY));
        }
    }
};

class pull_command : public CommandScript
{
public:
    pull_command() : CommandScript("pull_command") { }

    std::vector<ChatCommand> GetCommands() const override
    {
        static std::vector<ChatCommand> pullCommandTable =
        {
            { "pull", SEC_PLAYER, false, &HandlePullCommand, "" }
        };

        return pullCommandTable;
    }

    static bool HandlePullCommand(ChatHandler* handler, const char* /*args*/)
    {
        Player* player = handler->GetSession()->GetPlayer();
        Unit* target = player->GetSelectedUnit();

        // Check if the player is under cooldown
        uint32 currentTime = time(nullptr);
        auto it = sCooldowns.find(player->GetGUID().GetCounter());
        if (it != sCooldowns.end() && currentTime < it->second)
        {
            handler->SendSysMessage("You cannot use the pull command yet. Please wait.");
            return false;
        }

        if (!target || !target->IsAlive())
        {
            handler->SendSysMessage("You must select a target to pull.");
            return false;
        }

        if (target == player)
        {
            handler->SendSysMessage("You cannot target yourself.");
            return false;
        }

        // Find Hunter Bot
        Unit* hunterBot = nullptr;
        Unit* tankBot = nullptr;
        for (Unit* member : BotMgr::GetAllGroupMembers(player))
        {
            if (!member || !member->IsInWorld() || player->GetMap() != member->FindMap() || !member->IsAlive())
                continue;

            Creature* creature = member->ToCreature();
            if (creature && creature->GetBotAI())
            {
                if (creature->GetBotAI()->GetBotClass() == BOT_CLASS_HUNTER)
                {
                    hunterBot = member;
                }
                if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                {
                    tankBot = member;
                }
            }

            if (hunterBot && tankBot)
                break;
        }

        if (!hunterBot)
        {
            handler->SendSysMessage("No Hunter Bot found in your group.");
            return false;
        }

        if (hunterBot->GetDistance(player) > 55.0f)
        {
            handler->SendSysMessage("Hunter Bot must be within 45.0f of you to pull.");
            return false;
        }

        if (hunterBot->GetDistance(target) > 55.0f)
        {
            handler->SendSysMessage("Target must be within 45.0f of the Hunter Bot.");
            return false;
        }

        // Move all group members to player's position
        for (Unit* member : BotMgr::GetAllGroupMembers(player))
        {
            if (!member || !member->IsInWorld() || player->GetMap() != member->FindMap() || !member->IsAlive())
                continue;

            Creature* creature = member->ToCreature();
            if (creature && creature->GetBotAI())
            {
                creature->GetBotAI()->MoveToSendPosition(player->GetPosition());
            }
        }

        // Store initial position of the hunter bot
        Position initialPosition = hunterBot->GetPosition();

        // Check if the target is within LoS of the Hunter Bot
        if (hunterBot->IsWithinLOSInMap(target))
        {
            PerformPull(hunterBot, target, player, tankBot);
        }
        else
        {
            // Schedule the initial LoS check and movement for the Hunter Bot
            player->m_Events.AddEvent(new CheckLOSAndMoveEvent(hunterBot, target, player, tankBot, 0, false, initialPosition), player->m_Events.CalculateTime(0));
        }

        // Set the cooldown time (e.g., 8 seconds)
        sCooldowns[player->GetGUID().GetCounter()] = currentTime + 8;

        return true;
    }

private:
    // Cooldown map to track players' pull command cooldowns
    static std::unordered_map<uint32, uint32> sCooldowns;

    class CheckLOSAndMoveEvent : public BasicEvent
    {
    public:
        CheckLOSAndMoveEvent(Unit* hunterBot, Unit* target, Player* player, Unit* tankBot, uint32 attempt, bool moveToLos, Position initialPosition)
            : _hunterBot(hunterBot), _target(target), _player(player), _tankBot(tankBot), _attempt(attempt), _moveToLos(moveToLos), _initialPosition(initialPosition) { }

        bool Execute(uint64 /*time*/, uint32 /*diff*/) override
        {
            if (!_hunterBot || !_hunterBot->IsAlive() || !_player || !_player->IsAlive())
                return false;

            if (_attempt >= maxAttempts)
            {
                ChatHandler(_player->GetSession()).SendSysMessage("Hunter failed to pull target. Reposition and try again.");
                return true;
            }

            if (_moveToLos)
            {
                // Check if the bot has reached the position and has LoS to the target
                if (_hunterBot->IsWithinLOSInMap(_target))
                {
                    PerformPull(_hunterBot, _target, _player, _tankBot);
                    return true;
                }
            }
            else
            {
                const float radius = 14.0f;
                const int numPoints = 24;
                const float additionalRadius = 6.0f;
                const int additionalPoints = 24;

                // Try a wider range first
                float angle = (_attempt % numPoints) * (2 * M_PI / numPoints);
                float x = _initialPosition.GetPositionX() + radius * cos(angle);
                float y = _initialPosition.GetPositionY() + radius * sin(angle);
                float z = _initialPosition.GetPositionZ();
                z = _hunterBot->GetMap()->GetHeight(x, y, z, true);

                // Check if the position is within the player's LoS before moving
                if (_player->IsWithinLOS(x, y, z))
                {
                    _hunterBot->ToCreature()->GetBotAI()->MoveToSendPosition(Position(x, y, z));

                    // Schedule the next check for when the bot reaches the position
                    _player->m_Events.AddEvent(new CheckLOSAndMoveEvent(_hunterBot, _target, _player, _tankBot, _attempt, true, _initialPosition), _player->m_Events.CalculateTime(100));

                    return true;
                }

                // If the wider range fails, try a smaller radius closer to the bot
                if (_attempt >= numPoints)
                {
                    float smallAngle = ((_attempt - numPoints) % additionalPoints) * (2 * M_PI / additionalPoints);
                    x = _initialPosition.GetPositionX() + additionalRadius * cos(smallAngle);
                    y = _initialPosition.GetPositionY() + additionalRadius * sin(smallAngle);
                    z = _initialPosition.GetPositionZ();
                    z = _hunterBot->GetMap()->GetHeight(x, y, z, true);

                    if (_player->IsWithinLOS(x, y, z))
                    {
                        _hunterBot->ToCreature()->GetBotAI()->MoveToSendPosition(Position(x, y, z));

                        // Schedule the next check for when the bot reaches the position
                        _player->m_Events.AddEvent(new CheckLOSAndMoveEvent(_hunterBot, _target, _player, _tankBot, _attempt, true, _initialPosition), _player->m_Events.CalculateTime(100));

                        return true;
                    }
                }
            }

            // Schedule the next attempt after a short delay
            _player->m_Events.AddEvent(new CheckLOSAndMoveEvent(_hunterBot, _target, _player, _tankBot, _attempt + 1, false, _initialPosition), _player->m_Events.CalculateTime(100));

            return true;
        }

    private:
        Unit* _hunterBot;
        Unit* _target;
        Player* _player;
        Unit* _tankBot;
        uint32 _attempt;
        bool _moveToLos;
        Position _initialPosition;
        static const uint32 maxAttempts = 52; // Increase the number of attempts to cover both ranges
    };

    class DelayedMoveEvent : public BasicEvent
    {
    public:
        DelayedMoveEvent(Player* player, uint32 delay, bool isFinalMove = false) : _player(player), _delay(delay), _isFinalMove(isFinalMove) { }

        bool Execute(uint64 /*time*/, uint32 /*diff*/) override
        {
            if (_player && _player->IsAlive())
            {
                // Move all group members to player's position
                for (Unit* member : BotMgr::GetAllGroupMembers(_player))
                {
                    if (!member || !member->IsInWorld() || _player->GetMap() != member->FindMap() || !member->IsAlive())
                        continue;

                    Creature* creature = member->ToCreature();
                    if (creature && creature->GetBotAI())
                    {
                        creature->GetBotAI()->MoveToSendPosition(_player->GetPosition());
                    }
                }

                if (_isFinalMove)
                {
                    ChatHandler(_player->GetSession()).SendSysMessage("Pull event has ended.");
                }
            }
            return true;
        }

    private:
        Player* _player;
        uint32 _delay;
        bool _isFinalMove;
    };

    static void PerformPull(Unit* hunterBot, Unit* target, Player* player, Unit* tankBot)
    {
        if (hunterBot->getLevel() >= 35)
        {
            // Misdirect to tank or player
            Unit* misdirectTarget = tankBot ? tankBot : player;
            hunterBot->CastSpell(misdirectTarget, 834477, true); // CUSTOM_SPELL_ID_MISDIRECTION

            // Announce misdirection target and the target being pulled
            std::string misdirectMessage = "|cffFFFFFFMisdirecting " + std::string(target->GetName()) + " to " + std::string(misdirectTarget->GetName()) + "|r";
            hunterBot->Say(misdirectMessage, LANG_UNIVERSAL);

            // If misdirecting to player or no tank is found, send a message to the player as well
            if (misdirectTarget == player || !tankBot)
            {
                ChatHandler(player->GetSession()).SendSysMessage(misdirectMessage.c_str());
            }
        }

        // Hunter Bot attacks target
        hunterBot->CastSpell(target, 75, true); // SPELL_ID_AUTO_SHOT 
        hunterBot->CastSpell(target, 5116, true); // SPELL_ID_CONCUSSIVE_SHOT 

        player->GetSession()->SendAreaTriggerMessage("Hunter Bot is pulling the target.");

        // Schedule the group to move to player after 2 seconds
        player->m_Events.AddEvent(new DelayedMoveEvent(player, 2000), player->m_Events.CalculateTime(2000));
        // Schedule another move to ensure the group reaches destination after 1 more second
        player->m_Events.AddEvent(new DelayedMoveEvent(player, 3000), player->m_Events.CalculateTime(4000));
        // Schedule another move to ensure the group returns to the player after 2 more seconds and send a message that the pull event has ended
        player->m_Events.AddEvent(new DelayedMoveEvent(player, 5000, true), player->m_Events.CalculateTime(6000));
    }
};

// Initialize the cooldown map
std::unordered_map<uint32, uint32> pull_command::sCooldowns;

// This command is obsolete. I am keeping it for reference. It is replaced by direct bot_ai.cpp scripting. Search for // Thadius in bot_ai.cpp
// I probably over-coded it but oh well. It was fun to write.
class ThaddiusCommand : public CommandScript
{
public:
    ThaddiusCommand() : CommandScript("ThaddiusCommand") { }

    std::vector<ChatCommand> GetCommands() const override
    {
        static std::vector<ChatCommand> ThaddiusCommandTable =
        {
            { "thaddiustactics", SEC_PLAYER, false, &HandleThaddiusCommand, "" }
        };

        return ThaddiusCommandTable;
    }

    static bool HandleThaddiusCommand(ChatHandler* handler, const char* /*args*/)
    {
        Player* player = handler->GetSession()->GetPlayer();
        std::list<Unit*> targetList;
        Acore::AnyUnitInObjectRangeCheck checker(player, 80.0f); // Arbitrary large range to find bots
        Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(player, targetList, checker);
        Cell::VisitAllObjects(player, searcher, 80.0f);

        targetList.remove_if([](Unit* unit) {
            return !unit->IsNPCBot() || (unit->ToCreature() && unit->ToCreature()->IsWandererBot());
            });

        if (targetList.empty())
        {
            handler->SendSysMessage("No valid NPC Bots found.");
            return true;
        }

        bool hasAura = false;
        for (Unit* unit : targetList)
        {
            if (unit->HasAura(28059) || unit->HasAura(28084)) // Positive or Negative charge
            {
                hasAura = true;
                break;
            }
        }

        if (!hasAura)
        {
            handler->SendSysMessage("This command is for moving bots to the correct positions during the Thaddius fight when they have positive or negative charges. It must be executed each time Thaddius performs a polarity shift.");
            return true;
        }

        ThadMoveBots(handler, targetList);

        return true;
    }

private:
    static void ThadMoveBots(ChatHandler* handler, std::list<Unit*>& bots)
    {
        Position positivePos = { 3522.4340820312f, -2934.12109375f, 302.88565063477f, 2.3949143886566f };
        Position negativePos = { 3508.3127441406f, -2920.0598144531f, 302.86047363281f, 5.4680323600769f };

        for (Unit* unit : bots)
        {
            float x, y, z;
            bool inLoS;
            int attempts = MAX_POSITION_ATTEMPTS;

            if (unit->HasAura(28059)) // Positive charge
            {
                do {
                    x = positivePos.GetPositionX();
                    y = positivePos.GetPositionY();
                    z = GetValidHeight(unit, x, y);

                    inLoS = unit->IsWithinLOS(x, y, z);

                    attempts--;
                    if (attempts <= 0)
                    {
                        handler->SendSysMessage("Failed to find a valid position for a bot with positive charge after maximum attempts, skipping.");
                        break;
                    }
                } while ((!inLoS || z <= INVALID_BOT_HEIGHT) && attempts > 0);

                if (!inLoS || z <= INVALID_BOT_HEIGHT)
                {
                    handler->SendSysMessage("No valid position found for a bot with positive charge, skipping.");
                    continue;
                }

                unit->ToCreature()->GetBotAI()->MoveToSendPosition({ x, y, z, positivePos.GetOrientation() });
            }
            else if (unit->HasAura(28084)) // Negative charge
            {
                do {
                    x = negativePos.GetPositionX();
                    y = negativePos.GetPositionY();
                    z = GetValidHeight(unit, x, y);

                    inLoS = unit->IsWithinLOS(x, y, z);

                    attempts--;
                    if (attempts <= 0)
                    {
                        handler->SendSysMessage("Failed to find a valid position for a bot with negative charge after maximum attempts, skipping.");
                        break;
                    }
                } while ((!inLoS || z <= INVALID_BOT_HEIGHT) && attempts > 0);

                if (!inLoS || z <= INVALID_BOT_HEIGHT)
                {
                    handler->SendSysMessage("No valid position found for a bot with negative charge, skipping.");
                    continue;
                }

                unit->ToCreature()->GetBotAI()->MoveToSendPosition({ x, y, z, negativePos.GetOrientation() });
            }

            // Delay before moving the next bot to prevent server freezing
            std::this_thread::sleep_for(std::chrono::milliseconds(BOT_MOVE_DELAY));
        }
    }

    static float GetValidHeight(Unit* unit, float x, float y)
    {
        float z = unit->GetMap()->GetHeight(unit->GetPhaseMask(), x, y, unit->GetPositionZ() + 2.0f, true);

        if (z <= INVALID_BOT_HEIGHT)
        {
            for (int attempt = 1; attempt <= MAX_HEIGHT_ATTEMPTS; ++attempt)
            {
                z = unit->GetMap()->GetHeight(unit->GetPhaseMask(), x, y, unit->GetPositionZ() + attempt, true);
                if (z > INVALID_BOT_HEIGHT)
                {
                    break;
                }
            }
        }

        return z;
    }
};

class spell_bot_flask_custom : public SpellScriptLoader
{
public:
    spell_bot_flask_custom() : SpellScriptLoader("spell_bot_flask_custom") { }

    class spell_bot_flask_custom_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_bot_flask_custom_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {

                const uint32 FLASK_OF_DISTILLED_WISDOM = 17627;
                const uint32 FLASK_OF_SUPREME_POWER = 17628;
                const uint32 FLASK_OF_TITANS = 17626;
                const uint32 CUSTOM_FLASK = 817628;

                // Remove specific flask auras by spell ID
                const std::vector<uint32> flaskSpellIds = {
                    17627, 17628, 17626, 817628, 811728, 811729, 53760, 53755, 62380, 67016, 67017, 67018, 67019, 53758,
                    53752, 54212, 28518, 28519, 28520, 28521, 28540, 40567, 40568, 40572, 40573, 40575, 40576, 40577, 40579,
                    40580, 40586, 40582, 40587, 40588, 40763, 41604, 41605, 41606, 41607, 41608, 41609, 41610, 41611, 46837,
                    46838, 46839, 46840
                };

                for (uint32 spellId : flaskSpellIds)
                {
                    caster->RemoveAura(spellId);
                }                    
                     
                if (caster->GetTypeId() != TYPEID_PLAYER)
                    return;

                const float range = 50.0f; 

                std::list<Unit*> targets;
                Acore::AnyUnitInObjectRangeCheck check(caster, range);
                Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(caster, targets, check);
                Cell::VisitAllObjects(caster, searcher, range);

                targets.remove_if([caster](Unit* unit) -> bool {
                    return !unit->IsAlive() || !unit->IsNPCBot();
                    });

                for (Unit* target : targets)
                {
                    Creature* creature = target->ToCreature();
                    if (!creature)
                        continue;

                    uint32 spellId = 0;

                    switch (creature->GetBotClass())
                    {
                    case BOT_CLASS_MAGE:
                    case BOT_CLASS_PRIEST:
                    case BOT_CLASS_WARLOCK:
                        spellId = FLASK_OF_SUPREME_POWER;
                        break;
                    case BOT_CLASS_ROGUE:
                    case BOT_CLASS_HUNTER:
                        spellId = CUSTOM_FLASK;
                        break;
                    case BOT_CLASS_WARRIOR:
                    case BOT_CLASS_DEATH_KNIGHT:
                    case BOT_CLASS_PALADIN:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                            spellId = FLASK_OF_TITANS;
                        else if (creature->GetBotClass() == BOT_CLASS_PALADIN && creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_DISTILLED_WISDOM;
                        else
                            spellId = CUSTOM_FLASK;
                        break;
                    case BOT_CLASS_DRUID:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_SUPREME_POWER;
                        else if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                            spellId = FLASK_OF_TITANS;
                        else if (creature->GetBotAI()->HasRole(BOT_ROLE_RANGED) && !creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_SUPREME_POWER;
                        else
                            spellId = CUSTOM_FLASK;
                        break;
                    case BOT_CLASS_SHAMAN:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_RANGED))
                            spellId = FLASK_OF_SUPREME_POWER;
                        else
                            spellId = CUSTOM_FLASK;
                        break;
                    default:
                        break;
                    }

                    if (spellId != 0)
                    {     
                        // Apply the new flask aura
                        target->CastSpell(target, spellId, true);
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_bot_flask_custom_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_ANY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_bot_flask_custom_SpellScript();
    }
};

class spell_unified_might : public SpellScriptLoader
{
public:
    spell_unified_might() : SpellScriptLoader("spell_unified_might") { }

    class spell_unified_might_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_unified_might_SpellScript);

        void HandleRemoveAuras(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                // Remove specific flask auras by spell ID
                const std::vector<uint32> flaskSpellIds = {
                    17627, 17628, 17626, 817628, 53760, 53755, 62380, 67016, 67017, 67018, 67019, 53758,
                    53752, 54212, 28518, 28519, 28520, 28521, 28540, 40567, 40568, 40572, 40573, 40575, 40576, 40577, 40579,
                    40580, 40586, 40582, 40587, 40588, 40763, 41604, 41605, 41606, 41607, 41608, 41609, 41610, 41611, 46837,
                    46838, 46839, 46840
                };

                for (uint32 spellId : flaskSpellIds)
                {
                    caster->RemoveAura(spellId);
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_unified_might_SpellScript::HandleRemoveAuras, EFFECT_0, SPELL_EFFECT_ANY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_unified_might_SpellScript();
    }
};

class spell_bot_flask_tbc_custom : public SpellScriptLoader
{
public:
    spell_bot_flask_tbc_custom() : SpellScriptLoader("spell_bot_flask_tbc_custom") { }

    class spell_bot_flask_tbc_custom_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_bot_flask_tbc_custom_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {

                const uint32 FLASK_OF_DISTILLED_WISDOM = 17627;
                const uint32 FLASK_OF_SUPREME_POWER = 17628;
                const uint32 FLASK_OF_FORTIFICATION = 28518;
                const uint32 FLASK_OF_RELENTLESS_ASSAULT = 28520;
                
                // Remove specific flask auras by spell ID
                const std::vector<uint32> flaskSpellIds = {
                    17627, 17628, 17626, 817628, 811728, 811729, 53760, 53755, 62380, 67016, 67017, 67018, 67019, 53758,
                    53752, 54212, 28518, 28519, 28520, 28521, 28540, 40567, 40568, 40572, 40573, 40575, 40576, 40577, 40579,
                    40580, 40586, 40582, 40587, 40588, 40763, 41604, 41605, 41606, 41607, 41608, 41609, 41610, 41611, 46837,
                    46838, 46839, 46840
                };

                for (uint32 spellId : flaskSpellIds)
                {
                    caster->RemoveAura(spellId);
                }            

                if (caster->GetTypeId() != TYPEID_PLAYER)
                    return;

                const float range = 50.0f;

                std::list<Unit*> targets;
                Acore::AnyUnitInObjectRangeCheck check(caster, range);
                Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(caster, targets, check);
                Cell::VisitAllObjects(caster, searcher, range);

                targets.remove_if([caster](Unit* unit) -> bool {
                    return !unit->IsAlive() || !unit->IsNPCBot();
                    });

                for (Unit* target : targets)
                {
                    Creature* creature = target->ToCreature();
                    if (!creature)
                        continue;

                    uint32 spellId = 0;

                    switch (creature->GetBotClass())
                    {
                    case BOT_CLASS_MAGE:
                    case BOT_CLASS_PRIEST:
                    case BOT_CLASS_WARLOCK:
                        spellId = FLASK_OF_SUPREME_POWER;
                        break;
                    case BOT_CLASS_ROGUE:
                    case BOT_CLASS_HUNTER:
                        spellId = FLASK_OF_RELENTLESS_ASSAULT;
                        break;
                    case BOT_CLASS_WARRIOR:
                    case BOT_CLASS_DEATH_KNIGHT:
                    case BOT_CLASS_PALADIN:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                            spellId = FLASK_OF_FORTIFICATION;
                        else if (creature->GetBotClass() == BOT_CLASS_PALADIN && creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_DISTILLED_WISDOM;
                        else
                            spellId = FLASK_OF_RELENTLESS_ASSAULT;
                        break;
                    case BOT_CLASS_DRUID:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_SUPREME_POWER;
                        else if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                            spellId = FLASK_OF_FORTIFICATION;
                        else if (creature->GetBotAI()->HasRole(BOT_ROLE_RANGED) && !creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_SUPREME_POWER;
                        else
                            spellId = FLASK_OF_RELENTLESS_ASSAULT;
                        break;
                    case BOT_CLASS_SHAMAN:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_RANGED))
                            spellId = FLASK_OF_SUPREME_POWER;
                        else
                            spellId = FLASK_OF_RELENTLESS_ASSAULT;
                        break;
                    default:
                        break;
                    }

                    if (spellId != 0)
                    {
                        // Apply the new flask aura
                        target->CastSpell(target, spellId, true);
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_bot_flask_tbc_custom_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_ANY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_bot_flask_tbc_custom_SpellScript();
    }
};

class spell_bot_flask_wotlk_custom : public SpellScriptLoader
{
public:
    spell_bot_flask_wotlk_custom() : SpellScriptLoader("spell_bot_flask_wotlk_custom") { }

    class spell_bot_flask_wotlk_custom_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_bot_flask_wotlk_custom_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                const uint32 FLASK_OF_DISTILLED_WISDOM = 17627;
                const uint32 FLASK_OF_THE_FROST_WYRM = 53775;
                const uint32 FLASK_OF_STONEBLOOD = 53758;
                const uint32 FLASK_OF_ENDLESS_RAGE = 53760;

                // Remove specific flask auras by spell ID
                const std::vector<uint32> flaskSpellIds = {
                    17627, 17628, 17626, 817628, 811728, 811729, 53760, 53755, 62380, 67016, 67017, 67018, 67019, 53758,
                    53752, 54212, 28518, 28519, 28520, 28521, 28540, 40567, 40568, 40572, 40573, 40575, 40576, 40577, 40579,
                    40580, 40586, 40582, 40587, 40588, 40763, 41604, 41605, 41606, 41607, 41608, 41609, 41610, 41611, 46837,
                    46838, 46839, 46840
                };

                for (uint32 spellId : flaskSpellIds)
                {
                    caster->RemoveAura(spellId);
                }

                if (caster->GetTypeId() != TYPEID_PLAYER)
                    return;

                const float range = 50.0f;

                std::list<Unit*> targets;
                Acore::AnyUnitInObjectRangeCheck check(caster, range);
                Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(caster, targets, check);
                Cell::VisitAllObjects(caster, searcher, range);

                targets.remove_if([caster](Unit* unit) -> bool {
                    return !unit->IsAlive() || !unit->IsNPCBot();
                    });

                for (Unit* target : targets)
                {
                    Creature* creature = target->ToCreature();
                    if (!creature)
                        continue;

                    uint32 spellId = 0;

                    switch (creature->GetBotClass())
                    {
                    case BOT_CLASS_MAGE:
                    case BOT_CLASS_PRIEST:
                    case BOT_CLASS_WARLOCK:
                        spellId = FLASK_OF_THE_FROST_WYRM;
                        break;
                    case BOT_CLASS_ROGUE:
                    case BOT_CLASS_HUNTER:
                        spellId = FLASK_OF_ENDLESS_RAGE;
                        break;
                    case BOT_CLASS_WARRIOR:
                    case BOT_CLASS_DEATH_KNIGHT:
                    case BOT_CLASS_PALADIN:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                            spellId = FLASK_OF_STONEBLOOD;
                        else if (creature->GetBotClass() == BOT_CLASS_PALADIN && creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_DISTILLED_WISDOM;
                        else
                            spellId = FLASK_OF_ENDLESS_RAGE;
                        break;
                    case BOT_CLASS_DRUID:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_THE_FROST_WYRM;
                        else if (creature->GetBotAI()->HasRole(BOT_ROLE_TANK))
                            spellId = FLASK_OF_STONEBLOOD;
                        else if (creature->GetBotAI()->HasRole(BOT_ROLE_RANGED) && !creature->GetBotAI()->HasRole(BOT_ROLE_HEAL))
                            spellId = FLASK_OF_THE_FROST_WYRM;
                        else
                            spellId = FLASK_OF_ENDLESS_RAGE;
                        break;
                    case BOT_CLASS_SHAMAN:
                        if (creature->GetBotAI()->HasRole(BOT_ROLE_RANGED))
                            spellId = FLASK_OF_THE_FROST_WYRM;
                        else
                            spellId = FLASK_OF_ENDLESS_RAGE;
                        break;
                    default:
                        break;
                    }

                    if (spellId != 0)
                    {
                        // Apply the new flask aura
                        target->CastSpell(target, spellId, true);
                    }
                }
            }
        }

        void Register() override
        {
            OnEffectHit += SpellEffectFn(spell_bot_flask_wotlk_custom_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_ANY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_bot_flask_wotlk_custom_SpellScript();
    }
};

void AddSC_spread_command()
{
    new spread_command();
    new stack_command();
    new ThaddiusCommand();
    new pull_command();
    new spell_bot_flask_custom();
    new spell_bot_flask_wotlk_custom();
    new spell_bot_flask_tbc_custom();
    new spell_unified_might();
}

class spell_remove_exhaustion_debuffs : public SpellScriptLoader
{
public:
    spell_remove_exhaustion_debuffs() : SpellScriptLoader("spell_remove_exhaustion_debuffs") { }

    class spell_remove_exhaustion_debuffs_SpellScript : public SpellScript
    {
        PrepareSpellScript(spell_remove_exhaustion_debuffs_SpellScript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (Unit* caster = GetCaster())
            {
                const uint32 EXHAUSTION_SPELL_ID = 57723;
                const uint32 SATED_SPELL_ID = 57724;
                const float range = 200.0f; // Adjust range as needed

                std::list<Unit*> targets;
                Acore::AnyUnitInObjectRangeCheck check(caster, range);
                Acore::UnitListSearcher<Acore::AnyUnitInObjectRangeCheck> searcher(caster, targets, check);
                Cell::VisitAllObjects(caster, searcher, range);

                targets.remove_if([caster](Unit* unit) -> bool {
                    return !unit->IsAlive() || !(unit->GetTypeId() == TYPEID_PLAYER || (unit->GetTypeId() == TYPEID_UNIT && static_cast<Creature*>(unit)->IsNPCBot()));
                    });

                for (Unit* target : targets)
                {
                    target->RemoveAura(EXHAUSTION_SPELL_ID);
                    target->RemoveAura(SATED_SPELL_ID);
                }
            }
        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_remove_exhaustion_debuffs_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_remove_exhaustion_debuffs_SpellScript();
    }
};

void AddSC_fan_command()
{
    new spell_remove_exhaustion_debuffs();
}

