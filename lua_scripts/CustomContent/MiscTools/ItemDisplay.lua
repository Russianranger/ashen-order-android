local PlayerInfo = {}

PlayerInfo.ITEM_EQUIPMENT_SLOTS = {
    [0]  = "HEAD",
    [1]  = "NECK",
    [2]  = "SHOULDERS",
    [3]  = "BODY",
    [4]  = "CHEST",
    [5]  = "WAIST",
    [6]  = "LEGS",
    [7]  = "FEET",
    [8]  = "WRISTS",
    [9]  = "HANDS",
    [10] = "FINGER1",
    [11] = "FINGER2",
    [12] = "TRINKET1",
    [13] = "TRINKET2",
    [14] = "BACK",
    [15] = "MAINHAND",
    [16] = "OFFHAND",
    [17] = "RANGED",
    [18] = "TABARD"
}

function PlayerInfo.ShowPlayerInfo(event, player, command)
    if command == "items" then
        for slot, slotName in pairs(PlayerInfo.ITEM_EQUIPMENT_SLOTS) do
            local item = player:GetEquippedItemBySlot(slot)
            if item then
                local itemId = item:GetEntry()
                local displayId = item:GetDisplayId()
                local message = "Slot " .. slotName .. " (" .. slot .. "): Item ID " .. itemId .. ", Display ID " .. displayId
                player:SendBroadcastMessage(message)
                print(message) -- Log to server console
            end
        end
        return false -- prevent command from being parsed as a normal server command
    elseif command == "race" then
        local raceId = player:GetRace()
        local raceMask = player:GetRaceMask() -- Use GetRaceMask method
        local message = "Race ID: " .. raceId .. ", Race Mask: " .. raceMask
        player:SendBroadcastMessage(message)
        print(message) -- Log to server console
        return false -- prevent command from being parsed as a normal server command
    elseif command == "class" then
        local classId = player:GetClass()
        local classMask = player:GetClassMask() -- Use GetClassMask method
        local message = "Class ID: " .. classId .. ", Class Mask: " .. classMask
        player:SendBroadcastMessage(message)
        print(message) -- Log to server console
        return false -- prevent command from being parsed as a normal server command
    end
end

RegisterPlayerEvent(42, PlayerInfo.ShowPlayerInfo)


local PlayerOutfit = {}

PlayerOutfit.ITEM_EQUIPMENT_SLOTS = {
    [0]  = "HEAD",
    [2]  = "SHOULDERS",
    [3]  = "BODY",
    [4]  = "CHEST",
    [5]  = "WAIST",
    [6]  = "LEGS",
    [7]  = "FEET",
    [8]  = "WRISTS",
    [9]  = "HANDS",
    [14] = "BACK",
    [15] = "MAIN_HAND",
    [16] = "OFF_HAND",
    [17] = "RANGED",
    [18] = "TABARD"
}

function strsplit(delimiter, text)
    local list = {}
    local pos = 1
    if string.find("", delimiter, 1) then -- this would result in endless loops
        error("delimiter matches empty string!")
    end
    while true do
        local first, last = string.find(text, delimiter, pos)
        if first then
            table.insert(list, string.sub(text, pos, first - 1))
            pos = last + 1
        else
            table.insert(list, string.sub(text, pos))
            break
        end
    end
    return list
end

function PlayerOutfit.GetPlayerAppearance(playerGuid)
    local query = string.format("SELECT race, gender, skin, face, hairStyle, hairColor, facialStyle FROM characters WHERE guid = %d", playerGuid)
    local result = CharDBQuery(query)
    if result then
        return {
            race = result:GetUInt32(0),
            gender = result:GetUInt32(1),
            skin = result:GetUInt32(2),
            face = result:GetUInt32(3),
            hair = result:GetUInt32(4),
            haircolor = result:GetUInt32(5),
            facialhair = result:GetUInt32(6)
        }
    else
        return nil
    end
end

function PlayerOutfit.GetPlayerEquipment(player)
    local equipment = {}
    for slot, slotName in pairs(PlayerOutfit.ITEM_EQUIPMENT_SLOTS) do
        local item = player:GetEquippedItemBySlot(slot)
        if item then
            equipment[slotName] = item:GetDisplayId()
        else
            equipment[slotName] = 0
        end
    end
    return equipment
end

function PlayerOutfit.EntryExists(entry)
    local query = string.format("SELECT 1 FROM `acore_world`.`creature_outfits` WHERE `entry` = %d LIMIT 1", entry)
    local result = WorldDBQuery(query)
    return result ~= nil
