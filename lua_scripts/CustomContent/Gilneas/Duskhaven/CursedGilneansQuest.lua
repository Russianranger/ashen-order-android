--[[

CursedGilneansQuest = {}  

CursedGilneansQuest.QUEST_ID = 100003
CursedGilneansQuest.SPELL_ID = 800200
CursedGilneansQuest.NPC_ID = 1000009
CursedGilneansQuest.AURA_ID = 75215
CursedGilneansQuest.HOSTILE_FACTION = 1630
CursedGilneansQuest.FRIENDLY_FACTION = 11

CursedGilneansQuest.DIALOGUE_OPTIONS = {
	"Awakened from a nightmare, only to find it was real... what have I done?",
    "The clarity is a curse itself; I remember every scream, every drop of blood...",
    "Free from one curse, now trapped in another of guilt and haunting memories...",
    "My hands are my own again, yet they are stained with the blood of my family...",
    "The beast's eyes were mine...I saw what it did, what I did...",
    "A mind unshackled, but a soul forever torn by the horrors I inflicted...",
    "I've returned to myself, only to live with the ghosts of my unforgivable past..."
}

function CursedGilneansQuest.OnSpellCast(event, player, spell, skipCheck)
    if player and player:IsPlayer() then
        local target = player:GetSelection()

        if spell:GetEntry() == CursedGilneansQuest.SPELL_ID then
            if not target or target:GetEntry() ~= CursedGilneansQuest.NPC_ID or target:GetFaction() ~= CursedGilneansQuest.FRIENDLY_FACTION then
                spell:Cancel()
                player:SendBroadcastMessage("That's the wrong target!")
                return
            end

            local targetGUID = target:GetGUID()
            local playerGUID = player:GetGUIDLow()  -- Capture the player's GUID

            local function CureOrHostileAfterDelay(eventId, delay, repeats)
                local curPlayer = GetPlayerByGUID(playerGUID)  -- Retrieve the player object using the GUID
                if not curPlayer or not curPlayer:IsPlayer() then  -- Check if the player is still valid
                    return
                end

                local curTarget = curPlayer:GetSelection()
                if not curTarget or curTarget:GetGUID() ~= targetGUID or curTarget:IsDead() then
                    return
                end

                if math.random(1, 4) ~= 1 then
                    -- 75% Successful Cure
                    curPlayer:KilledMonsterCredit(CursedGilneansQuest.NPC_ID)
                    curTarget:RemoveAura(CursedGilneansQuest.AURA_ID)
                    local dialogue = CursedGilneansQuest.DIALOGUE_OPTIONS[math.random(1, #CursedGilneansQuest.DIALOGUE_OPTIONS)]
                    curTarget:SendUnitSay(dialogue, 0)
                    curTarget:DespawnOrUnsummon(5000)
                else
                    -- 25% Turn Hostile
                    curTarget:RemoveAura(CursedGilneansQuest.AURA_ID)
                    curTarget:SetFaction(CursedGilneansQuest.HOSTILE_FACTION)
                    curTarget:AttackStart(curPlayer)
                end
            end

            player:RegisterEvent(CureOrHostileAfterDelay, 3000, 1)
        end
    end
end

function CursedGilneansQuest.OnLeaveCombat(event, creature)
    creature:SetFaction(CursedGilneansQuest.FRIENDLY_FACTION)
end

function CursedGilneansQuest.OnSpawn(event, creature)
    creature:SetFaction(CursedGilneansQuest.FRIENDLY_FACTION)
end

RegisterPlayerEvent(5, CursedGilneansQuest.OnSpellCast)
RegisterCreatureEvent(CursedGilneansQuest.NPC_ID, 2, CursedGilneansQuest.OnLeaveCombat)
RegisterCreatureEvent(CursedGilneansQuest.NPC_ID, 5, CursedGilneansQuest.OnSpawn)  
]]--