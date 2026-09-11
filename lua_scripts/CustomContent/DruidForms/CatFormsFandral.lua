local DruidCatMorphs = {
    [234] = {displayId = 600116, name = "Fandral's Flamescythe"}
}

local function ApplyDruidCatMorph(player, morphId)
    local morphInfo = DruidCatMorphs[morphId]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
end

local function OnDruidCatItemUse(event, player, item, target)
    if item:GetEntry() == 865024 then
        if player:HasAura(768) then  
            ApplyDruidCatMorph(player, 234)  
        else
            player:SendBroadcastMessage("You must be in Cat Form to use this item.")
        end
        return false
    end
end

RegisterItemEvent(865024, 2, OnDruidCatItemUse)
