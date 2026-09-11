local DruidCatMorphs = {
    [221] = {displayId = 600060, name = "Cat Kul Tiran Coral"},
    [222] = {displayId = 600061, name = "Cat Kul Tiran Onyx"},
    [223] = {displayId = 600062, name = "Cat Kul Tiran Emerald"},
    [224] = {displayId = 600063, name = "Cat Kul Tiran Citrine"}
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
    player:GossipSendMenu(100, player, 865021)  
end

local function OnDruidCatItemUse(event, player, item, target)
    if item:GetEntry() == 865021 then  
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

RegisterItemEvent(865021, 2, OnDruidCatItemUse)  
RegisterPlayerGossipEvent(865021, 2, OnDruidCatGossipSelect) 