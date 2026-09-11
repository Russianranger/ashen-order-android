local DruidAquaticMorphs = {
    [9] = {displayId = 600126, name = "Black Orca aquatic form"}
}

local function ApplyDruidAquaticMorph(player, morphId)
    local morphInfo = DruidAquaticMorphs[morphId]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
end

local function OnDruidMorphItemUse(event, player, item, target)
    if item:GetEntry() == 865009 then
        if player:HasAura(1066) then  
            ApplyDruidAquaticMorph(player, 9)  
        else
            player:SendBroadcastMessage("You must be in Aquatic Form to use this item.")
        end
        return false
    end
end

RegisterItemEvent(865009, 2, OnDruidMorphItemUse)
