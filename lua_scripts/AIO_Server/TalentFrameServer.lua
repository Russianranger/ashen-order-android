local TALENT_LEVELS = {15, 30, 45, 60, 70, 80} -- This determines how many rows of choices there are and at what milestones you unlock them. Needs to match the server config.
local CLASS_TALENTS = { -- Insert the spell IDs for each class, corresponding to the numbers in TALENT_LEVELS. Default is 3 per row but this can be changed by adjusting "numCols" further down. Needs to match the server config.
    [1] = { -- Warrior
        [15] = {12294, 23881, 23922},
        [30] = {12296, 12323, 12975},
        [45] = {29834, 16487, 29787},
        [60] = {64976, 60970, 57499},
        [70] = {29623, 29801, 20243},
        [80] = {46924, 46917, 46968},
    },
    [2] = { -- Paladin
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [3] = { -- Hunter
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [4] = { -- Rogue
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [5] = { -- Priest
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [6] = { -- Death Knight
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [7] = { -- Shaman
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [8] = { -- Mage
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [9] = { -- Warlock
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },
    [11] = { -- Druid
        [15] = {},
        [30] = {},
        [45] = {},
        [60] = {},
        [70] = {},
        [80] = {},
    },	
}

-- NOTE: Spells with the "do not display" flag WILL be taught but there is no message in the log and the icon won't turn to color when learned. Uncheck that flag in your dbc if you want that to work (or come up with a fix and PM me)
-- NOTE: If you use ranked spells as a non-mana class (since only the highest known rank show up in their spellbook) then the icon saturation won't work either once you learn a higher rank of the spell

local USE_ITEM_FOR_RESET = 0  -- 1 = Use item for reset, 0 = No item required
local RESET_ITEM_ID = 0  -- Replace with the actual item ID required for reset
local RESET_BONUS_ABILITIES = 0  -- 1 = Reset bonus abilities with talent reset, 0 = Do not reset bonus abilities

AIO.AddHandlers("TalentHandler", {
    LearnTalentSpell = function(player, spellId, levelRequired, classId)
        if player and spellId and levelRequired and classId then
            if player:IsDead() then
                player:SendBroadcastMessage("Unable to learn talents while dead.")
                return
            end

            local playerClass = player:GetClass()
            local playerLevel = player:GetLevel()

            if playerClass == classId and playerLevel >= levelRequired then
                local validSpell = false
                local learnedSpells = CLASS_TALENTS[classId][levelRequired]

                for _, validSpellId in ipairs(learnedSpells) do
                    if validSpellId == spellId then
                        validSpell = true
                        break
                    end
                end

                if validSpell then
                    for _, spell in ipairs(learnedSpells) do
                        if player:HasSpell(spell) then
                            player:SendBroadcastMessage("You already know a spell from this tier.")
                            return
                        end
                    end

                    player:LearnSpell(spellId)
                    player:SendBroadcastMessage("You have learned the talent spell: " .. GetSpellLink(spellId))
                else
                    player:SendBroadcastMessage("Invalid spell for your class or level.")
                end
            else
                player:SendBroadcastMessage("You do not meet the requirements to learn this spell.")
            end
        end
    end,

    LearnSelectedTalents = function(player, selectedTalents)
        for row, choice in pairs(selectedTalents) do
            local levelRequired = TALENT_LEVELS[row]
            local spellId = CLASS_TALENTS[player:GetClass()][levelRequired][choice]
            TalentHandler.LearnTalentSpell(player, spellId, levelRequired, player:GetClass())
        end
    end,

    ResetTalents = function(player)
        if player:IsDead() then
            player:SendBroadcastMessage("Unable to reset talents while dead.")
            AIO.Handle(player, "TalentHandler", "ResetTalentsResponse", false)
            return
        end

        if player:IsInCombat() then
            player:SendBroadcastMessage("Unable to reset talents while in combat.")
            AIO.Handle(player, "TalentHandler", "ResetTalentsResponse", false)
            return
        end

        local classId = player:GetClass()
        local spellsToUnlearn = {}
        local hasLearnedAnySpell = false

        for level, talents in pairs(CLASS_TALENTS[classId]) do
            for _, spellId in ipairs(talents) do
                if player:HasSpell(spellId) then
                    table.insert(spellsToUnlearn, spellId)
                    hasLearnedAnySpell = true
                end
            end
        end

        if not hasLearnedAnySpell then
            player:SendBroadcastMessage("You have not learned any talents.")
            AIO.Handle(player, "TalentHandler", "ResetTalentsResponse", false)
            return
        end

        if USE_ITEM_FOR_RESET == 1 then
            if player:GetItemCount(RESET_ITEM_ID) == 0 then
                player:SendBroadcastMessage("You need an item to reset your talents.")
                AIO.Handle(player, "TalentHandler", "ResetTalentsResponse", false)
                return
            else
                player:RemoveItem(RESET_ITEM_ID, 1)
            end
        end

        for _, spellId in ipairs(spellsToUnlearn) do
            player:RemoveSpell(spellId)
        end

        player:SendBroadcastMessage("Talent points reset.")
        AIO.Handle(player, "TalentHandler", "ResetTalentsResponse", true)
    end,

ResetIndividualTalent = function(player, spellId)
    if player:IsDead() then
        player:SendBroadcastMessage("Unable to reset talents while dead.")
        AIO.Handle(player, "TalentHandler", "ResetIndividualTalentResponse", false)
        return
    end

    if player:IsInCombat() then
        player:SendBroadcastMessage("Unable to reset talents while in combat.")
        AIO.Handle(player, "TalentHandler", "ResetIndividualTalentResponse", false)
        return
    end

    local spellKnown = player:HasSpell(spellId)
    local itemAvailable = player:GetItemCount(RESET_ITEM_ID) > 0

    if USE_ITEM_FOR_RESET == 1 then
        if not itemAvailable then
            player:SendBroadcastMessage("You need an item to reset your talent.")
            AIO.Handle(player, "TalentHandler", "ResetIndividualTalentResponse", false)
            return
        end
    end

    if spellKnown then
        -- Remove the spell first
        player:RemoveSpell(spellId)

        -- Now remove the item if required
        if USE_ITEM_FOR_RESET == 1 and itemAvailable then
            player:RemoveItem(RESET_ITEM_ID, 1)
        end

        player:SendBroadcastMessage("You have reset the talent spell: " .. GetSpellLink(spellId))
        AIO.Handle(player, "TalentHandler", "ResetIndividualTalentResponse", true)
    else
        player:SendBroadcastMessage("You do not know this spell.")
        AIO.Handle(player, "TalentHandler", "ResetIndividualTalentResponse", false)
    end
end

})

local function OnPlayerTalentsReset(event, player)
    if RESET_BONUS_ABILITIES == 1 then
        local classId = player:GetClass()
        local spellsToUnlearn = {}
        
        for level, talents in pairs(CLASS_TALENTS[classId]) do
            for _, spellId in ipairs(talents) do
                if player:HasSpell(spellId) then
                    table.insert(spellsToUnlearn, spellId)
                end
            end
        end
        
        for _, spellId in ipairs(spellsToUnlearn) do
            player:RemoveSpell(spellId)
        end
        
        player:SendBroadcastMessage("Talent points reset.")
    end
end

RegisterPlayerEvent(17, OnPlayerTalentsReset)
