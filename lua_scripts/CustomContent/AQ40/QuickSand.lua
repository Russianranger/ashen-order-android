local Quicksand = {}

Quicksand.CREATURE_ID = 829692
Quicksand.CHECK_RADIUS = 11
Quicksand.AURA_ID = 800029

function Quicksand.CheckForPlayers(event, delay, pCall, creature)
    local players = creature:GetPlayersInRange(Quicksand.CHECK_RADIUS)
    if players then  
        for _, player in pairs(players) do
            if not player:IsInCombat() then
                player:AddAura(Quicksand.AURA_ID, player)
            end
        end
    end
end

function Quicksand.OnSpawn(event, creature)
    creature:RegisterEvent(Quicksand.CheckForPlayers, 500, 0)
end

RegisterCreatureEvent(Quicksand.CREATURE_ID, 5, Quicksand.OnSpawn)
