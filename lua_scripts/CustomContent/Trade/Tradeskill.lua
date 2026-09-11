local TraderSkills = {}

TraderSkills.NPC_ID = 500150

TraderSkills.SPELLS_AND_ITEMS = {
    { name = "Learn Alchemy",        spellId = 2259 },
    { name = "Learn Blacksmithing",  spellId = 2018, itemId = 5956 },
    { name = "Learn Cooking",        spellId = 2550 },
    { name = "Learn Enchanting",     spellId = 7411, itemId = 6218 },
    { name = "Learn First Aid",      spellId = 3273 },
    { name = "Learn Fishing",        spellId = 7620 },
    { name = "Learn Herbalism",      spellId = 9134 },
    { name = "Learn Inscription",    spellId = 45357 },
    { name = "Learn Leatherworking", spellId = 2108 },
    { name = "Learn Mining",         spellId = 2575, itemId = 2901 },
    { name = "Learn Skinning",       spellId = 8613, itemId = 7005 },
    { name = "Learn Tailoring",      spellId = 3908 },
    { name = "Learn Jewelcrafting",  spellId = 25229, itemId = 20815 }
}

function TraderSkills.OnGossipHello(event, player, creature)
    player:GossipClearMenu()
    for i, v in ipairs(TraderSkills.SPELLS_AND_ITEMS) do
        if not player:HasSpell(v.spellId) then
            player:GossipMenuAddItem(0, v.name, 0, i)
        end
    end
    player:GossipMenuAddItem(0, "Never mind...", 0, 0)
    player:GossipSendMenu(1, creature)
end

function TraderSkills.OnGossipSelect(event, player, creature, sender, intid, code, menu_id)
    if intid == 0 then
        player:GossipComplete()
        return
    end
    local spellId = TraderSkills.SPELLS_AND_ITEMS[intid].spellId
    local itemId = TraderSkills.SPELLS_AND_ITEMS[intid].itemId
    player:LearnSpell(spellId)
    if itemId then
        player:AddItem(itemId, 1)
    end
    player:GossipComplete()
end

RegisterCreatureGossipEvent(TraderSkills.NPC_ID, 1, TraderSkills.OnGossipHello)
RegisterCreatureGossipEvent(TraderSkills.NPC_ID, 2, TraderSkills.OnGossipSelect)
