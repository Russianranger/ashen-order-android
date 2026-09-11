-- NPC IDs
local WITCH1 = 881853
local WITCH2 = 881854
local WITCH3 = 881855
local ICE_BEAM_NPC = 817260
local EXPLODING_FROG = 840176
local ADDITIONAL_NPC = 83020
local FLAME_TSUNAMI_1 = 83022
local FLAME_TSUNAMI_2 = 83023
local FLAME_TSUNAMI_3 = 83024
local FLAME_TSUNAMI_4 = 83025
local FLAME_TSUNAMI_5 = 83026

-- Gobject IDS
local GAMEOBJECT_ID_1 = 893771 -- Trap
local GAMEOBJECT_ID_2 = 893772 -- PI
local GAMEOBJECT_ID_3 = 893773 -- Shield
local GOO_DOOR_ID = 181203
local WITCH_EFFIGY_ID = 914401
local CAULDRON_GO_ID = 890021  

-- Spell IDs
local SPELL_ICE_PATCH = 13810
local SPELL_19484 = 19484
local SPELL_ACID_SPRAY = 38163
local SPELL_FROSTBOLT_VOLLEY = 888406

-- Coordinates for Ice Beam NPCs
local ice_beam_positions = {
  {-10235.066, 295.93, 2.8, 4.14}
}

-- Coordinates for Frogger NPCs
local frogger_positions = {
  {-10225.389, 299.297, 2.79988, 4.833},
  {-10236.378, 299.222, 2.79988, 4.833},
  {-10230.2, 299.587, 2.79988, 4.833},
  {-10218.78, 301.37, 2.79988, 4.833},
  {-10248.84, 296.85, 2.79988, 4.833},
  {-10242.21, 298.85, 2.79988, 4.833},
  {-10239.6, 299.18, 2.79988, 4.833},
  {-10233.447, 299.96, 2.79988, 4.833},
  {-10221.71, 300.74, 2.79988, 4.833},
  {-10247.118, 298.85, 2.79988, 4.833},
  {-10252.106, 297.99, 2.79988, 4.833},
  {-10243.9589, 297.62, 2.789988, 4.833}  
}

local additional_npc_positions = {
  {-10220.76, 201.92, 2.8, 1.66},
  {-10231.1, 301.546, 2.8, 1.66},
  {-10239.6, 299.657, 2.8, 1.66},
  {-10219.9, 302.745, 2.8, 1.66},
  {-10225.5, 302.033, 2.8, 1.66},
  {-10244.7, 299.025, 2.8, 1.66},
  {-10249.9, 298.396, 2.8, 1.66},
}

local flame_tsunami_positions = {
  {-10243.3857, 295.507, 2.8, 4.833},
  {-10226.0635, 297.052, 2.8, 4.833}
}

-- NPCs to despawn on Witch spawn
local NPC_TO_DESPAWN = {604, 570, 210, 503}

local new_flame_tsunami_position = {-10234.887, 296.811, 2.8, 4.833}
local goo_door_position = {-10222.4, 213.477, 2.80082, 4.84056}  
local witch_effigy_position = {-10235.3, 298.48, 2.80024, 4.7786}

function SpawnDeadlyFrogAtSpecificLocation(eventId, delay, repeats, creature)
  local deadly_frog_position = {-10232.357422, 278.688507, 4.674543, 4.833}
  local randomizedX = deadly_frog_position[1] + (math.random() - 0.5)
  local randomizedY = deadly_frog_position[2] + (math.random() - 0.5)
  local frog_npc = creature:SpawnCreature(EXPLODING_FROG, randomizedX, randomizedY, deadly_frog_position[3], deadly_frog_position[4], 3, 35000)  
end

function Witch3_SpawnGameObjectOne(eventId, delay, repeats, creature)
  local x, y, z, o = creature:GetLocation()
  local randDist = math.random(10, 30)
  local randAngle = math.random() * math.pi * 2
  local newX = x + randDist * math.cos(randAngle)
  local newY = y + randDist * math.sin(randAngle)
  local newZ = z + 0.1 
  local spawnedGameObject = creature:SummonGameObject(GAMEOBJECT_ID_1, newX, newY, newZ, o, 30)  
  
  if spawnedGameObject then
  else
  end
end

function Witch3_SpawnGameObjectTwo(eventId, delay, repeats, creature)
  local x, y, z, o = creature:GetLocation()
  local randDist = math.random(12, 35)
  local randAngle = math.random() * math.pi * 2
  local newX = x + randDist * math.cos(randAngle)
  local newY = y + randDist * math.sin(randAngle)
  local newZ = z + 0.1 
  local spawnedGameObject = creature:SummonGameObject(GAMEOBJECT_ID_2, newX, newY, newZ, o, 30)  
  
  if spawnedGameObject then
  else
  end
end

