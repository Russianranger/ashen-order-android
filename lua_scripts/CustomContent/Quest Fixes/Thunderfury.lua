local ThunderaanAura = {}

function ThunderaanAura.OnQuestComplete(event, player, quest)
    if quest:GetId() == 7786 then
        player:AddAura(800201, player)
    end
end

RegisterPlayerEvent(54, ThunderaanAura.OnQuestComplete)

local PrinceThunderaan = {}

function PrinceThunderaan.OnDied(event, creature, killer)
    local players = creature:GetPlayersInRange(150)

    for i, player in ipairs(players) do
        if player:HasAura(800201) then
            player:AddItem(19018, 1) 
        end
    end
end

RegisterCreatureEvent(14435, 4, PrinceThunderaan.OnDied)
