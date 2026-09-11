local DruidBearMorphs = {
    [101] = {displayId = 600008, name = "Claws of Ursoc Onyx"},
    [102] = {displayId = 600009, name = "Claws of Ursoc Sapphire"},
    [103] = {displayId = 600010, name = "Claws of Ursoc Citrine"},
    [104] = {displayId = 600011, name = "Claws of Ursoc Amethyst"}
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
    player:GossipSendMenu(100, player, 865001)  
end

local function OnDruidBearItemUse(event, player, item, target)
    if item:GetEntry() == 865001 then 
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

RegisterItemEvent(865001, 2, OnDruidBearItemUse)  
RegisterPlayerGossipEvent(865001, 2, OnDruidBearGossipSelect)  