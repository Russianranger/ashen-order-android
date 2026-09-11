local NPC_KRAZJALAH = 886500
local NPC_DESPAWN1 = 886506
local NPC_DESPAWN2 = 886581
local SPELL_ENRAGE = 848138
local frenziedRoarCast = false

local SPELL_DEVOURING_BITE = 98766
local SPELL_RAGING_STOMP = 98768
local SPELL_TAIL_SWIPE = 25653
local SPELL_FRENZIED_ROAR = 14100
local SPELL_SUMMON_RAPTORS = 98770
local SPELL_LAVA_BURST = 100131

function Krazjalah_OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Krazjalah_SummonRaptors, 2000, 1)
    creature:RegisterEvent(Krazjalah_DevouringBite, 8000, 0)
    creature:RegisterEvent(Krazjalah_RagingStomp, 17000, 0)
    creature:RegisterEvent(Krazjalah_LavaBurst, 12000, 0)
    creature:RegisterEvent(Krazjalah_SummonRaptors, 30000, 0)
    creature:RegisterEvent(Krazjalah_CheckForRavasaur, 1000, 0)
	--print("Krazjalah_CheckForRavasaur event registered.")  
end

function Krazjalah_DevouringBite(event, delay, pCall, creature)
    creature:CastSpell(creature:GetVictim(), SPELL_DEVOURING_BITE, true)
end

function Krazjalah_RagingStomp(event, delay, pCall, creature)
    creature:CastSpell(creature, SPELL_RAGING_STOMP, true)
end

function Krazjalah_TailSwipe(event, delay, pCall, creature)
    creature:CastSpell(creature, SPELL_TAIL_SWIPE, true)
end

function Krazjalah_SummonRaptors(event, delay, pCall, creature)
    creature:CastSpell(creature, SPELL_SUMMON_RAPTORS, true)
end

function Krazjalah_LavaBurst(event, delay, pCall, creature)
    local targets = creature:GetAITargets()
    if #targets > 0 then
        local target = targets[math.random(#targets)]
        creature:CastSpell(target, SPELL_LAVA_BURST, true)
    end
end

function Krazjalah_OnDamageTaken(event, creature, attacker, damage)
    if creature:GetHealthPct() <= 50 and not frenziedRoarCast and not creature:IsCasting() then
        creature:CastSpell(creature, SPELL_FRENZIED_ROAR, true)
        frenziedRoarCast = true
    end
end

function Krazjalah_CheckForRavasaur(event, delay, pCall, creature)
    --print("Checking for Ravasaur Patriarch...")
    local allCreatures = creature:GetCreaturesInRange(30)
    local foundPatriarch = false

    for i, c in ipairs(allCreatures) do
        if c:GetEntry() == NPC_DESPAWN2 and c:IsAlive() then
            foundPatriarch = true
            break
        end
    end

    if foundPatriarch then
        --print("Ravasaur Patriarch is alive and in range.")
        if not creature:HasAura(SPELL_ENRAGE) then
            creature:AddAura(SPELL_ENRAGE, creature)
            --print("Krazjalah has cast Enrage on itself.")
            creature:SendUnitEmote("Ravasaur Patriarch enrages Kraz'Jalah!")
        end
    else
        --print("No live Ravasaur Patriarch in range.")
        if creature:HasAura(SPELL_ENRAGE) then
            creature:RemoveAura(SPELL_ENRAGE)
            --print("Enrage removed from Krazjalah.")
        end
    end
end

function Krazjalah_OnLeaveCombat(event, creature)
    creature:RemoveEvents()
    DespawnCreaturesInRange(creature, NPC_DESPAWN1, 100)
    DespawnCreaturesInRange(creature, NPC_DESPAWN2, 100)
end

function DespawnCreaturesInRange(creature, npcId, range)
    local creatures = creature:GetCreaturesInRange(range, npcId)
    for i, targetCreature in ipairs(creatures) do
        targetCreature:DespawnOrUnsummon()
    end
end

function Krazjalah_OnDied(event, creature, killer)
    creature:RemoveEvents()

    local target = creature:GetNearestCreature(133, 800062)  
    if target and target:IsAlive() then
        creature:CastSpell(target, 5, true)
    end
end

RegisterCreatureEvent(NPC_KRAZJALAH, 1, Krazjalah_OnEnterCombat)
RegisterCreatureEvent(NPC_KRAZJALAH, 2, Krazjalah_OnLeaveCombat)
RegisterCreatureEvent(NPC_KRAZJALAH, 4, Krazjalah_OnDied)
RegisterCreatureEvent(NPC_KRAZJALAH, 9, Krazjalah_OnDamageTaken)