function Witch3_SpawnGameObjectThree(eventId, delay, repeats, creature)
  local x, y, z, o = creature:GetLocation()
  local randDist = math.random(8, 37)
  local randAngle = math.random() * math.pi * 2
  local newX = x + randDist * math.cos(randAngle)
  local newY = y + randDist * math.sin(randAngle)
  local newZ = z + 0.1 
  local spawnedGameObject = creature:SummonGameObject(GAMEOBJECT_ID_3, newX, newY, newZ, o, 30)  
  if spawnedGameObject then
  else
  end
end

function CommonWitchSpawn(creature)
  creature:CastSpell(creature, SPELL_19484, true)
    creature:RegisterEvent(SpawnDeadlyFrogAtSpecificLocation, 4000, 0)  
  local allCreaturesInRange = creature:GetCreaturesInRange(30)
  
  local creaturesInRange = {}
  for _, targetCreature in pairs(allCreaturesInRange) do
    local id = targetCreature:GetEntry()
    if id >= 70000 and id <= 90000 then
      table.insert(creaturesInRange, targetCreature)
    end
  end
  
  for _, targetCreature in pairs(creaturesInRange) do
    targetCreature:CastSpell(targetCreature, 5, true)
  end
  for _, pos in ipairs(additional_npc_positions) do
    creature:SpawnCreature(ADDITIONAL_NPC, pos[1], pos[2], pos[3], pos[4], 3, 500000)
  end
  creature:SummonGameObject(GOO_DOOR_ID, goo_door_position[1], goo_door_position[2], goo_door_position[3], goo_door_position[4], 300)
  creature:SummonGameObject(WITCH_EFFIGY_ID, witch_effigy_position[1], witch_effigy_position[2], witch_effigy_position[3], witch_effigy_position[4], 300)

  for _, npcId in ipairs(NPC_TO_DESPAWN) do
    local npcs = creature:GetCreaturesInRange(100, npcId, 3)  
    for _, npc in pairs(npcs) do
      npc:DespawnOrUnsummon(0)
    end
  end
end

function CommonDespawn(creature)
  creature:RemoveEvents()

  -- List of NPCs to despawn
  local to_despawn = {
    ICE_BEAM_NPC, 
    EXPLODING_FROG, 
    ADDITIONAL_NPC, 
    FLAME_TSUNAMI_1, 
    FLAME_TSUNAMI_2,
    FLAME_TSUNAMI_3,
    FLAME_TSUNAMI_4,
    FLAME_TSUNAMI_5
  }
  
 for _, npcId in ipairs(to_despawn) do
    local npcs = creature:GetCreaturesInRange(120, npcId, 3)
    for _, npc in pairs(npcs) do
      npc:DespawnOrUnsummon(0)
    end
  end
  
  local goo_doors = creature:GetGameObjectsInRange(120, GOO_DOOR_ID)
  local witch_effigies = creature:GetGameObjectsInRange(120, WITCH_EFFIGY_ID)
  
  for _, goo_door in pairs(goo_doors) do
    goo_door:Despawn()
  end
  
  for _, witch_effigy in pairs(witch_effigies) do
    witch_effigy:Despawn()
  end

  if creature:GetEntry() ~= WITCH3 then
    creature:DespawnOrUnsummon(0)
  end
end

function Witch1_SummonFrogs(eventId, delay, repeats, creature)
  for _, pos in ipairs(frogger_positions) do
    local randomizedX = pos[1] + math.random(-3, 3)
    local randomizedY = pos[2] + math.random(-3, 3)
    local frog_npc = creature:SpawnCreature(EXPLODING_FROG, randomizedX, randomizedY, pos[3], pos[4], 1, 35000)
  end
end

function Witch1_OnSpawn(event, creature)
 local cauldrons = creature:GetGameObjectsInRange(50, CAULDRON_GO_ID)  
  for _, cauldron in pairs(cauldrons) do
    cauldron:Despawn()
  end
  creature:RegisterEvent(Witch1_SummonFrogs, 2100, 0)
  creature:CastSpell(creature, SPELL_19484, true)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 100, 4)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 3000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 6000, 0)
  CommonWitchSpawn(creature)
  local player = creature:GetNearestPlayer(90)  
  if player then
    creature:AttackStart(player)
	end
  creature:SendUnitYell("Ah, fresh souls! Prepare to be toadally poisoned!", 0)  
end

function Witch1_AcidSpray(eventId, delay, repeats, creature)
  creature:CastSpell(creature:GetVictim(), SPELL_ACID_SPRAY, false)
end

function Witch1_OnCombat(event, creature, target)
  creature:RegisterEvent(Witch1_AcidSpray, math.random(8000, 12000), 0)  
end

function Witch1_OnDeath(event, creature)
  creature:RemoveEvents()
  CommonDespawn(creature)
  local x, y, z, o = creature:GetLocation()
  local spawnX = x + math.random(-10, 10)
  local spawnY = y + math.random(-10, 10)
  creature:SpawnCreature(WITCH2, spawnX, spawnY, z, o, 3, 800000)
  creature:SendUnitYell("My brews... my beautiful brews... all for naught!", 0)  -- Creative and thematic yell on death
end

