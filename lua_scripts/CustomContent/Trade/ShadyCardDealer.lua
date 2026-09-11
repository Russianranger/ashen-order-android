local DarkmoonDealer = {}

local ENABLED = true -- Set to false to disable the entire script
local PRICE_IN_GOLD = 125 -- Price in gold for each card

if not ENABLED then return end

local questItemMapping = {
    {itemID = 19288, label = "Darkmoon Card: Blue Dragon"},
    {itemID = 19289, label = "Darkmoon Card: Maelstrom"},
    {itemID = 19290, label = "Darkmoon Card: Twisting Nether"},
    {itemID = 42989, label = "Darkmoon Card: Berserker!"},
    {itemID = 31856, label = "Darkmoon Card: Crusade"},
    {itemID = 42990, label = "Darkmoon Card: Death"},
    {itemID = 42987, label = "Darkmoon Card: Greatness Str"}, --finish
    {itemID = 44255, label = "Darkmoon Card: Greatness Int"}, --finish
    {itemID = 44253, label = "Darkmoon Card: Greatness Agi"}, --finish
    {itemID = 44254, label = "Darkmoon Card: Greatness Spir"}, --finish
    {itemID = 19287, label = "Darkmoon Card: Heroism"},
    {itemID = 42988, label = "Darkmoon Card: Illusion"},
    {itemID = 31859, label = "Darkmoon Card: Madness"},
    {itemID = 31858, label = "Darkmoon Card: Vengeance"},
    {itemID = 31857, label = "Darkmoon Card: Wrath"},
}

function DarkmoonDealer.OnGossipHello(event, player, object)
    player:GossipClearMenu()

    for intid, info in ipairs(questItemMapping) do
        if player:HasItem(info.itemID) then
            player:GossipMenuAddItem(0, info.label, 0, intid)
        end
    end

    player:GossipSendMenu(1, object, 0)
    player:SendBroadcastMessage("|cffa335eeRazzle Dealtwister: Hey there, friend! I can dupe your cards for ya...for a price, hehehe.|r")
end

function DarkmoonDealer.OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    local info = questItemMapping[intid]
    local popupMessage = "Ya really want to duplicate " .. info.label .. " for " .. PRICE_IN_GOLD .. " gold?"
    player:GossipMenuAddItem(0, "Confirm Purchase", 0, intid + 10000, false, popupMessage, PRICE_IN_GOLD * 10000)
    player:GossipSendMenu(1, object, 0)
end

function DarkmoonDealer.OnGossipSelectConfirm(event, player, object, sender, intid, code, menu_id)
    local FEE_IN_COPPER = PRICE_IN_GOLD * 10000

    if intid < 10001 then return end -- Not a confirmation selection

    if player:GetCoinage() < FEE_IN_COPPER then
        player:SendBroadcastMessage("|cffa335eeRazzle Dealtwister: Looks like you're a bit short on gold, friend!|r")
        return
    end

    local info = questItemMapping[intid - 10000]
    local item = player:AddItem(info.itemID)
    if item then
        player:ModifyMoney(-FEE_IN_COPPER)
        player:SendBroadcastMessage("|cffa335eeRazzle Dealtwister: Here's your Darkmoon Card. Pleasure doin' business with ya!|r")
        player:SendBroadcastMessage("You bought " .. info.label .. " for " .. PRICE_IN_GOLD .. " gold.") -- Broadcast message
    else
        player:SendBroadcastMessage("|cffa335eeRazzle Dealtwister: Oops! Somethin' went wrong. Try again later, buddy.|r")
    end

    player:GossipComplete()
end

RegisterCreatureGossipEvent(180108, 1, DarkmoonDealer.OnGossipHello)
RegisterCreatureGossipEvent(180108, 2, DarkmoonDealer.OnGossipSelect)
RegisterCreatureGossipEvent(180108, 2, DarkmoonDealer.OnGossipSelectConfirm)