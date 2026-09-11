--[[
Name: Menus Menu
Version: 1.5.1
Made by: MadBuffoon
Notes: Opens the a menu for other menus from a item.

]]

local TP_Menu_Enabled = false -- set to true to enable the teleport menu again. I removed this as default due to mage bot changes

local enabled = true
local DinkleStoneOneGossipID = 9900000
local Binding_Menu = true
local Party_Summon_Menu = true
local TP_Menu = true
local Other = true
local ItemEntry = 65000 -- DinkleStoneOne. You can change this item ID to whatever as long as it has a spell. Please see items to remove if you're not using my server,

local CHALLENGE_ITEMS = {
    90000, -- HARDCORE_ITEM
    800048, -- SLOW_AND_STEADY_ITEM
    800051, -- PACIFIST_ITEM
    800084, -- DIET_ITEM
    800085, -- NOMAD_ITEM
    800086, -- TAXATION_WITHOUT_REPRESENTATION_ITEM
    800049, -- IRONMAN_ITEM
    800050  -- RANDOMY_ATTACKED_ITEM
}

local CHALLENGE_AURAS = {
    80089 -- FRAGILE_WARRIOR_SPELL
}

-- Do not change or remove
local Gold = 10000
local GuidN = 0

--(Start) Pulles for the guid for the player
local function getPlayerCharacterGUID(player)
    local query = CharDBQuery(string.format("SELECT guid FROM characters WHERE name='%s'", player:GetName()))

    if query then 
      local row = query:GetRow()

      return tonumber(row["guid"])
    end

    return nil
  end
  
  local function PlayerHasChallenge(player)
    for _, itemId in pairs(CHALLENGE_ITEMS) do
        if player:HasItem(itemId) then
            return true
        end
    end
    for _, spellId in pairs(CHALLENGE_AURAS) do
        if player:HasAura(spellId) then
            return true
        end
    end
    return false
end
--(End)

--(Start) The Gossip Menu that shows Main Menu
function DinkleStoneOneMenuMenusGossip(event, player)
    -- First, check if the player has any challenge conditions or is in combat
    if player:IsInCombat() then
        player:SendBroadcastMessage("You cannot use this item while in combat.")
        return
    elseif PlayerHasChallenge(player) then
        player:SendBroadcastMessage("You cannot use this item while participating in a challenge mode.")
        return
    end

    -- If no challenges are present, proceed with showing the menu
    GuidN = getPlayerCharacterGUID(player)
    Gossipintid_Use = 1100
    Gossipintid_Delete = 11000
    player:GossipClearMenu()
    if Binding_Menu then
        player:GossipMenuAddItem(3, "|TInterface\\Icons\\Ability_spy:45:45:-40|t Bind Menu (Save Location)", 0, 10)
    end
    if Party_Summon_Menu then
        player:GossipMenuAddItem(3, "|TInterface\\Icons\\Spell_shadow_demoniccirclesummon:45:45:-40|t Summon Party Menu", 0, 20)
    end
    if TP_Menu and TP_Menu_Enabled then
        player:GossipMenuAddItem(3, "|TInterface\\Icons\\Spell_arcane_portaldalaran:45:45:-40|t Teleport Menu", 0, 25)  
    end
    if Other then
        player:GossipMenuAddItem(3, "|TInterface\\Icons\\Mail_gmicon:45:45:-40|t Other", 0, 90)
    end
    player:GossipMenuAddItem(4, "|TInterface\\Icons\\achievement_bg_hld4bases_eos:45:45:-40|t [Exit Menu]", 0, 99)
    if (player:GetGMRank() >= 3) then
        player:GossipMenuAddItem(3, "|TInterface\\Icons\\Mail_gmicon:45:45:-40|t GM Menu", 0, 95)
    end
    player:GossipSendMenu(1, player, DinkleStoneOneGossipID)  
end
--(End)


--(Start)
local function DinkleStoneOneOnSelect(event, player, _, sender, intid, code)	
	local x = player:GetX()
	local y = player:GetY()
	local z = player:GetZ()
	local o = player:GetO()
	local map = player:GetMap()
	local mapID = map:GetMapId()
	local areaId = map:GetAreaId( x, y, z )
	
	if(intid == 1) then --Use HearthStone	
		player:ResetSpellCooldown( 8690, true )
		player:CastSpell(player, 8690, false)
		player:GossipComplete()
	end	
	if(intid == 10) then --Bind Menu
		BindMenuGossip(event, player)
	end	
	if(intid == 20) then --Summon Menu
		PartyTPMenuGossip(event, player)
	end	
	if(intid== 25) then -- Pocket Portal 		
		TP_MenuMenuGossip(event, player)
	end	
	if(intid == 90) then --Other Menu
		OtherMenuGossip(event, player)
	end		
	if(intid == 95) then --GM Menu
		GMSettingsMenuGossip(event, player)
	end
	if(intid == 9999) then --Back
		DinkleStoneOneMenuMenusGossip(event, player)
		return false
	end
	if(intid == 99) then --Close
		player:SendAreaTriggerMessage("Good Bye!")
		player:GossipComplete()
	end
end
--(End)


--(Start) Part of start up.
local function BootMSG(eventid, delay, repeats, player)
   -- player:SendBroadcastMessage("|cff3399FFYou can open a bind menu by typing |cff00cc00 ."..commandline1.." |cff3399FF in chat.")
end
local firstlogin = false
local function DinkleStoneOneOnFirstLogin(event, player)
	if event == 30 then
	firstlogin = true
	end
	
	player:RegisterEvent(BootMSG, 60000, 1, player)
end
local function DinkleStoneOneOnLogin(event, player)
	if not firstlogin then
	player:RegisterEvent(BootMSG, 20000, 1, player)
	else
	firstlogin = false
	end
end



local function DinkleStoneOneOnUse(event, player, item, target)
    if not TP_Menu_Enabled then
        if not player:GetData("TP_Menu_Disabled_Notified") then
            player:SetData("TP_Menu_Disabled_Notified", true) -- Mark the player as notified
        end
        return false -- Prevent the menu from being used since the TP_Menu is disabled
    end
    if player:IsInCombat() then
        player:SendBroadcastMessage("You cannot use this item while in combat.")
        return false
    elseif PlayerHasChallenge(player) then
        player:SendBroadcastMessage("You cannot use this item while participating in a challenge mode.")
        return false
    end
    return true
end
-- Register the events
if enabled then
    RegisterPlayerEvent(30, DinkleStoneOneOnFirstLogin)
    RegisterPlayerEvent(3, DinkleStoneOneOnLogin)
    RegisterPlayerGossipEvent(DinkleStoneOneGossipID, 2, DinkleStoneOneOnSelect)
    RegisterItemEvent(ItemEntry, 2, DinkleStoneOneMenuMenusGossip)
    RegisterItemEvent(ItemEntry, 2, DinkleStoneOneOnUse)
end
