AldricWolfheart = {}
local AW = AldricWolfheart

AW.NPC_ID = 1000013
AW.REND_SPELL_ID = 772
AW.CHECK_INTERVAL = 10000 -- 10 seconds in milliseconds

local function OnEnterCombat(event, creature, target)
    creature:CastSpell(target, AW.REND_SPELL_ID, true)
end


local function CheckForNearestCreature(event, delay, pCall, creature)
    local nearestCreature = creature:GetNearestCreature(30)
    if nearestCreature and nearestCreature:IsAlive() then
        creature:AttackStart(nearestCreature)
    end
end

local function OnSpawn(event, creature)
    creature:RegisterEvent(CheckForNearestCreature, AW.CHECK_INTERVAL, 0)
end

RegisterCreatureEvent(AW.NPC_ID, 1, OnEnterCombat)
RegisterCreatureEvent(AW.NPC_ID, 5, OnSpawn)
