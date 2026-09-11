local AIO = AIO or require("AIO")

if AIO.AddAddon() then return end -- Ensure this script runs only on the client

local ReagentBankHandler = AIO.AddHandlers("ReagentBankHandler", {})

local currentItems = {}
local itemFrames = {}
local pendingItemInfos = {}

-- Categories and their corresponding subclasses
local categories = {
    {name = "All Types", subclasses = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}},  -- Includes all subclasses
    {name = "Cloth", subclasses = {5}},               -- Trade Goods -> Cloth
    {name = "Leather", subclasses = {6}},             -- Trade Goods -> Leather
    {name = "Metal & Stone", subclasses = {7}},       -- Trade Goods -> Metal & Stone
    {name = "Herbs", subclasses = {9}},               -- Trade Goods -> Herb
    {name = "Elemental", subclasses = {10}},          -- Trade Goods -> Elemental
    {name = "Jewelcrafting", subclasses = {4}},       -- Trade Goods -> Jewelcrafting
    {name = "Enchanting", subclasses = {12}},         -- Trade Goods -> Enchanting
    {name = "Parts", subclasses = {1}},               -- Trade Goods -> Parts
 --   {name = "Explosives", subclasses = {2}},          -- Trade Goods -> Explosives
 --   {name = "Devices", subclasses = {3}},             -- Trade Goods -> Devices
    {name = "Cooking", subclasses = {8}},             -- Trade Goods -> Cooking
    {name = "Materials", subclasses = {13}},          -- Trade Goods -> Materials
    {name = "Armor Enchantments", subclasses = {14}}, -- Trade Goods -> Armor Enchantments
    {name = "Weapon Enchantments", subclasses = {15}},-- Trade Goods -> Weapon Enchantments
    {name = "Other Trade Goods", subclasses = {11}},  -- Trade Goods -> Other

}


-- Subclasses that are considered reagents (adjust based on your needs)
-- Subclasses that are considered reagents
local reagentSubclasses = {
    ["Cloth"] = true,
    ["Leather"] = true,
    ["Metal & Stone"] = true,
    ["Herb"] = true,
    ["Elemental"] = true,
    ["Jewelcrafting"] = true,
    ["Enchanting"] = true,
    ["Parts"] = true,
 --   ["Explosives"] = true,
 --   ["Devices"] = true,
    ["Meat"] = true,                -- Corrected subclass name
    ["Materials"] = true,
    ["Armor Enchantment"] = true,   -- Corrected subclass name
    ["Weapon Enchantment"] = true,  -- Corrected subclass name
    ["Other"] = true,
}

local function AddCategoryButtons(frame)
    local buttonHeight = 20
    local buttonSpacing = 5

    for i, category in ipairs(categories) do
        local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        btn:SetSize(120, buttonHeight)
        btn:SetText(category.name)
        btn:SetPoint("TOPLEFT", -120, -((i - 1) * (buttonHeight + buttonSpacing)))
        btn:SetScript("OnClick", function()
            -- Send the selected category to the server to filter items
            AIO.Handle("ReagentBankHandler", "GetReagentBankItems", category.name)
        end)
    end
end

