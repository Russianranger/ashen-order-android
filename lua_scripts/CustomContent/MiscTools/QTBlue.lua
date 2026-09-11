local npcIds = {9900003, 9900004, 9900005, 9900006, 25970, 25970, 25970, 25970, 25970, 25970}  -- Example NPC IDs
local spawnPoints = {
    {map = 0, x = -8107.21, y = 403.55, z = 119.36, o = 2.961406},
    {map = 0, x = -8098.79, y = 401.24, z = 122.99, o = 2.838605},
    {map = 0, x = -8106.76, y = 398.98, z = 119.36, o = 2.470881},
    {map = 0, x = -8104.38, y = 407.54, z = 119.36, o = 3.001339},
    {map = 0, x = -8113.00, y = 409.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 407.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 405.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 403.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8113.00, y = 401.00, z = 116.36, o = 5.993420},
    {map = 0, x = -8116.00, y = 399.00, z = 116.36, o = 5.993420}
}
local soundId = 188044
local soundDuration = 64000

-- Function to spawn the NPCs at the specified locations, with specific actions
local function SpawnNPCs(player)
    for i, npcId in ipairs(npcIds) do
        local spawnPoint = spawnPoints[i]
        local map, x, y, z, o = spawnPoint.map, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.o
        local npc = player:SpawnCreature(npcId, x, y, z, o, 2, soundDuration)
        if npc then
            npc:PlayDirectSound(soundId, player)
            if i == 1 then
                npc:EmoteState(10)  -- First NPC dances
            elseif i > 4 then
                if (i % 2 == 0) then
                    npc:EmoteState(253)  -- NPCs at even positions clap (starting from index 5)
                else
                    npc:EmoteState(4)  -- NPCs at odd positions cheer (starting from index 5)
                end
            end
            -- NPCs from index 2 to 4 do nothing (skipped intentionally)
        end
    end
end

-- Custom command to spawn NPCs and play the sound
local function OnChat(event, player, msg, _, lang)
    if msg:lower() == "#qtblue" then
        if player:IsGM() then
            SpawnNPCs(player)
            player:SendBroadcastMessage("First NPC dancing, next three do nothing, others alternating between clapping and cheering.")
        end
        return false
    end
end

RegisterPlayerEvent(18, OnChat)