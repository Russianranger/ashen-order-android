local EVENT_ONGOSSIPHELLO       = 1
local EVENT_ONGOSSIPSELECT      = 2

local NPC_MULTIVENDOR = 500147
local VENDOR_ID1     = 500111
local VENDOR_ID2     = 500046
local VENDOR_ID3     = 500057
local VENDOR_ID4     = 500068
local VENDOR_ID5     = 500110
local VENDOR_ID6     = 500026
local VENDOR_ID7     = 500027
local VENDOR_ID8     = 500095
local VENDOR_ID9     = 500097
local VENDOR_ID10    = 500113
local VENDOR_ID11    = 500148
--[[local VENDOR_ID12    = 500149
local VENDOR_ID13    = 500057
local VENDOR_ID14    = 500058
local VENDOR_ID15    = 500059]]--



local function MultiVendorOnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(1, "Warrior Glyphs", 1, 1)
    player:GossipMenuAddItem(1, "Hunter Glyphs", 1, 2)
    player:GossipMenuAddItem(1, "Mage Glyphs", 1, 3)
    player:GossipMenuAddItem(1, "Paladin Glyphs", 1, 4)
    player:GossipMenuAddItem(1, "Warlock Glyphs", 1, 5)
    player:GossipMenuAddItem(1, "Death Knight Glyphs", 1, 6)
    player:GossipMenuAddItem(1, "Druid Glyphs", 1, 7)
    player:GossipMenuAddItem(1, "Rogue Glyphs", 1, 8)
    player:GossipMenuAddItem(1, "Shaman Glyphs", 1, 9)
    player:GossipMenuAddItem(1, "Priest Glyphs", 1, 10)
    player:GossipMenuAddItem(1, "Enchantments", 1, 11)
   --[[ player:GossipMenuAddItem(1, "Blacksmithing Enchantmenss", 1, 12)
    player:GossipMenuAddItem(1, "Tailoring Enchantments", 1, 13)
    player:GossipMenuAddItem(1, "Leatherworking Enchantments", 1, 14)
    player:GossipMenuAddItem(1, "Engineering Enchantments", 1, 15)]]--

    player:GossipMenuAddItem(1, "Close", 1, 100)
    player:GossipSendMenu(1, creature, 1)
end

local function MultiVendorOnGossipSelect(event, player, creature, sender, intid, code, menu_id)
    if (intid == 1) then
        player:SendListInventory(creature, VENDOR_ID1)
    elseif (intid == 2) then
        player:SendListInventory(creature, VENDOR_ID2)
    elseif (intid == 3) then
        player:SendListInventory(creature, VENDOR_ID3)
    elseif (intid == 4) then
        player:SendListInventory(creature, VENDOR_ID4)
    elseif (intid == 5) then
        player:SendListInventory(creature, VENDOR_ID5)
    elseif (intid == 6) then
        player:SendListInventory(creature, VENDOR_ID6)
    elseif (intid == 7) then
        player:SendListInventory(creature, VENDOR_ID7)
    elseif (intid == 8) then
        player:SendListInventory(creature, VENDOR_ID8)
    elseif (intid == 9) then
        player:SendListInventory(creature, VENDOR_ID9)
    elseif (intid == 10) then
        player:SendListInventory(creature, VENDOR_ID10)
    elseif (intid == 11) then
        player:SendListInventory(creature, VENDOR_ID11)
    elseif (intid == 12) then
        player:SendListInventory(creature, VENDOR_ID12)
    elseif (intid == 13) then
        player:SendListInventory(creature, VENDOR_ID13)
    elseif (intid == 14) then
        player:SendListInventory(creature, VENDOR_ID14)
    elseif (intid == 15) then
        player:SendListInventory(creature, VENDOR_ID15)
    elseif (intid == 16) then
        player:SendListInventory(creature, VENDOR_ID16)
    elseif (intid == 100) then
        player:GossipComplete()
    end
end


RegisterCreatureGossipEvent(NPC_MULTIVENDOR, EVENT_ONGOSSIPHELLO, MultiVendorOnGossipHello)
RegisterCreatureGossipEvent(NPC_MULTIVENDOR, EVENT_ONGOSSIPSELECT, MultiVendorOnGossipSelect)