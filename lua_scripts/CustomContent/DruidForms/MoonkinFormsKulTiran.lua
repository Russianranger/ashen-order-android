local DruidMoonkinMorphs = {
    [401] = {displayId = 600073, name = "Owlbear Kul Tiran Onyx"},
    [402] = {displayId = 600074, name = "Owlbear Kul Tiran Emerald"},
    [403] = {displayId = 600075, name = "Owlbear Kul Tiran Moonstone"},
    [404] = {displayId = 600076, name = "Owlbear Kul Tiran Ruby"}
}

local function sortedKeysByMoonkinMorphName()
    local keys = {}
    for k in pairs(DruidMoonkinMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidMoonkinMorphs[a].name < DruidMoonkinMorphs[b].name
    end)
    return keys
end

local function CreateDruidMoonkinGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByMoonkinMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidMoonkinMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865004)  
end

local function OnDruidMoonkinItemUse(event, player, item, target)
    if item:GetEntry() == 865004 then  
        if player:HasAura(24858) then  
            CreateDruidMoonkinGossipMenu(player)
        else
            player:SendBroadcastMessage("You must be in Moonkin Form to use this item.")
        end
        return false  
    end
end

local function OnDruidMoonkinGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidMoonkinMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId) 
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865004, 2, OnDruidMoonkinItemUse) 
RegisterPlayerGossipEvent(865004, 2, OnDruidMoonkinGossipSelect)  
