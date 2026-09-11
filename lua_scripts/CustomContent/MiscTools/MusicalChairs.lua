local teleportData = {
    [491385] = { mapId = 1, x = 10204.4, y = 2258.63, z = 1346.62, o = 4.11344, delay = 500 },
    [491386] = { mapId = 0, x = -8867.81, y = 1087.95, z = 102.455, o = 0.266159, delay = 500 },
    [491387] = { mapId = 0, x = 1629.58, y = 342.159, z = -62.1707, o = 1.1516, delay = 500 },
    [491388] = { mapId = 1, x = 1611.5, y = -4311.64, z = 3.32332, o = 6.00671, delay = 500 },
	[983767] = { mapId = 530, x = -3702.09, y = -11380.8, z = -134.718, o = 0.635949, delay = 500 },
    [983768] = { mapId = 0, x = -4723.33, y = -1146.69, z = 502.448, o = 4.19213, delay = 500 }
}

local function CreateTeleportFunction(goId)
    return function(eventid, delay, repeats, player)
        local data = teleportData[goId]
        if data then
            player:Teleport(data.mapId, data.x, data.y, data.z, data.o)
        end
    end
end

local function OnMusicalChairUse(event, go, player)
    local goId = go:GetEntry()
    local data = teleportData[goId]
    if data then
        player:RegisterEvent(CreateTeleportFunction(goId), data.delay, 1)
    end
    return false 
end

for goId, _ in pairs(teleportData) do
    RegisterGameObjectEvent(goId, 14, OnMusicalChairUse)
end
