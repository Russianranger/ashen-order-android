local RuneOfMazthoril = {}

RuneOfMazthoril.GO_IDS = {176163} 
RuneOfMazthoril.CLOSE_DISTANCE = 5 

function RuneOfMazthoril.OnEnter(event, go, player)
    go:RegisterEvent(RuneOfMazthoril.CheckForPlayersEntrance, 1000, 0)
end

function RuneOfMazthoril.CheckForPlayersEntrance(event, delay, repeat_times, go)
    local players_in_range = go:GetPlayersInRange(RuneOfMazthoril.CLOSE_DISTANCE)

    if #players_in_range == 0 then
    end

    for _, player in pairs(players_in_range) do
        player:CastSpell(player, 41236, true)
        player:Teleport(1, 6109.24, -4187.25, 851.275, 5.0454)  
    end
end

for _, go_id in ipairs(RuneOfMazthoril.GO_IDS) do
    RegisterGameObjectEvent(go_id, 2, RuneOfMazthoril.OnEnter)
end
