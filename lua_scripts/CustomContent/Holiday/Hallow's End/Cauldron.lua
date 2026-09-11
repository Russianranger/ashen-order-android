local GOB_ID = 890021  

function GreenWitchCauldron_Gossip(event, player, object)
    local group = player:GetGroup()
    if group then
        player:SendBroadcastMessage("You need to leave your group first. This event is intended to be soloable.")
        return
    end

    local playerLevel = player:GetLevel()
    player:GossipAddQuests(object)
    if playerLevel >= 60 then
        player:GossipMenuAddItem(0, "Stir the Cauldron", 1, 1)
        player:GossipMenuAddItem(0, "Walk Away", 1, 2)
        player:GossipSendMenu(824007, object)
    else
        player:SendBroadcastMessage("You need to be at least level 60 to interact with this cauldron.")
    end
end

function GreenWitchCauldron_OnGossipSelect(event, player, object, sender, intid, code, menuid)
         if (intid == 1) then
        player:SendBroadcastMessage("You've stirred the cauldron...")
        player:CastSpell(player, 887511, true)
        local playersInRange = object:GetPlayersInRange(30)
        
        local allCreaturesInRange = object:GetCreaturesInRange(30)
        
        local creaturesInRange = {}
        for _, creature in pairs(allCreaturesInRange) do
            local id = creature:GetEntry()
            if id >= 70000 and id <= 88999 then
                table.insert(creaturesInRange, creature)
            end
        end

        for _, targetPlayer in pairs(playersInRange) do
            if targetPlayer:GetGUIDLow() ~= player:GetGUIDLow() then
                targetPlayer:CastSpell(targetPlayer, 5, true)
            end
        end

        for _, targetCreature in pairs(creaturesInRange) do
            targetCreature:CastSpell(targetCreature, 5, true)
        end


        local girlNpcIDs = {814496, 888849, 888851}
        local torchID = 187988
        local effigyID = 914401

        local radius = 30
        local girlData = {}
        local torchData = {}
        local effigyData = {}

        for _, npcID in ipairs(girlNpcIDs) do
            local npcs = object:GetCreaturesInRange(radius, npcID)
            if npcs[1] then
                npcs[1]:SendUnitSay("They come...", 0)
                table.insert(girlData, {guid = npcs[1]:GetGUID()})
            end
        end

        local torches = object:GetGameObjectsInRange(radius, torchID)
        local effigies = object:GetGameObjectsInRange(radius, effigyID)

        for _, torch in ipairs(torches) do
            table.insert(torchData, {guid = torch:GetGUID()})
        end

        for _, effigy in ipairs(effigies) do
            table.insert(effigyData, {guid = effigy:GetGUID()})
        end

        local function DespawnEntities(eventId, delay, repeats, worldobject)
            local map = worldobject:GetMap()

            for _, data in ipairs(girlData) do
                local girl = map:GetWorldObject(data.guid)
                if girl then
                    girl:DespawnOrUnsummon(0)
                end
            end

            for _, data in ipairs(torchData) do
                local torch = map:GetWorldObject(data.guid)
                if torch then
                    torch:Despawn()
                end
            end

            for _, data in ipairs(effigyData) do
                local effigy = map:GetWorldObject(data.guid)
                if effigy then
                    effigy:Despawn()
                end
            end
        end

        local function DespawnCauldron(eventId, delay, repeats, worldobject)
            worldobject:Despawn()
        end
		
		 local function SpawnNewNPC(eventId, delay, repeats, worldobject)
            local x, y, z, o = worldobject:GetLocation()
            worldobject:SpawnCreature(881853, x, y, z, o, 3, 600000)  -- 10 minutes
        end

        object:RegisterEvent(DespawnEntities, 5000, 1)  -- Despawn after 5 seconds
        object:RegisterEvent(DespawnEntities, 8000, 1)  -- Despawn torches and effigy after 8 seconds
        object:RegisterEvent(SpawnNewNPC, 9000, 1)  -- Spawn new NPC after 9 seconds

        player:GossipComplete()
    elseif intid == 2 then
        player:SendBroadcastMessage("Wise choice. You walk away from the cauldron.")
        player:GossipComplete()
    end
end

RegisterGameObjectGossipEvent(GOB_ID, 1, GreenWitchCauldron_Gossip)
RegisterGameObjectGossipEvent(GOB_ID, 2, GreenWitchCauldron_OnGossipSelect)




