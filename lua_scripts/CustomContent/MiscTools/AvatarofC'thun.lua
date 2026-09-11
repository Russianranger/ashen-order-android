local avatarofcthunsword = {}

local CREATURE_ID = 415720
local SPELL_ID = 7641
local CAST_INTERVAL = 2505

function avatarofcthunsword.OnSpawn(event, creature)
    local nearbyCreature = creature:GetNearestCreature(7, CREATURE_ID)
    if nearbyCreature then
        creature:DespawnOrUnsummon(0) 
        return
    end
    local target = creature:GetNearestPlayer(100, 1) 
    if not target then
        target = creature:GetNearestCreature(100)
    end
    if target then
        creature:AttackStart(target)
    end
end

function avatarofcthunsword.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(avatarofcthunsword.CastSpell, CAST_INTERVAL, 0)
    creature:RegisterEvent(avatarofcthunsword.CastSpell, 1, 1)
end

function avatarofcthunsword.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function avatarofcthunsword.CastSpell(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), SPELL_ID, true)
end

RegisterCreatureEvent(CREATURE_ID, 5, avatarofcthunsword.OnSpawn)
RegisterCreatureEvent(CREATURE_ID, 1, avatarofcthunsword.OnEnterCombat)
RegisterCreatureEvent(CREATURE_ID, 2, avatarofcthunsword.OnLeaveCombat)
