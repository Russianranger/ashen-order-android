local DruidCatMorphs = {
    [205] = {displayId = 600044, name = "Ghost of the Pridemother Sapphire"},
    [206] = {displayId = 600045, name = "Ghost of the Pridemother Emerald"},
    [207] = {displayId = 600046, name = "Ghost of the Pridemother Amethyst"},
    [208] = {displayId = 600047, name = "Ghost of the Pridemother Ruby"}
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
    player:GossipSendMenu(100, player, 865017)  
end

local function OnDruidCatItemUse(event, player, item, target)
    if item:GetEntry() == 865017 then  
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

RegisterItemEvent(865017, 2, OnDruidCatItemUse)  
RegisterPlayerGossipEvent(865017, 2, OnDruidCatGossipSelect) 