function Witch2_OnSpawn(event, creature)
  creature:CastSpell(creature, SPELL_19484, true)
  CommonWitchSpawn(creature)
  creature:RegisterEvent(Witch3_SpawnGameObjectTwo, 7000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 3000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 6000, 0)
  creature:RegisterEvent(Witch1_SummonFrogs, 2100, 0)
  for _, pos in ipairs(ice_beam_positions) do
    local ice_beam_npc = creature:SpawnCreature(ICE_BEAM_NPC, pos[1], pos[2], pos[3], pos[4], 3, 800000)
  end
    local player = creature:GetNearestPlayer(90)  
  if player then
    creature:AttackStart(player)
  end
  creature:SendUnitYell("Winter has arrived, and it has teeth!", 0)  
end

function Witch2_FrostboltVolley(eventId, delay, repeats, creature)
  creature:CastSpell(creature:GetVictim(), SPELL_FROSTBOLT_VOLLEY, true)
end

function Witch2_OnCombat(event, creature, target)
  creature:RegisterEvent(Witch2_FrostboltVolley, 9000, 0)  
end

function Witch2_OnDeath(event, creature)
  CommonDespawn(creature)
  
  local x, y, z, o = creature:GetLocation() 
  local spawnX = x + math.random(-10, 10)
  local spawnY = y + math.random(-10, 10)
  
  creature:SpawnCreature(WITCH3, spawnX, spawnY, z, o, 3, 800000)
  creature:SendUnitYell("A cold end... but winter will return...", 0)
end

function SpawnAdditionalFlameTsunamis(eventId, delay, repeats, creature)
  
  for _, pos in ipairs(flame_tsunami_positions) do
    creature:SpawnCreature(FLAME_TSUNAMI_3, pos[1], pos[2], pos[3], pos[4], 3, 800000)
    creature:SpawnCreature(FLAME_TSUNAMI_4, pos[1], pos[2], pos[3], pos[4], 3, 800000)
  end

  local flame_tsunami_5 = creature:SpawnCreature(FLAME_TSUNAMI_5, new_flame_tsunami_position[1], new_flame_tsunami_position[2], new_flame_tsunami_position[3], new_flame_tsunami_position[4], 3, 800000)

  if flame_tsunami_5 then
  else
  end
end

function Witch3_OnSpawn(event, creature)
  creature:RegisterEvent(Witch3_SpawnGameObjectOne, 100, 5)
  creature:RegisterEvent(Witch3_SpawnGameObjectOne, 3000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectTwo, 100, 3)
  creature:RegisterEvent(Witch3_SpawnGameObjectTwo, 4000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectTwo, 4000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 3000, 0)
  creature:RegisterEvent(Witch3_SpawnGameObjectThree, 6000, 0)
  creature:CastSpell(creature, SPELL_19484, true)
  CommonWitchSpawn(creature)
  creature:RegisterEvent(Witch1_SummonFrogs, 2100, 0)
  for _, pos in ipairs(ice_beam_positions) do
    local ice_beam_npc = creature:SpawnCreature(ICE_BEAM_NPC, pos[1], pos[2], pos[3], pos[4], 3, 800000)
  end
  
  for _, pos in ipairs(flame_tsunami_positions) do
    local flame_tsunami_npc = creature:SpawnCreature(FLAME_TSUNAMI_1, pos[1], pos[2], pos[3], pos[4], 3, 300000)
  end
  
  creature:RegisterEvent(SpawnAdditionalFlameTsunamis, 4500, 1)  
    local player = creature:GetNearestPlayer(90)  
  if player then
    creature:AttackStart(player)
  end
  creature:SendUnitYell("Let your screams fan the flames of my power!", 0)  
end

function Witch3_OnLeaveCombat(event, creature)
  CommonDespawn(creature)
  creature:DespawnOrUnsummon(0)
  creature:RemoveEvents()
end

function Witch3_OnDeath(event, creature)
  CommonDespawn(creature)
  creature:RemoveEvents()
  creature:SendUnitYell("Even in ashes, the embers of my rage linger!", 0) 
end

function Witches_OnLeaveCombat(event, creature)
  CommonDespawn(creature)
  creature:RemoveEvents()
end

RegisterCreatureEvent(WITCH1, 5, Witch1_OnSpawn)
RegisterCreatureEvent(WITCH1, 1, Witch1_OnCombat)
RegisterCreatureEvent(WITCH1, 4, Witch1_OnDeath)
RegisterCreatureEvent(WITCH1, 2, Witches_OnLeaveCombat)

RegisterCreatureEvent(WITCH2, 5, Witch2_OnSpawn)
RegisterCreatureEvent(WITCH2, 1, Witch2_OnCombat) 
RegisterCreatureEvent(WITCH2, 4, Witch2_OnDeath)
RegisterCreatureEvent(WITCH2, 2, Witches_OnLeaveCombat)

RegisterCreatureEvent(WITCH3, 5, Witch3_OnSpawn)
RegisterCreatureEvent(WITCH3, 4, Witch3_OnDeath)
RegisterCreatureEvent(WITCH3, 2, Witch3_OnLeaveCombat)