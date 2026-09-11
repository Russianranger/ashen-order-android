local config = require ('!config')-- Need Don't Remove

local luaName = "Other Menu"
local luaNameShort = "OM_"

local debugON = config.get(luaNameShort.."debugOn")
local enabled = config.get(luaNameShort.."enabled", debugON)
local GossipID = config.get(luaNameShort.."GossipID", debugON)
local minExpRate = config.get(luaNameShort.."minExpRate", debugON)
local maxExpRate = config.get(luaNameShort.."maxExpRate", debugON)

if debugON then
	print("ECC: Configs for "..luaName.." Loaded") -- Finished Loading
end

-- Do not change or remove
local Gold = 10000

--(Start) The Gossip Menu that shows Main Menu
function OtherMenuGossip(event, player)
	if player:IsInCombat() then
        return
    end
	player:GossipClearMenu()
	--player:GossipMenuAddItem(3, "|TInterface\\Icons\\Inv_letter_05:45:45:-40|t Mail Box", 0, 1)
	--player:GossipMenuAddItem(3, "|TInterface\\Icons\\Inv_crate_04:45:45:-40|t Personal Bank", 0, 2)
	--player:GossipMenuAddItem(3, "|TInterface\\Icons\\inv_misc_rune_01:45:45:-40|t Guild Bank", 0, 3
	player:GossipMenuAddItem(3, "|TInterface\\Icons\\spell_fire_flare:45:45:-40|t NPC Summon Menu", 0, 4)
	player:GossipMenuAddItem(3, "|TInterface\\Icons\\Inv_gizmo_thebiggerone:45:45:-40|t Reset Dungeons & Raids", 0, 10, false, "Note: Leave group before using this!")	
	--player:GossipMenuAddItem(3, "|TInterface\\Icons\\achievement_boss_mutanus_the_devourer:45:45:-40|t ReCustomize Character", 0, 20)
	player:GossipMenuAddItem(3, "|TInterface\\Icons\\Ability_rogue_disguise:45:45:-40|t Morph Menu", 0, 21)
	player:GossipMenuAddItem(3, "|TInterface\\Icons\\trade_engineering:45:45:-40|t Change Rates", 0, 30)
	player:GossipMenuAddItem(4, "|TInterface\\Icons\\Achievement_bg_returnxflags_def_wsg:45:45:-40|t [Back]", 0, 9999)
	player:GossipSendMenu(1, player, GossipID)

end
--(End)

--(Start)
local function OnSelect(event, player, object, sender, intid, code, menu_id)
	local PlayerName = player:GetName()
	Gossipintid_Use = 100
	Gossipintid_Delete = 1000
	local currentgold = player:GetCoinage()	
    local PUID = player:GetGUIDLow(player)
	
	local x = player:GetX()
	local y = player:GetY()
	local z = player:GetZ()
	local o = player:GetO()
	local map = player:GetMap()
	local mapID = map:GetMapId()
	local areaId = map:GetAreaId( x, y, z )
	
	if(intid == 1) then -- Mail	
		player:SendShowMailBox( GuidN )
	end	
	if(intid == 2) then -- Personal Bank	
		player:SendShowBank( player )
	end	
	if(intid == 3) then -- Guild Bank	
		guild = player:GetGuild()
		player:SendShowBank( guild )
	end
	if(intid == 4) then -- NPC Summon Menu
		NPC_Summon_MenuGossip(event, player)
	end	
	if(intid== 10) then -- Reset Instances/Raids
		player:UnbindAllInstances()
		player:SendBroadcastMessage("|cffff3347Notice: |cffffd000Instances/Raids have been Reset.")
		player:GossipComplete()
	end	
	if(intid == 20) then --ReCustomize Character
		ChangeMenuGossip(event, player)
	end	
	if(intid == 21) then --ReCustomize Character
		Morph_MenuMenuGossip(event, player)
	end	
	if (intid == 30) then
		CustomRatesMenu(event, player)
	end
	if(intid == 9999) then --Back
		DinkleStoneOneMenuMenusGossip(event, player)
	end
end
--(End)


if enabled then
RegisterPlayerGossipEvent(GossipID, 2, OnSelect)
end
