local NPC_SHADE_OF_NAX_1 = 351056
local NPC_SHADE_OF_NAX_2 = 16449
local SPELL_SHADOW_BOLT = 11661
local SPELL_SHADOW_BOLT_VOLLEY = 21340

function ShadeOfNax_OnEnterCombat(event, creature)
    creature:RegisterEvent(ShadeOfNax_CastShadowBolt, 4000, 0) 
    creature:RegisterEvent(ShadeOfNax_CastShadowBoltVolley, 12000, 0) 
end

function ShadeOfNax_CastShadowBolt(event, delay, pCall, creature)
    local target = creature:GetVictim() 
    if target then
        creature:CastSpell(target, SPELL_SHADOW_BOLT, true)
    end
end

function ShadeOfNax_CastShadowBoltVolley(event, delay, pCall, creature)
    creature:CastSpell(creature, SPELL_SHADOW_BOLT_VOLLEY, true)
end

function ShadeOfNax_RemoveEvents(event, creature)
    creature:RemoveEvents()
end

RegisterCreatureEvent(NPC_SHADE_OF_NAX_1, 1, ShadeOfNax_OnEnterCombat) 
RegisterCreatureEvent(NPC_SHADE_OF_NAX_1, 2, ShadeOfNax_RemoveEvents) 
RegisterCreatureEvent(NPC_SHADE_OF_NAX_1, 4, ShadeOfNax_RemoveEvents) 
RegisterCreatureEvent(NPC_SHADE_OF_NAX_2, 1, ShadeOfNax_OnEnterCombat) 
RegisterCreatureEvent(NPC_SHADE_OF_NAX_2, 2, ShadeOfNax_RemoveEvents) 
RegisterCreatureEvent(NPC_SHADE_OF_NAX_2, 4, ShadeOfNax_RemoveEvents) 
