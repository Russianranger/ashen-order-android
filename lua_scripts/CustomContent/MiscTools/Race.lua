local function OnPlayerCommand(event, player, command)
    if command:lower() == "race" then
        local target = player:GetSelection()
        if target then
            local race = target:GetRace()
            if race then
                player:SendBroadcastMessage("Target's race ID: " .. race)
            else
                player:SendBroadcastMessage("Error: Unable to determine target's race.")
            end
        else
            player:SendBroadcastMessage("You must select a target to use this command.")
        end
        return false 
    elseif command:lower() == "faction" then
        local target = player:GetSelection()
        if target then
            local faction = target:GetFaction()
            if faction then
                player:SendBroadcastMessage("Target's faction ID: " .. faction)
            else
                player:SendBroadcastMessage("Error: Unable to determine target's faction.")
            end
        else
            player:SendBroadcastMessage("You must select a target to use this command.")
        end
        return false 
    end
end

RegisterPlayerEvent(42, OnPlayerCommand)
