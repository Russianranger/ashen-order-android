local NPC_LIVING_TRAINEE = 351043
local NPC_LIVING_KNIGHT = 351044
local NPC_LIVING_RIDER = 351045

local NPC_DEAD_TRAINEE = 351046
local NPC_DEAD_KNIGHT = 351050
local NPC_DEAD_RIDER = 351052
local NPC_DEAD_HORSE = 351051

local GAMEOBJECT_GATE = 181170
local GATE_OPEN = false 

-- Spells
local SPELL_DEATH_PLAGUE = 55604
local SPELL_ARCANE_EXPLOSION = 27989
local SPELL_SHADOW_MARK = 27825
local SPELL_WHIRLWIND = 56408
local SPELL_SHADOW_BOLT_VOLLEY = 27831
local SPELL_DRAIN_LIFE = 27994
local SPELL_UNHOLY_FRENZY = 55648
local SPELL_STOMP = 27993

local SEARCH_RADIUS = 300
local DESPAWN_TIME = 600000  

local SPELL_MAPPINGS = {
    [NPC_LIVING_TRAINEE] = {{SPELL_DEATH_PLAGUE, 3000}},
    [NPC_DEAD_TRAINEE] = {{SPELL_ARCANE_EXPLOSION, 2500}},
    [NPC_LIVING_KNIGHT] = {{SPELL_SHADOW_MARK, 3000}},
    [NPC_DEAD_KNIGHT] = {{SPELL_WHIRLWIND, 2000}},
    [NPC_LIVING_RIDER] = {{SPELL_SHADOW_BOLT_VOLLEY, 3000}},
    [NPC_DEAD_RIDER] = {{SPELL_DRAIN_LIFE, math.random(2000, 3500)}, {SPELL_UNHOLY_FRENZY, math.random(5000, 9000)}},
    [NPC_DEAD_HORSE] = {{SPELL_STOMP, math.random(2000, 5000)}}
}

local spawnOnDeath = {
    [NPC_LIVING_TRAINEE] = {NPC_DEAD_TRAINEE},
    [NPC_LIVING_KNIGHT] = {NPC_DEAD_KNIGHT},
    [NPC_LIVING_RIDER] = {NPC_DEAD_RIDER, NPC_DEAD_HORSE}
}

local deathSpawnLocations = {
    {2725.1, -3310.0, 268.85, 3.4},
    {2699.3, -3322.8, 268.60, 3.3},
    {2733.1, -3348.5, 268.84, 3.1},
    {2682.8, -3304.2, 268.85, 3.9},
    {2664.8, -3340.7, 268.23, 3.7}
}

local function CastSpell(event, delay, repeats, creature)
    local entry = creature:GetEntry()
    local spells = SPELL_MAPPINGS[entry]
    if spells then
        for _, spellData in ipairs(spells) do
            local spell = spellData[1]
            local castDelay = spellData[2]
            if delay == castDelay then
                creature:CastSpell(creature:GetVictim(), spell, false)
                return
            end
        end
    end
end

local function GateOnStateChanged(event, go, state)
    if state == 0 then
        GATE_OPEN = true
    else
        GATE_OPEN = false
    end
end

local function PeriodicCheckGate(event, delay, repeats, creature)
    if GATE_OPEN then
        local nearbyCreatures = creature:GetCreaturesInRange(SEARCH_RADIUS)
        local nearbyPlayers = creature:GetPlayersInRange(SEARCH_RADIUS)

        for _, target in pairs(nearbyCreatures) do
            local entry = target:GetEntry()
            if entry >= 70000 and entry <= 89000 then
                creature:AttackStart(target)
            end
        end

        for _, player in pairs(nearbyPlayers) do
            creature:AttackStart(player)
        end
    end
end

local function GothikOnSpawn(event, creature) 
  creature:RegisterEvent(PeriodicCheckGate, 2000, 0)
    
    local nearbyCreatures = creature:GetCreaturesInRange(SEARCH_RADIUS)
    local nearbyPlayers = creature:GetPlayersInRange(SEARCH_RADIUS)
        
    for _, target in pairs(nearbyCreatures) do
        local entry = target:GetEntry()
        if entry >= 70000 and entry <= 89000 and creature:IsWithinLoS(target) then
            creature:AttackStart(target)
        end
    end
    
    for _, player in pairs(nearbyPlayers) do
        if creature:IsWithinLoS(player) then
            creature:AttackStart(player)
        end
    end
end

local function GothikOnEnterCombat(event, creature)
    local spells = SPELL_MAPPINGS[creature:GetEntry()]
    if spells then
        for _, spellData in ipairs(spells) do
            local spell = spellData[1]
            local delay = spellData[2]
            creature:RegisterEvent(function(_, _, _, creature) 
                creature:CastSpell(creature:GetVictim(), spell, false) 
            end, delay, 0)
        end
    end
end

local function GothikOnDied(event, creature)
    local entry = creature:GetEntry()
    local location = deathSpawnLocations[math.random(#deathSpawnLocations)]
    
    if spawnOnDeath[entry] then
        for _, spawnID in pairs(spawnOnDeath[entry]) do
            creature:SpawnCreature(spawnID, location[1], location[2], location[3], location[4], 3, DESPAWN_TIME)
        end
    end
    creature:RemoveEvents()
end


local function GothikOnLeaveCombat(event, creature)
    creature:DespawnOrUnsummon(1)
end


local LIVING_CREATURES = {NPC_LIVING_TRAINEE, NPC_LIVING_KNIGHT, NPC_LIVING_RIDER}
local DEAD_CREATURES = {NPC_DEAD_TRAINEE, NPC_DEAD_KNIGHT, NPC_DEAD_RIDER, NPC_DEAD_HORSE}

for _, entry in pairs(LIVING_CREATURES) do
    RegisterCreatureEvent(entry, 1, GothikOnEnterCombat)
    RegisterCreatureEvent(entry, 5, GothikOnSpawn)
    RegisterCreatureEvent(entry, 2, GothikOnLeaveCombat)  
    RegisterCreatureEvent(entry, 4, GothikOnDied)
end

for _, entry in pairs(DEAD_CREATURES) do
    RegisterCreatureEvent(entry, 1, GothikOnEnterCombat)
    RegisterCreatureEvent(entry, 5, GothikOnSpawn)
    RegisterCreatureEvent(entry, 2, GothikOnLeaveCombat)  
	RegisterCreatureEvent(entry, 4, GothikOnDied)
end

RegisterGameObjectEvent(GAMEOBJECT_GATE, 10, GateOnStateChanged)
