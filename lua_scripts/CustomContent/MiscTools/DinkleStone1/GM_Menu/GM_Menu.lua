--[[
Name: Menus Menu
Version: 1.5.0
Made by: MadBuffoon
Notes: Opens the a menu for other menus from a item.

]]
local enabled = true
local MenuMenus = true
local GM_MENU_GossipID = 9910000

function GMSettingsMenuGossip(event, player)
	if player:GetGMRank() < 3 then
		return
	end
	player:GossipClearMenu()
	
	player:GossipMenuAddItem(0, "|TInterface\\Icons\\Ability_mage_invisibility:30:30:-40|t Teleport To Player", 0, 2)
	player:GossipMenuAddItem(0, "|TInterface\\Icons\\Ability_mage_tormentoftheweak:30:30:-40|t Summon Players", 0, 3)
	player:GossipMenuAddItem(0, "|TInterface\\Icons\\Inv_drink_22:30:30:-40|t GM Buffs +List+", 0, 4)
	player:GossipMenuAddItem(0, "|TInterface\\Icons\\Mail_gmicon:30:30:-40|t More Functions", 0, 5)
	player:GossipMenuAddItem(0, "|TInterface\\Icons\\Spell_Holy_RemoveCurse:30:30:-40|t Remove Sated/Exhaustion", 0, 6)
	player:GossipMenuAddItem(0, "|TInterface\\Icons\\Inv_gizmo_supersappercharge:30:30:-40|t Reload Eluna", 0, 95, false, "Are you sure?")
	player:GossipMenuAddItem(4, "|TInterface\\Icons\\Achievement_bg_returnxflags_def_wsg:45:45:-40|t [Back]", 0, 9999)
	
	player:GossipSendMenu(1, player, GM_MENU_GossipID)

end


--(Start)
local function GM_MENU_OnSelect(event, player, _, sender, intid, code)
    local PlayerName = player:GetName()

    if intid == 2 then
        PLayerListGossip(event, player)
    elseif intid == 3 then
        PLayerListSummonGossip(event, player)
    elseif intid == 4 then
        GMBuffsGossip(event, player)
    elseif intid == 5 then
        GMFunctionMenuGossip(event, player)
    elseif intid == 6 then
        player:CastSpell(player, 875167)
        player:GossipComplete()
    elseif intid == 95 then
        player:SendBroadcastMessage("|cffff3347Notice: |cffffd000Reloading Eluna")
        player:GossipComplete()
        ReloadEluna()
    elseif intid == 9999 then
        DinkleStoneOneMenuMenusGossip(event, player)
        return false
    end
end
--(End)
if enabled then
RegisterPlayerGossipEvent(GM_MENU_GossipID, 2, GM_MENU_OnSelect)
end
