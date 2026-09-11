--[[
local QUEST_CUSTOM_COMPLETE = 100022
local ITEM_ID = 800102
local GAMEOBJECT_ID_1 = 1000009
local GAMEOBJECT_ID_2 = 1000010

-- Function to handle the GameObject events
local function OnGameObjectEvent(event, go, player)
    if event == 14 then  -- GAMEOBJECT_EVENT_ON_USE
        if player:HasQuest(QUEST_CUSTOM_COMPLETE) then
            if not player:HasItem(ITEM_ID) then
                player:AddItem(ITEM_ID, 1)
                -- print("Player received the quest item (ITEM_ID:", ITEM_ID, ").")
            else
                -- print("Error: Player already has the quest item.")
                return  -- Skip the rest of the function if the player already has the item
            end

            local x, y, z, o = go:GetLocation()
            local locationOfGO1 = {x = x, y = y, z = z, o = o}

            if go:IsInWorld() then
                go:Despawn()

                local objectsInRange = player:GetGameObjectsInRange(100, GAMEOBJECT_ID_2)
                for _, obj in pairs(objectsInRange) do
                    if obj:GetEntry() == GAMEOBJECT_ID_2 then
                        obj:Despawn()
                        break
                    end
                end

                local respawnDelay = 0
                local gameObject2 = player:SummonGameObject(GAMEOBJECT_ID_2, locationOfGO1.x, locationOfGO1.y, locationOfGO1.z, locationOfGO1.o, respawnDelay)

                if gameObject2 then
                    -- print("GAMEOBJECT_ID_2 successfully summoned.")
                else
                    -- print("Error: Failed to summon GAMEOBJECT_ID_2.")
                end
            else
                -- print("Error: GameObject is not valid.")
            end
        end
    end
end

-- Function to handle quest completion and abandonment
local function OnQuestEvent(event, player, questId)
    if event == 38 and questId == QUEST_CUSTOM_COMPLETE then
        -- Quest abandoned, find and despawn GAMEOBJECT_ID_2
        local objectsInRange = player:GetGameObjectsInRange(100, GAMEOBJECT_ID_2)  -- Adjust the range and entry as needed
        for _, obj in pairs(objectsInRange) do
            if obj:GetEntry() == GAMEOBJECT_ID_2 then
                -- Despawn GAMEOBJECT_ID_2
                obj:Despawn()
                -- print("Despawning GAMEOBJECT_ID_2 on quest abandonment.")
                break
            end
        end
    elseif event == 54 and questId == QUEST_CUSTOM_COMPLETE then
        -- Quest completed, find and despawn GAMEOBJECT_ID_2
        local objectsInRange = player:GetGameObjectsInRange(100, GAMEOBJECT_ID_2)  -- Adjust the range and entry as needed
        for _, obj in pairs(objectsInRange) do
            if obj:GetEntry() == GAMEOBJECT_ID_2 then
                -- Despawn GAMEOBJECT_ID_2
                obj:Despawn()
                print("Despawning GAMEOBJECT_ID_2 on quest completion.")
                break
            end
        end
    end
end

-- Function to handle quest reward item event
local function OnQuestRewardItem(event, player, item, count)
    if event == 51 and item == ITEM_ID and count > 0 then
        local objectsInRange = player:GetGameObjectsInRange(100, GAMEOBJECT_ID_2)
        for _, obj in pairs(objectsInRange) do
            if obj:GetEntry() == GAMEOBJECT_ID_2 then
                obj:Despawn()
                -- print("Despawning GAMEOBJECT_ID_2 on quest reward item.")
                break
            end
        end
        -- print("Event:", event)  -- Corrected indentation
    end
end

local function OnQuestComplete(event, player, quest)
    if quest and quest:GetId() == QUEST_CUSTOM_COMPLETE then
        -- Quest completed, find and despawn GAMEOBJECT_ID_2
        local objectsInRange = player:GetGameObjectsInRange(100, GAMEOBJECT_ID_2)
        for _, obj in pairs(objectsInRange) do
            if obj:GetEntry() == GAMEOBJECT_ID_2 then
                -- Despawn GAMEOBJECT_ID_2
                obj:Despawn()
                print("Despawning GAMEOBJECT_ID_2 on quest completion. Quest ID:", quest:GetId())
                break
            end
        end
    end
end
-- Register the GameObject event handler for both GAMEOBJECT_ID_1
RegisterGameObjectEvent(GAMEOBJECT_ID_1, 14, OnGameObjectEvent)

-- Register the Quest event handler for quest completion and abandonment
RegisterPlayerEvent(54, OnQuestComplete)  -- EVENT_ON_COMPLETE_QUEST
RegisterPlayerEvent(38, OnQuestEvent)  -- EVENT_ON_QUEST_ABANDON
RegisterPlayerEvent(51, OnQuestRewardItem)  -- PLAYER
]]--