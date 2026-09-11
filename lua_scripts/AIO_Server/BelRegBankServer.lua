local AIO = AIO or require("AIO")

-- Define the ReagentBankHandler
local ReagentBankHandler = AIO.AddHandlers("ReagentBankHandler", {})

-- Define item categories and their corresponding subclasses
local itemCategories = {
    ["All Types"] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15},  -- Including all possible subclasses
    
    -- Specific categories
    ["Cloth"] = {5},               -- Trade Goods -> Cloth
    ["Leather"] = {6},             -- Trade Goods -> Leather
    ["Metal & Stone"] = {7},       -- Trade Goods -> Metal & Stone
    ["Herbs"] = {9},               -- Trade Goods -> Herb
    ["Elemental"] = {10},          -- Trade Goods -> Elemental
    ["Jewelcrafting"] = {4},       -- Trade Goods -> Jewelcrafting
    ["Enchanting"] = {12},         -- Trade Goods -> Enchanting
    ["Parts"] = {1},               -- Trade Goods -> Parts
  -- ["Explosives"] = {2},          -- Trade Goods -> Explosives
  --  ["Devices"] = {3},             -- Trade Goods -> Devices
    ["Cooking"] = {8},             -- Trade Goods -> Cooking
    ["Materials"] = {13},          -- Trade Goods -> Materials
    ["Armor Enchantments"] = {14}, -- Trade Goods -> Armor Enchantments
    ["Weapon Enchantments"] = {15},-- Trade Goods -> Weapon Enchantments
    ["Other Trade Goods"] = {11},  -- Trade Goods -> Other

}


-- Mapping of subclass names to subclass IDs
local subclassMapping = {
    ["Trade Goods"] = 0,
    ["Parts"] = 1,
 --  ["Explosives"] = 2,
 --   ["Devices"] = 3,
    ["Jewelcrafting"] = 4,
    ["Cloth"] = 5,
    ["Leather"] = 6,
    ["Metal & Stone"] = 7,
    ["Meat"] = 8,                   -- Corrected subclass name
    ["Herb"] = 9,
    ["Elemental"] = 10,
    ["Other"] = 11,
    ["Enchanting"] = 12,
    ["Materials"] = 13,
    ["Armor Enchantment"] = 14,     -- Corrected subclass name
    ["Weapon Enchantment"] = 15,    -- Corrected subclass name
}


-- Function to check if a table contains a value
local function tContains(table, item)
    for _, value in ipairs(table) do
        if value == item then
            return true
        end
    end
    return false
end

-- Function to get reagent bank items from the character database
function ReagentBankHandler.GetReagentBankItems(player, category)
    local accountId = player:GetAccountId()
    local query = string.format("SELECT item_entry, item_subclass, amount FROM custom_reagent_bank_account WHERE account_id = %d", accountId)
    local result = CharDBQuery(query)

    if result then
        local items = {}
        repeat
            local itemEntry = result:GetUInt32(0)
            local itemSubclass = result:GetUInt32(1)
            local amount = result:GetUInt32(2)

            -- Filter items based on the selected category
            if not category or (itemCategories[category] and tContains(itemCategories[category], itemSubclass)) then
                table.insert(items, {
                    itemEntry = itemEntry,
                    itemSubclass = itemSubclass,
                    amount = amount
                })
            end
        until not result:NextRow()

        -- Send the filtered item data to the client
        AIO.Handle(player, "ReagentBankHandler", "ReceiveReagentBankItems", items)
    end
end