local function CreateReagentBankFrame()
    -- Check if the frame already exists
    if _G["ReagentBankFrame"] then
        return _G["ReagentBankFrame"]
    end

    -- Create the main frame manually
    local frame = CreateFrame("Frame", "ReagentBankFrame", UIParent)
    frame:SetSize(400, 600)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 1)

    -- Create a title for the frame
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("CENTER", frame, "TOP", 0, -20)
    title:SetText("Reagent Bank")

    -- Create a close button for the frame
    local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    closeButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    -- Create a scroll frame
    local scrollFrame = CreateFrame("ScrollFrame", "ReagentBankScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -40)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

    -- Create the content frame
    local content = CreateFrame("Frame", "ReagentBankContent", scrollFrame)
    content:SetSize(350, 500)
    scrollFrame:SetScrollChild(content)

    -- Add category buttons
    AddCategoryButtons(frame)

    -- Add deposit button
    local depositButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    depositButton:SetSize(100, 30)
    depositButton:SetText("Deposit Items")
    depositButton:SetPoint("BOTTOM", frame, "BOTTOM", 0, -25)
    depositButton:SetScript("OnClick", function()
        OpenDepositInputBox()
    end)

    return frame
end

local function UpdateReagentBankItems(items)
    local frame = CreateReagentBankFrame()

    -- Store the current items for later use
    currentItems = items
    itemFrames = {}  -- Reset item frames table
    pendingItemInfos = {}  -- Reset pending item info table

    -- Clear the existing content by hiding or removing all child frames
    local content = _G["ReagentBankContent"]
    for _, child in ipairs({ content:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Prefetch item info for all items and track pending items
    for _, item in ipairs(items) do
        local itemName = GetItemInfo(item.itemEntry)
        if not itemName then
            -- Force client to query item data
            local queryLink = "item:" .. item.itemEntry
            GameTooltip:SetHyperlink(queryLink)
            GameTooltip:Hide()
            pendingItemInfos[item.itemEntry] = true  -- Mark as pending
        end
    end

    -- Layout settings
    local numColumns = 7
    local buttonSize = 40
    local spacing = 5
    local row, col = 0, 0

    -- Calculate total rows needed
    local totalItems = #items
    local totalRows = math.ceil(totalItems / numColumns)

    -- Adjust content frame size based on total rows
    local contentWidth = 10 + numColumns * (buttonSize + spacing)
    local contentHeight = 10 + totalRows * (buttonSize + spacing)
    content:SetSize(contentWidth, contentHeight)

    -- Function to create the item button
    local function CreateItemButton(item, parent, row, col)
        local itemFrame = CreateFrame("Button", nil, parent)
        itemFrame:SetSize(buttonSize, buttonSize)
        itemFrame:SetPoint("TOPLEFT", 10 + col * (buttonSize + spacing), -10 - row * (buttonSize + spacing))

        -- Store the item frame in the itemFrames table
        itemFrames[item.itemEntry] = itemFrame

        -- Create the item icon
        local itemIcon = itemFrame:CreateTexture(nil, "ARTWORK")
        itemIcon:SetAllPoints()

        local itemTexture = select(10, GetItemInfo(item.itemEntry))
        if itemTexture then
            itemIcon:SetTexture(itemTexture)
            pendingItemInfos[item.itemEntry] = nil  -- Remove from pending if already available
        else
            itemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        -- Store the itemIcon in the itemFrame for later updates
        itemFrame.itemIcon = itemIcon

        -- Create the item count text
        local itemCount = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        itemCount:SetPoint("BOTTOMRIGHT", itemFrame, "BOTTOMRIGHT", -2, 2)
        itemCount:SetText(item.amount)

        -- Tooltip for item on mouseover
        itemFrame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink("item:" .. item.itemEntry)
            GameTooltip:Show()
        end)
        itemFrame:SetScript("OnLeave", function(self)
            GameTooltip:Hide()
        end)

        -- OnClick event to open the input box for withdrawal
        itemFrame:SetScript("OnClick", function()
            OpenWithdrawInputBox(item.itemEntry, item.amount)
        end)
    end

    -- Add item buttons to the content frame
    for i, item in ipairs(items) do
        CreateItemButton(item, content, row, col)

        -- Update row and column for next item
        col = col + 1
        if col >= numColumns then
            col = 0
            row = row + 1
        end
    end

    -- Ensure the frame is shown
    frame:Show()
end

local itemInfoReceivedFrame = CreateFrame("Frame")
itemInfoReceivedFrame:RegisterEvent("GET_ITEM_INFO_RECEIVED")

local function CheckPendingItems()
    for _ in pairs(pendingItemInfos) do
        return false  
    end
    return true  
end

itemInfoReceivedFrame:SetScript("OnEvent", function(self, event, itemID, success)
    if success and pendingItemInfos[itemID] then
        pendingItemInfos[itemID] = nil

        local itemFrame = itemFrames[itemID]
        if itemFrame then
            local itemIcon = itemFrame.itemIcon
            local itemTexture = select(10, GetItemInfo(itemID))
            if itemTexture then
                itemIcon:SetTexture(itemTexture)
            end
        end

        if CheckPendingItems() then
            UpdateReagentBankItems(currentItems)
        end
    end
end)

-- Handler for receiving reagent bank items
function ReagentBankHandler.ReceiveReagentBankItems(player, items)
    UpdateReagentBankItems(items)
end

-- Function to open an input box for item withdrawal
function OpenWithdrawInputBox(itemEntry, maxAmount)
    -- Create the input frame manually
	local parentFrame = _G["ReagentBankFrame"]
    local inputFrame = CreateFrame("Frame", "WithdrawInputFrame", UIParent)
    inputFrame:SetSize(200, 100)
    inputFrame:SetPoint("TOPRIGHT", parentFrame, "TOPRIGHT", 200, 0)
    inputFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    inputFrame:SetBackdropColor(0, 0, 0, 1)

    -- Create a title for the input frame
    local title = inputFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Withdraw Items")

    -- Create the input box
    local inputBox = CreateFrame("EditBox", nil, inputFrame, "InputBoxTemplate")
    inputBox:SetSize(100, 20)
    inputBox:SetPoint("CENTER", 0, 0)
    inputBox:SetNumeric(true)
    inputBox:SetMaxLetters(5)
    inputBox:SetText(maxAmount)

    -- Create a confirm button
    local confirmButton = CreateFrame("Button", nil, inputFrame, "GameMenuButtonTemplate")
    confirmButton:SetSize(80, 20)
    confirmButton:SetPoint("BOTTOMLEFT", 10, 10)
    confirmButton:SetText("Confirm")
    confirmButton:SetScript("OnClick", function()
        local amount = tonumber(inputBox:GetText())
        if amount and amount > 0 and amount <= maxAmount then
            -- Call the function to handle withdrawal
            WithdrawItems(itemEntry, amount)
            inputFrame:Hide()
        else
            print("Invalid amount entered.")
        end
    end)

    -- Create a cancel button
    local cancelButton = CreateFrame("Button", nil, inputFrame, "GameMenuButtonTemplate")
    cancelButton:SetSize(80, 20)
    cancelButton:SetPoint("BOTTOMRIGHT", -10, 10)
    cancelButton:SetText("Cancel")
    cancelButton:SetScript("OnClick", function()
        inputFrame:Hide()
    end)
end

-- Function to open an input box for item deposit
function OpenDepositInputBox()
    -- Create a list of all items in the player's inventory that can be deposited
    local items = {}

    for bag = 0, 4 do  -- Including backpack and bags
        for slot = 1, GetContainerNumSlots(bag) do
            local itemID = GetContainerItemID(bag, slot)
            if itemID then
                local itemName, _, _, _, _, itemClass, itemSubclass, _, _, itemTexture = GetItemInfo(itemID)
                local _, itemCount = GetContainerItemInfo(bag, slot)

                -- Debugging output with item info
               -- print(string.format("ItemID: %d, ItemName: %s, Class: %s, Subclass: %s", itemID or 0, itemName or "Unknown", itemClass or "Unknown", itemSubclass or "Unknown"))

                -- Adjusting the logic to handle text-based itemClass and itemSubclass
                if itemClass == "Trade Goods" or itemClass == "Miscellaneous" then
                    if reagentSubclasses[itemSubclass] then
                      --  print("Item is a reagent: " .. (itemName or "Unknown"))
                        table.insert(items, {
                            itemID = itemID,
                            itemName = itemName,
                            itemTexture = itemTexture,
                            itemCount = itemCount,
                            itemSubclass = itemSubclass,  -- Include subclass
                            bag = bag,
                            slot = slot
                        })
                    else
                       -- print("Item is not a reagent: " .. (itemName or "Unknown"))
                    end
                else
                   -- print("Item does not belong to Trade Goods or Miscellaneous class: " .. (itemName or "Unknown"))
                end
            end
        end
    end

    -- If no items were found, notify the player
    if #items == 0 then
        print("No items found that can be deposited.")
    end

    -- Create the input frame manually and attach it to the top-right corner of the Reagent Bank frame
    local parentFrame = _G["ReagentBankFrame"]
    local inputFrame = CreateFrame("Frame", "DepositInputFrame", UIParent)
    inputFrame:SetSize(300, 400)
    inputFrame:SetPoint("TOPRIGHT", parentFrame, "TOPRIGHT", 300, 0)  -- Attach to the top-right corner of Reagent Bank frame
    inputFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    inputFrame:SetBackdropColor(0, 0, 0, 1)

    -- Create a title for the input frame
    local title = inputFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Deposit Items")

    -- Create a scroll frame for the items
    local scrollFrame = CreateFrame("ScrollFrame", "DepositScrollFrame", inputFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 10, -40)
    scrollFrame:SetPoint("BOTTOMRIGHT", -30, 50)

    -- Create the content frame
    local content = CreateFrame("Frame", "DepositContent", scrollFrame)
    content:SetSize(260, 300)
    scrollFrame:SetScrollChild(content)

    -- Add buttons for each item in the inventory
    local buttonHeight = 40
    for i, item in ipairs(items) do
        local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
        btn:SetSize(240, buttonHeight)
        btn:SetText(item.itemName .. " x" .. item.itemCount)
        btn:SetPoint("TOP", content, "TOP", 0, -((i - 1) * buttonHeight))
        btn:SetScript("OnClick", function()
            OpenDepositAmountInputBox(item)
            inputFrame:Hide()
        end)

        local icon = btn:CreateTexture(nil, "ARTWORK")
        icon:SetSize(30, 30)
        icon:SetPoint("LEFT", btn, "LEFT", 5, 0)
        icon:SetTexture(item.itemTexture)
    end

    -- Create a "Deposit All" button to deposit all items at once
    local depositAllButton = CreateFrame("Button", nil, inputFrame, "UIPanelButtonTemplate")
    depositAllButton:SetSize(100, 30)
    depositAllButton:SetText("Deposit All")
    depositAllButton:SetPoint("BOTTOM", inputFrame, "BOTTOM", 0, 10)
    depositAllButton:SetScript("OnClick", function()
        for _, item in ipairs(items) do
            DepositItems(item, item.itemCount)
        end
        inputFrame:Hide()
    end)

    -- Create a close button for the deposit frame
    local closeButton = CreateFrame("Button", nil, inputFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", inputFrame, "TOPRIGHT")
    closeButton:SetScript("OnClick", function()
        inputFrame:Hide()
    end)

    inputFrame:Show()
end

-- Function to open an input box for specifying deposit amount
function OpenDepositAmountInputBox(item)
    -- Ensure the main frame exists and is referenced correctly
    local parentFrame = _G["ReagentBankFrame"]
    if not parentFrame then
        print("Reagent Bank frame not found!")
        return
    end

    -- Create the input frame manually and attach it to the top-right corner of the Reagent Bank frame
    local inputFrame = CreateFrame("Frame", "DepositAmountInputFrame", UIParent)
    inputFrame:SetSize(200, 100)
    inputFrame:SetPoint("TOPRIGHT", parentFrame, "TOPRIGHT", 200, 0)  -- Attach to the top-right corner of the Reagent Bank frame
    inputFrame:SetFrameStrata("DIALOG")  -- Ensure the frame appears above others
    inputFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    inputFrame:SetBackdropColor(0, 0, 0, 1)

    -- Create a title for the input frame
    local title = inputFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    title:SetPoint("TOP", 0, -10)
    title:SetText("Deposit Amount")

    -- Create the input box
    local inputBox = CreateFrame("EditBox", nil, inputFrame, "InputBoxTemplate")
    inputBox:SetSize(100, 20)
    inputBox:SetPoint("CENTER", 0, 0)
    inputBox:SetNumeric(true)
    inputBox:SetMaxLetters(5)
    inputBox:SetText(item.itemCount)

    -- Create a confirm button
    local confirmButton = CreateFrame("Button", nil, inputFrame, "GameMenuButtonTemplate")
    confirmButton:SetSize(80, 20)
    confirmButton:SetPoint("BOTTOMLEFT", 10, 10)
    confirmButton:SetText("Confirm")
    confirmButton:SetScript("OnClick", function()
        local amount = tonumber(inputBox:GetText())
        if amount and amount > 0 and amount <= item.itemCount then
            -- Call the function to handle the deposit
            DepositItems(item, amount)
            inputFrame:Hide()
        else
            print("Invalid amount entered.")
        end
    end)

    -- Create a cancel button
    local cancelButton = CreateFrame("Button", nil, inputFrame, "GameMenuButtonTemplate")
    cancelButton:SetSize(80, 20)
    cancelButton:SetPoint("BOTTOMRIGHT", -10, 10)
    cancelButton:SetText("Cancel")
    cancelButton:SetScript("OnClick", function()
        inputFrame:Hide()
    end)

    inputFrame:Show()
end


-- Function to handle the deposit logic
function DepositItems(item, amount)
    -- Send the subclass along with itemID and amount
    AIO.Handle("ReagentBankHandler", "DepositItems", item.itemID, item.itemSubclass, amount, item.bag, item.slot)

    -- Poll the server again to refresh items
    C_Timer.After(0.5, function()
        AIO.Handle("ReagentBankHandler", "GetReagentBankItems")
    end)
end

-- Function to handle the withdrawal logic
function WithdrawItems(itemEntry, amount)
    AIO.Handle("ReagentBankHandler", "WithdrawItems", itemEntry, amount)
    
    -- Poll the server again to refresh items
    C_Timer.After(0.5, function()
        AIO.Handle("ReagentBankHandler", "GetReagentBankItems")
    end)
end
