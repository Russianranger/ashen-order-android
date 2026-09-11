local PumpkinKobold = {}

PumpkinKobold.CREATURE_ID = 100168


function PumpkinKobold.OnCreatureSpawn(event, creature)
    local player = creature:GetNearestPlayer()
    if player then
        creature:AttackStart(player)
        creature:SendUnitSay("You no take Pumpkin!", 0)
    end
end

RegisterCreatureEvent(PumpkinKobold.CREATURE_ID, 5, PumpkinKobold.OnCreatureSpawn)
