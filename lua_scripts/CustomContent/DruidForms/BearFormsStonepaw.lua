local DruidBearMorphs = {
    [105] = {displayId = 600012, name = "Stonepaw Sapphire"},
    [106] = {displayId = 600013, name = "Stonepaw Onyx"},
    [107] = {displayId = 600014, name = "Stonepaw Emerald"},
    [108] = {displayId = 600015, name = "Stonepaw Amethyst"}
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
    player:GossipSendMenu(100, player, 865010)  
end

local function OnDruidBearItemUse(event, player, item, target)
    if item:GetEntry() == 865010 then 
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

RegisterItemEvent(865010, 2, OnDruidBearItemUse)  
RegisterPlayerGossipEvent(865010, 2, OnDruidBearGossipSelect)  