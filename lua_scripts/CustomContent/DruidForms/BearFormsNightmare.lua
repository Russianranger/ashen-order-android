local DruidBearMorphs = {
    [113] = {displayId = 600020, name = "Fallen to Nightmare Sapphire"},
    [114] = {displayId = 600021, name = "Fallen to Nightmare Opal"},
    [115] = {displayId = 600022, name = "Fallen to Nightmare Emerald"},
    [116] = {displayId = 600023, name = "Fallen to Nightmare Ruby"}
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
    player:GossipSendMenu(100, player, 865012)  
end

local function OnDruidBearItemUse(event, player, item, target)
    if item:GetEntry() == 865012 then 
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

RegisterItemEvent(865012, 2, OnDruidBearItemUse)  
RegisterPlayerGossipEvent(865012, 2, OnDruidBearGossipSelect)  