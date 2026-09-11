--[[
local CREATURE_RENEGADES_CARRIAGE_ID = 1000079
local GAMEOBJECT_RENEGADES_STOLEN_CARGO_ID = 1000013
local SPELL_ID_VISUAL_EFFECT = 1100028
local MIN_CARGO_COUNT = 2
local MAX_CARGO_COUNT = 4
local SPAWN_RADIUS = 10 -- Increased maximum distance from the corpse within which to spawn the objects
local MIN_DISTANCE_BETWEEN_CARGOS = 3 -- Minimum distance between each cargo to avoid overlap

-- Table to keep track of spawned cargo objects
local spawnedCargo = {}

-- Function to generate a random position within a circle
local function getRandomPosition(x, y, radius)
    local angle = math.random() * 2 * math.pi
    local distance = math.random() * radius
    local offsetX = math.cos(angle) * distance
    local offsetY = math.sin(angle) * distance
    return x + offsetX, y + offsetY
end

-- Function to check if the new position overlaps with existing positions
local function isPositionFree(x, y, positions, minDistance)
    for _, pos in ipairs(positions) do
        if ((x - pos[1]) ^ 2 + (y - pos[2]) ^ 2) < (minDistance ^ 2) then
            return false
        end
    end
    return true
end

-- Event handler for the creature's death
local function OnCreatureDeath(event, creature, killer)
    local count = math.random(MIN_CARGO_COUNT, MAX_CARGO_COUNT)
    local positions = {}
    local x, y, z = creature:GetLocation()

    -- Ensure proper initialization
    local creatureGUID = creature:GetGUID()
    spawnedCargo[creatureGUID] = spawnedCargo[creatureGUID] or {}

    -- Debug: Print GUID and table state
    -- print("Handling creature death with GUID:", creatureGUID)
    -- print("Current state of spawnedCargo for this GUID:", spawnedCargo[creatureGUID])

    -- Cast visual spell effect on the corpse
    creature:CastSpell(creature, SPELL_ID_VISUAL_EFFECT, true)
    -- print("Visual spell cast on the creature's corpse with spell ID:", SPELL_ID_VISUAL_EFFECT)

    for i = 1, count do
        local spawnX, spawnY, spawnZ
        local attempts = 0
        repeat
            spawnX, spawnY = getRandomPosition(x, y, SPAWN_RADIUS)
            -- Attempt to get ground height
            spawnZ = creature:GetMap():GetHeight(spawnX, spawnY, z)
            if not spawnZ then
                -- Fallback to creature's Z if GetHeight fails
                print("GetHeight failed, using creature Z with adjustment")
                spawnZ = z + 1.0
            else
                -- Adjust spawnZ to ensure it's above ground level
                spawnZ = spawnZ + 1.0
            end
            attempts = attempts + 1
        until isPositionFree(spawnX, spawnY, positions, MIN_DISTANCE_BETWEEN_CARGOS) or attempts > 10

        if spawnZ then
            table.insert(positions, {spawnX, spawnY})

            -- Debug: Print the spawn location
            -- print(string.format("Spawning game object at: (%.2f, %.2f, %.2f)", spawnX, spawnY, spawnZ))

            local gameObject = creature:SummonGameObject(GAMEOBJECT_RENEGADES_STOLEN_CARGO_ID, spawnX, spawnY, spawnZ, 0, 0, 0, 0, 0)
            if gameObject then
                table.insert(spawnedCargo[creatureGUID], gameObject:GetGUID())
                -- print("Summoned game object with GUID:", gameObject:GetGUID(), "at position:", spawnX, spawnY, spawnZ)
            else
                print("Error: Failed to summon game object at position:", spawnX, spawnY, spawnZ)
            end
        else
            print("Error: Failed to get valid ground height for position:", spawnX, spawnY)
        end
    end

    -- Debug: Final state of spawnedCargo
    -- print("Final state of spawnedCargo for GUID:", creatureGUID, spawnedCargo[creatureGUID])
end

-- Event handler for the creature's respawn
local function OnCreatureRespawn(event, creature)
    local creatureGUID = creature:GetGUID()
    if spawnedCargo[creatureGUID] then
        for _, cargoGUID in ipairs(spawnedCargo[creatureGUID]) do
            local gameObject = GetGameObjectByGUID(cargoGUID)
            if gameObject then
                gameObject:RemoveFromWorld()
                print("Removed game object with GUID:", cargoGUID)
            else
                print("Error: Game object with GUID:", cargoGUID, "not found")
            end
        end
        spawnedCargo[creatureGUID] = nil
    else
        print("No spawnedCargo entry found for GUID:", creatureGUID)
    end
end

-- Register the events
RegisterCreatureEvent(CREATURE_RENEGADES_CARRIAGE_ID, 4, OnCreatureDeath)  -- Event 4: CREATURE_EVENT_ON_DIED
RegisterCreatureEvent(CREATURE_RENEGADES_CARRIAGE_ID, 27, OnCreatureRespawn)  -- Event 27: CREATURE_EVENT_ON_RESPAWN
]]--