local Berylgos = {}

Berylgos.NPC_ID = 10203
Berylgos.SPELL_IDS = {
    DRAGON_BREATH = 22479,     
    TAIL_SWIPE = 25653,        
    WING_BUFFET = 22425        
}

function Berylgos.CastDragonBreath(eventId, delay, calls, creature)
    creature:CastSpell(creature:GetVictim(), Berylgos.SPELL_IDS.DRAGON_BREATH, true)
end

function Berylgos.CastTailSwipe(eventId, delay, calls, creature)
    creature:CastSpell(creature, Berylgos.SPELL_IDS.TAIL_SWIPE, true)
end

function Berylgos.CastWingBuffet(eventId, delay, calls, creature)
    creature:CastSpell(creature, Berylgos.SPELL_IDS.WING_BUFFET, true)
end

function Berylgos.OnEnterCombat(event, creature, target)
    if math.random(1, 100) <= 25 then
        creature:SendUnitYell("You dare challenge me in my domain?", 0)
    end
    creature:RegisterEvent(Berylgos.CastDragonBreath, 8000, 0)
    creature:RegisterEvent(Berylgos.CastTailSwipe, 6000, 0)
    creature:RegisterEvent(Berylgos.CastWingBuffet, 16000, 0)
end

function Berylgos.OnLeaveCombat(event, creature)
    if math.random(1, 100) <= 25 then
        creature:SendUnitSay("My time will come again...", 0)
    end
    creature:RemoveEvents()
end

function Berylgos.OnDied(event, creature, killer)
    if killer:GetObjectType() == "Player" then
        killer:SendBroadcastMessage("You have slain Berylgos!")
    end
    creature:RemoveEvents()
end

RegisterCreatureEvent(Berylgos.NPC_ID, 1, Berylgos.OnEnterCombat)
RegisterCreatureEvent(Berylgos.NPC_ID, 2, Berylgos.OnLeaveCombat)
RegisterCreatureEvent(Berylgos.NPC_ID, 4, Berylgos.OnDied)
