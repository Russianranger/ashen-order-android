local SonOfFlame = {}

function SonOfFlame.OnSpawn(event, creature)
    local locations = {
        {842.75, -812.913, -230.1, 3.987},
        {850.31, -853.59, -228.76, 2.89},
        {819.246, -837.196, -229.83, 2.89},
        {806.83, -798.73, -225.93, 6.14}
    }

    local loc = locations[math.random(#locations)]
    creature:NearTeleport(loc[1], loc[2], loc[3], loc[4])

    local playersInRange = creature:GetPlayersInRange(80, 0, 1) 

    if #playersInRange > 0 then
        local targetPlayer = playersInRange[math.random(#playersInRange)]

        if targetPlayer then
            creature:AttackStart(targetPlayer)
        end
    end
end

RegisterCreatureEvent(12143, 5, SonOfFlame.OnSpawn)
