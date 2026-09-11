local DruidAquaticMorphs = {
    [5] = {displayId = 600004, name = "Zandalari aquatic form Onyx"},
    [6] = {displayId = 600005, name = "Zandalari aquatic form Sapphire"},
    [7] = {displayId = 600006, name = "Zandalari aquatic form Emerald"},
    [8] = {displayId = 600007, name = "Zandalari aquatic form Topaz"}
}

local function sortedKeysByMorphName()
    local keys = {}
    for k in pairs(DruidAquaticMorphs) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b)
        return DruidAquaticMorphs[a].name < DruidAquaticMorphs[b].name
    end)
    return keys
end

local function CreateDruidAquaticGossipMenu(player)
	player:GossipClearMenu()
    local sortedKeys = sortedKeysByMorphName()
    for _, intid in ipairs(sortedKeys) do
        local morphInfo = DruidAquaticMorphs[intid]
        player:GossipMenuAddItem(0, morphInfo.name, 0, intid)
    end
    player:GossipSendMenu(100, player, 865008)  
end


local function OnDruidMorphItemUse(event, player, item, target)
    if item:GetEntry() == 865008 then 
        if player:HasAura(1066) then  
            CreateDruidAquaticGossipMenu(player)
        else
            player:SendBroadcastMessage("You must be in Aquatic Form to use this item.")
        end
        return false  
    end
end


local function OnDruidMorphGossipSelect(event, player, item, sender, intid, code, menu_id)
    local morphInfo = DruidAquaticMorphs[intid]
    if morphInfo then
        player:SetDisplayId(morphInfo.displayId)  
        player:CastSpell(player, 51908, true)  
        player:SendBroadcastMessage("You have been morphed into " .. morphInfo.name .. "!")
    end
    player:GossipComplete()
end

RegisterItemEvent(865008, 2, OnDruidMorphItemUse)  
RegisterPlayerGossipEvent(865008, 2, OnDruidMorphGossipSelect)  







