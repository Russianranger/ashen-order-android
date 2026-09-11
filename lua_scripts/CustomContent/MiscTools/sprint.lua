local SPRINT_SPELL_ID = 920900  -- sprint spell ID
local BLOCKING_AURA_ID = 1200006 -- blocking aura ID
local sprintPowerMax = 100
local sprintCost = 5
local sprintRegen = 10
local DECREMENT_INTERVAL = 1250  -- Time in milliseconds between each power decrement
local REGEN_INTERVAL = 5000      -- Time in milliseconds between each power regeneration tick

-- Forward declare functions to ensure visibility
local RegenerateSprintPower
local DecrementSprintPower
local SendSprintPowerUpdate

-- Table to keep track of registered events and states for players
local playerEventIds = {}
local playerState = {}

-- Function to send sprint power updates to the client
SendSprintPowerUpdate = function(player, power)
    local prefix = "SprintPowerUpdate"
    local message = tostring(power)
    local channel = 1

    if player and player:IsPlayer() then
        player:SendAddonMessage(prefix, message, channel, player)
    else
        --print("Error: Invalid player object. Object is either nil or not a player.")
    end
end

-- Function to decrement sprint power over time using player GUID
DecrementSprintPower = function(playerGuid)
    local player = GetPlayerByGUID(playerGuid)
    if not player or not player:IsInWorld() then
        --print("Player not found or not in world for GUID:", playerGuid)
        return
    end

    local currentPower = player:GetData("sprintPower") or 0
    if player:HasAura(SPRINT_SPELL_ID) and currentPower > 0 then
        currentPower = currentPower - sprintCost
        player:SetData("sprintPower", currentPower)
        SendSprintPowerUpdate(player, currentPower)

        if currentPower > 0 then
            if playerEventIds[playerGuid] then
                player:RemoveEvents(playerEventIds[playerGuid].decrement)
            end
            local eventId = player:RegisterEvent(function() DecrementSprintPower(playerGuid) end, DECREMENT_INTERVAL, 1)
            playerEventIds[playerGuid] = playerEventIds[playerGuid] or {}
            playerEventIds[playerGuid].decrement = eventId
        else
            player:RemoveAura(SPRINT_SPELL_ID)
            player:SendBroadcastMessage("|cfff99b09Your sprint power has run out.|r")
            player:CastSpell(player, BLOCKING_AURA_ID, true)
            -- Start regenerating immediately if power hits zero
            playerState[playerGuid].isSprinting = false
            RegenerateSprintPower(playerGuid)
        end
    end
end

-- Function to regenerate sprint power over time using player GUID
RegenerateSprintPower = function(playerGuid)
    local player = GetPlayerByGUID(playerGuid)
    if not player or not player:IsInWorld() then
        --print("Player not found or not in world for GUID:", playerGuid)
        return
    end

    if not player:HasAura(SPRINT_SPELL_ID) then
        local currentPower = player:GetData("sprintPower") or 0
        if currentPower < sprintPowerMax then
            currentPower = currentPower + sprintRegen
            if currentPower > sprintPowerMax then
                currentPower = sprintPowerMax
            end
            player:SetData("sprintPower", currentPower)
            SendSprintPowerUpdate(player, currentPower)

            if currentPower < sprintPowerMax then
                if playerEventIds[playerGuid] then
                    player:RemoveEvents(playerEventIds[playerGuid].regenerate)
                end
                local eventId = player:RegisterEvent(function() RegenerateSprintPower(playerGuid) end, REGEN_INTERVAL, 1)
                playerEventIds[playerGuid] = playerEventIds[playerGuid] or {}
                playerEventIds[playerGuid].regenerate = eventId
            else
                playerState[playerGuid].isRegenerating = false
            end
        end
    else
        --print("Sprint spell is active, not regenerating power.")
    end
end

-- Function to handle the custom sprint command
local function HandleSprintCommand(event, player, command)
    if command == "sprint" then
        if player:IsMounted() then
            player:SendBroadcastMessage("|cfff99b09You cannot sprint while mounted.|r")
            return false -- Return false to prevent "Command 'sprint" does not exist message from appearing in-game.
        end
        
        if player:IsOnVehicle() then
            player:SendBroadcastMessage("|cfff99b09You cannot sprint while in a vehicle.|r")
            return false -- Return false to prevent "Command 'sprint" does not exist message from appearing in-game.
        end

        if player:HasAura(BLOCKING_AURA_ID) then
            local aura = player:GetAura(BLOCKING_AURA_ID)
            if aura then
                local duration = aura:GetDuration()
                player:SendBroadcastMessage("|cfff99b09You must wait " .. string.format("%.1f", duration / 1000) .. " seconds before sprinting again.|r")
            end
            return false -- Return false to prevent "Command 'sprint" does not exist message from appearing in-game.
        end

        local playerGuid = player:GetGUID()

        -- Initialize player state if not already done
        if not playerState[playerGuid] then
            playerState[playerGuid] = {isSprinting = false, isRegenerating = false}
        end

        -- Cancel any existing events
        if playerEventIds[playerGuid] then
            if playerEventIds[playerGuid].decrement then
                player:RemoveEvents(playerEventIds[playerGuid].decrement)
            end
            if playerEventIds[playerGuid].regenerate then
                player:RemoveEvents(playerEventIds[playerGuid].regenerate)
            end
        end

        if player:HasAura(SPRINT_SPELL_ID) then
            player:RemoveAura(SPRINT_SPELL_ID)
            player:CastSpell(player, BLOCKING_AURA_ID, true)
            player:SendBroadcastMessage("|cfff99b09Sprint cancelled.|r")
            local currentPower = player:GetData("sprintPower") or sprintPowerMax
            player:SetData("sprintPower", math.max(0, currentPower - 10))
            SendSprintPowerUpdate(player, math.max(0, currentPower - 10))
            -- Ensure regeneration starts if the sprint is cancelled and not at max
            playerState[playerGuid].isSprinting = false
            if not playerState[playerGuid].isRegenerating then
                playerState[playerGuid].isRegenerating = true
                RegenerateSprintPower(playerGuid)
            end
            return false -- Return false to prevent "Command 'sprint" does not exist message from appearing in-game.
        end

        local currentPower = player:GetData("sprintPower") or sprintPowerMax
        if currentPower >= sprintCost then
            player:SetData("sprintPower", currentPower - sprintCost)
            SendSprintPowerUpdate(player, currentPower - sprintCost)
            player:CastSpell(player, SPRINT_SPELL_ID, true)
            playerState[playerGuid].isSprinting = true
            local eventId = player:RegisterEvent(function() DecrementSprintPower(playerGuid) end, DECREMENT_INTERVAL, 1)
            playerEventIds[playerGuid] = playerEventIds[playerGuid] or {}
            playerEventIds[playerGuid].decrement = eventId
        else
            player:SendBroadcastMessage("|cfff99b09Not enough sprint power.|r")
            -- Ensure regeneration starts if the spell is cancelled and not at max
            if currentPower < sprintPowerMax and not playerState[playerGuid].isRegenerating then
                playerState[playerGuid].isRegenerating = true
                RegenerateSprintPower(playerGuid)
            end
        end

        return false -- Return false to prevent "Command 'sprint" does not exist message from appearing in-game.
    end
end

-- Register events for custom command
RegisterPlayerEvent(42, HandleSprintCommand)  -- Custom command