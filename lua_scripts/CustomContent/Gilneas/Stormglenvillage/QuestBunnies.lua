--[[
local ThornsBunny = {}

ThornsBunny.NPC_ID = 800058 
ThornsBunny.QUEST_ID = 100024 -- change me
ThornsBunny.CLOSE_DISTANCE = 5 
ThornsBunny.MESSAGE = "These look like the strange thorns that Lady Lorna described. The way the ground has been pushed aside, it must have grown very fast"

function ThornsBunny.CheckForNearbyPlayers(event, delay, repeat_times, creature)
    local players_in_range = creature:GetPlayersInRange(ThornsBunny.CLOSE_DISTANCE)
    for _, player in pairs(players_in_range) do
        if player:HasQuest(ThornsBunny.QUEST_ID) and not player:GetData("ReceivedThornsBroadcast") then
            player:SendBroadcastMessage(ThornsBunny.MESSAGE)
            player:KilledMonsterCredit(ThornsBunny.NPC_ID)
            player:SetData("ReceivedThornsBroadcast", true)
        end
    end
end

function ThornsBunny.OnSpawn(event, creature)
    creature:RegisterEvent(ThornsBunny.CheckForNearbyPlayers, 2000, 0)
end

RegisterCreatureEvent(ThornsBunny.NPC_ID, 5, ThornsBunny.OnSpawn)


local OuthouseBunny = {}

OuthouseBunny.NPC_ID = 800059 
OuthouseBunny.QUEST_ID = 100024 -- change me
OuthouseBunny.CLOSE_DISTANCE = 5 
OuthouseBunny.MESSAGE = "The outhouse has vicious-looking claw marks on them. They look like Worgen claws"

function OuthouseBunny.CheckForNearbyPlayers(event, delay, repeat_times, creature)
    local players_in_range = creature:GetPlayersInRange(OuthouseBunny.CLOSE_DISTANCE)
    for _, player in pairs(players_in_range) do
        if player:HasQuest(OuthouseBunny.QUEST_ID) and not player:GetData("ReceivedOuthouseBroadcast") then
            player:SendBroadcastMessage(OuthouseBunny.MESSAGE)
            player:KilledMonsterCredit(OuthouseBunny.NPC_ID)
            player:SetData("ReceivedOuthouseBroadcast", true)
        end
    end
end

function OuthouseBunny.OnSpawn(event, creature)
    creature:RegisterEvent(OuthouseBunny.CheckForNearbyPlayers, 2000, 0)
end

RegisterCreatureEvent(OuthouseBunny.NPC_ID, 5, OuthouseBunny.OnSpawn)


local GraveBunny = {}

GraveBunny.NPC_ID = 800060 
GraveBunny.QUEST_ID = 100024 -- change me
GraveBunny.CLOSE_DISTANCE = 5 
GraveBunny.MESSAGE = "These graves look very fresh. A number of people must have died recently"

function GraveBunny.CheckForNearbyPlayers(event, delay, repeat_times, creature)
    local players_in_range = creature:GetPlayersInRange(GraveBunny.CLOSE_DISTANCE)
    for _, player in pairs(players_in_range) do
        if player:HasQuest(GraveBunny.QUEST_ID) and not player:GetData("ReceivedGraveBroadcast") then
            player:SendBroadcastMessage(GraveBunny.MESSAGE)
            player:KilledMonsterCredit(GraveBunny.NPC_ID)
            player:SetData("ReceivedGraveBroadcast", true)
        end
    end
end

function GraveBunny.OnSpawn(event, creature)
    creature:RegisterEvent(GraveBunny.CheckForNearbyPlayers, 2000, 0)
end

RegisterCreatureEvent(GraveBunny.NPC_ID, 5, GraveBunny.OnSpawn)
]]--