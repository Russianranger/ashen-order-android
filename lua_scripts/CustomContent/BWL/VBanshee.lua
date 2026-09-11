local VBanshee = {}

local function CastSilence(eventId, delay, calls, creature)
    local targets = creature:GetAITargets()
    if #targets > 0 then
        local target = targets[math.random(1, #targets)]
        creature:CastSpell(target, 65542, true)
    end
end

local function CastShadowBolt(eventId, delay, calls, creature)
    local targets = creature:GetAITargets()
    if #targets > 0 then
        local target = targets[math.random(1, #targets)]
        creature:CastSpell(target, 11660, false)
    end
end

function VBanshee.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(CastSilence, 8000, 0)
    creature:RegisterEvent(CastShadowBolt, 5000, 0)
end

function VBanshee.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
end

function VBanshee.OnDied(event, creature, killer)
    creature:DespawnOrUnsummon(5000)
    creature:RemoveEvents()
end

function VBanshee.OnSpawn(event, creature)
    creature:CastSpell(creature, 51908, true)
end


RegisterCreatureEvent(400152, 1, VBanshee.OnEnterCombat)
RegisterCreatureEvent(400152, 2, VBanshee.OnLeaveCombat)
RegisterCreatureEvent(400152, 4, VBanshee.OnDied)
RegisterCreatureEvent(400152, 5, VBanshee.OnSpawn)
