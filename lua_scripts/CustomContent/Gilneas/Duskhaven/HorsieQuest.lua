--[[
HorsieQuest = {}
HorsieQuest.HORSE_NPC_ID = 1000018
HorsieQuest.RUGGED_THORNE_NPC_ID = 1000017
HorsieQuest.QUEST_ID = 100009
HorsieQuest.SPELL_ID = 61857
HorsieQuest.RADIUS_TO_COMPLETE = 5.0
HorsieQuest.TIMER_INTERVAL = 2000

HorsieQuest.horseOwners = {}

function HorsieQuest.OnGossipHello(event, player, creature)
    if player:HasQuest(HorsieQuest.QUEST_ID) then
        player:GossipMenuAddItem(0, "Coax horse to follow you.", 0, 1)
        player:GossipSendMenu(5001, creature)
    end
end

-- Gossip Selection
function HorsieQuest.OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if intid == 1 then
        -- Remove any existing event for this player
        local existingEventId = HorsieQuest.horseOwners[player:GetGUIDLow()]
        if existingEventId then
            RemoveEventById(existingEventId)  -- Remove the existing event using its eventId
        end

        player:CastSpell(creature, HorsieQuest.SPELL_ID, true)
        creature:SetSpeed(1, 1.2, true)  -- Set horse speed to run and rate to 1.2

        local eventId = player:RegisterEvent(HorsieQuest.CheckProximity, HorsieQuest.TIMER_INTERVAL, 0)  -- infinite repeats
        HorsieQuest.horseOwners[player:GetGUIDLow()] = eventId  -- Store the new eventId
        creature:MoveFollow(player, 2.0, creature:GetAngle(player))
    end
    player:GossipComplete()
end


-- Function to handle timer
function HorsieQuest.CheckProximity(eventId, delay, repeats, player)
    local eventId = HorsieQuest.horseOwners[player:GetGUIDLow()]
    if eventId then
        local creaturesInRange = player:GetCreaturesInRange(50, HorsieQuest.RUGGED_THORNE_NPC_ID)
        for i, creature in ipairs(creaturesInRange) do
            if creature:GetEntry() == HorsieQuest.RUGGED_THORNE_NPC_ID then
                local distanceToRuggedThorne = player:GetDistance(creature)
                if distanceToRuggedThorne <= HorsieQuest.RADIUS_TO_COMPLETE then
                    player:KilledMonsterCredit(HorsieQuest.HORSE_NPC_ID)
                    HorsieQuest.horseOwners[player:GetGUIDLow()] = nil
                    RemoveEventById(eventId)

                    -- Despawn nearest horses within a 5-yard radius of Rugged Thorne
                    local nearbyHorses = creature:GetCreaturesInRange(10, HorsieQuest.HORSE_NPC_ID)
                    for j, horse in ipairs(nearbyHorses) do
                        horse:DespawnOrUnsummon(100)
                    end

                    return
                end
            end
        end
    end
end


function HorsieQuest.OnLogoutOrMapChange(event, player)
    local eventId = HorsieQuest.horseOwners[player:GetGUIDLow()]
    if eventId then
        player:RemoveEvent(eventId)
        HorsieQuest.horseOwners[player:GetGUIDLow()] = nil
    end
end

function HorsieQuest.OnQuestComplete(event, player, quest)
    if quest == HorsieQuest.QUEST_ID then
        local eventId = HorsieQuest.horseOwners[player:GetGUIDLow()]
        if eventId then
            player:RemoveEvent(eventId)
            HorsieQuest.horseOwners[player:GetGUIDLow()] = nil
        end
    end
end

RegisterCreatureGossipEvent(HorsieQuest.HORSE_NPC_ID, 1, HorsieQuest.OnGossipHello)
RegisterCreatureGossipEvent(HorsieQuest.HORSE_NPC_ID, 2, HorsieQuest.OnGossipSelect)
RegisterPlayerEvent(4, HorsieQuest.OnLogoutOrMapChange)
RegisterPlayerEvent(28, HorsieQuest.OnLogoutOrMapChange)
RegisterPlayerEvent(54, HorsieQuest.OnQuestComplete)
]]--