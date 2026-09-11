local A = {}

function A.OnGossipHello(event, player, unit)
    unit:SendUnitSay("Return your legendary bracers for the original ones here!", 0)

    if player:HasItem(860094) or player:HasItem(861094) then
        player:GossipMenuAddItem(0, "Original Legendary Druid bracers", 0, 1)
    end
    if player:HasItem(860101) or player:HasItem(861101) then
        player:GossipMenuAddItem(0, "Original Legendary Paladin bracers", 0, 2)
    end
    if player:HasItem(860102) then
        player:GossipMenuAddItem(0, "Original Legendary Warrior bracers", 0, 3)
    end
    if player:HasItem(860105) or player:HasItem(961105) then
        player:GossipMenuAddItem(0, "Original Legendary Shaman bracers", 0, 4)
    end
    if player:HasItem(860106) then
        player:GossipMenuAddItem(0, "Original Legendary Priest bracers", 0, 5)
    end

    player:GossipSendMenu(3000002, unit)
end

function A.OnGossipSelect(event, player, unit, sender, intid, code)
    print("OnGossipSelect called with intid: ", intid)
    local subject = "Bracer Exchange"
    local text = "Here are your original bracers, as requested."
    local receiverGUID = player:GetGUIDLow()
    local senderGUID = player:GetGUIDLow() 
    local stationary = 62 

    if intid >= 1 and intid <= 5 then
        local itemEntry = 0
        local removeItem1 = 0
        local removeItem2 = 0

        if intid == 1 then
            removeItem1, removeItem2, itemEntry = 860094, 861094, 60094
        elseif intid == 2 then
            removeItem1, removeItem2, itemEntry = 860101, 861101, 60101
        elseif intid == 3 then
            removeItem1, itemEntry = 860102, 60102
        elseif intid == 4 then
            removeItem1, removeItem2, itemEntry = 860105, 961105, 60105
        elseif intid == 5 then
            removeItem1, itemEntry = 860106, 60106
        end

        if removeItem1 ~= 0 then
            player:RemoveItem(removeItem1, 1)
        end
        if removeItem2 ~= 0 then
            player:RemoveItem(removeItem2, 1)
        end

        print("Attempting to send mail with itemEntry: ", itemEntry)
        local itemGUIDlow = SendMail(subject, text, receiverGUID, senderGUID, stationary, 0, 0, 0, itemEntry, 1)
        if itemGUIDlow then
            print("Mail sent successfully.")
            player:SendBroadcastMessage("Your replacement bracers have been mailed to you.")
        else
            print("Failed to send mail.")
        end
    else
        print("Invalid intid: ", intid)
    end

    player:GossipComplete()
end

RegisterCreatureGossipEvent(410266, 1, A.OnGossipHello)
RegisterCreatureGossipEvent(410266, 2, A.OnGossipSelect)

legendarybracers = A
