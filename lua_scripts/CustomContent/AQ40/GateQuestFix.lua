local GameObjectId = 180633 -- Crystalline Tear
local QuestId = 8519

local function OnQuestAccept(event, player, gameObject, quest)
    if quest:GetId() == QuestId then
        player:CompleteQuest(QuestId)
    end
end

RegisterGameObjectEvent(GameObjectId, 4, OnQuestAccept)
