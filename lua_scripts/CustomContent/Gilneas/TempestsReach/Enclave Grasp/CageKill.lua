--[[
local ITEM_ID = 800106          -- Item ID of the Flaming Torch
local TARGET_NPC_ID = 1000073   -- NPC ID of the Invisible Cage Bunny
local SPELL_ID = 1100027        -- Primary Spell ID to be cast implicitly
local VISUAL_SPELL_ID = 49132   -- Visual Spell ID to cast on the bunny
local PLAYER_LIST_KEY = "PlayersUsed" -- Key to store player GUIDs who have used the item
local DURATION = 30000          -- Duration in milliseconds (10 seconds)
local SOME_QUEST_ID = 100028    -- Example quest ID

-- Global NPC registry for tracking NPCs across events
local npcRegistry = {}

-- Function to add or remove NPC from global tracking
local function TrackNPC(event, npc)
    if npc:GetEntry() == TARGET_NPC_ID then
        if event == 1 then -- NPC Spawn
            npcRegistry[npc:GetGUID()] = npc
        elseif event == 20 then -- NPC Despawn
            npcRegistry[npc:GetGUID()] = nil
        end
    end
end

-- Function to handle the item use event
local function OnItemUse(event, player, item, target)
    if item:GetEntry() == ITEM_ID then
        player:SetData("UsedFlamingTorch", true)
    end
end

-- First, define the function
local function RemoveVisualEffect(npc)
    if npc then
        --print("RemoveVisualEffect called on NPC with GUID:", npc:GetGUID())  -- Debugging NPC GUID
        --print("NPC Entry ID for debugging:", npc:GetEntry())  -- Debugging NPC Entry ID for clarity on which NPC type is affected

        -- Registering the event with a function to remove the visual aura
        local eventID = npc:RegisterEvent(function(eventId, delay, repeats, worldobject)
            --print("Event triggered for NPC GUID:", (worldobject and worldobject:GetGUID() or "Unknown"))  -- Confirming which NPC the event is firing for

            -- Check if the worldobject is still valid and in the world
            if worldobject and worldobject:IsInWorld() then
                --print("NPC is valid and in world, proceeding to remove aura.")
                worldobject:RemoveAura(VISUAL_SPELL_ID)
                --print("Aura removed from NPC GUID:", worldobject:GetGUID())  -- Confirm aura removal
            else
                --print("NPC is no longer valid or has despawned. NPC GUID:", (worldobject and worldobject:GetGUID() or "Unknown"))
            end
        end, DURATION, 1)

        -- Debugging the event registration success and storing event ID
        if eventID then
            --print("Event registered successfully with ID:", eventID)
        else
            --print("Failed to register event for NPC GUID:", npc:GetGUID())
        end
    else
        --print("RemoveVisualEffect called with nil NPC.")
    end
end



-- Later in the script, use the function
local function OnSpellCast(event, player, spell, skipCheck)
    if spell:GetEntry() == SPELL_ID and player:GetData("UsedFlamingTorch") then
        player:SetData("UsedFlamingTorch", nil)

        local targets = player:GetCreaturesInRange(5, TARGET_NPC_ID)
        for i, target in ipairs(targets) do
            if target and target:IsInWorld() then
                local usedByPlayers = target:GetData(PLAYER_LIST_KEY) or {}

                if not usedByPlayers[player:GetGUIDLow()] then
                    player:KilledMonsterCredit(TARGET_NPC_ID)
                    usedByPlayers[player:GetGUIDLow()] = true
                    target:SetData(PLAYER_LIST_KEY, usedByPlayers)
                    target:CastSpell(target, VISUAL_SPELL_ID, true)
                    RemoveVisualEffect(target)  -- Make sure this function is defined before this point
                end
            end
        end
    end
end

RegisterCreatureEvent(TARGET_NPC_ID, 5, TrackNPC) -- NPC Spawn
RegisterCreatureEvent(TARGET_NPC_ID, 20, TrackNPC) -- NPC Despawn
RegisterItemEvent(ITEM_ID, 2, OnItemUse) -- Item use
RegisterPlayerEvent(5, OnSpellCast) -- Spell cast
]]--