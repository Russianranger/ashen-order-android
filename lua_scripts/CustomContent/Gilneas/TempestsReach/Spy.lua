--[[
local NPC_ID = 1000069
local QUEST_ID = 100027
local VANISH_SPELL_ID = 8822  -- ID for the Vanish spell effect
local DISTANCE_THRESHOLD = 10.0  -- Distance threshold in yards
local CHECK_INTERVAL = 5000  -- Check every 5 seconds

function CheckPlayersForQuest(eventId, delay, repeats, creature)
    local players = creature:GetPlayersInRange(DISTANCE_THRESHOLD)
    local questActiveNearby = false  -- Flag to check if any nearby player has the quest and is not completed.

    for _, player in ipairs(players) do
        -- Check if player has the quest and if it's not completed
        if player:HasQuest(QUEST_ID) and not player:GetQuestStatus(QUEST_ID) == 3 then  -- Assuming 3 means completed
            questActiveNearby = true
            break
        end
    end

    -- Handle the NPC's visibility based on the quest status of nearby players
    if questActiveNearby then
        if creature:HasAura(VANISH_SPELL_ID) then
            creature:RemoveAura(VANISH_SPELL_ID)
            print("Vanish removed: Player with active quest is nearby.")
        end
    else
        if not creature:HasAura(VANISH_SPELL_ID) then
            creature:CastSpell(creature, VANISH_SPELL_ID, true)
            print("Vanish applied: No active quest nearby.")
        end
    end
end

function OnSpawnOrSee(event, creature)
    creature:RegisterEvent(CheckPlayersForQuest, CHECK_INTERVAL, 0)
end

RegisterCreatureEvent(NPC_ID, 5, OnSpawnOrSee)  -- Hook into spawn event to start the check
RegisterCreatureEvent(NPC_ID, 27, OnSpawnOrSee)  -- Optionally hook into the sight event as well
]]--