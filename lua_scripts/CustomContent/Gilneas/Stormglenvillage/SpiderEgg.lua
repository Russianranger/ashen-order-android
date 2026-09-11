--[[
local gameObjectId = 1000006 
local spellId = 1100026 
local targetCreatureId = 1000068 
local questId = 100026 

local function OnGameObjectUse(event, go, player)
    if go:GetEntry() == gameObjectId then
        

        local bunny = player:GetNearestCreature(10, targetCreatureId) 
        if bunny then
            
            player:CastSpell(bunny, spellId, true) 

            player:KilledMonsterCredit(targetCreatureId, questId)
            
        else
            player:SendNotification("No target bunny found nearby.")
            
        end
    end
end

RegisterGameObjectEvent(gameObjectId, 14, OnGameObjectUse) 

]]--