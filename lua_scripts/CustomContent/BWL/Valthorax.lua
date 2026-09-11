local Valthorax = {} -- don't touch
Valthorax.spellQueue = {} -- don't touch
Valthorax.hasCast50PercentAbilities = false -- don't touch
Valthorax.shouldSpawnMinions = true -- Set false to make fight easier by not spawning minions. Abomination will still spawn. 
Valthorax.shouldCast50PercentAbilities = true -- Set false to disable 50% health mechanic
Valthorax.hasCastEnrage = false -- Added new flag for enrage

function Valthorax.ToggleSpawnMinions(shouldSpawn)
    Valthorax.shouldSpawnMinions = shouldSpawn
end

function Valthorax.Toggle50PercentAbilities(shouldCast)
    Valthorax.shouldCast50PercentAbilities = shouldCast
end

function Valthorax.DespawnSpecificMinionsInRange(creature, range)
    local minions = creature:GetCreaturesInRange(range)
    for _, minion in pairs(minions) do
        local entry = minion:GetEntry()
        if entry == 400150 or entry == 400151 or entry == 400152 or entry == 400153 or entry == 83020 or entry == 83019 then
            minion:DespawnOrUnsummon(100)
        end
    end
end

function Valthorax.CastFrostbreath(eventId, delay, calls, creature)
    table.insert(Valthorax.spellQueue, {spell = 21099, targetType = 'victim'})
end

function Valthorax.Enrage(eventId, delay, calls, creature)
    if not creature:HasAura(26662) then 
        creature:CastSpell(creature, 26662, true) 
    end
end

function Valthorax.CastShadowBoltVolley(eventId, delay, calls, creature)
    creature:CastSpell(creature:GetVictim(), 20741, true) 
end

