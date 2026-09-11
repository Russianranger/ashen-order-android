local BlockerNPCID = 83020  
local SlimeNPCID = 83021  


local BlockerSpawnLocations = {
    {-9042.08, 1219.45, -112.294, 4.96264},
    {-9021.94, 1220.78, -112.305, 3.77669},
    {-9008, 1203.85, -112.305, 3.78871},
    {-9000.36, 1195.15, -112.305, 3.85971},
    {-8992.98, 1186.63, -112.305, 3.89318},
    {-8980.36, 1160.51, -112.292, 2.82879},
    {-8984.18, 1149.72, -112.292, 2.82879},
    {-8898.26, 1167.49, -112.295, 0.701459},
    {-8908.43, 1183, -112.306, 5.84582},
    {-8905.02, 1193.96, -112.304, 5.87526},
    {-8894.77, 1223.6, -112.304, 5.92238},
    {-8886.23, 1246.31, -112.293, 5.92138},
    {-8866.19, 1251.76, -112.292, 4.97195},
    {-8878.2, 1249.53, -112.292, 4.97195},
    {-9011.88, 1299.93, -112.293, 0.773036},
    {-8998.36, 1287.61, -112.294, 1.75524},
    {-8975.07, 1291.96, -112.305, 1.75524},
    {-8954.04, 1295.7, -112.305, 1.75524},
    {-8932.87, 1299.89, -112.305, 1.70026},
    {-8924.8, 1316.17, -112.296, 2.64291},
    {-8942.58, 1297.74, -112.302, 1.76264},
    {-8964.88, 1293.77, -112.304, 1.74693},
    {-8987.13, 1289.81, -112.304, 1.74693},
    {-9004.29, 1292.15, -112.293, 0.773036},
    {-8928.02, 1307.01, -112.302, 2.64291},
    {-8890.21, 1234.65, -112.305, 5.97066},
    {-8897.93, 1213.12, -112.305, 5.90832},
    {-8901.06, 1203.68, -112.306, 5.95963},
    {-8905.72, 1176.32, -112.302, 0.701459},
    {-8978.61, 1169.48, -112.294, 3.93809},
    {-9032.86, 1220.73, -112.3, 4.96264},
    {-9015.95, 1213.66, -112.304, 3.77669},
    {-8986.03, 1178.35, -112.304, 3.89318}
}

local SlimeSpawnLocations = {
	{-8894.49, 1234.82, -112.28, 3.142},
    {-8894.97, 1242.35, -112.28, 0.126},
    {-8896.38, 1249.76, -112.28, 0.251},
    {-8898.71, 1256.93, -112.28, 0.377},
    {-8901.92, 1263.75, -112.28, 0.503},
    {-8905.96, 1270.12, -112.28, 0.628},
    {-8910.77, 1275.93, -112.28, 0.754},
    {-8916.27, 1281.09, -112.28, 0.880},
    {-8922.37, 1285.53, -112.28, 1.005},
    {-8928.98, 1289.16, -112.28, 1.131},
    {-8935.99, 1291.94, -112.28, 1.257},
    {-8943.29, 1293.81, -112.28, 1.382},
    {-8950.78, 1294.76, -112.28, 1.508},
    {-8958.32, 1294.76, -112.28, 1.634},
    {-8965.80, 1293.81, -112.28, 1.759},
    {-8973.10, 1291.94, -112.28, 1.885},
    {-8980.12, 1289.16, -112.28, 2.011},
    {-8986.72, 1285.53, -112.28, 2.137},
    {-8992.83, 1281.09, -112.28, 2.262},
    {-8998.32, 1275.93, -112.28, 2.388},
    {-9003.13, 1270.12, -112.28, 2.514},
    {-9007.17, 1263.75, -112.28, 2.639},
    {-9010.38, 1256.93, -112.28, 2.765},
    {-9012.71, 1249.76, -112.28, 2.891},
    {-9014.13, 1242.35, -112.28, 3.017},
    {-9014.61, 1234.82, -112.28, 3.142},
    {-9014.13, 1227.29, -112.28, 0.126},
    {-9012.71, 1219.88, -112.28, 0.251},
    {-9010.38, 1212.71, -112.28, 0.377},
    {-9007.17, 1205.89, -112.28, 0.503},
    {-9003.13, 1199.52, -112.28, 0.628},
    {-8998.32, 1193.71, -112.28, 0.754},
    {-8992.83, 1188.55, -112.28, 0.880},
    {-8986.72, 1184.12, -112.28, 1.005},
    {-8980.12, 1180.48, -112.28, 1.131},
    {-8973.10, 1177.71, -112.28, 1.257},
    {-8965.80, 1175.83, -112.28, 1.382},
    {-8958.32, 1174.89, -112.28, 1.508},
    {-8950.78, 1174.89, -112.28, 1.634},
    {-8943.29, 1175.83, -112.28, 1.759},
    {-8935.99, 1177.71, -112.28, 1.885},
    {-8928.98, 1180.48, -112.28, 2.011},
    {-8922.37, 1184.12, -112.28, 2.137},
    {-8916.27, 1188.55, -112.28, 2.262},
    {-8910.77, 1193.71, -112.28, 2.388},
    {-8905.96, 1199.52, -112.28, 2.514},
    {-8901.92, 1205.89, -112.28, 2.639},
    {-8898.71, 1212.71, -112.28, 2.765},
    {-8896.38, 1219.88, -112.28, 2.891},
    {-8894.97, 1227.29, -112.28, 3.016}
}


