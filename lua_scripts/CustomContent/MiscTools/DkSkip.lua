local DkStartingSkip = {}

function DkStartingSkip.OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    player:GossipMenuAddItem(0, "Skip the DK starting area", 1, 1)
    player:GossipSendMenu(1, creature)
end

function DkStartingSkip.OnGossipSelect(event, player, creature, sender, intid, code)
    if intid == 1 then
        player:GossipClearMenu()
        player:GossipMenuAddItem(0, "Are you sure you want to skip the DK starting area?", 1, 2)
        player:GossipMenuAddItem(0, "No, take me back.", 1, 3)
        player:GossipSendMenu(1, creature)
    elseif intid == 2 then
        local faction = player:GetTeam()
		player:LearnSpell(50977) -- Teach spell
        player:LearnSpell(48778) -- Teach spell
        if faction == 0 then -- Alliance
            player:AddQuest(13188)
            player:SendBroadcastMessage("You have been given the quest to skip the DK starting area. Complete the quest and relog for talent points.")
            player:CastSpell(player, 3561, true) -- Teleport to Stormwind
        else -- Horde
            player:AddQuest(13189)
            player:SendBroadcastMessage("You have been given the quest to skip the DK starting area. Complete the quest and relog for talent points.")
            player:CastSpell(player, 3567, true) -- Teleport to Orgrimmar
        end
        player:GossipComplete()
    elseif intid == 3 then
        player:GossipComplete() 
    end
end

RegisterCreatureGossipEvent(820066, 1, DkStartingSkip.OnGossipHello)
RegisterCreatureGossipEvent(820066, 2, DkStartingSkip.OnGossipSelect)
