local SocketExchanger = {}

SocketExchanger.NPC_ID = 190015
SocketExchanger.PLAN_ITEM_ID = 812692
SocketExchanger.REQUIRED_ITEM_ID = 17010
SocketExchanger.REQUIRED_ITEM_AMOUNT = 50
SocketExchanger.REQUIRED_SKILL_ID = 164 
SocketExchanger.REQUIRED_SKILL_LEVEL = 275

function SocketExchanger.OnGossipHello(event, player, creature)
    if player:GetSkillValue(SocketExchanger.REQUIRED_SKILL_ID) >= SocketExchanger.REQUIRED_SKILL_LEVEL then
        player:GossipMenuAddItem(0, "Would you like to trade 50 Fiery Cores for the plans to Socket Punch?", 0, 1)
        player:GossipSendMenu(1, creature)
    else
        creature:SendUnitSay("You need at least 275 skill in Blacksmithing to get what I'm offering.", 0)
        player:GossipComplete()
    end
end

function SocketExchanger.OnGossipSelect(event, player, creature, sender, intid, code, menuid)
    if (intid == 1) then
      --  creature:SendUnitSay("Are you sure you want to exchange 10 Fiery Cores for the Socket Punch plans?", 0)
        player:GossipMenuAddItem(0, "Yes, please.", 0, 2)
        player:GossipMenuAddItem(0, "No, thank you.", 0, 3)
        player:GossipSendMenu(1, creature)
    elseif (intid == 2) then
        if (player:GetItemCount(SocketExchanger.REQUIRED_ITEM_ID) >= SocketExchanger.REQUIRED_ITEM_AMOUNT) then
            player:RemoveItem(SocketExchanger.REQUIRED_ITEM_ID, SocketExchanger.REQUIRED_ITEM_AMOUNT)
            player:AddItem(SocketExchanger.PLAN_ITEM_ID, 1)
            creature:SendUnitSay("The Socket Punch plans are now in your inventory.", 0)
            player:GossipComplete()
        else
            creature:SendUnitSay("It looks like you don't have enough Fiery Cores.", 0)
            player:GossipComplete()
        end
    elseif (intid == 3) then
        player:GossipComplete()
    end
end

RegisterCreatureGossipEvent(SocketExchanger.NPC_ID, 1, SocketExchanger.OnGossipHello)
RegisterCreatureGossipEvent(SocketExchanger.NPC_ID, 2, SocketExchanger.OnGossipSelect)
