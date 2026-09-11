local WorgenGuard = {}

WorgenGuard.NPC_ID = 1000032

function WorgenGuard.GossipHello(event, player, unit)
    player:GossipClearMenu()
    player:GossipAddQuests(unit)
    player:GossipMenuAddItem(0, "You seem concerned. What's the situation?", 0, 1)
    player:GossipSendMenu(1, unit)
end

function WorgenGuard.GossipSelect(event, player, unit, sender, intid, code)
    player:GossipClearMenu()
    if (intid == 1) then
        unit:SendUnitSay("It's truly heart-wrenching. Those within the cage are our brethren, afflicted by the Worgen curse. They've yet to receive the Potion of Lucidity, and their sanity remains lost.", 0)
        player:GossipMenuAddItem(0, "Have they posed a threat?", 0, 2)
    elseif (intid == 2) then
        unit:SendUnitSay("Unfortunately, in their current state, they can be unpredictable. Some have acted out, unintentionally causing harm. The anguish they'll feel when they come to...it's unbearable to think about.", 0)
        player:GossipMenuAddItem(0, "Is there hope for a full recovery?", 0, 3)
    elseif (intid == 3) then
        unit:SendUnitSay("We are fervently working on it, but a complete cure remains elusive. The Potion of Lucidity offers temporary reprieve, but it's not a permanent solution.", 0)
        player:GossipMenuAddItem(0, "Any updates from Gilneas City?", 0, 4)
    elseif (intid == 4) then
        unit:SendUnitSay("Communications are limited. Out here in Duskhaven, we're largely on our own. It's a challenging ordeal, but we won't give up hope.", 0)
        player:GossipMenuAddItem(0, "Your dedication is commendable. Stay vigilant.", 0, 5)
    elseif (intid == 5) then
        unit:SendUnitSay("We do what we must for the sake of our people. Farewell, traveler.", 0)
        player:CastSpell(player, 25898, true)  
        player:GossipComplete()
    end
    if (intid ~= 5) then
        player:GossipSendMenu(1, unit)
    end
end

RegisterCreatureGossipEvent(WorgenGuard.NPC_ID, 1, WorgenGuard.GossipHello)
RegisterCreatureGossipEvent(WorgenGuard.NPC_ID, 2, WorgenGuard.GossipSelect)