function Valthorax.GetRandomPlayerTarget(creature)
    local targets = creature:GetAITargets()
    if #targets > 0 then
        return targets[math.random(1, #targets)]
    else
        return nil
    end
end

function Valthorax.CastFrenzy(creature)
    if not creature:HasAura(28468) then  
        creature:CastSpell(creature, 28468, true)
    end
end

function Valthorax.CastNecroticAura(eventId, delay, calls, creature)
	creature:CastSpell(creature, 80030, true)
end

function Valthorax.CastIceboundTomb(eventId, delay, calls, creature)
    table.insert(Valthorax.spellQueue, {spell = 80034, targetType = 'randomPlayer'})
end


function Valthorax.SpawnUndeadMinions(eventId, delay, calls, creature)
    if not Valthorax.shouldSpawnMinions then
        return
    end
    
    local x, y, z, o = creature:GetLocation()

    -- Skeletons, Ghouls, and Banshees are spawned
    creature:SpawnCreature(400151, x + math.random(-15, 15), y + math.random(-15, 15), z, o, 2, 600000)
    creature:SpawnCreature(400150, x + math.random(-15, 15), y + math.random(-15, 15), z, o, 2, 600000)
    creature:SpawnCreature(400152, x + math.random(-15, 15), y + math.random(-15, 15), z, o, 2, 600000)
    creature:SpawnCreature(400150, x + math.random(-15, 15), y + math.random(-15, 15), z, o, 2, 600000)
    creature:SpawnCreature(400151, x + math.random(-15, 15), y + math.random(-15, 15), z, o, 2, 600000)
    creature:SpawnCreature(400152, x + math.random(-15, 15), y + math.random(-15, 15), z, o, 2, 600000)
end


function Valthorax.SpawnAbomination(eventId, delay, calls, creature)
    creature:SpawnCreature(400153, -7470.265, -1138.114, 476.534, 3.736, 2, 600000)
	creature:SpawnCreature(83019, -7486.763, -1149.3397, 476.534241, 3.765, 2, 450000)
	creature:SpawnCreature(83019, -7486.763, -1149.3397, 476.534241, 3.765, 2, 450000)
	creature:SpawnCreature(83019, -7461.474, -1107.0505, 476.552216, 5.3, 2, 450000)
	creature:SpawnCreature(83019, -7461.474, -1107.0505, 476.552216, 5.3, 2, 450000)
end


function Valthorax.ProcessSpellQueue(eventId, delay, calls, creature)
    if not creature:IsCasting() and #Valthorax.spellQueue > 0 then
        local nextSpell = table.remove(Valthorax.spellQueue, 1)
        local target

        if nextSpell.targetType == 'victim' then
            target = creature:GetVictim()
        elseif nextSpell.targetType == 'self' then
            target = creature
        elseif nextSpell.targetType == 'randomPlayer' then
            local targets = creature:GetAITargets()
            if #targets > 0 then
                target = targets[math.random(1, #targets)]
            end
        end

        if target then
            creature:CastSpell(target, nextSpell.spell, false)

            -- Notify players if Frost Bomb is being cast
            if nextSpell.spell == 80031 then
                local targets = creature:GetAITargets()
                for _, playerTarget in pairs(targets) do
                    if playerTarget:IsPlayer() then
                        playerTarget:SendNotification("Valthorax begins to cast a devastating spell...")
                    end
                end
            end
        end
    end
end


function Valthorax.OnEnterCombat(event, creature, target)
    creature:SendUnitYell("So bold to disrupt the dealings of the Lich King? You will regret this audacity!", 0)
    creature:RegisterEvent(Valthorax.CastFrostbreath, math.random(17000, 23000), 0)
    creature:RegisterEvent(Valthorax.CastNecroticAura, 30000, 0)
 --creature:RegisterEvent(Valthorax.CastIceboundTomb, math.random(21000, 34000), 0)
--	creature:RegisterEvent(Valthorax.Enrage, 360000, 1) -- Enrage after 6 minutes
	creature:RegisterEvent(Valthorax.CastNecroticAura, 100, 1)
    creature:RegisterEvent(Valthorax.SpawnUndeadMinions, 50000, 0)
	creature:RegisterEvent(Valthorax.SpawnAbomination, 45000, 0) -- every 45 seconds
    creature:RegisterEvent(Valthorax.SpawnAbomination, 5000, 1) 
	creature:RegisterEvent(Valthorax.CastShadowBoltVolley, 16000, 0)
    creature:RegisterEvent(Valthorax.ProcessSpellQueue, 2000, 0)
end

function Valthorax.OnLeaveCombat(event, creature)
    Valthorax.DespawnSpecificMinionsInRange(creature, 200) -- 200 yd range
    creature:RemoveEvents()
    Valthorax.spellQueue = {}
    Valthorax.hasCast50PercentAbilities = false -- Reset the flag back to false
	Valthorax.hasCastEnrage = false -- Reset the enrage flag on leave combat
end

function Valthorax.OnTargetDied(event, creature, victim)
    creature:SendUnitYell("Such a pity...", 0)
end

function Valthorax.OnDied(event, creature, killer)
    creature:SendUnitYell("Master...forgive me...", 0)
    Valthorax.DespawnSpecificMinionsInRange(creature, 200) -- 200 yd range
    creature:RemoveEvents()
	local target = creature:GetNearestCreature(300, 800067)  
	if target then
        creature:CastSpell(target, 5, true)
    end
    Valthorax.spellQueue = {}
end

function Valthorax.RemoveRoot(eventId, delay, calls, creature)
    creature:RemoveAura(80000)
end

function Valthorax.ClearSpellQueue()
    Valthorax.spellQueue = {}
end

function Valthorax.OnTakeDamage(event, creature, attacker, damage)
    local healthPct = creature:GetHealthPct()
    
    -- Check for enrage at 15% health
    if healthPct <= 15 and not Valthorax.hasCastEnrage then
        Valthorax.ClearSpellQueue()
        Valthorax.CastFrenzy(creature)
        Valthorax.hasCastEnrage = true -- Set flag to true after casting enrage
        creature:SendUnitYell("Feel the true wrath of the Lich King!", 0)
    end

    -- Check for the 50% health abilities
    if healthPct <= 50 and not Valthorax.hasCast50PercentAbilities and Valthorax.shouldCast50PercentAbilities then
        Valthorax.hasCast50PercentAbilities = true
        -- Clear the spell queue and prioritize Frost Bomb
        Valthorax.ClearSpellQueue()

        -- Add Frost Bomb to the front of the spell queue
        table.insert(Valthorax.spellQueue, 1, {spell = 80031, targetType = 'self'})

        -- Cast other 50% health abilities
        creature:CastSpell(creature, 80032, true)
        creature:CastSpell(creature, 80033, true)
        
        -- Cast Frost Nova on the current victim
        creature:CastSpell(creature:GetVictim(), 6131, true)

        -- Root Valthorax in place
        creature:CastSpell(creature, 80000, true)

        -- Yell to indicate casting of Frost Bomb
        creature:SendUnitYell("I will freeze your very soul!", 0)

        -- Schedule removal of root after 15 seconds
        creature:RegisterEvent(Valthorax.RemoveRoot, 15000, 1, creature)

        -- Despawn specific minions
        local range = 100 -- Define the appropriate range
        Valthorax.DespawnSpecificMinionsInRange(creature, range)

        print("Valthorax has reached 50% health. Queuing Frost Bomb.") -- Debug message
    end
end

function Valthorax.SetPowerOnSpawn(event, creature)
   -- creature:SetPower(2000000, 0)
end

RegisterCreatureEvent(100184, 1, Valthorax.OnEnterCombat)  
RegisterCreatureEvent(100184, 2, Valthorax.OnLeaveCombat)  
RegisterCreatureEvent(100184, 3, Valthorax.OnTargetDied)   
RegisterCreatureEvent(100184, 4, Valthorax.OnDied) 
RegisterCreatureEvent(100184, 5, Valthorax.SetPowerOnSpawn)        
RegisterCreatureEvent(100184, 9, Valthorax.OnTakeDamage)




