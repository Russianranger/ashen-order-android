--[[
local GO_CLUE_1 = 1000008 
local GO_CLUE_2 = 1000007 
local NPC_ENTRY = 1000048 
local SPAWN_X = -2163.052979
local SPAWN_Y = 2231.588135
local SPAWN_Z = 9.364508
local SPAWN_O = 0
local DESPAWN_TIMER = 36000000 -- 30 minutes in milliseconds

local clue1Changed = false
local clue2Changed = false

-- Function to check for nearby NPCs with the same ID in a 5-yard radius.
local function CheckNearbyDuplicateNPCs(npc)
    local range = 5 -- 5-yard radius
    local entryId = NPC_ENTRY

    local nearbyNPCs = npc:GetCreaturesInRange(range, entryId)
    if #nearbyNPCs > 0 then 
        for _, duplicate in pairs(nearbyNPCs) do
            if duplicate:GetGUIDLow() ~= npc:GetGUIDLow() then -- Do not despawn the newly spawned NPC
                print("Duplicate NPC found nearby. Despawning the duplicate.")
                duplicate:DespawnOrUnsummon(0)
            end
        end
    end
end

local function SpawnFather(player)
    local spawnType = 1 -- TEMPSUMMON_TIMED_OR_DEAD_DESPAWN
    local despawnTimer = DESPAWN_TIMER

    local father = player:SpawnCreature(NPC_ENTRY, SPAWN_X, SPAWN_Y, SPAWN_Z, SPAWN_O, spawnType, despawnTimer)

    if father then
        father:SendUnitSay("This is the last place I saw my daughter before I devoured that deer... she was so afraid of me... I can't forgive myself. Where is she?", 0)
    else
        print("Failed to spawn the father NPC.")
    end
end

local function FatherOnSpawn(event, creature)
    CheckNearbyDuplicateNPCs(creature)
end

local function CheckGOStateAndSpawn(event, go, state)
    if go:GetEntry() == GO_CLUE_1 then
        clue1Changed = true
        print("Game object with entry " .. GO_CLUE_1 .. " has changed state.")
    elseif go:GetEntry() == GO_CLUE_2 then
        clue2Changed = true
        print("Game object with entry " .. GO_CLUE_2 .. " has changed state.")
    end

    if clue1Changed and clue2Changed then
        print("Both game objects have changed state. Spawning the father NPC.")
        local player = go:GetNearestPlayer()
        if player then
            SpawnFather(player)
        end
        
        -- Resetting the clues to their initial state.
        clue1Changed = false
        clue2Changed = false
    end
end

RegisterGameObjectEvent(GO_CLUE_1, 9, CheckGOStateAndSpawn) 
RegisterGameObjectEvent(GO_CLUE_2, 9, CheckGOStateAndSpawn)
RegisterCreatureEvent(NPC_ENTRY, 5, FatherOnSpawn)
]]--