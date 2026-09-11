local BLACK_HOLE_DESPAWN = 83020

function OnBlackHoleSpawn(event, creature)
  creature:RegisterEvent(CheckForWitches, 1000, 0)  
end

function CheckForWitches(eventId, delay, repeats, creature)
  local witch_ids = {881853, 881854, 881855}
  local foundWitch = false
  
  for _, witch_id in ipairs(witch_ids) do
    local witches = creature:GetCreaturesInRange(3, witch_id, 0, 1)
    for _, witch in pairs(witches) do
      witch:DespawnOrUnsummon(0)
      foundWitch = true
    end
  end
  
  if foundWitch then
    local black_holes = creature:GetCreaturesInRange(100, BLACK_HOLE_DESPAWN, 0, 1)  
    for _, black_hole in pairs(black_holes) do
      black_hole:DespawnOrUnsummon(0)
    end
    
    creature:DespawnOrUnsummon(0)
  end
end

RegisterCreatureEvent(BLACK_HOLE_DESPAWN, 5, OnBlackHoleSpawn)


-- NPC IDs
local NPC_TO_FOLLOW = 83022
local FOLLOWING_NPC = 83024
local NPC_TO_FOLLOWT = 83023
local FOLLOWING_NPCT = 83025

-- Distance to follow
local DISTANCE_TO_FOLLOW = 3
local ANGLE_TO_FOLLOW = math.pi  -- 180 degrees in radians, which is directly behind
local DISTANCE_TO_FOLLOWT = 3
local ANGLE_TO_FOLLOWT = math.pi  

local function DebugMessage(message)
    print("[DEBUG] " .. message)
end

local function UpdateFollowing(eventId, delay, repeats, creature)
    local following_npc_id = creature:GetEntry()
    local target_npc_id = (following_npc_id == FOLLOWING_NPC) and NPC_TO_FOLLOW or NPC_TO_FOLLOWT
    
    local target = creature:GetNearestCreature(90, target_npc_id)
    if target then
      --  DebugMessage("Updating follow for NPC " .. following_npc_id .. " to target " .. target:GetEntry())
        creature:MoveFollow(target, DISTANCE_TO_FOLLOW, ANGLE_TO_FOLLOW)
        
        local x, y, z, o = creature:GetLocation()
        creature:SetHomePosition(x, y, z, o)
     --   DebugMessage("Updated home position for NPC " .. following_npc_id)
    else
      --  DebugMessage("Target NPC " .. target_npc_id .. " not found within range.")
    end
end
local function OnFollowingNpcSpawn(event, creature)
  --  DebugMessage("Spawn event triggered for NPC " .. creature:GetEntry())
    
    creature:RegisterEvent(UpdateFollowing, 1000, 0)
end

RegisterCreatureEvent(FOLLOWING_NPC, 5, OnFollowingNpcSpawn)
RegisterCreatureEvent(FOLLOWING_NPCT, 5, OnFollowingNpcSpawn)