local HeraldSpawnLocations = {
    {-8940.156, 1163.90, -112.29, 1.68},
}

local TentacleSpawnLocations = {
    {-8971.02, 1253.79, -112.29, 1.76},
    {-8946.07, 1258.44, -112.29, 1.07},
    {-8983.078, 1229.979, -112.29, 1.07},
    {-8965.28, 1205.7878, -112.29, 1.07},
    {-8935.752, 1212.5, -112.29, 1.07},
    {-8924.33, 1240.2, -112.29, 1.07}
}

-- Boss OnDamageTaken Function (Modified)
local function Boss_OnDamageTaken(event, creature, attacker, damage)
    local hpPercent = (creature:GetHealth() - damage) / creature:GetMaxHealth() * 100

    if hpPercent <= 75 and creature:GetData("Slimes75") ~= 1 then
        creature:SetData("Slimes75", 1)
        creature:SendUnitYell("Dreams fray at the edges, woven by frost and void.", 0)
        for _, loc in ipairs(SlimeSpawnLocations) do
            creature:SpawnCreature(SlimeNPCID, loc[1], loc[2], loc[3], loc[4], 3, 950000)  
        end
    end

    if hpPercent <= 75 and creature:GetData("ArcaneVolley75") ~= 1 then
        creature:SetData("ArcaneVolley75", 1)
        creature:RegisterEvent(function(event, delay, calls, creature)
            creature:CastSpell(creature, 829885, true) 
        end, 16000, 0)  -- Repeat indefinitely every 16 seconds
    end
    
    if hpPercent <= 50 and creature:GetData("Slimes50") ~= 1 then
        creature:SetData("Slimes50", 1)
        creature:SendUnitYell("The eye watches, the dream darkens.", 0)
        for _, loc in ipairs(SlimeSpawnLocations) do
            creature:SpawnCreature(SlimeNPCID, loc[1], loc[2], loc[3], loc[4], 3, 950000)  
        end
    end
    
    if hpPercent <= 50 and creature:GetData("Fear50") ~= 1 then
        creature:SetData("Fear50", 1)
        creature:RegisterEvent(function(event, delay, calls, creature)
            local victim = creature:GetVictim()
            if victim then
                creature:CastSpell(victim, 22678, true)  -- Cast Fear
            end
        end, 12000, 0)  -- Repeat indefinitely every 12 seconds
    end
    
    if hpPercent <= 25 and creature:GetData("Slimes25") ~= 1 then
        creature:SetData("Slimes25", 1)
        creature:SendUnitYell("The veil shatters, yet our vision remains.", 0)
        for _, loc in ipairs(SlimeSpawnLocations) do
            creature:SpawnCreature(SlimeNPCID, loc[1], loc[2], loc[3], loc[4], 3, 950000)  
        end
    end
    
    if hpPercent <= 25 and creature:GetData("DarkChaos25") ~= 1 then
        creature:SetData("DarkChaos25", 1)
        creature:RegisterEvent(function(event, delay, calls, creature)
            creature:CastSpell(creature, 917467, true)  -- Cast Dark Chaos
        end, 30000, 0)  -- Repeat indefinitely every 30 seconds
    end
end


-- Helper function to check if a tentacle exists at a spawn location
local function TentacleExistsAt(creature, x, y)
    local creatures = creature:GetCreaturesInRange(20)  -- Change the range if needed
    for _, targetCreature in pairs(creatures) do
        if targetCreature:GetEntry() == 815725 then  -- Tentacle NPC ID
            local cx, cy, _, _ = targetCreature:GetLocation()
            if math.abs(cx - x) < 1 and math.abs(cy - y) < 1 then  -- 1 yard tolerance
                return true
            end
        end
    end
    return false
