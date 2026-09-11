--[[

local NPC_SPEECH_IDS = {1000070, 1000071, 1000072}
local CAGE_ID = 1000011
local KEY_ID = 800105
local POTION_SPELL_ID = 800200
local RESPAWN_TIME = 60000
local MOVE_DISTANCE = 20

local NPC_DIALOGUES = {
    [1000070] = {
        pre_release = {
            "Are you daft? I’m ACTUALLY talking to you! I can REASON with you! Can’t you see? We aren’t all mindless monsters! There is hope for the cursed!",
            "Please, what you are doing is insane! I’m proof of that! Release us! Help us with a cure!",
            "You’ve lost your minds! We need to be working together right now! For the sake of Gilneas, you’ve got to let me go!",
            "I didn’t even harm any of you! I thought I was helping! You tricked me! You KNOW that not all worgen are mindless! If you didn’t you wouldn’t have set such a trap!"
        },
        post_release = "Oh thank the Light, I never thought I’d be happy to see a <Player Race Name> like yourself. Quickly, do you have a potion? I can feel the touches of madness creeping across my mind again.",
        post_potion = "Burned last time it went down too. Eck. Thank you for your aid, <Player Class Name>!"
    },
    [1000071] = {
        pre_release = {
            "I aint no animal! You can’t…can’t….do……",
            "I need out! Out! I’m…. you don’t…understand….",
            "I…I don’t…. this isn’t good. Oh dear… this isn’t good a’tal.",
            "Please, I’m begging you! It’s…getting worse…I…I…"
        },
        post_release = "Hurry… the potion!...I’ll not…make much longer…",
        post_potion = "Oh…that was...too close. I’m… forever in your debt!"
    },
    [1000072] = {
        pre_release = {
            "Lyran Shadowpelt coughs horribly!",
            "What happens from here…is on your hands.",
            "Lyran Shadowpelt growls menacingly!",
            "You don’t know what you’ve done.",
            "Lyran Shadowpelt Let out a deafening roar!"
        },
        post_release = "Lyran Shadowpelt coughs horribly!",
        post_potion = "The worgen will roar angrily and run off into the woods, knocking you over as it bolts."
    }
}

local npcDialogueTimers = {}  -- Table to store dialogue timers for each NPC

local function OnNPCSpawn(event, creature)
    local npcID = creature:GetEntry()
    local texts = NPC_DIALOGUES[npcID]
    if texts then
        for _, text in ipairs(texts.pre_release) do
            --print("Dialogue:", text)
        end
        
        -- Set initial random timer for the next dialogue
        npcDialogueTimers[npcID] = math.random(1, 10) * 2000  -- Initial delay between 2 to 20 seconds
    end
end

local function OnNPCUpdate(event, creature, diff)
    local npcID = creature:GetEntry()
    if npcDialogueTimers[npcID] then
        npcDialogueTimers[npcID] = npcDialogueTimers[npcID] - diff
        if npcDialogueTimers[npcID] <= 0 then
            local texts = NPC_DIALOGUES[npcID]
            if texts then
                creature:SendUnitSay(texts.pre_release[math.random(#texts.pre_release)], 0)
                -- Reset timer for next dialogue with a new random interval
                npcDialogueTimers[npcID] = math.random(1, 10) * 5000  -- New delay between 2 to 20 seconds
            end
        end
    end
end

function OnGameObjectUse(event, go, player)
    print("OnGameObjectUse function called")

    -- Ensure that the player object is valid
    if not player or not player:IsPlayer() then
        print("Invalid player object")
        return
    end

    -- Check if the player has the item required to interact with the game object
    local keyItemEntry = KEY_ID
    if player:HasItem(keyItemEntry, 1) then  -- Check if the player has at least one of the key item
        -- Proceed with interacting with the game object
        print("Player has the required key item")

        if not go or go:GetEntry() ~= CAGE_ID then
            print("Invalid or wrong game object")
            return
        end

        -- Find nearby creatures within the cage
        local nearbyCreatures = go:GetCreaturesInRange(1)  -- Assumes NPCs are close to the cage
        -- Iterate over nearby creatures
        for _, npc in ipairs(nearbyCreatures) do
            if NPC_DIALOGUES[npc:GetEntry()] then
                -- Handle interaction with the NPC
                print("Interacting with NPC", npc:GetEntry())
                npc:MoveTo(1, player:GetX(), player:GetY(), player:GetZ())  -- Move to the next waypoint
                npc:SendUnitSay(NPC_DIALOGUES[npc:GetEntry()].post_release, 0)
                npc:SetData("freed", true)  -- Custom flag to mark NPC as freed
            end
        end
    else
        print("Player does not have the required key item")
        player:SendBroadcastMessage("You need the correct key to open this cage.")
    end
end

local function PotionUse(event, player, spell, skipCheck)
    if spell:GetEntry() == POTION_SPELL_ID then
        local target = player:GetSelection()
        if target and NPC_DIALOGUES[target:GetEntry()] then
            target:SendUnitSay(NPC_DIALOGUES[target:GetEntry()].post_potion, 0)
            player:KilledMonsterCredit(target:GetEntry())
            target:DespawnOrUnsummon(1000)
            player:RegisterEvent(function()
                target:Respawn()
                local cageX, cageY, cageZ = Object:GetLocation()
                target:MoveTo(0, cageX, cageY, cageZ)
                local creatures = Object:GetCreaturesInRange(20)
                for _, creature in ipairs(creatures) do
                    local dialogues = NPC_DIALOGUES[creature:GetGUIDLow()]
                    if dialogues and dialogues.pre_release then
                        creature:SendUnitSay(dialogues.pre_release[math.random(#dialogues.pre_release)], 0)
                    end
                end
            end, RESPAWN_TIME, 1)
        else
            player:SendBroadcastMessage("Invalid target for the potion.")
        end
    end
end
-- Register NPC spawn event for each NPC ID
for _, id in ipairs(NPC_SPEECH_IDS) do
    RegisterCreatureEvent(id, 5, OnNPCSpawn)
    RegisterCreatureEvent(id, 7, OnNPCUpdate)  -- Register OnNPCSpawn function for CREATURE_EVENT_ON_SPAWN
end


RegisterGameObjectEvent(CAGE_ID, 14, OnGameObjectUse)

RegisterPlayerEvent(5, PotionUse)
]]--