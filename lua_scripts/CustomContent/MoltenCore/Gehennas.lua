local Gehennas = {}
Gehennas.spellQueue = {}

function Gehennas.CastGehennasCurse(eventId, delay, calls, creature)
    table.insert(Gehennas.spellQueue, {spell = 19716, targetType = 'victim'})
end

function Gehennas.CastRainOfFire(eventId, delay, calls, creature)
    table.insert(Gehennas.spellQueue, {spell = 19717, targetType = 'random', range = 10})
end

function Gehennas.CastShadowBolt(eventId, delay, calls, creature)
    table.insert(Gehennas.spellQueue, {spell = 21077, targetType = 'random', chance = 0.5, range = 10})
end

function Gehennas.CastShadowboltVolley(eventId, delay, calls, creature)
    table.insert(Gehennas.spellQueue, {spell = 27646, targetType = 'victim'})
end

function Gehennas.ProcessSpellQueue(eventId, delay, calls, creature)
    if not creature:IsCasting() and #Gehennas.spellQueue > 0 then
        local nextSpell = table.remove(Gehennas.spellQueue, 1)
        local target

        if nextSpell.targetType == 'victim' then
            target = creature:GetVictim()
        elseif nextSpell.targetType == 'random' then
            local targets = creature:GetAITargets(nextSpell.range or 0)
            if #targets > 0 then
                target = targets[math.random(1, #targets)]
            end
        end

        if target then
            if type(nextSpell.spell) == "table" then
                local spellToCast = nextSpell.spell[1]
                if math.random() <= (nextSpell.chance or 0.5) then
                    spellToCast = nextSpell.spell[2]
                end
                creature:CastSpell(target, spellToCast, true)
            else
                creature:CastSpell(target, nextSpell.spell, true)
            end
        end
    end
end

function Gehennas.OnEnterCombat(event, creature, target)
    creature:RegisterEvent(Gehennas.CastGehennasCurse, math.random(25000, 30000), 0)
    creature:RegisterEvent(Gehennas.CastRainOfFire, 6000, 0)
    creature:RegisterEvent(Gehennas.CastShadowBolt, 5000, 0)
    creature:RegisterEvent(Gehennas.CastShadowboltVolley, 15000, 0)
    creature:RegisterEvent(Gehennas.ProcessSpellQueue, 2000, 0)
end

local function RespawnCreaturesGehennas(creature, npcId1, npcId2, npcId3, range)
    print("Gehennas: Respawning creatures within range: " .. range)

    local creatures = creature:GetCreaturesInRange(range, npcId1, 0, 0) -- 0 for both hostile/friendly and alive/dead
    if #creatures == 0 then
        print("Gehennas: No creatures found with NPC ID: " .. npcId1)
    else
        for _, c in ipairs(creatures) do
            if c:IsDead() then
                c:Respawn()
                print("Gehennas: Respawned creature with NPC ID: " .. npcId1)
            end
        end
    end

    creatures = creature:GetCreaturesInRange(range, npcId2, 0, 0)
    if #creatures == 0 then
        print("Gehennas: No creatures found with NPC ID: " .. npcId2)
    else
        for _, c in ipairs(creatures) do
            if c:IsDead() then
                c:Respawn()
                print("Gehennas: Respawned creature with NPC ID: " .. npcId2)
            end
        end
    end

    creatures = creature:GetCreaturesInRange(range, npcId3, 0, 0)
    if #creatures == 0 then
        print("Gehennas: No creatures found with NPC ID: " .. npcId3)
    else
        for _, c in ipairs(creatures) do
            if c:IsDead() then
                c:Respawn()
                print("Gehennas: Respawned creature with NPC ID: " .. npcId3)
            end
        end
    end
end

function Gehennas.OnLeaveCombat(event, creature)
    creature:RemoveEvents()
    Gehennas.spellQueue = {}

    if creature:IsAlive() then
        print("Gehennas left combat and is alive, checking for creatures to respawn.")
        RespawnCreaturesGehennas(creature, 11661, 12119, 11662, 150)
    else
        print("Gehennas is dead, not respawning creatures.")
    end
end


function Gehennas.OnDied(event, creature, killer)
	creature:CastSpell(self, 875167, true)
    creature:RemoveEvents()
    Gehennas.spellQueue = {}
	local target = creature:GetNearestCreature(250, 800065)  
	if target then
        creature:CastSpell(target, 5, true)
    end
end

function Gehennas.OnSpawn(event, creature)
    --creature:SetMaxHealth(648000)
end

RegisterCreatureEvent(12259, 1, Gehennas.OnEnterCombat)
RegisterCreatureEvent(12259, 2, Gehennas.OnLeaveCombat)
RegisterCreatureEvent(12259, 4, Gehennas.OnDied)
RegisterCreatureEvent(12259, 5, Gehennas.OnSpawn)