end

-- Boss OnSpawn Function
local function Boss_OnSpawn(event, creature)
    creature:CastSpell(creature, 62003, true)
    creature:CastSpell(creature, 42716, true)
    creature:RegisterEvent(function(event, delay, calls, creature) 
        creature:SendUnitYell("Two lights extinguished...now the shadow rises.", 0) 
    end, 4000, 1)
end

-- Boss Cast Cleave Function
local function Boss_CastCleave(event, delay, calls, creature)
    print("Attempting to cast Cleave...")
    local victim = creature:GetVictim()
    if victim then
        print("Casting Cleave on victim.")
        creature:CastSpell(victim, 872493, true)
    else
        print("No victim found for Cleave.")
    end
end

local isChaosBoltCasting = false

-- Boss OnEnterCombat Function
local function Boss_OnEnterCombat(event, creature, target)
    creature:CastSpell(creature, 42716, true)
    
   -- creature:RegisterEvent(function(event, delay, calls, creature)
   --    creature:CastSpell(creature, 26662, true)  -- Cast Enrage
   --     creature:SendUnitYell("Enough! I shall feast on your souls!", 0)
   -- end, 360000, 1)  -- Execute only once after 6 minutes
    
    creature:RegisterEvent(function(event, delay, calls, creature)
        local victim = creature:GetVictim()
        if victim then
            isChaosBoltCasting = true  
            creature:CastSpell(victim, 850796, false)  
            isChaosBoltCasting = false  
        end
    end, 12000, 0)


    creature:RegisterEvent(function(event, delay, calls, creature)
        if not isChaosBoltCasting then  -- Check if Chaos Bolt is not being cast
            local victim = creature:GetVictim()
            if victim then
                print("Casting Cleave on victim.")
                creature:CastSpell(victim, 872493, true) 
            else
                print("No victim found for Cleave.")
            end
        end
    end, math.random(14000, 18000), 0)


    -- Initial Blocker spawn at the start of the fight
    creature:RegisterEvent(function(event, delay, calls, creature)
        for _, loc in ipairs(BlockerSpawnLocations) do
            creature:SpawnCreature(BlockerNPCID, loc[1], loc[2], loc[3], loc[4], 2, 600000)  
        end
    end, 1000, 1)  -- Execute immediately and only once

    creature:RegisterEvent(function(event, delay, calls, creature)
        for _, loc in ipairs(HeraldSpawnLocations) do
            creature:SpawnCreature(815728, loc[1], loc[2], loc[3], loc[4], 3, 1200000)
            creature:SpawnCreature(24925, loc[1], loc[2], loc[3], loc[4], 2, 2000)
        end
    end, 45000, 0)
	
	 creature:RegisterEvent(function(event, delay, calls, creature)
        for _, loc in ipairs(HeraldSpawnLocations) do
            creature:SpawnCreature(815728, loc[1], loc[2], loc[3], loc[4], 3, 1200000)
            creature:SpawnCreature(24925, loc[1], loc[2], loc[3], loc[4], 2, 2000)
        end
    end, 5000, 1)
	
	 creature:RegisterEvent(function(event, delay, calls, creature)
        print("Attempting to spawn tentacles immediately...")
        for _, loc in ipairs(TentacleSpawnLocations) do
            creature:SpawnCreature(815725, loc[1], loc[2], loc[3], loc[4], 2, 1200000)
        end
    end, 1000, 1)  -- Execute immediately and only once

 creature:RegisterEvent(function(event, delay, calls, creature)
        print("Attempting to spawn tentacles...")
        for _, loc in ipairs(TentacleSpawnLocations) do
            local x, y, z, o = loc[1], loc[2], loc[3], loc[4]
            
            -- Check if a tentacle already exists at this spawn location
            if TentacleExistsAt(creature, x, y) then
                -- If yes, spawn at a random position 7 yards away
                local angle = math.random() * 2 * math.pi
                local dx = 7 * math.cos(angle)
                local dy = 7 * math.sin(angle)
                
                x = x + dx
                y = y + dy
            end
            
            creature:SpawnCreature(815725, x, y, z, o, 2, 1200000)
        end
    end, 40000, 0)

    creature:RegisterEvent(function(event, delay, calls, creature)
        local targets = creature:GetAITargets(10.0)
        local rangedTargets = {}
        for _, target in ipairs(targets) do
            if target:GetDistance(creature) > 5 then
                table.insert(rangedTargets, target)
            end
        end
        if #rangedTargets > 0 then
            local randomTarget = rangedTargets[math.random(1, #rangedTargets)]
            creature:CastSpell(randomTarget, 67890, true)
        end
    end, 10000, 0)

    -- Existing code for victim distance check
    creature:RegisterEvent(function(event, delay, calls, creature)
        local victim = creature:GetVictim()
        if victim and victim:GetDistance(creature) > 2.2 then
            creature:CastSpell(victim, 828599, true)
        end
    end, 1500, 0)

    -- Reset the Slime spawn data when entering combat
    creature:SetData("Slimes75", 0)
    creature:SetData("Slimes50", 0)
    creature:SetData("Slimes25", 0)
end

-- Boss OnLeaveCombat Function
local function Boss_OnLeaveCombat(event, creature)
    local creatures = creature:GetCreaturesInRange(200)
    for _, targetCreature in pairs(creatures) do
        if targetCreature:GetEntry() ~= 400166 then  -- Make exception for 400166
            targetCreature:DespawnOrUnsummon(1)
        end
    end
    creature:RemoveEvents()

    -- Reset the Slime spawn data when leaving combat
    creature:SetData("Slimes75", 0)
    creature:SetData("Slimes50", 0)
    creature:SetData("Slimes25", 0)
end


-- Boss OnDied Function
local function Boss_OnDied(event, creature, killer)
    local creatures = creature:GetCreaturesInRange(200)
    for _, targetCreature in pairs(creatures) do
        targetCreature:DespawnOrUnsummon(1)
    end
    creature:RemoveEvents()
end

-- Register Events
RegisterCreatureEvent(815727, 1, Boss_OnEnterCombat)
RegisterCreatureEvent(815727, 2, Boss_OnLeaveCombat)
RegisterCreatureEvent(815727, 4, Boss_OnDied)
RegisterCreatureEvent(815727, 5, Boss_OnSpawn)
RegisterCreatureEvent(815727, 9, Boss_OnDamageTaken) 

-- Central Position Coordinates
local CentralPosition = {-8954.5459, 1234.8217, -112.62, 1.7}

-- DarkSlime OnSpawn Function
local function DarkSlime_OnSpawn(event, creature)
    -- Set React State to 0
    creature:SetReactState(0)
    
    -- Set Speed for Walk and Run
    creature:SetSpeed(0, 0.22)
    creature:SetSpeed(1, 0.22)
    
    -- Move to Central Position
    creature:MoveTo(1, CentralPosition[1], CentralPosition[2], CentralPosition[3])
    
    -- Register Event to move to Central Position every 2 seconds
    creature:RegisterEvent(function(event, delay, calls, creature)
        creature:MoveTo(1, CentralPosition[1], CentralPosition[2], CentralPosition[3])
    end, 2000, 0)  -- Repeat indefinitely every 2 seconds
end

-- DarkSlime OnEnterCombat Function
local function DarkSlime_OnEnterCombat(event, creature, target)
    -- Get current position of the creature using GetLocation
    local x, y, z, o = creature:GetLocation()
    
    -- Set the current position as the new home position
    creature:SetHomePosition(x, y, z, o)
    
    -- Set Speed for Walk and Run
    creature:SetSpeed(0, 0.22)
    creature:SetSpeed(1, 0.22)
    
    -- Move to Central Position
    creature:MoveTo(1, CentralPosition[1], CentralPosition[2], CentralPosition[3])
end

-- DarkSlime OnLeaveCombat Function
local function DarkSlime_OnLeaveCombat(event, creature)
    -- Move to Central Position
    creature:MoveTo(1, CentralPosition[1], CentralPosition[2], CentralPosition[3])
end

-- DarkSlime OnDied Function
local function DarkSlime_OnDied(event, creature)
    -- Find nearby creatures with ID 815727 within 3 yards
    local nearbyCreatures = creature:GetCreaturesInRange(3, 815727)

    -- Cast spell on nearby creature with ID 815727
    for _, nearbyCreature in pairs(nearbyCreatures) do
        local dist = creature:GetDistance(nearbyCreature)
        if dist <= 2 then  -- Check if the creature is within 3 yards
            nearbyCreature:CastSpell(nearbyCreature, 80248, true)  -- Creature casts it on itself
        else
            creature:CastSpell(nearbyCreature, 80248, true)  -- Original slime casts the spell on the nearby creature
        end
        break  -- Cast on only one nearby creature
    end

    -- Remove all events
    creature:RemoveEvents()
end

-- Register events
RegisterCreatureEvent(83021, 5, DarkSlime_OnSpawn)
RegisterCreatureEvent(83021, 1, DarkSlime_OnEnterCombat)
RegisterCreatureEvent(83021, 4, DarkSlime_OnDied)
RegisterCreatureEvent(83021, 2, DarkSlime_OnLeaveCombat)

local function HiddenTentacle_OnSpawn(event, creature)
    creature:SetReactState(2)
    creature:CastSpell(creature, 72313, true)
    creature:CastSpell(creature, 42716, true)
    creature:SetRooted(true)  
end

local function HiddenTentacle_OnEnterCombat(event, creature, target)
    creature:CastSpell(creature, 42716, true)
    creature:SetRooted(true)  
    creature:RegisterEvent(function(event, delay, calls, creature)

        local targets = creature:GetAITargets()

		if #targets > 0 then
            local randomTarget = targets[math.random(1, #targets)]
            creature:CastSpell(randomTarget, 811659, true)  -- Shadow Bolt
        end
    end, math.random(4000, 7000), 0)  -- Repeat indefinitely, randomized between 5 and 9 seconds
end


local function HiddenTentacle_OnLeaveCombat(event, creature)
    creature:CastSpell(creature, 42716, true) 
    creature:SetRooted(true)  
    creature:RemoveEvents()
end


local function HiddenTentacle_OnDied(event, creature)
    creature:RemoveEvents()
end


RegisterCreatureEvent(815725, 5, HiddenTentacle_OnSpawn)
RegisterCreatureEvent(815725, 1, HiddenTentacle_OnEnterCombat)
RegisterCreatureEvent(815725, 2, HiddenTentacle_OnLeaveCombat)  
RegisterCreatureEvent(815725, 4, HiddenTentacle_OnDied)


local HeraldCentralPosition = {-8954.5459, 1234.8217, -112.62, 1.7}

-- Herald OnSpawn Function
local function Herald_OnSpawn(event, creature)
	creature:SetReactState(2)
    creature:MoveTo(1, HeraldCentralPosition[1], HeraldCentralPosition[2], HeraldCentralPosition[3], HeraldCentralPosition[4])
    creature:SetHomePosition(HeraldCentralPosition[1], HeraldCentralPosition[2], HeraldCentralPosition[3], HeraldCentralPosition[4])
end

-- Herald OnDied Function
local function Herald_OnDied(event, creature)
    -- Find nearby creatures with ID 815727 within 10 yards
    local nearbyCreatures = creature:GetCreaturesInRange(10, 815727)
    
    -- If a creature with ID 815727 is within 10 yards, make it cast spell 865209
    for _, nearbyCreature in pairs(nearbyCreatures) do
        local dist = creature:GetDistance(nearbyCreature)
        if dist <= 10 then  -- Check if the creature is within 10 yards
            nearbyCreature:CastSpell(nearbyCreature, 865209, true)
        end
        break  -- Apply to only one nearby creature, remove this line if you want to apply to all within range
    end

    -- Remove all events
    creature:RemoveEvents()
end


-- Herald OnLeaveCombat Function
local function Herald_OnLeaveCombat(event, creature)
	creature:SetReactState(2)
    creature:MoveTo(1, HeraldCentralPosition[1], HeraldCentralPosition[2], HeraldCentralPosition[3], HeraldCentralPosition[4])
    creature:RemoveEvents()
end

-- Herald OnEnterCombat Function
local function Herald_OnEnterCombat(event, creature, target)
    
    -- Register event for Knockback with randomized delay between 15 to 30 seconds (15000 to 30000 milliseconds)
    creature:RegisterEvent(function(event, delay, calls, creature)
        local victim = creature:GetVictim()
        if victim then
            creature:CastSpell(victim, 37317, true)  -- Knockback
        end
    end, math.random(15000, 35000), 0)
    
    -- Sunder Armor
    creature:RegisterEvent(function(event, delay, calls, creature)
        local target = creature:GetAITarget(1)
        if target then
            creature:CastSpell(target, 707405, true)  -- Sunder Armor
        end
    end, 10000, 0)
end

-- Register Events
RegisterCreatureEvent(815728, 5, Herald_OnSpawn)
RegisterCreatureEvent(815728, 1, Herald_OnEnterCombat)
RegisterCreatureEvent(815728, 4, Herald_OnDied)
RegisterCreatureEvent(815728, 2, Herald_OnLeaveCombat)

