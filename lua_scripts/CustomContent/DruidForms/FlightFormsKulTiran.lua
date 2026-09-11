-- !!!NOTE: I'LL NEED TO RESCRIPT FLIGHT FORM SO IT CAN USE ITEMS WITHOUT INTERRUPTING THE FORM!!! This script is just for testing currently.

local DruidFlightMorphs = {
    [301] = {displayId = 600068, name = "Kul Tiran flight form Coral"},
    [302] = {displayId = 600069, name = "Kul Tiran flight form Onyx"},
    [303] = {displayId = 600070, name = "Kul Tiran flight form Emerald"},
    [304] = {displayId = 600071, name = "Kul Tiran flight form Moonstone"}
}

local function sortedKeysByFlightMorphName()
    local keys = {}
    for k in pairs(DruidFlightMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidFlightMorphs[a].name < DruidFlightMorphs[b].name
    end)
    return keys
end

local function CreateDruidFlightGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByFlightMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidFlightMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865003)  
end

local function OnDruidFlightItemUse(event, player, item, target)
    if item:GetEntry() == 865003 then  
        CreateDruidFlightGossipMenu(player)
        return false  
    end
end

local function OnDruidFlightGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidFlightMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true) 
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865003, 2, OnDruidFlightItemUse) 
RegisterPlayerGossipEvent(865003, 2, OnDruidFlightGossipSelect) 
