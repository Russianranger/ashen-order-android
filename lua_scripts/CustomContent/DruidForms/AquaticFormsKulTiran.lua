local DruidAquaticMorphs = {
    [1] = {displayId = 600000, name = "Kul Tiran aquatic form Coral"},
    [2] = {displayId = 600001, name = "Kul Tiran aquatic form Onyx"},
    [3] = {displayId = 600002, name = "Kul Tiran aquatic form Emerald"},
    [4] = {displayId = 600003, name = "Kul Tiran aquatic form Citrine"}
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
    player:GossipSendMenu(100, player, 865007)  
end


local function OnDruidMorphItemUse(event, player, item, target)
    if item:GetEntry() == 865007 then 
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

RegisterItemEvent(865007, 2, OnDruidMorphItemUse)  
RegisterPlayerGossipEvent(865007, 2, OnDruidMorphGossipSelect)  







