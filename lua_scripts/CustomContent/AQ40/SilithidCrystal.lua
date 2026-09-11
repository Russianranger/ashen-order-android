local SGO_ID = 883767 

local function Silithid_OnGameObjectUse(event, go, player)
    if player:GetLevel() >= 50 then
        player:Teleport(1, -6861.96, 732.56, 55.05, 3.6)
    else
        player:SendBroadcastMessage("You must be at least level 50 to use this device.")
    end
    return false 
end

RegisterGameObjectEvent(SGO_ID, 14, Silithid_OnGameObjectUse)
