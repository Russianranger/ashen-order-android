local DruidTravelMorphs = {
    [505] = {displayId = 600082, name = "Zandalari travel form Sapphire"}
}

local function ApplyDruidTravelMorph(player, morphId)
    local morphInfo = DruidTravelMorphs[morphId]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
end

local function OnDruidTravelItemUse(event, player, item, target)
    if item:GetEntry() == 865030 then
        if player:HasAura(783) then  
            ApplyDruidTravelMorph(player, 505)  
        else
            player:SendBroadcastMessage("You must be in Travel Form to use this item.")
        end
        return false
    end
end

RegisterItemEvent(865030, 2, OnDruidTravelItemUse)
