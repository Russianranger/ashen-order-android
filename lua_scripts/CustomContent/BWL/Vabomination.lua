local BOSS_ENTRY = 100184
local HEALER_MINION_ENTRY = 400153
local HEAL_RANGE = 5.0 -- in yards
local HEAL_AMOUNT = 350000 -- fixed amount of 200,000 HP
local SHADOWMEND_SPELL_ID = 25531 -- Spell ID for Shadowmend

function CheckProximityToBoss(eventId, delay, calls, healerMinion)
    local boss = healerMinion:GetNearestCreature(500, BOSS_ENTRY) -- get boss within 300 yards
    
    if boss then
        -- Check if the minion is close enough to the boss
        local x1, y1, z1 = boss:GetLocation()
        local x2, y2, z2 = healerMinion:GetLocation()
        local distance = math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)

        -- If minion is close enough, heal the boss using Shadowmend spell and despawn the minion
        if distance <= HEAL_RANGE then
            healerMinion:DealHeal(boss, SHADOWMEND_SPELL_ID, HEAL_AMOUNT, false)
            healerMinion:DespawnOrUnsummon(0)
        else
            -- If not close enough, update the movement path to the current boss location
            healerMinion:MoveTo(0, x1, y1, z1, true)
        end
    end
end

function OnHealerMinionSpawn(event, healerMinion)
    healerMinion:SetReactState(0)

    local yells = {
        "Master, me never been much good, but me save you now!",
        "Me always clumsy, but me not mess this up, master!",
        "Master, me come! Me not leave you! Me give life to you!"
    }
    local randomYell = yells[math.random(1, #yells)]

    healerMinion:SendUnitYell(randomYell, 0)

    healerMinion:RegisterEvent(CheckProximityToBoss, 1000, 0, healerMinion)
end

function OnHealerMinionEnterCombat(event, healerMinion, target)
    healerMinion:SetReactState(0)
end

function OnAbominationReset(event, abomination)
    abomination:SetReactState(0)
end

RegisterCreatureEvent(HEALER_MINION_ENTRY, 5, OnHealerMinionSpawn) 
RegisterCreatureEvent(HEALER_MINION_ENTRY, 1, OnHealerMinionEnterCombat) 
RegisterCreatureEvent(HEALER_MINION_ENTRY, 23, OnAbominationReset)