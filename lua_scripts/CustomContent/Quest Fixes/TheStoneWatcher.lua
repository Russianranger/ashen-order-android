local GameObjectId = 142343 
local QuestId = 2954 
local NpcId = 7918 
local SpawnDuration = 600000 

local function OnQuestAccept(event, player, gameObject, quest)
    if quest:GetId() == QuestId then
        player:SpawnCreature(NpcId, -9503.07, -2813.725586, 11.489568, 1.250, 3, SpawnDuration)
    end
end

RegisterGameObjectEvent(GameObjectId, 4, OnQuestAccept)
