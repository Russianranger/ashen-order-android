local Treant = {}
local NPCID = 900649

function Treant_OnSpawn(event, creature)
    local playersInRange = creature:GetPlayersInRange(100)
    if #playersInRange > 0 then
        local target = playersInRange[math.random(1, #playersInRange)]
        creature:CastSpell(target, 49026, true)
    end
end

function Treant_Fixate(eventId, delay, calls, creature)
    local playersInRange = creature:GetPlayersInRange(100)
    if #playersInRange > 0 then
        local target = playersInRange[math.random(1, #playersInRange)]
        creature:CastSpell(target, 49026, true)
    end
end

function Treant_Wipe(eventId, delay, calls, creature)
creature:CastSpell(creature:GetVictim(), 64596, true)
end

function Treant_OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Treant_Fixate, 9000, 0)
	creature:RegisterEvent(Treant_Wipe, 38000, 0)
end

function Treant_OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function Treant_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(NPCID, 1, Treant_OnEnterCombat)
RegisterCreatureEvent(NPCID, 2, Treant_OnLeaveCombat)
RegisterCreatureEvent(NPCID, 4, Treant_OnDied)
RegisterCreatureEvent(NPCID, 5, Treant_OnSpawn)