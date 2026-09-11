local SurveyAlcazIsland = {}

function SurveyAlcazIsland.OnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if player:HasQuest(11142) then
        player:CompleteQuest(11142)
        player:CastSpell(player, 42295, true)
        player:SendAreaTriggerMessage("Quest Survey Alcaz Island completed.") 
        player:GossipSendMenu(11224, object, 8782) 
        player:GossipComplete() 
    else
        player:GossipSendMenu(11224, object, 8782)
		player:GossipAddQuests(object)
    end
end

RegisterCreatureGossipEvent(23704, 2, SurveyAlcazIsland.OnGossipSelect)
