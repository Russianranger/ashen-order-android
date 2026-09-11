local function RetrieveBotGear(event, player, command)
    if command:find("getgear") then
        local _, botEntry = command:match("(%S+)%s*(%d+)")
        botEntry = tonumber(botEntry)
        if not botEntry then
            player:SendBroadcastMessage("Please provide a valid bot entry ID.")
            return false
        end

        -- Only retrieve and send the stats
        local statsQuery = string.format("SELECT maxhealth, maxpower, strength, agility, stamina, intellect, spirit, armor, defense, resHoly, resFire, resNature, resFrost, resShadow, resArcane, blockPct, dodgePct, parryPct, critPct, attackPower, spellPower, spellPen, hastePct, hitBonusPct, expertise, armorPenPct FROM characters_npcbot_stats WHERE entry = %d", botEntry)
        local statsResult = CharDBQuery(statsQuery)

        if statsResult then
            local statsData = {
                statsResult:GetUInt32(0), -- maxhealth
                statsResult:GetUInt32(1), -- maxpower
                statsResult:GetUInt32(2), -- strength
                statsResult:GetUInt32(3), -- agility
                statsResult:GetUInt32(4), -- stamina
                statsResult:GetUInt32(5), -- intellect
                statsResult:GetUInt32(6), -- spirit
                statsResult:GetUInt32(7), -- armor
                statsResult:GetUInt32(8), -- defense
                statsResult:GetUInt32(9), -- resHoly
                statsResult:GetUInt32(10), -- resFire
                statsResult:GetUInt32(11), -- resNature
                statsResult:GetUInt32(12), -- resFrost
                statsResult:GetUInt32(13), -- resShadow
                statsResult:GetUInt32(14), -- resArcane
                statsResult:GetFloat(15), -- blockPct
                statsResult:GetFloat(16), -- dodgePct
                statsResult:GetFloat(17), -- parryPct
                statsResult:GetFloat(18), -- critPct
                statsResult:GetUInt32(19), -- attackPower
                statsResult:GetUInt32(20), -- spellPower
                statsResult:GetUInt32(21), -- spellPen
                statsResult:GetFloat(22), -- hastePct
                statsResult:GetFloat(23), -- hitBonusPct
                statsResult:GetFloat(24), -- expertise
                statsResult:GetFloat(25) -- armorPenPct
            }

            local statsDataStr = table.concat(statsData, ",")
            player:SendBroadcastMessage("Gear data for botEntry " .. botEntry .. ": " .. statsDataStr)
        else
            player:SendBroadcastMessage("Bot stats not found.")
        end

        return false
    end
end

RegisterPlayerEvent(42, RetrieveBotGear)
