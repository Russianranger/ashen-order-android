local Mothers_Milk_Quest = {}

Mothers_Milk_Quest.Quest_ID = 4866
Mothers_Milk_Quest.Aura_ID = 16468
Mothers_Milk_Quest.Creature_ID = 9563
Mothers_Milk_Quest.Spell_ID = 16472 
Mothers_Milk_Quest.RANGE = 15

function Mothers_Milk_Quest.PLAYER_EVENT_ON_COMPLETE_QUEST(event, player, quest)
    if quest:GetId() == Mothers_Milk_Quest.Quest_ID and player:HasAura(Mothers_Milk_Quest.Aura_ID) then
         player:RemoveAura(Mothers_Milk_Quest.Aura_ID)
    end
end

RegisterPlayerEvent(54, Mothers_Milk_Quest.PLAYER_EVENT_ON_COMPLETE_QUEST)