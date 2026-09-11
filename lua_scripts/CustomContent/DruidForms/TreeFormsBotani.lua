local DruidTreeMorphs = {
    [603] = {displayId = 600105, name = "Botani Tree of Life Coral"},
    [604] = {displayId = 600106, name = "Botani Tree of Life Ruby"},
    [605] = {displayId = 600107, name = "Botani Tree of Life Coral II"},
    [606] = {displayId = 600108, name = "Botani Tree of Life Dust"},
    [607] = {displayId = 600109, name = "Botani Tree of Life Amethyst"},
    [608] = {displayId = 600110, name = "Botani Tree of Life Ruby II"}
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
    player:GossipSendMenu(100, player, 865032)  
end

local function OnDruidTreeItemUse(event, player, item, target)
    if item:GetEntry() == 865032 then  
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

RegisterItemEvent(865032, 2, OnDruidTreeItemUse) 
RegisterPlayerGossipEvent(865032, 2, OnDruidTreeGossipSelect) 
