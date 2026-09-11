
--[[
local NPC_THEGIRL_DELETED = 1000049
local NPC_THEGIRL_TOPROTECT = 1000050
local NPC_THEMOM = 1000026
local NPC_WORGEN_ATTACKERS = 1000031
local WAYPOINT_PATH_ID = 11000050
local QUEST_ID = 100019
local SPAWN_X = -2248.389893
local SPAWN_Y = 1960.109985
local SPAWN_Z = 101.178001
local SPAWN_O = 0
local currentWaypoint = 1 -- Initialize currentWaypoint
local THEMOM_DISTANCE = 10 -- Adjust the distance for THEMOM NPC interaction
local ATTACK_DELAY = 10 -- Delay between attacks in milliseconds
local MAX_ATTACKERS = 3 -- Maximum number of attackers spawned
local lastAttackTime = 0
local questInProgress = false
local girlTexts = {
    "Let's get out of here!",
    "Please hurry!",
    "Hero, save me!",
    -- Add more text messages here as needed
}
local waypoints = {
    {X =  -2268.05, Y = 1964.42, Z = 99.76, Map = 0},
    {X =  -2272.61, Y = 1972.69, Z = 98.39, Map = 0},
    {X =  -2277.17, Y = 1980.96, Z = 97.03, Map = 0},
    {X =  -2281.73, Y = 1989.23, Z = 95.66, Map = 0},
    {X =  -2286.29, Y = 1997.50, Z = 94.30, Map = 0},
    {X =  -2290.85, Y = 2005.77, Z = 92.93, Map = 0},
    {X =  -2295.41, Y = 2014.04, Z = 91.56, Map = 0},
    {X =  -2299.98, Y = 2022.31, Z = 90.20, Map = 0},
    {X =  -2304.54, Y = 2030.58, Z = 88.83, Map = 0},
    {X =  -2309.10, Y = 2038.85, Z = 87.46, Map = 0},
    {X =  -2313.66, Y = 2047.12, Z = 86.10, Map = 0},
    {X =  -2318.22, Y = 2055.39, Z = 84.73, Map = 0},
    {X =  -2322.78, Y = 2063.66, Z = 83.37, Map = 0},
    {X =  -2327.34, Y = 2071.93, Z = 82.00, Map = 0},
    {X =  -2331.90, Y = 2080.20, Z = 80.63, Map = 0},
    {X =  -2336.46, Y = 2088.47, Z = 79.27, Map = 0},
    {X =  -2341.02, Y = 2096.74, Z = 77.90, Map = 0},
    {X =  -2345.58, Y = 2105.01, Z = 76.54, Map = 0},
    {X =  -2350.15, Y = 2113.28, Z = 75.17, Map = 0},
    {X =  -2354.71, Y = 2121.56, Z = 73.80, Map = 0},
    {X =  -2359.27, Y = 2129.83, Z = 72.44, Map = 0},
    {X =  -2363.83, Y = 2138.10, Z = 71.07, Map = 0},
    {X =  -2368.39, Y = 2146.37, Z = 69.70, Map = 0},
    {X =  -2372.95, Y = 2154.64, Z = 68.34, Map = 0},
    {X =  -2377.51, Y = 2162.91, Z = 66.97, Map = 0},
    {X =  -2382.07, Y = 2171.18, Z = 65.61, Map = 0},
    {X =  -2386.63, Y = 2179.45, Z = 64.24, Map = 0},
    {X =  -2391.19, Y = 2187.72, Z = 62.87, Map = 0},
    {X =  -2395.75, Y = 2195.99, Z = 61.51, Map = 0},
    {X =  -2400.31, Y = 2204.26, Z = 60.14, Map = 0},
    {X =  -2404.88, Y = 2212.53, Z = 58.77, Map = 0},
    {X =  -2409.44, Y = 2220.80, Z = 57.41, Map = 0},
    {X =  -2414.00, Y = 2229.07, Z = 56.04, Map = 0},
    {X =  -2418.56, Y = 2237.34, Z = 54.68, Map = 0},
    {X =  -2423.12, Y = 2245.61, Z = 53.31, Map = 0},
    {X =  -2427.68, Y = 2253.88, Z = 51.94, Map = 0},
    {X =  -2432.24, Y = 2262.15, Z = 50.58, Map = 0},
    {X =  -2436.80, Y = 2270.42, Z = 49.21, Map = 0},
    {X =  -2441.36, Y = 2278.69, Z = 47.84, Map = 0},
    {X =  -2445.92, Y = 2286.96, Z = 46.48, Map = 0},
    {X =  -2450.48, Y = 2295.23, Z = 45.11, Map = 0},
    {X =  -2455.04, Y = 2303.50, Z = 43.75, Map = 0},
    {X =  -2459.61, Y = 2311.77, Z = 42.38, Map = 0},
    {X =  -2464.17, Y = 2320.04, Z = 41.01, Map = 0},
    {X =  -2468.73, Y = 2328.31, Z = 39.65, Map = 0},
    {X =  -2473.29, Y = 2336.58, Z = 38.28, Map = 0},
    {X =  -2477.85, Y = 2344.85, Z = 36.91, Map = 0},
    {X =  -2482.41, Y = 2353.12, Z = 35.55, Map = 0},
    {X =  -2486.97, Y = 2361.39, Z = 34.18, Map = 0},
    {X =  -2491.53, Y = 2369.66, Z = 32.82, Map = 0},
    {X =  -2496.09, Y = 2377.93, Z = 31.45, Map = 0},
    {X =  -2500.65, Y = 2386.20, Z = 30.08, Map = 0},
    {X =  -2505.21, Y = 2394.47, Z = 28.72, Map = 0},
    {X =  -2509.77, Y = 2402.74, Z = 27.35, Map = 0},
    {X =  -2514.34, Y = 2411.02, Z = 25.98, Map = 0},
    {X =  -2518.90, Y = 2419.29, Z = 24.62, Map = 0},
    {X =  -2523.46, Y = 2427.56, Z = 23.25, Map = 0},
    {X =  -2528.02, Y = 2435.83, Z = 21.89, Map = 0},
    {X =  -2532.58, Y = 2444.10, Z = 20.52, Map = 0},
    {X =  -2537.14, Y = 2452.37, Z = 19.15, Map = 0},
    {X =  -2541.70, Y = 2460.64, Z = 17.79, Map = 0},
    {X =  -2546.26, Y = 2468.91, Z = 16.42, Map = 0},
    {X =  -2550.82, Y = 2477.18, Z = 15.05, Map = 0},
    {X =  -2555.38, Y = 2485.45, Z = 13.69, Map = 0},
    {X =  -2559.94, Y = 2493.72, Z = 12.32, Map = 0},
    {X =  -2564.50, Y = 2501.99, Z = 10.96, Map = 0},
    {X =  -2569.07, Y = 2510.26, Z = 9.59, Map = 0},
    {X =  -2573.63, Y = 2518.53, Z = 8.22, Map = 0},
    {X =  -2578.19, Y = 2526.80, Z = 6.86, Map = 0},
    {X =  -2582.75, Y = 2535.07, Z = 5.49, Map = 0},
    {X =  -2587.31, Y = 2543.34, Z = 4.12, Map = 0},
    {X =  -2591.87, Y = 2551.61, Z = 2.76, Map = 0},
    {X =  -2596.43, Y = 2559.88, Z = 1.39, Map = 0},
}

local function SpawnNPC(creature)
    -- Spawn the NPC at the original coordinates with the specified despawn type and timer
    local spawnedCreature = creature:SpawnCreature(NPC_THEGIRL_DELETED, SPAWN_X, SPAWN_Y, SPAWN_Z, SPAWN_O) -- Adjust the despawn timer as needed (60000 milliseconds = 60 seconds)
end
local function SpawnNPC_RUN(player)
    -- Spawn the NPC at the original coordinates with the specified despawn type and timer
    local spawnedCreature = player:SpawnCreature(NPC_THEGIRL_TOPROTECT, SPAWN_X, SPAWN_Y, SPAWN_Z, SPAWN_O) -- Adjust the despawn timer as needed (60000 milliseconds = 60 seconds)
    return spawnedCreature
end
local function IsTheMomNearby(creature)
    local creaturesInRange = creature:GetCreaturesInRange(THEMOM_DISTANCE, NPC_THEMOM)
    return #creaturesInRange > 0
end
-- Function to spawn WORGEN_ATTACKERS
-- Function to spawn WORGEN_ATTACKERS
local function SpawnWorgenAttackers(player, creature)
    local currentTime = GetGameTime()
    print("The current time is: " .. tostring(currentTime))

    -- Check if enough time has passed since the last attack
    if currentTime - lastAttackTime >= ATTACK_DELAY * 1000 then
        local playerX, playerY, playerZ = creature:GetLocation()

        -- Ensure that we spawn between 1 and MAX_ATTACKERS attackers
        local numAttackersToSpawn = math.random(1, MAX_ATTACKERS)

        local attackersSpawned = 0 -- Variable to keep track of how many attackers are spawned

        for i = 1, numAttackersToSpawn do
            local angle = math.random(0, 360)
            local distance = math.random(5, 15)

            -- Calculate the spawn location for the attacker
            local spawnX = playerX + distance * math.cos(math.rad(angle))
            local spawnY = playerY + distance * math.sin(math.rad(angle))
            local spawnZ = playerZ

            -- Spawn the Worgen attacker
            local attacker = player:SpawnCreature(NPC_WORGEN_ATTACKERS, spawnX, spawnY, spawnZ, 0, 2, 0)

            if attacker then
                attacker:SetInCombatWith(player)
                attackersSpawned = attackersSpawned + 1
            end
        end

        if attackersSpawned > 0 then
            -- At least one attacker was spawned, update lastAttackTime
            lastAttackTime = currentTime
            print("Last attack was: " .. tostring(lastAttackTime))
        end
    end
end




-- Define the MoveToNextWaypoint function first
local function MoveToNextWaypoint(creature)
    print("MoveToNextWaypoint called")
    local sniffDialogue = "Let's get out of here!..."
    local findDialogue = "Please hurry!"
    
    if currentWaypoint <= #waypoints then
        local waypoint = waypoints[currentWaypoint]

        creature:MoveWaypoint(WAYPOINT_PATH_ID)
        print("Start Moving")
    else
        if IsTheMomNearby(creature) then
            -- THEMOM is nearby, complete the quest and despawn
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



local function OnQuestAbandon(event, player, questId)
    if questId == QUEST_ID then
	print("Quest abandoned for NPC with entry " .. NPC_THEGIRL_TOPROTECT)
        -- Handle quest abandonment here
        -- Despawn the NPC, reset its state, or perform any other necessary actions
        local creaturesInRange = player:GetCreaturesInRange(100, NPC_THEGIRL_TOPROTECT) -- Adjust the range as needed

        for _, creature in ipairs(creaturesInRange) do
            if creature:GetEntry() == NPC_THEGIRL_TOPROTECT then
                creature:DespawnOrUnsummon(0) -- Instantly despawn the NPC
                -- Respawn the NPC at its original location
                SpawnNPC(player)
                break -- Exit the loop once the creature is found and despawned
            end  
        end
        if worgenAttackersEventId then
            RemoveEventById(worgenAttackersEventId)
            worgenAttackersEventId = nil -- Reset the event ID
            print("Cancelled Worgen attacker event.")
        end
    end
end
local function OnQuestComplete(event, player, quest)
    if quest:GetId() == QUEST_ID then
        -- Mark the quest as completed
        player:CompleteQuest(QUEST_ID)

        -- Set the quest in progress flag to false
        questInProgress = false

        if worgenAttackersEventId then
            RemoveEventById(worgenAttackersEventId)
            worgenAttackersEventId = nil -- Reset the event ID
            print("Cancelled Worgen attacker event.")
        end
    end
end

-- Function to check if the quest is completed
local function IsQuestCompleted(player)
    return player:GetQuestStatus(QUEST_ID) == 0
end


-- Register the OnQuestAccept event
local function OnQuestAccept(event, player, creature, quest)
    if quest:GetId() == QUEST_ID then
        if creature:GetEntry() == NPC_THEGIRL_DELETED then
            print("Script started for NPC with entry " .. creature:GetEntry())
            
            -- Find and despawn all creatures with the entry NPC_THEGIRL_DELETED
            local creaturesToDelete = player:GetCreaturesInRange(100, NPC_THEGIRL_DELETED)
            for _, toDelete in pairs(creaturesToDelete) do
                toDelete:DespawnOrUnsummon(0)
            end
            
            -- Spawn the correct NPC (NPC_THEGIRL_TOPROTECT)
            local girlNPC = SpawnNPC_RUN(player)
            print("Script started for NPC with entry " .. girlNPC:GetEntry()) -- Print the entry of the spawned NPC
            local eventHandler = SpawnWorgenAttackers(player, creature)
            -- Start NPC movement for the newly spawned NPC
            MoveToNextWaypoint(girlNPC)
            CreateLuaEvent(eventHandler, ATTACK_DELAY, 0)
           -- Register the timed event for continuous attacks
        end
    end
end

-- Function to start the quest and initiate continuous attack

-- Register the CheckForTheMom event
local function CheckForTheMom(event, creature, diff)
    if IsTheMomNearby(creature) then
        -- THEMOM is nearby, complete the quest and despawn
        local playersInRange = creature:GetPlayersInRange(200, 0) -- Adjust the range as needed

        for _, playerInRange in pairs(playersInRange) do
            -- Set the quest status to "completed" (status = 1) for the player
            playerInRange:CompleteQuest(QUEST_ID)
            playerInRange:SendBroadcastMessage("Quest marked as completed: Return my little girl to her mother. I need to finish those bastards, and I will be right with you, my little baby.")
        end

        -- Despawn the NPC
        creature:DespawnOrUnsummon()
    end
end
-- Function to register the server event and schedule periodic spawns of Worgen attackers
local function ContinuousAttacks(event, creature, target)
    -- Check if the target is a valid creature
    if target and type(target) == "table" and target:GetEntry() == NPC_THEGIRL_TOPROTECT then
        if creature then
            -- Yell for help
            local randomYells = {
                "Let's get out of here!",
                "Please hurry!",
                "Hero, save me!",
            }
            local randomYell = randomYells[math.random(1, #randomYells)]
            creature:SendUnitYell(randomYell, 0)

            local playersInRange = creature:GetPlayersInRange(100, 2, 1) -- Adjust the range, hostility, and alive/dead status as needed

            for _, player in ipairs(playersInRange) do
                SpawnWorgenAttackers(player, creature)
            end

            -- Schedule the next attack after ATTACK_DELAY milliseconds
            local attackEventId = CreateLuaEvent(function()
                ContinuousAttacks(event, creature, target) -- Call the function recursively to continue checking for players
            end, ATTACK_DELAY)
        end
    end
end
RegisterCreatureEvent(NPC_THEGIRL_TOPROTECT, 7, CheckForTheMom)
RegisterCreatureEvent(NPC_THEGIRL_DELETED, 31, OnQuestAccept)
RegisterCreatureEvent(NPC_THEGIRL_TOPROTECT, 25, OnQuestAccept)
RegisterCreatureEvent(NPC_THEGIRL_TOPROTECT, 7, ContinuousAttacks)
RegisterPlayerEvent(54, OnQuestComplete)
RegisterPlayerEvent(38, OnQuestAbandon) -- Register the quest abandon event
]]--