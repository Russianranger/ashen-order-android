local SaveLocationmk = {}
SaveLocationmk.SAVE_LOCATION_SPELL = 312370
SaveLocationmk.TELEPORT_BACK_DURATION = 900000 -- 15 minutes (unused)
local savedLocations = {}

local function RemoveSavedLocation(playerGuid)
    savedLocations[playerGuid] = nil
    local player = GetPlayerByGUID(playerGuid)
    if player then
        player:SendBroadcastMessage("Your saved location has expired.")
    end
end

function SaveLocationmk.OnSaveLocationmkCast(event, player, spell)
    if spell:GetEntry() == SaveLocationmk.SAVE_LOCATION_SPELL then
        local playerGuid = player:GetGUIDLow()
        local mapId, x, y, z, orientation = player:GetMapId(), player:GetX(), player:GetY(), player:GetZ(), player:GetO()
        savedLocations[playerGuid] = { mapId = mapId, x = x, y = y, z = z, orientation = orientation }
        player:SendBroadcastMessage("Your save location has been stored. It will remain until you save a new location.")

    end
end

RegisterPlayerEvent(5, SaveLocationmk.OnSaveLocationmkCast)


local TeleportBackmk = {}
TeleportBackmk.TELEPORT_BACK_SPELL = 312372
TeleportBackmk.SPELL_ON_TELEPORT = 51908

function TeleportBackmk.OnTeleportBackmkCast(event, player, spell)
    if spell:GetEntry() == TeleportBackmk.TELEPORT_BACK_SPELL then
        local playerGuid = player:GetGUIDLow()
        local currentMap = player:GetMap()

        if savedLocations[playerGuid] then
            if currentMap and currentMap:IsBattleground() then
                player:SendBroadcastMessage("You cannot use this ability in battlegrounds.")
                spell:Cancel()
            else
                local savedLocation = savedLocations[playerGuid]
                player:Teleport(savedLocation.mapId, savedLocation.x, savedLocation.y, savedLocation.z, savedLocation.orientation)
                player:CastSpell(player, TeleportBackmk.SPELL_ON_TELEPORT, true)
                player:SendBroadcastMessage("You have been teleported back to your camp.")
            end
        else
            player:SendBroadcastMessage("No saved location found.")
            spell:Cancel()  -- Cancel the spell if no saved location is found
        end
    end
end

RegisterPlayerEvent(5, TeleportBackmk.OnTeleportBackmkCast)
