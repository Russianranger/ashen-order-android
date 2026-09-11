local REQUIRED_ALCHEMY_SKILL = 275
local NPC_SPELL_MAPPING = {
    [400191] = 17637,  -- Supreme Power
    [400192] = 17635,  -- Titans
    [400193] = 17636,  -- Distilled Wisdom
    [400194] = 817637  -- Battle Prowess
}

local function OnGossipHello_FlaskBook(event, player, creature)
    local spellId = NPC_SPELL_MAPPING[creature:GetEntry()]
    if spellId then
        if player:HasSkill(171) then
            if player:GetSkillValue(171) >= REQUIRED_ALCHEMY_SKILL then
                player:LearnSpell(spellId)
            else
                player:SendBroadcastMessage("Your alchemy skills are not developed enough to read these pages.")
            end
        else
            player:SendBroadcastMessage("You can't understand the mumbo-jumbo in these pages.")
        end
        return true 
    end
end

for npcId, _ in pairs(NPC_SPELL_MAPPING) do
    RegisterCreatureGossipEvent(npcId, 1, OnGossipHello_FlaskBook)
end