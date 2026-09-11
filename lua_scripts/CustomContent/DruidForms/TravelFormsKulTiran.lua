local DruidTravelMorphs = {
    [501] = {displayId = 600078, name = "Kul Tiran travel form Sapphire"},
    [502] = {displayId = 600079, name = "Kul Tiran travel form Coral"},
    [503] = {displayId = 600080, name = "Kul Tiran travel form Emerald"},
    [504] = {displayId = 600081, name = "Kul Tiran travel form Moonstone"}
}

local function sortedKeysByTravelMorphName()
    local keys = {}
    for k in pairs(DruidTravelMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidTravelMorphs[a].name < DruidTravelMorphs[b].name
    end)
    return keys
end

local function CreateDruidTravelGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByTravelMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidTravelMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865005)  
end

local function OnDruidTravelItemUse(event, player, item, target)
    if item:GetEntry() == 865005 then  
        if player:HasAura(783) then  
            CreateDruidTravelGossipMenu(player)
        else
            player:SendBroadcastMessage("You must be in Travel Form to use this item.")
        end
        return false  
    end
end

local function OnDruidTravelGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidTravelMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865005, 2, OnDruidTravelItemUse)  
RegisterPlayerGossipEvent(865005, 2, OnDruidTravelGossipSelect)  
