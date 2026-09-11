--[[
Name: Reward Points Menu
Version: 1.0.0
Made by: MadBuffoon
Notes: Blank

]]

local config = require ('!config')-- Need Don't Remove

local luaName = "Reward Points Earned"
local luaNameShort = "RPE_"

local debugON = config.get(luaNameShort.."debugOn")
local enabled_BG_win = config.get(luaNameShort.."enabled_BG_win", debugON)
local points_AV_win = config.get(luaNameShort.."points_AV_win", debugON)
local points_WG_win = config.get(luaNameShort.."points_WG_win", debugON)
local points_AB_win = config.get(luaNameShort.."points_AB_win", debugON)
local points_Other_win = config.get(luaNameShort.."points_Other_win", debugON)

--(Start) Pulles for the guid for the player
local function getPlayerCharacterGUID(player)
    local query = CharDBQuery(string.format("SELECT guid FROM characters WHERE name='%s'", player:GetName()))

    if query then 
      local row = query:GetRow()

      return tonumber(row["guid"])
    end

    return nil
  end
--(End)

local function Gain_Points(pointsAdded,player)
	local playerAccount = player:GetAccountId()
	local query = CharDBQuery(string.format("SELECT * FROM ac_eluna.Reward_points_bank WHERE Account='%i'", playerAccount))
	local pointsInBank = tonumber(query:GetString(1))
	local newAmount = pointsInBank + pointsAdded

	CharDBExecute(string.format("UPDATE ac_eluna.Reward_points_bank SET Points=%i WHERE Account=%i", newAmount, playerAccount))
	player:SendBroadcastMessage("|cffff3347Notice: |cff3399FFYou have gain |cfffca726"..pointsAdded.."|cff3399FF Reward Points and have |cfffca726"..newAmount.."|cff3399FF in the Bank.")
end

local function Battlegound_Ended(event, BattleGround, bgId, instanceId, winner)
	local worldPlayers = GetPlayersInWorld(winner)
	for event, WPlayer in ipairs(worldPlayers) do
		--local Name = tostring(WPlayer:GetName())
		--local WPlayer = GetPlayerByName(Name)
		local Map = WPlayer:GetMap()
		local MapId = Map:GetMapId()
		local playerInstanceId = Map:GetInstanceId()
		local bgMapId = BattleGround:GetMapId()
		local PlayerID = math.floor(getPlayerCharacterGUID(WPlayer))
		if debugON then
			print("RPE: bgId "..bgId.." - winner "..winner)
			print("RPE: MapId "..MapId.." - bgMapId "..bgMapId)
			print("RPE: playerInstanceId "..playerInstanceId.." - instanceId "..instanceId)
		end
		if MapId == bgMapId and playerInstanceId == instanceId then
			WPlayer:SendBroadcastMessage("|cffff3347Notice: |cff3399FFWon a BattleGround here is some points.")
			if bgId == 1 then -- Alterac Valley (battleground)
				Gain_Points(points_AV_win,WPlayer)
			elseif bgId == 2 then -- Warsong Gulch (battleground)
				Gain_Points(points_WG_win,WPlayer)
			elseif bgId == 3 then -- Arathi Basin (battleground)
				Gain_Points(points_AB_win,WPlayer)
			else
				Gain_Points(points_Other_win,WPlayer)
			end
			
		end
	end

end

if enabled_BG_win then RegisterBGEvent(2, Battlegound_Ended) end
