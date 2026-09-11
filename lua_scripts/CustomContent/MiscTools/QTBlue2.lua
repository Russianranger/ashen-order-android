-- Credits to Belgarth

local npcIds = {9900003, 9900004, 9900005, 9900006, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642, 1642}  -- Example NPC IDs
local spawnPoints = {
    {map = 0, x = -8107.21, y = 403.55, z = 119.36, o = 2.961406},
    {map = 0, x = -8098.79, y = 401.24, z = 122.99, o = 2.838605},
    {map = 0, x = -8106.76, y = 398.98, z = 119.36, o = 2.470881},
    {map = 0, x = -8104.38, y = 407.54, z = 119.36, o = 3.001339},
    {map = 0, x = -8113.00, y = 409.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 407.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 405.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 403.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8117.00, y = 409.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8117.00, y = 407.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8117.00, y = 405.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8117.00, y = 403.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8115.00, y = 406.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8115.00, y = 404.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8115.00, y = 402.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 401.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8114.00, y = 398.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 399.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8118.00, y = 399.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8116.00, y = 399.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8114.00, y = 410.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 411.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8118.00, y = 410.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8116.00, y = 411.00, z = 116.36, o = 5.993420}
}
local soundId = 188045 -- Sound ID to play
local soundDuration = 164000 -- Duration of the sound in milliseconds
local BUNNY_NPC_ID = 9900008  -- ID for the invisible bunny

-- Function to spawn NPCs triggered by the invisible bunny
function SpawnNPCsFromBunny(bunny)
    print("Bunny has spawned and is initiating NPC spawns.")
    for i, npcId in ipairs(npcIds) do
        local spawnPoint = spawnPoints[i]
        local npc = bunny:SpawnCreature(npcId, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.o, 2, soundDuration)
        if npc then
            print("Spawned NPC with ID " .. npcId .. " at index " .. i)
            npc:PlayDirectSound(soundId, bunny)  -- Assume sound should be heard by nearby players or bunny itself
            if i == 1 then
                npc:EmoteState(10)  -- First NPC dances
                npc:AddAura(200172, npc)  -- Apply the aura with both arguments
            elseif i > 4 then
                npc:EmoteState(i % 2 == 0 and 10 or 4)  -- NPCs at even positions clap, odd positions cheer
            end
        else
            print("Failed to spawn NPC with ID " .. npcId .. " at index " .. i)
        end
    end
end

function OnBunnySpawn(event, bunny)
    if bunny:GetEntry() == BUNNY_NPC_ID then
        SpawnNPCsFromBunny(bunny)
    end
end

RegisterCreatureEvent(BUNNY_NPC_ID, 5, OnBunnySpawn)  