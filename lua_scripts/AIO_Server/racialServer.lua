local AIO = AIO or require("AIO")







local enableItem = false  -- set to true if you want to use an item to remove racial
local itemRequired = 4540 -- item required to remove racial
local amountRequired = 1  -- amount of item required to remove racial

local IsNpc = true       --  set to true if you want to use an npc to open UI at
local npcEntry = 98888    --  npc entry to open UI at

local racialHandler = AIO.AddHandlers("RACIAL_SERVER", {})

local PLAYER_EVENT_ON_LOGIN = 30

----------------------------------------------------------
-----------------[Npc Interaction]------------------------
----------------------------------------------------------
if IsNpc then
    local function creatureOnSpawn(event, creature) creature:SetNPCFlags(3) end

    local CREATURE_EVENT_ON_MOVE_IN_LOS = 27

    local GOSSIP_EVENT_ON_HELLO         = 1
    local GOSSIP_EVENT_ON_SELECT        = 2
    local CREATURE_EVENT_ON_SPAWN       = 5
    local menuId                        = 0x7FFFFFFF


    local isWindowOpen = false -- add this global variable



    local function creatureOnMoveInLos(event, creature, object)
        if (object:GetObjectType() == "Player") then
            if object:GetDistance(creature) < 2 then
                -- dismount player if mounted
                if object:IsMounted() then
                    object:Dismount()
                end
                return false
            end
            if object:GetDistance(creature) > 2 then
                if isWindowOpen then     -- add this check to only close the window when it's open
                    AIO.Handle(object, "RACIAL_CLIENT", "racialCloseUI")
                    isWindowOpen = false -- set the global variable to false when the window is closed
                end
                return false
            elseif isWindowOpen then -- add this check to only execute the rest of the function when the window is open
                return false
            end
        end
    end

    local function helloOnVendor(event, player, object)
        if (player:IsInCombat() and player:InBattleground() == true) then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
            return false
        end

        AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
        isWindowOpen = true -- set the global variable to true when the window is opened
        -- player:GossipSendMenu(menuId, object)
    end

    -- local function vendorOnSelection(event, player, object, sender, intid, code)
    --     if (intid == 1) then
    --         -- send menu for racial change

    --         AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
    --         player:GossipComplete()
    --     elseif (intid == 2) then -- add this line to handle the new option
    --         -- AIO.Handle(player, "RACIAL_SERVER", "racialOpenUI")
    --         player:GossipComplete()
    --     elseif (intid == 999) then
    --         player:GossipComplete()
    --     end
    -- end

    RegisterCreatureEvent(npcEntry, CREATURE_EVENT_ON_MOVE_IN_LOS, creatureOnMoveInLos)
    RegisterCreatureEvent(npcEntry, CREATURE_EVENT_ON_SPAWN, creatureOnSpawn)
    RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_HELLO, helloOnVendor)
    -- RegisterCreatureGossipEvent(npcEntry, GOSSIP_EVENT_ON_SELECT, vendorOnSelection)
end

--  handle player's first login
local function onPlayerFirstLogin(event, player)
    AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, onPlayerFirstLogin)

----------------------------------------------------------
-----------------[End of Interaction]---------------------
----------------------------------------------------------

    local professionSpells = {
        [20593] = true, [20552] = true, [28877] = true, [28875] = true, [69045] = true,
        [68978] = true, [255667] = true, [878241] = true, [878242] = true, [878243] = true,
        [100117] = true, [100118] = true, [100105] = true
    }


local function hasRequiredItem(player)
    if enableItem then
        return player:HasItem(itemRequired)
    else
        return true
    end
end

function racialHandler.racialActivate(player, spellId, itemType)
    if player:IsInCombat() or player:InBattleground() then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat!")
        return false
    end

    local costToActivate = 10000
    -- Level check for gold deduction
    if player:GetLevel() > 11 then
        if player:GetCoinage() < costToActivate then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You don't have enough gold to activate this racial!")
            return false
        end
        -- Deduct gold if level is above 11
        player:ModifyMoney(-costToActivate)
    end
	
    -- Check and apply the cooldown for learning profession spells
    if professionSpells[spellId] and not player:HasAura(882053) then
        player:AddAura(882053, player)
    end

    local groupedSpells = {312372, 312370} -- Spells that should be considered as one
    local isGroupedSpell = false

    -- Check if the spell is in the groupedSpells list
    for _, id in ipairs(groupedSpells) do
        if spellId == id then
            isGroupedSpell = true
            break
        end
    end

    -- Special handling for grouped spells
    if isGroupedSpell then
        local hasOneOfGroupedSpells = false

        -- Check if the player already has one of the grouped spells
        for _, id in ipairs(groupedSpells) do
            if player:HasSpell(id) then
                hasOneOfGroupedSpells = true
                break
            end
        end

        -- If the player already has one of the grouped spells, do not proceed
        if hasOneOfGroupedSpells then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can only choose one of the grouped racial spells!")
            return false
        else
            -- Learn both spells but count as one
            for _, id in ipairs(groupedSpells) do
                player:LearnSpell(id)
            end
        end
    else
        -- Regular handling for non-grouped spells
        if player:HasSpell(spellId) then
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You already have this racial!")
            return false
        end
        player:LearnSpell(spellId)
    end

    player:SaveToDB()
end

function racialHandler.racialDeactivate(player, spellId, itemType)
    if (player:IsInCombat() or player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    -- Check for the dummy aura when attempting to unlearn a profession spell
    if professionSpells[spellId] and player:HasAura(882053) then
        local aura = player:GetAura(882053)
        local remainingTime = aura:GetDuration() / 1000  -- Convert milliseconds to seconds
        local minutes = math.floor(remainingTime / 60)
        local seconds = remainingTime % 60
        player:SendBroadcastMessage(string.format("|cff00ff00[World]|r |cffff0000You must wait %d minutes and %d seconds before unlearning profession spells again.", minutes, seconds))
        return false
    end

    -- Removing the spell or item based on itemType
    if itemType == "spell" then
        player:RemoveSpell(spellId)
    elseif itemType == "item" then
        player:RemoveItem(spellId, 1)
    end

    player:SaveToDB()
end

function racialHandler.unLearnAllRacials(player, spellId, itemType)
    if (player:IsInCombat() and player:InBattleground() == true) then
        player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000You can't use racial while in combat !")
        return false
    end

    if not hasRequiredItem(player) then
        player:SendBroadcastMessage(
            "|cff00ff00[World]|r |cffff0000You don't have |cffff0000|cff00ff00 " ..
            GetItemLink(itemRequired) .. " |cffff0000 |cffff0000in your inventory!"
        )
    else
        if itemType == "spell" then
            player:RemoveSpell(spellId)
        elseif itemType == "item" then
            player:RemoveItem(spellId, 1)
            player:SendBroadcastMessage("|cff00ff00[World]|r |cffff0000 have removed " ..
                GetItemLink(spellId) .. " |cffff0000Racial item!")
        end

        player:RemoveItem(itemRequired, amountRequired)


        player:SaveToDB()
    end
end

local function showWindowPls(event, player, command)
    if (command == "rc") then
        AIO.Handle(player, "RACIAL_CLIENT", "racialOpenUI")
        return false
    end
end

RegisterPlayerEvent(42, showWindowPls)
