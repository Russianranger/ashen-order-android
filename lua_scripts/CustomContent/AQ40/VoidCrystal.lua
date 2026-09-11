local VoidCrystal = {}

VoidCrystal.VOID_CRYSTAL_NPCID = 400166
VoidCrystal.OPTION_SUMMON_WATCHER = 0
VoidCrystal.WATCHER_CREATUREID = 815727
VoidCrystal.OTHER_CREATUREID = 15275
--VoidCrystal.SPELLID = 5
VoidCrystal.RANGE = 200
VoidCrystal.DESPAWN_TIMER = 3600000 

function VoidCrystal.GossipHello(event, player, object)
    player:GossipMenuAddItem(0, "Summon the Hidden Watcher...", VoidCrystal.OPTION_SUMMON_WATCHER, 0)
    player:GossipSendMenu(1, object)
end

function VoidCrystal.GossipSelect(event, player, object, sender, intid, code, menuid)
    if intid == VoidCrystal.OPTION_SUMMON_WATCHER then
        local creaturesInRange = object:GetCreaturesInRange(VoidCrystal.RANGE)
        
        local canSummon = true
        for _, creature in ipairs(creaturesInRange) do
            if creature:GetEntry() == VoidCrystal.WATCHER_CREATUREID or creature:GetEntry() == VoidCrystal.OTHER_CREATUREID then
                if creature:IsAlive() then
                    canSummon = false
                    break
                end
            end
        end
        
        if canSummon then
            local spawnedWatcher = object:SpawnCreature(VoidCrystal.WATCHER_CREATUREID, -8954.5459, 1234.8217, -112.62, 1.7, 3, VoidCrystal.DESPAWN_TIMER)
            -- Removed the CastSpell line
        else
            player:SendAreaTriggerMessage("A pair of powerful foes must be defeated before you can use this crystal...either that or the entity you're attempting to summon is already here.")
        end

        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(VoidCrystal.VOID_CRYSTAL_NPCID, 1, VoidCrystal.GossipHello)
RegisterCreatureGossipEvent(VoidCrystal.VOID_CRYSTAL_NPCID, 2, VoidCrystal.GossipSelect)
