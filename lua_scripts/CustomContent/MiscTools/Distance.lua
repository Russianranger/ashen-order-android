local function OnCommandsExtended(event, player, command, handler)
    -- If the command is '.dist'
    if command:lower() == "dist" then
        -- Check if the player has a target
        local target = player:GetSelection()
        
        -- If the player has no target, send a message and return
        if target == nil or target:GetGUID() == 0 then
            player:SendBroadcastMessage("You have no target.")
            return false  -- Prevent the default command handler from taking over
        end

        -- Get the target object
        local targetObject = player:GetMap():GetWorldObject(target)

        -- If the target object could not be found, send a message and return
        if targetObject == nil then
            player:SendBroadcastMessage("Target could not be found.")
            return false  -- Prevent the default command handler from taking over
        end

        -- Calculate the distance to the target
        local distance = player:GetDistance(targetObject)
        
        -- Send a broadcast message displaying the distance
        player:SendBroadcastMessage("Distance to target: " .. string.format("%.2f", distance) .. " yards.")
        
        return false  -- Prevent the default command handler from taking over
    end

        -- If the command is '.speed'
    if command:lower() == "speed" then
        -- Check if the player has a target
        local target = player:GetSelection()

        -- If the player has no target, send a message and return
        if target == nil or target:GetGUID() == 0 then
            player:SendBroadcastMessage("You have no target.")
            return false
        end

        -- Get speed values for Walk, Run, and Flight
        local walkSpeed = target:GetSpeed(0)  -- Walk
        local runSpeed = target:GetSpeed(1)   -- Run
        local flightSpeed = target:GetSpeed(6)  -- Flight

        -- Display the speeds
        player:SendBroadcastMessage("Walk Speed: " .. string.format("%.2f", walkSpeed))
        player:SendBroadcastMessage("Run Speed: " .. string.format("%.2f", runSpeed))
        player:SendBroadcastMessage("Flight Speed: " .. string.format("%.2f", flightSpeed))

        return false  -- Prevent the default command handler from taking over
    end

    return true  -- Continue with the default command handler for other commands
end

RegisterPlayerEvent(42, OnCommandsExtended)
