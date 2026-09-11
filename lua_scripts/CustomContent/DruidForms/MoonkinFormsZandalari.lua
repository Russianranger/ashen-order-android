local DruidMoonkinMorphs = {
    [405] = {displayId = 600077, name = "Owlbear Zandalari Emerald"}
}

local function ApplyDruidMoonkinMorph(player, morphId)
    local morphInfo = DruidMoonkinMorphs[morphId]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
end

local function OnDruidMoonkinItemUse(event, player, item, target)
    if item:GetEntry() == 865028 then
        if player:HasAura(24858) then  
            ApplyDruidMoonkinMorph(player, 405)  
        else
            player:SendBroadcastMessage("You must be in Moonkin Form to use this item.")
        end
        return false
    end
end

RegisterItemEvent(865028, 2, OnDruidMoonkinItemUse)
