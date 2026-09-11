local DruidBearMorphs = {
    [117] = {displayId = 600024, name = "Guardian of the Glade Onyx"},
    [118] = {displayId = 600025, name = "Guardian of the Glade Coral"},
    [119] = {displayId = 600026, name = "Guardian of the Glade Ruby"},
    [120] = {displayId = 600027, name = "Guardian of the Glade Moonstone"}
}



local function sortedKeysByBearMorphName()
    local keys = {}
    for k in pairs(DruidBearMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidBearMorphs[a].name < DruidBearMorphs[b].name
    end)
    return keys
end

local function CreateDruidBearGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByBearMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidBearMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865013)  
end

local function OnDruidBearItemUse(event, player, item, target)
    if item:GetEntry() == 865013 then 
        if player:HasAura(5487) or player:HasAura(9634) then  
            CreateDruidBearGossipMenu(player)
        else
            player:SendBroadcastMessage("You must be in Bear Form to use this item.")
        end
        return false  
    end
end

local function OnDruidBearGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidBearMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865013, 2, OnDruidBearItemUse)  
RegisterPlayerGossipEvent(865013, 2, OnDruidBearGossipSelect)  