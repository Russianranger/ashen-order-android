local NaxxKick = {}

NaxxKick.teleportLocations = {
    [533] = {0, 3089.6, -3891.53, 131.44, 2.1},
    [249] = {1, -4737.995, -3745.33, 53.68, 3.7},
	[13] = {1, -956.66, -3754.709, 5.33, 2.1}

}

function NaxxKick.TeleportPlayerIfNecessary(event, player)
    local mapId = player:GetMapId()
    local teleportData = NaxxKick.teleportLocations[mapId]
    if teleportData then
        player:Teleport(table.unpack(teleportData))
    end
end

RegisterPlayerEvent(3, NaxxKick.TeleportPlayerIfNecessary)
RegisterPlayerEvent(4, NaxxKick.TeleportPlayerIfNecessary)

--[[
    [624] = {571, 5470.37, 2853.65, 418.68, 6},
    [409] = {0, -7528.38, -1056.57, 180.98, 0.637},
    [469] = {0, -7658.8, -1221, 287.79, 2.55},
    [509] = {1, -8063.615, 1631.419, 24.3453, 4.6},
    [531] = {1, -8063.615, 1631.419, 24.3453, 4.6},
    [859] = {0, -7658.8, -1221, 287.79, 2.55}
	]]--