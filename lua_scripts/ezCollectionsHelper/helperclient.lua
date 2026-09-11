local AIO = AIO or require("AIO")
if AIO.AddAddon() then return end

local _, MyAddon = ...

-- Localization strings (dummy localization for demonstration purposes)
local L = {
    ["Tooltip.UnlockSkin.Binding"] = "Press %s to unlock skin.",
    ["Tooltip.UnlockSkin.Binding.Separator"] = " or ",
    ["Tooltip.UnlockSkin.Command"] = "Type /ezc unlock to unlock skin."
}

-- Function to check if an item is collectible (dummy logic)
local function IsTooltipItemCollectible(tooltip)
    print("Checking if tooltip item is collectible")
    return true
end

-- Function to check if an item is collected (dummy logic)
local function IsItemCollected(itemID)
    -- Replace this with actual logic to check if the item is collected
    return ezCollections:HasSkin(itemID)
end

-- Function to update the tooltip with collected status
local function UpdateTooltipWithCollectedStatus(tooltip, itemID)
    local isCollected = IsItemCollected(itemID)
    local icon = isCollected and "Interface\\RAIDFRAME\\ReadyCheck-Ready" or "Interface\\RAIDFRAME\\ReadyCheck-NotReady"
    local size = ezCollections.Config.TooltipTransmog.IconEntry.Size
    local line = format("|T%s:%d|t", icon, size)
    tooltip:AddLine(line)
    tooltip:Show()
end

-- Function to handle collectible logic
local function HandleCollectible(itemID, itemLink, slot)
    if not ezCollections:HasSkin(itemID) then
        print("Item is collectible and not yet collected.")
        local tooltip = CreateFrame("GameTooltip", "ItemTooltip", UIParent, "GameTooltipTemplate")
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:SetHyperlink(itemLink)
        
        local isCollectible = IsTooltipItemCollectible(tooltip)
        print("Is item collectible? ", isCollectible)
        if isCollectible then
            local color = ezCollections.Config.TooltipCollection.Color
            local text
            if GetBindingKey("EZCOLLECTIONS_UNLOCK_SKIN") then
                text = format(L["Tooltip.UnlockSkin.Binding"], table.concat({ GetBindingKey("EZCOLLECTIONS_UNLOCK_SKIN") }, L["Tooltip.UnlockSkin.Binding.Separator"]))
            else
                text = format(L["Tooltip.UnlockSkin.Command"], ezCollections.UnlockSkinHintCommand)
            end
            tooltip:AddLine(text, color.r * 0.75, color.g * 0.75, color.b * 0.75, false)
            
            ezCollections.itemUnderCursor.ID = itemID
            ezCollections.itemUnderCursor.Bag = nil
            ezCollections.itemUnderCursor.Slot = slot
            
            print("Unlocking skin for item ID:", itemID)
            ezCollections:UnlockSkinUnderCursor()
            
            -- Send addon message to unlock skin
            print("Sending addon message to unlock skin.")
            ezCollections:SendAddonMessage("UNLOCKSKIN:" .. itemID)
            
            -- Refresh UI and other necessary actions
            print("Refreshing UI.")
            if ezCollections.Callbacks.AddSkin then
                print("Calling AddSkin callback.")
                ezCollections.Callbacks.AddSkin(itemID)
            else
                print("AddSkin callback not found, using fallback.")
                -- Fallback if AddSkin callback is not available
                pcall(function()
                    ezCollections:WipeSearchResults()
                    C_TransmogCollection.WipeAppearanceCache()
                    C_TransmogSets.ReportSetSourceCollectedChanged()
                    C_Transmog.ValidateAllPending(true)
                    ezCollections:RaiseEvent("TRANSMOG_COLLECTION_UPDATED")
                    ezCollections.IconOverlays:Update()
                end)
            end
            
            -- Update the tooltip to reflect the unlocked skin
            print("Updating tooltip to reflect the unlocked skin.")
            UpdateTooltipWithCollectedStatus(tooltip, itemID)
        else
            print("Item is not collectible according to the tooltip.")
            tooltip:Hide()
        end
    else
        print("Item is either not collectible or already collected.")
    end
end

-- Event handler for equipment changes
local function OnEquipmentChanged(event, slot, hasCurrent)
    --print("OnEquipmentChanged called with event:", event, "slot:", tostring(slot), "hasCurrent:", tostring(hasCurrent))
    
    -- Ensure slot is a number
    slot = tonumber(slot)
    hasCurrent = tonumber(hasCurrent)
    
    if not slot then
     --   print("Invalid slot: slot is nil or not a number")
        return
    end
    
    if hasCurrent == nil then
    --    print("Invalid hasCurrent: hasCurrent is nil or not a number")
        return
    end
    
    local itemID = GetInventoryItemID("player", slot)
    if itemID then
      --  print("Item equipped: slot:", slot, "ID:", itemID)
        local itemName, itemLink = GetItemInfo(itemID)
        if itemName then
        --    print("Retrieved item info for:", itemName)
            HandleCollectible(itemID, itemLink, slot)
        else
        --    print("Failed to retrieve item info for item ID:", itemID)
        end
    else
      --  print("No item found in slot:", slot)
    end
end

-- Event handler for loot
local function OnLootReady(event)
    print("Loot ready event triggered")
    for i = 1, GetNumLootItems() do
        local itemLink = GetLootSlotLink(i)
        if itemLink then
            local itemName, _, _, _, _, _, _, _, _, _, itemID = GetItemInfo(itemLink)
            if itemName then
               -- print("Looted item: ID:", itemID, "Name:", itemName)
                local bindType = select(14, GetItemInfo(itemID))
                if bindType == 1 then -- BoP item
                    HandleCollectible(itemID, itemLink, nil)
                end
            end
        end
    end
end

-- Frame for event handling
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
frame:RegisterEvent("LOOT_READY")
frame:SetScript("OnEvent", function(_, event, arg1, arg2)
   -- print("Event parameters:", "event:", event, "arg1:", arg1, "arg2:", arg2)
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        OnEquipmentChanged(event, arg1, arg2)
    elseif event == "LOOT_READY" then
        OnLootReady(event)
    end
end)

print("Events registered for PLAYER_EQUIPMENT_CHANGED and LOOT_READY.")