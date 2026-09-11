local DruidTreeMorphs = {
    [601] = {displayId = 600083, name = "Incarnation Tree of Life Kul Tiran"},
    [602] = {displayId = 600084, name = "Incarnation Tree of Life Zandalari"}
}

local function sortedKeysByTreeMorphName()
    local keys = {}
    for k in pairs(DruidTreeMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidTreeMorphs[a].name < DruidTreeMorphs[b].name
    end)
    return keys
end

local function CreateDruidTreeGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByTreeMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidTreeMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865006)  
end

local function OnDruidTreeItemUse(event, player, item, target)
    if item:GetEntry() == 865006 then  
        if player:HasAura(33891) then  
            CreateDruidTreeGossipMenu(player)
        else
            player:SendBroadcastMessage("You must be in Tree of Life Form to use this item.")
        end
        return false  
    end
end

local function OnDruidTreeGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidTreeMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865006, 2, OnDruidTreeItemUse) 
RegisterPlayerGossipEvent(865006, 2, OnDruidTreeGossipSelect) 
