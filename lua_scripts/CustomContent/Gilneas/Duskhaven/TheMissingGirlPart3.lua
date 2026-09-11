--[[ NOTE: NEEDS TO USE REGISTER EVENT RATHER THAN LUA EVENT

-- Define the quest and NPC IDs
local QUEST_ID = 100018 -- Replace with the actual quest ID
local NPC_FATHER = 1000048 -- Replace with the actual NPC ID for the father
local NPC_WORGEN_CAMP = 1000031 -- Replace with the actual NPC ID for the worgen camp guards
local NPC_THEGIRL = 1000049

local WAYPOINT_PATH_ID = 11000039 -- Replace with your waypoint path ID

local SPAWN_X = -2163.052979
local SPAWN_Y = 2231.588135
local SPAWN_Z = 9.364508
local SPAWN_O = 0 -- This could be the initial orientation

-- Define the waypoints the father will follow
local waypoints = {
    {X = -2118.4597, Y = 2293.9087, Z = 15.979556, Map = 0},
    {X = -2028.4731, Y = 2267.1775, Z = 24.489067, Map = 0},
    -- Add the rest of your waypoints here
}

-- Function to spawn the NPC at the original coordinates
local function SpawnNPC(creature)
    -- Spawn the NPC at the original coordinates with the specified despawn type and timer
    local spawnedCreature = creature:SpawnCreature(NPC_FATHER, SPAWN_X, SPAWN_Y, SPAWN_Z, SPAWN_O) -- Adjust the despawn timer as needed (60000 milliseconds = 60 seconds)
end


local shoutDialogues = {
    "You'll regret the day you crossed me! Give me back my child!",
    "I won't stop until I rescue my daughter. Prepare to face your doom!",
    "Release my little girl, or I'll make you pay dearly!",
    "You scoundrels will pay for your crimes! Return my daughter immediately!",
    "I'll show you the meaning of true vengeance if my child is harmed!",
    "You can't hide forever. I'll hunt you down until I find my daughter!",
    "I've faced worse than you. You won't stop me from saving my child!",
    "Every step you take, I'll be one step closer to my daughter!",
    "There's no escape from my wrath until my daughter is safe!",
    "I'll chase you to the ends of the earth to rescue my child!",
    "Your days are numbered! Give up my daughter or face the consequences!",
    "I'll unleash a storm of fury upon you if my little girl is harmed!",
    "You won't live to see another day if you don't release my child!",
    "You thought you could hide, but you underestimated my determination!",
    "My love for my daughter knows no bounds. You can't break me!",
    "I'll never rest until my daughter is back in my arms!",
    "You've made a grave mistake by crossing paths with me!",
    "My child's safety is the only thing that matters now!",
    "I'll fight tooth and nail to rescue my beloved daughter!",
    "This is your last chance. Surrender my child, or face your doom!",
}

local WAYPOINT_PATH_ID = 11000039 -- Replace with your actual waypoint path ID
local currentWaypoint = 1 -- Initialize currentWaypoint
local THEGIRL_DISTANCE = 10 -- Adjust the distance for THEGIRL NPC interaction

-- Function to check if THEGIRL NPC is within range
local function IsTheGirlNearby(creature)
    local creaturesInRange = creature:GetCreaturesInRange(THEGIRL_DISTANCE, NPC_THEGIRL) -- Check if THEGIRL is within the specified range
    return #creaturesInRange > 0
end


-- In MoveToNextWaypoint, add the EmoteSniffAndContinue function before setting the movement type
local function MoveToNextWaypoint(creature)
    local currentWaypoint = creature:GetCurrentWaypointId()
    local sniffDialogue = "I detected the smell..."
    local findDialogue = "I found it this way!"
    if currentWaypoint <= #waypoints then
        local waypoint = waypoints[currentWaypoint]
	creature:MoveStop() -- Stop the movement after 5 seconds
            
        -- Add EmoteSniffAndContinue here
        local delayMilliseconds = 5000 -- 5 seconds
        local eventId = CreateLuaEvent(function()
        end, delayMilliseconds)

	    creature:PerformEmote(2)
            creature:SendUnitSay(sniffDialogue, 0)
            creature:SendUnitSay(findDialogue, 0)
        -- Move to the waypoint
        creature:MoveWaypoint(WAYPOINT_PATH_ID)
    else
         if IsTheGirlNearby(creature) then
                -- THEGIRL is nearby, complete the quest and despawn
                local playersInRange = creature:GetPlayersInRange(100, 0) -- Adjust the range as needed

                for _, playerInRange in pairs(playersInRange) do
                    -- Set the quest status to "completed" (status = 1) for the player
                    playerInRange:CompleteQuest(QUEST_ID)
                    playerInRange:SendBroadcastMessage("Quest marked as completed: Return my little girl to her mother. I need to finish those bastards, and I will be right with you, my little baby.")
                end

                -- Despawn the NPC
                creature:DespawnOrUnsummon()
        end
    end
end

-- Register the OnReachWaypoint event
local function OnReachWaypoint(event, creature, type, id)
    if type == 0 then
        -- The creature reached the current waypoint
        print("NPC reached waypoint " .. currentWaypoint)
        if not creature:IsInCombat() then
            -- Only proceed to the next waypoint if not in combat
            MoveToNextWaypoint(creature)

            -- Emote and say the find dialogue
            creature:PerformEmote(1) -- Emote ID 1 for "point"
            creature:SendUnitSay(findDialogue, 0)
        end
    end
end

local function OnCombat(event, creature, target)
    -- Check if the target is one of the worgen camp guards
    if target:GetEntry() == NPC_WORGEN_CAMP then
        -- When attacked by or attacking a guard, yell a random shout dialogue
        local randomIndex = math.random(1, #shoutDialogues)
        local randomShout = shoutDialogues[randomIndex]
        creature:SendUnitYell(randomShout, 0)
    end
end

local function OnQuestAccept(event, player, creature, quest)
    if quest:GetId() == QUEST_ID then
	print("Script started for NPC with entry " .. creature:GetEntry())
        -- The player accepted the quest, start NPC movement
        MoveToNextWaypoint(creature)
    end
end

local function OnQuestComplete(event, player, quest)
    if quest:GetId() == QUEST_ID then
        -- Handle quest completion here
        -- You can add logic to perform any actions related to quest completion

        -- Despawn the NPC
        local npc = player:GetCreatureByEntry(NPC_ENTRY)
        if npc then
            npc:DespawnOrUnsummon()
        end
    end
end


local function OnQuestAbandon(event, player, questId)
    if questId == QUEST_ID then
	print("Quest abandoned for NPC with entry " .. NPC_FATHER)
        -- Handle quest abandonment here
        -- Despawn the NPC, reset its state, or perform any other necessary actions
        local creaturesInRange = player:GetCreaturesInRange(100, NPC_FATHER) -- Adjust the range as needed

        for _, creature in ipairs(creaturesInRange) do
            if creature:GetEntry() == NPC_FATHER then
                creature:DespawnOrUnsummon(0) -- Instantly despawn the NPC
                -- Respawn the NPC at its original location
                SpawnNPC(player)
                break -- Exit the loop once the creature is found and despawned
            end
        end
    end
end

local function CheckForTheGirl(event, creature, diff)
    if IsTheGirlNearby(creature) then
        -- THEGIRL is nearby, complete the quest and despawn
        local playersInRange = creature:GetPlayersInRange(100, 0) -- Adjust the range as needed

        for _, playerInRange in pairs(playersInRange) do
            -- Set the quest status to "completed" (status = 1) for the player
            playerInRange:CompleteQuest(QUEST_ID)
            playerInRange:SendBroadcastMessage("Quest marked as completed: Return my little girl to her mother. I need to finish those bastards, and I will be right with you, my little baby.")
        end

        -- Despawn the NPC
        creature:DespawnOrUnsummon()
    end
end

-- Register the continuous check function
RegisterCreatureEvent(NPC_FATHER, 7, CheckForTheGirl) -- Register the update event for continuous checking
RegisterCreatureEvent(NPC_FATHER, 31, OnQuestAccept) -- Register quest accept event
RegisterCreatureEvent(NPC_FATHER, 6, OnReachWaypoint) -- Register waypoint reach event
RegisterCreatureEvent(NPC_FATHER, 1, OnCombat) -- Register combat event
RegisterPlayerEvent(54, OnQuestComplete) -- Register the quest complete event
RegisterPlayerEvent(38, OnQuestAbandon) -- Register the quest abandon event

]]--