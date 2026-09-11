local DruidCatMorphs = {
    [201] = {displayId = 600040, name = "Fang's of Ashamane Onyx"},
    [202] = {displayId = 600041, name = "Fang's of Ashamane Sapphire"},
    [203] = {displayId = 600042, name = "Fang's of Ashamane Emerald"},
    [204] = {displayId = 600043, name = "Fang's of Ashamane Amethyst"}
}

local function sortedKeysByCatMorphName()
    local keys = {}
    for k in pairs(DruidCatMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidCatMorphs[a].name < DruidCatMorphs[b].name
    end)
    return keys
end

local function CreateDruidCatGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByCatMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidCatMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865002)  
end

local function OnDruidCatItemUse(event, player, item, target)
    if item:GetEntry() == 865002 then  
        if player:HasAura(768) then  
            CreateDruidCatGossipMenu(player)
        else
            player:SendBroadcastMessage("You must be in Cat Form to use this item.")
        end
        return false  
    end
end

local function OnDruidCatGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidCatMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
  player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865002, 2, OnDruidCatItemUse)  
RegisterPlayerGossipEvent(865002, 2, OnDruidCatGossipSelect) 