end

function PlayerOutfit.InsertOutfitToDB(entry, appearance, equipment, player)
    -- Check if existing outfit exists and delete it
    local checkOutfitQuery = string.format("SELECT 1 FROM `acore_world`.`creature_outfits` WHERE `entry` = %d", entry)
    local outfitResult = WorldDBQuery(checkOutfitQuery)
    if outfitResult then
        local deleteOutfitQuery = string.format("DELETE FROM `acore_world`.`creature_outfits` WHERE `entry` = %d", entry)
        WorldDBExecute(deleteOutfitQuery)
    end

    -- Insert new outfit
    local outfitQuery = string.format(
        "INSERT INTO `acore_world`.`creature_outfits` (`entry`, `race`, `gender`, `skin`, `face`, `hair`, `haircolor`, `facialhair`, `head`, `shoulders`, `body`, `chest`, `waist`, `legs`, `feet`, `wrists`, `hands`, `back`, `tabard`) " ..
        "VALUES (%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d)",
        entry, appearance.race, appearance.gender, appearance.skin, appearance.face, appearance.hair, appearance.haircolor, appearance.facialhair,
        equipment.HEAD, equipment.SHOULDERS, equipment.BODY, equipment.CHEST, equipment.WAIST,
        equipment.LEGS, equipment.FEET, equipment.WRISTS, equipment.HANDS, equipment.BACK, equipment.TABARD
    )
    WorldDBExecute(outfitQuery)

    -- Check if existing model exists and delete it
    local checkModelQuery = string.format("SELECT 1 FROM `acore_world`.`creature_template_model` WHERE `CreatureID` = %d AND `Idx` = 0", entry)
    local modelResult = WorldDBQuery(checkModelQuery)
    if modelResult then
        local deleteModelQuery = string.format("DELETE FROM `acore_world`.`creature_template_model` WHERE `CreatureID` = %d AND `Idx` = 0", entry)
        WorldDBExecute(deleteModelQuery)
    end

    -- Insert new model
    local displayId = player:GetDisplayId()
    local modelQuery = string.format(
        "INSERT INTO `acore_world`.`creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) " ..
        "VALUES (%d, 0, %d, 1, 1, 12340)",
        entry, displayId
    )
    WorldDBExecute(modelQuery)

    -- Check if existing equipment exists and delete it
    local checkEquipQuery = string.format("SELECT 1 FROM `acore_world`.`creature_equip_template` WHERE `CreatureID` = %d AND `ID` = 1", entry)
    local equipResult = WorldDBQuery(checkEquipQuery)
    if equipResult then
        local deleteEquipQuery = string.format("DELETE FROM `acore_world`.`creature_equip_template` WHERE `CreatureID` = %d AND `ID` = 1", entry)
        WorldDBExecute(deleteEquipQuery)
    end

    -- Insert new equipment
    local mainHand = player:GetEquippedItemBySlot(15)
    local offHand = player:GetEquippedItemBySlot(16)
    local ranged = player:GetEquippedItemBySlot(17)

    local equipQuery = string.format(
        "INSERT INTO `acore_world`.`creature_equip_template` (`CreatureID`, `ID`, `ItemID1`, `ItemID2`, `ItemID3`) " ..
        "VALUES (%d, 1, %d, %d, %d)",
        entry,
        mainHand and mainHand:GetEntry() or 0,
        offHand and offHand:GetEntry() or 0,
        ranged and ranged:GetEntry() or 0
    )
    WorldDBExecute(equipQuery)
end


function PlayerOutfit.CommandHandler(event, player, command)
    local commandParts = strsplit(" ", command)
    if commandParts[1] ~= "outfit" then
        return false
    end

    local npcId = tonumber(commandParts[2])
    if not npcId then
        player:SendBroadcastMessage("Invalid NPC ID.")
        return false
    end

    local playerGuid = player:GetGUIDLow()
    local appearance = PlayerOutfit.GetPlayerAppearance(playerGuid)
    if not appearance then
        player:SendBroadcastMessage("Failed to retrieve player appearance from database.")
        return false
    end

    local equipment = PlayerOutfit.GetPlayerEquipment(player)

    PlayerOutfit.InsertOutfitToDB(npcId, appearance, equipment, player)
    player:SendBroadcastMessage(string.format("Outfit for NPC ID %d has been inserted into the database.", npcId))

    return false
end

RegisterPlayerEvent(42, PlayerOutfit.CommandHandler)

