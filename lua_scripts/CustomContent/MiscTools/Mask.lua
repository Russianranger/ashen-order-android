local Masks = {}

Masks.Tables = {
    Alliance_races = {1, 3, 4, 7, 11, 19, 16, 12, 14, 20}, 
    Horde_races = {2, 5, 6, 8, 10, 17, 13, 15, 9, 21}, 
    Classes = {1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15},
    Demon_Hunter_Races = {14, 15} 
}

function Masks.calculateMask(ids)
    local mask = 0
    for _, id in ipairs(ids) do
        mask = mask + 2^(id - 1)
    end
    return mask
end

function Masks.Command(event, player, command)
    if command:lower() == "masks" then
        local raceMask = player:GetRaceMask()
        local classMask = player:GetClassMask()

        print("Your race mask ID is: " .. tostring(raceMask))
        print("Your class mask ID is: " .. tostring(classMask))

        local allianceMask = Masks.calculateMask(Masks.Tables.Alliance_races)
        local hordeMask = Masks.calculateMask(Masks.Tables.Horde_races)
        local classesMask = Masks.calculateMask(Masks.Tables.Classes)

        print("The overall mask for Alliance races is: " .. tostring(allianceMask))
        print("The overall mask for Horde races is: " .. tostring(hordeMask))
        print("The overall mask for Alliance/Horde races is: " .. tostring(hordeMask + allianceMask))
        print("The overall mask for classes is: " .. tostring(classesMask))
    elseif command:lower() == "dhmask" then
        local dhMask = Masks.calculateMask(Masks.Tables.Demon_Hunter_Races)
        print("The overall mask for Demon Hunter races is: " .. tostring(dhMask))
    else
        return
    end

    return false
end

local function GetLocation(event, player, command)
    if command == "location" then
        local target = player:GetSelection()
        if target then
            local x, y, z, o = target:GetLocation()
            player:SendBroadcastMessage("Selected Unit Location: X=" .. x .. " Y=" .. y .. " Z=" .. z .. " O=" .. o)
            print("" .. x .. ", " .. y .. ", " .. z .. ", " .. o)
        else
            player:SendBroadcastMessage("No target selected.")
        end
        return false
    end
end

local function GetFLocation(event, player, command)
    if command == "flocation" then
        local target = player:GetSelection()
        if target then
            local x, y, z, o = target:GetLocation()
            player:SendBroadcastMessage("Selected Unit Location: X=" .. x .. "f Y=" .. y .. "f Z=" .. z .. "f O=" .. o .. "f")
            print("" .. x .. "f, " .. y .. "f, " .. z .. "f, " .. o .. "f")
        else
            player:SendBroadcastMessage("No target selected.")
        end
        return false
    end
end
--[[
local function SimulateLootCommand(event, player, command)
    local npcId = command:match("simloot (%d+)")
    if npcId then
        local target = player:GetSelection()
        if target then
            local x, y, z, o = target:GetLocation()
            local creature = player:SpawnCreature(tonumber(npcId), x, y, z, o, 3, 30000)
            
            if creature then
                player:CastSpell(creature, 5, true)
                player:SendBroadcastMessage("Killing NPC ID " .. npcId .. ".")
            else
                player:SendBroadcastMessage("Failed to spawn NPC ID " .. npcId .. ".")
            end
        else
            player:SendBroadcastMessage("No target selected.")
        end
    end
    return false
end
]]--
--RegisterPlayerEvent(42, SimulateLootCommand)
RegisterPlayerEvent(42, GetLocation)
RegisterPlayerEvent(42, GetFLocation)
RegisterPlayerEvent(42, Masks.Command)
