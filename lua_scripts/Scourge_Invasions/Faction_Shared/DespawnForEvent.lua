local DespawnScript = {}

DespawnScript.MAIN_NPC_ID = 296920
DespawnScript.TARGET_NPC_IDS = {32666, 32667, 31144, 31146, 3338, 3615, 931, 10037}
DespawnScript.DESPAWN_DELAY = 0 -- Immediate despawn
DespawnScript.DESPAWN_INTERVAL = 5000 -- 5 seconds in milliseconds
DespawnScript.DESPAWN_RANGE = 40 -- in yards


function DespawnScript.DespawnTargetNPCs(creature)
    for _, npcId in ipairs(DespawnScript.TARGET_NPC_IDS) do
        local targets = creature:GetCreaturesInRange(DespawnScript.DESPAWN_RANGE, npcId)
        for _, target in ipairs(targets) do
            target:DespawnOrUnsummon(DespawnScript.DESPAWN_DELAY)
        end
    end
end


function DespawnScript.RepeatedDespawn(eventId, delay, repeats, creature)
    DespawnScript.DespawnTargetNPCs(creature)
end

function DespawnScript.OnMainNPCCreate(event, creature)
    DespawnScript.DespawnTargetNPCs(creature)
    creature:RegisterEvent(DespawnScript.RepeatedDespawn, DespawnScript.DESPAWN_INTERVAL, 0)
end

RegisterCreatureEvent(DespawnScript.MAIN_NPC_ID, 5, DespawnScript.OnMainNPCCreate)
