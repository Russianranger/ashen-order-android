--[[

local ITEM_ID = 800107        -- ID of the item that triggers the trap
local GO_TRAP_ID = 1000012    -- ID of the trap game object
local CREATURE_ID2 = 1000076
local SPELL_ID = 1100028
local SPELL_ID2 = 1100029    -- ID of the spell to cast
local CREATURE_ID = 1000075   -- ID of the creature for kill credit
local TIMER_DURATION = 10     -- Duration of the timer in seconds
local DESPAWN_DELAY = 10000   -- Delay for despawning the trap in milliseconds (10 seconds)

-- Fetch player using name without causing recursion
local function FetchPlayerByName(playerName)
    local player = GetPlayerByName(playerName)  -- Using the API's function directly
    if player then
        --print("Player fetched successfully: " .. player:GetName())
    else
        --print("Failed to fetch player by name.")
    end
    return player
end

-- Function to handle the spawning of the trap and the timer
local function SpawnTrapAndStartTimer(playerName)
    local player = FetchPlayerByName(playerName)
    if not player then
        --print("Invalid player object.")
        return
    end

    --print("Spawning trap and starting timer...")
    local x, y, z, o = player:GetLocation()
    local mapId = player:GetMapId()
    local instanceId = player:GetInstanceId()
    local trap = PerformIngameSpawn(2, GO_TRAP_ID, mapId, instanceId, x, y, z, o, false, 0, 1)
    local dimyTrap = PerformIngameSpawn(1, CREATURE_ID2, mapId, instanceId, x, y, z, o, false, 0, 1)

    if trap and trap:IsSpawned() then
        --print("Trap spawned successfully.")
        local countdown = TIMER_DURATION
        local function HandleCountdown()
            

            local player = FetchPlayerByName(playerName)
            if not player then
                --print("Player object is no longer valid during countdown.")
                if trap:IsInWorld() then
                    trap:RemoveFromWorld()
                end
                return
            end

            --print("Countdown:", countdown)
            if countdown > 0 then
                player:SendAreaTriggerMessage("A trap has been set! It will activate in " .. countdown .. " seconds.")
                countdown = countdown - 1
            else
                --print("Countdown reached zero. Activating trap...")
                PerformTrapActivation(player:GetName(), player:GetCreaturesInRange(120,CREATURE_ID2))
                local trapGameObjects = player:GetGameObjectsInRange(1500, GO_TRAP_ID)
    
                 -- Loop through each trap GameObject and despawn them
                for _, trapGameObject in ipairs(trapGameObjects) do
                    trapGameObject:RemoveFromWorld()
                end
                local trapNpcObjects = player:GetCreaturesInRange(1500,CREATURE_ID2)
                for _, trapNpcObjects in ipairs(trapNpcObjects) do
                    trapNpcObjects:DespawnOrUnsummon()
                end
                --print("Trap despawned.")
            end
        end

        --print("Registering countdown event...")
        trap:RegisterEvent(HandleCountdown, 1000, TIMER_DURATION + 1)
    else
        --print("Failed to spawn the trap.")
    end
end

function PerformTrapActivation(playerName, trapObjects)
    local player = FetchPlayerByName(playerName)
    if not player then
        --print("Invalid player object.")
        return
    end

    --print("Performing trap activation...")
    for _, trap in ipairs(trapObjects) do
        local creaturesInRange = trap:GetCreaturesInRange(5, CREATURE_ID)
        if #creaturesInRange > 0 then
            local target = creaturesInRange[1]
            trap:CastSpell(target, SPELL_ID, true)
            player:KilledMonsterCredit(CREATURE_ID)
            player:SendAreaTriggerMessage("The trap has been activated and the target has been dealt with!")
        else
            player:SendAreaTriggerMessage("No valid target found for the trap. It has been wasted.")
        end
    end
end

-- Handler for when the item is used
local function OnSpellCast(event, player, spell, skipCheck)
    if not player then
        --print("Invalid player object when spell is cast.")
        return
    end
    
    if spell:GetEntry() == SPELL_ID2 then
        --print("Spell cast event triggered.")
        SpawnTrapAndStartTimer(player:GetName())
    end
end

RegisterPlayerEvent(5, OnSpellCast)

]]--