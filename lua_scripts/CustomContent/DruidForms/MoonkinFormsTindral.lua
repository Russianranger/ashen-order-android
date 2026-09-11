local DruidMoonkinMorphs = {
    [406] = {displayId = 600098, name = "Tindralmoonkin Moonstone"},
    [407] = {displayId = 600099, name = "Tindralmoonkin Onyx"},
    [408] = {displayId = 600100, name = "Tindralmoonkin Coral"},
    [409] = {displayId = 600101, name = "Tindralmoonkin Citrine"},
    [410] = {displayId = 600102, name = "Tindralmoonkin Emerald"},
    [411] = {displayId = 600103, name = "Tindralmoonkin Ruby"},
    [412] = {displayId = 600104, name = "Tindralmoonkin Sunstone"}
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
    player:GossipSendMenu(100, player, 865029)  
end

local function OnDruidMoonkinItemUse(event, player, item, target)
    if item:GetEntry() == 865029 then  
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

RegisterItemEvent(865029, 2, OnDruidMoonkinItemUse) 
RegisterPlayerGossipEvent(865029, 2, OnDruidMoonkinGossipSelect)  
