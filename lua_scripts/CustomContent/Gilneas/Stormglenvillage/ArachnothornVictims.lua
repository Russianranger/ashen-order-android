--[[
GilneasSpiderQuest = {}

GilneasSpiderQuest.CreatureEntry = 1000065
GilneasSpiderQuest.SpawnID1 = 1000066
GilneasSpiderQuest.SpawnID2 = 1000067
GilneasSpiderQuest.QuestID = 100025
GilneasSpiderQuest.CLOSE_DISTANCE = 15

GilneasSpiderQuest.ThankingMessages = {
    "Thanks for saving me, $N, from the terrible Arachnothorn Webs! I will now go back to Stormglen!",
    "I owe you my life, $N! The Arachnothorn Webs were no place for me. Off to Stormglen I go!",
    "$N, your bravery knows no bounds! Freed from the Arachnothorn Webs, I return to Stormglen!",
    "By your hand, I'm saved, $N! The Arachnothorn Webs will haunt me no more. To Stormglen, my journey leads!",
    "Oh, thank the Light! I thought I was going to be eaten next! Someone came! Someone actually came! Thank you!",
    "Didn’t expect a Worgen to rescue me, but you look right proper, so I’ll take it. Thanks!",
    "I’m free! You’ve spared me a gruesome death, friend. Thank you!",
    "AHH! Please don’t eat me!!!"
}

GilneasSpiderQuest.LateConsumeMessage = "The feast is complete, the villager now woven into our silken embrace."

function GilneasSpiderQuest.OnDeath(event, creature, killer)
    local chance = math.random(100)
    if chance <= 30 then
        creature:SpawnCreature(GilneasSpiderQuest.SpawnID1, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 2, 60000)
    elseif chance <= 60 then
        creature:SpawnCreature(GilneasSpiderQuest.SpawnID2, creature:GetX(), creature:GetY(), creature:GetZ(), creature:GetO(), 3, 60000)
    else
        creature:SendUnitYell(GilneasSpiderQuest.LateConsumeMessage, 0)
    end
end

function GilneasSpiderQuest.OnSpawn(event, creature)
    creature:RegisterEvent(GilneasSpiderQuest.CheckForNearbyPlayers, 1000, 1)
    if event == 5 and creature:GetEntry() == GilneasSpiderQuest.SpawnID1 then -- Only aggressive for SpawnID1
        local player = creature:GetNearestPlayer(50.0)
        if player then
            creature:AttackStart(player)
        end
    end
end

function GilneasSpiderQuest.CheckForNearbyPlayers(event, delay, repeat_times, creature)
    local playersInRange = creature:GetPlayersInRange(GilneasSpiderQuest.CLOSE_DISTANCE)
    for _, player in ipairs(playersInRange) do
        if player:HasQuest(GilneasSpiderQuest.QuestID) then  
            GilneasSpiderQuest.SendRandomThankingMessage(creature)
            player:KilledMonsterCredit(creature:GetEntry())
            creature:MoveTo(1, -2375.753174, 1321.119873, 1.0, true)
            creature:DespawnOrUnsummon(6000)
        end
    end
end

function GilneasSpiderQuest.SendRandomThankingMessage(creature)
    local player = creature:GetNearestPlayer(30.0)
    if player then
        local messageIndex = math.random(#GilneasSpiderQuest.ThankingMessages)
        local message = GilneasSpiderQuest.ThankingMessages[messageIndex]:gsub("$N", player:GetName())
        creature:SendUnitSay(message, 0)
    end
end

RegisterCreatureEvent(GilneasSpiderQuest.CreatureEntry, 4, GilneasSpiderQuest.OnDeath)
RegisterCreatureEvent(GilneasSpiderQuest.SpawnID1, 5, GilneasSpiderQuest.OnSpawn)
RegisterCreatureEvent(GilneasSpiderQuest.SpawnID1, 4, GilneasSpiderQuest.OnSpawn) 
RegisterCreatureEvent(GilneasSpiderQuest.SpawnID2, 5, GilneasSpiderQuest.OnSpawn)
]]--