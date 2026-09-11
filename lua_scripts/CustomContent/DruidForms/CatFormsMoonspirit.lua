local DruidCatMorphs = {
    [229] = {displayId = 600111, name = "Moonspirit Onyx"},
    [230] = {displayId = 600112, name = "Moonspirit Sapphire"},
    [231] = {displayId = 600113, name = "Moonspirit Emerald"},
    [232] = {displayId = 600114, name = "Moonspirit Topaz"},
	[233] = {displayId = 600115, name = "Moonspirit Topaz II"}
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
    player:GossipSendMenu(100, player, 865023)  
end

local function OnDruidCatItemUse(event, player, item, target)
    if item:GetEntry() == 865023 then  
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

RegisterItemEvent(865023, 2, OnDruidCatItemUse)  
RegisterPlayerGossipEvent(865023, 2, OnDruidCatGossipSelect) 