local Crystallon = {}

Crystallon.SPELL_CRYSTAL_SPIKE = 859750
Crystallon.SPELL_EARTHQUAKE = 832686
Crystallon.SPELL_SHOCKWAVE = 863783
Crystallon.SPELL_SUMMON_MINIONS = 864726
Crystallon.summonMinionsCast60 = false
Crystallon.summonMinionsCast30 = false
Crystallon.isCastingSpecial = false

function Crystallon.CancelAndDelayEvents(creature)
    creature:RemoveEvents()
    creature:RegisterEvent(Crystallon.CrystalSpike, 2000, 0)
   -- creature:RegisterEvent(Crystallon.Earthquake, math.random(33000, 35000), 0)
    creature:RegisterEvent(Crystallon.Shockwave, math.random(15000, 15000), 0)
end

function Crystallon.CrystalSpike(event, delay, pCall, creature)
    if not creature:IsCasting() then
        local targets = creature:GetAITargets()
        local validTargets = {}
        local tank = creature:GetAITarget(1)

        for _, target in pairs(targets) do
            if target:IsAlive() and target ~= tank then  -- Exclude the tank
                table.insert(validTargets, target)
            end
        end

        if #validTargets >= 2 then
            local firstTargetIndex = math.random(1, #validTargets)
            local secondTargetIndex = firstTargetIndex
            while secondTargetIndex == firstTargetIndex do
                secondTargetIndex = math.random(1, #validTargets)
            end
            local firstTarget = validTargets[firstTargetIndex]
            local secondTarget = validTargets[secondTargetIndex]

            creature:CastSpell(firstTarget, Crystallon.SPELL_CRYSTAL_SPIKE, true)
            creature:CastSpell(secondTarget, Crystallon.SPELL_CRYSTAL_SPIKE, true)

            print("Casting Crystal Spike on targets: " .. firstTarget:GetName() .. " and " .. secondTarget:GetName())
        elseif #validTargets == 1 then
            creature:CastSpell(validTargets[1], Crystallon.SPELL_CRYSTAL_SPIKE, true)
            print("Casting Crystal Spike on single target: " .. validTargets[1]:GetName())
        end
    end
end

function Crystallon.Earthquake(event, delay, pCall, creature)
    if not creature:IsCasting() and not Crystallon.isCastingSpecial then
        Crystallon.isCastingSpecial = true
        creature:SendUnitYell("Feel the tremors of the Earth!", 0)
        creature:CastSpell(creature, Crystallon.SPELL_EARTHQUAKE, false)
        Crystallon.isCastingSpecial = false
    end
end

function Crystallon.Shockwave(event, delay, pCall, creature)
    if not creature:IsCasting() and not Crystallon.isCastingSpecial then
        Crystallon.isCastingSpecial = true
        creature:CastSpell(creature, Crystallon.SPELL_SHOCKWAVE, false)
        Crystallon.isCastingSpecial = false
    end
end

function Crystallon.OnEnterCombat(event, creature, target)
    if math.random(1, 4) == 1 then
        local dialogues = {
            "Intruders! I'll grind you into dust!",
            "You dare challenge me?",
            "You cannot escape the tremors!",
            "Feel the wrath of the Earth!",
            "You tread on sacred ground!",
            "Your bones will line my den!",
            "None can withstand my fury!",
            "You will be but a footnote in my reign!",
            "Flee, fools!",
            "The Earth will reclaim you!"
        }
        local randomDialogue = dialogues[math.random(1, #dialogues)]
        creature:SendUnitYell(randomDialogue, 0)
    end
    creature:RegisterEvent(Crystallon.CrystalSpike, 2000, 0)
   -- creature:RegisterEvent(Crystallon.Earthquake, math.random(33000, 35000), 0)
    creature:RegisterEvent(Crystallon.Shockwave, math.random(15000, 15000), 0)
end

function Crystallon.OnHealthChanged(event, creature, killer)
    local healthPct = creature:GetHealthPct()

    if healthPct <= 60 and not Crystallon.summonMinionsCast60 then
        Crystallon.CancelAndDelayEvents(creature)
        Crystallon.summonMinionsCast60 = true
        creature:CastSpell(creature, Crystallon.SPELL_SUMMON_MINIONS, false)
        creature:SendUnitYell("Rise, stoneborn, and shatter my foes!", 0)
    end

    if healthPct <= 30 and not Crystallon.summonMinionsCast30 then
        Crystallon.CancelAndDelayEvents(creature)
        Crystallon.summonMinionsCast30 = true
        creature:CastSpell(creature, Crystallon.SPELL_SUMMON_MINIONS, false)
        creature:SendUnitYell("Rise, stoneborn, and shatter my foes!", 0) 
    end
end

function Crystallon.OnLeaveCombat(event, creature)
    creature:SendUnitYell("Run, mortals! Remember, the earth beneath you is my domain.", 0)
    creature:RemoveEvents()
end

function Crystallon.OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(810119, 1, Crystallon.OnEnterCombat)
RegisterCreatureEvent(810119, 2, Crystallon.OnLeaveCombat)
RegisterCreatureEvent(810119, 4, Crystallon.OnDied)
RegisterCreatureEvent(810119, 9, Crystallon.OnHealthChanged)
