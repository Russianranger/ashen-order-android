-- All this script does is make the spawned flame Tsunamis from the Smolder Fight move to a specified forward after a 2.5 second delay. 
-- I had to get xyz manually for all positions. I created a seperate script to spawn creatures at the tsunami starting positions so i could map them out.

local EntryId1 = 83006

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 835.78, -758.032, -223.82, 1.678
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o) -- Once they reach their waypoint, they were going back to their original position. To circumvent this I had to set their destination as the new home position.
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0) -- makes sure they don't decide to attack players
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId1, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId1, 4, Tsunami_OnDied)



local EntryId2 = 83007

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 784.62, -799.38, -224.29, 2.75
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId2, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId2, 4, Tsunami_OnDied)


local EntryId3 = 83008

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 853.5921, -863.412903, -228.707, 5
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId3, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId3, 4, Tsunami_OnDied)

local EntryId4 = 83009

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 852.236, -931.113586, -225.57, 4.88
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId4, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId4, 4, Tsunami_OnDied)


local EntryId5 = 83010

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 917.63, -781.384, -225.997, 0.168
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId5, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId5, 4, Tsunami_OnDied)


local EntryId6 = 83011

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 922.26, -818.822, -226.37, 0.213
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId6, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId6, 4, Tsunami_OnDied)


local EntryId7 = 83012

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 807.280457, -928.533, -225.45, 4.48
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId7, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId7, 4, Tsunami_OnDied)



local EntryId8 = 83013

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 735.096, -861.793, -222.235, 3.4
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId8, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId8, 4, Tsunami_OnDied)



local EntryId9 = 83014

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 724.86441, -798.594, -223.6, 2.97
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId9, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId9, 4, Tsunami_OnDied)


local EntryId10 = 83016

local function MoveToLocation(creature)
    local waypointId = 1
    local x, y, z, o = 735, -737.85, -211.493357, 2.67
    creature:MoveTo(waypointId, x, y, z)
    creature:SetHomePosition(x, y, z, o)
end

local function Tsunami_OnSpawn(event, creature)
    creature:SetReactState(0)
    creature:RegisterEvent(function(event, delay, calls, capturedCreature)
        MoveToLocation(capturedCreature)
    end, 2500, 1)
end

local function Tsunami_OnDied(event, creature, killer)
    creature:RemoveEvents()
end

RegisterCreatureEvent(EntryId10, 5, Tsunami_OnSpawn)
RegisterCreatureEvent(EntryId10, 4, Tsunami_OnDied)


local Cheater_Killer = 83020
local TARGET_Cheater_Killer = 83001
local TCHECK_RADIUS = 15
local PLAYER_RADIUS = 1000
local TSPELL_ID = 5

local function CheckForCreature(event, delay, pCall, creature)
    local targetCreatures = creature:GetCreaturesInRange(TCHECK_RADIUS, TARGET_Cheater_Killer, 0, 1)
    for _, targetCreature in pairs(targetCreatures) do
        if targetCreature:GetEntry() == TARGET_Cheater_Killer then
            local players = creature:GetPlayersInRange(PLAYER_RADIUS)
            for _, player in pairs(players) do
            creature:CastSpell(player, TSPELL_ID)
            end
            break 
        end
    end
end

local function Cheater_OnSpawn(event, creature)
    creature:RegisterEvent(CheckForCreature, 1000, 0)
end

RegisterCreatureEvent(Cheater_Killer, 5, Cheater_OnSpawn)