-- Function to handle the item withdrawal
function ReagentBankHandler.WithdrawItems(player, itemEntry, amount)
    local accountId = player:GetAccountId()

    -- Query the current amount of the item in the reagent bank
    local query = string.format("SELECT amount FROM custom_reagent_bank_account WHERE account_id = %d AND item_entry = %d", accountId, itemEntry)
    local result = CharDBQuery(query)

    if result then
        local currentAmount = result:GetUInt32(0)

        -- Check if the player has enough items to withdraw
        if currentAmount >= amount then
            -- Update the reagent bank by reducing the amount
            local newAmount = currentAmount - amount
            if newAmount > 0 then
                CharDBExecute(string.format("UPDATE custom_reagent_bank_account SET amount = %d WHERE account_id = %d AND item_entry = %d", newAmount, accountId, itemEntry))
            else
                CharDBExecute(string.format("DELETE FROM custom_reagent_bank_account WHERE account_id = %d AND item_entry = %d", accountId, itemEntry))
            end

            -- Add the items to the player's inventory
            player:AddItem(itemEntry, amount)

            -- Notify the player
            player:SendBroadcastMessage(string.format("Withdrew %d of item ID %d from your reagent bank.", amount, itemEntry))

            -- Refresh the reagent bank by sending updated data
            ReagentBankHandler.GetReagentBankItems(player)
        else
            -- Notify the player if they tried to withdraw more than they have
            player:SendBroadcastMessage("You do not have that many items in your reagent bank.")
        end
    else
        -- Notify the player if the item doesn't exist in their reagent bank
        player:SendBroadcastMessage("Item not found in your reagent bank.")
    end
end

-- Function to handle the item deposit
function ReagentBankHandler.DepositItems(player, itemID, itemSubclassName, amount, bag, slot)
    local accountId = player:GetAccountId()
    local itemEntry = itemID

    -- Convert subclass name to subclass ID
    local itemSubclass = subclassMapping[itemSubclassName]
    if not itemSubclass then
        player:SendBroadcastMessage("Error: Unrecognized item subclass " .. tostring(itemSubclassName))
        return
    end

    -- Verify the player has the items in their inventory
    local hasItem = player:GetItemCount(itemEntry)
    player:SendBroadcastMessage("Checking inventory for item ID " .. tostring(itemEntry))
    player:SendBroadcastMessage("Item count: " .. tostring(hasItem) .. " Required amount: " .. tostring(amount))
    player:SendBroadcastMessage("Item subclass ID: " .. tostring(itemSubclass))

    if hasItem and hasItem >= amount then
        -- Check if the item already exists in the reagent bank
        local query = string.format("SELECT amount FROM custom_reagent_bank_account WHERE account_id = %d AND item_entry = %d", accountId, itemEntry)
        local result = CharDBQuery(query)

        if result then
            -- Update the existing record
            local currentAmount = result:GetUInt32(0)
            local newAmount = currentAmount + amount
            player:SendBroadcastMessage("Updating existing entry for item ID " .. tostring(itemEntry) .. " with new amount " .. tostring(newAmount))
            CharDBExecute(string.format("UPDATE custom_reagent_bank_account SET amount = %d WHERE account_id = %d AND item_entry = %d", newAmount, accountId, itemEntry))
        else
            -- Insert a new record
            local insertQuery = string.format("INSERT INTO custom_reagent_bank_account (account_id, item_entry, item_subclass, amount) VALUES (%d, %d, %d, %d)", accountId, itemEntry, itemSubclass, amount)
            player:SendBroadcastMessage("Executing insert query: " .. insertQuery)
            CharDBExecute(insertQuery)
        end

        -- Remove the items from the player's inventory
        player:RemoveItem(itemEntry, amount)
        player:SendBroadcastMessage("Removed " .. tostring(amount) .. " of item ID " .. tostring(itemEntry) .. " from inventory.")

        -- Refresh the reagent bank by sending updated data
        ReagentBankHandler.GetReagentBankItems(player)
    else
        -- Notify the player if they don't have enough items
        player:SendBroadcastMessage("You do not have that many items in your inventory.")
    end
end

-- Function to handle the .rbank command
local function HandleReagentBankCommand(event, player, command)
    if command:lower() == "rbank" then
        ReagentBankHandler.GetReagentBankItems(player)
        return false -- Prevents the command from appearing in chat
    end
end

-- Register the .rbank command using event 42
RegisterPlayerEvent(42, HandleReagentBankCommand)
