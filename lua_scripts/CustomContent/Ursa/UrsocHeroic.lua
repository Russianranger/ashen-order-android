local UrsocH = {}
local NPCID = 900640

-- Constants for spell IDs
local ROARING_CACOPHONY = 900640
local BARRELING_CHARGE = 900661
local REND_FLESH = 900662
local ENRAGE_SPELL = 47008
local SOFTENRAGE_SPELL = 900663
local TORMENTED_GUARDIAN = 900664

local isCasting = false

local phaseTwoThresholds = {30} -- Phase 2 starts at 30% HP
local hasCastPhaseTwo = {[30] = false}

-- Individual spell functions using isCasting check
function UrsocH_RoaringCacophony(eventId, delay, calls, creature)
    if not isCasting then
        isCasting = true
        creature:CastSpell(creature:GetVictim(), ROARING_CACOPHONY, true)
        creature:RegisterEvent(function() isCasting = false end, 2000, 1)
    end
end

function UrsocH_BarrelingCharge(event, delay, calls, creature)
    if not isCasting then
        isCasting = true
        local maxRange = 60.0 -- Maximum range for the charge ability

        -- Get the nearest player within the specified range
        local target = creature:GetNearestPlayer(maxRange)

        if target then
            creature:CastSpell(target, BARRELING_CHARGE, true)
            creature:SendUnitYell("STAMP AND TRAMPLE! CRUSH AND CRUMPLE!", 0)
            creature:PlayDirectSound(188078)
        else
            print("UrsocH_BarrelingCharge: No target found within range")
        end

        creature:RegisterEvent(function() isCasting = false end, 2500, 1) -- Adjust time as needed for spell duration
    end
end

function UrsocH_RendFlesh(eventId, delay, calls, creature)
    if not isCasting then
        isCasting = true
        creature:SendUnitYell("The Wilds Tremble before my fury!", 0)
        creature:PlayDirectSound(188075)
        creature:CastSpell(creature:GetVictim(), REND_FLESH, true)
        creature:RegisterEvent(function() isCasting = false end, 1000, 1)
    end
end

function UrsocH_TormentedGuardian(creature)
    creature:CastSpell(creature, TORMENTED_GUARDIAN, true)
end

function UrsocH_Softenrage(creature)
    creature:CastSpell(creature, SOFTENRAGE_SPELL, true)
end

function UrsocH_Enrage(eventId, delay, calls, creature)
    -- This function should trigger the Enrage spell after 2 minutes
    creature:CastSpell(creature, ENRAGE_SPELL, true)
    creature:SendUnitYell("The nightmare consumes me...compels me....to serve.. TO KILL!", 0)
    creature:PlayDirectSound(188082)
end

function StartPhaseTwo(creature, threshold)
    hasCastPhaseTwo[threshold] = true
    creature:RemoveEvents()  -- Clear all previous events to stop Phase 1 abilities
    creature:SendUnitYell("My sacred gift from the Watchers! Yes... yes, Nightmare Lord... yes... the fury of the Claws must be mine once more!", 0)
    creature:PlayDirectSound(188076)
    UrsocH_TormentedGuardian(creature)
    UrsocH_Softenrage(creature)
    -- Register Phase 2 events
    creature:RegisterEvent(UrsocH_BarrelingCharge, 14000, 0)
    creature:RegisterEvent(UrsocH_RendFlesh, 16000, 0)
    creature:RegisterEvent(UrsocH_Enrage, 120000, 1) -- Trigger Enrage after 2 minutes (120,000 ms)
    creature:RegisterEvent(UrsocH_RoaringCacophony, 11000, 0)
end

function UrsocH_CheckPhase(eventId, delay, calls, creature)
    local healthPct = creature:GetHealthPct()
    for _, threshold in ipairs(phaseTwoThresholds) do
        if healthPct <= threshold and not hasCastPhaseTwo[threshold] then
            StartPhaseTwo(creature, threshold)
            break
        end
    end
end

-- Event handlers
function UrsocH_OnEnterCombat(event, creature, target)
    creature:SendUnitYell("You should have fled! Now I'll feed your bones to the storm crows!", 0)
    creature:PlayDirectSound(188081)
    creature:RegisterEvent(UrsocH_BarrelingCharge, 14000, 0)
    creature:RegisterEvent(UrsocH_RendFlesh, 16000, 0)
    creature:RegisterEvent(UrsocH_RoaringCacophony, 11000, 0)
    creature:RegisterEvent(UrsocH_CheckPhase, 1000, 0)
end

function UrsocH_OnLeaveCombat(event, creature)
    creature:SendUnitYell("Should have fled. SHOULD HAVE LISTENED!", 0)
    creature:PlayDirectSound(188083)
    creature:RemoveEvents()
    isCasting = false
    hasCastPhaseTwo = {[30] = false} -- Reset phase status on leave combat
end

function UrsocH_OnDied(event, creature, killer)
    creature:SendUnitYell("The Nightmare's veil is lifted... I return at last... to the long slumber.", 0)
    creature:PlayDirectSound(188079)

    if killer and killer:GetObjectType() == "Player" then
        killer:SendBroadcastMessage("You killed " .. creature:GetName() .. "!")
    end

    creature:RemoveEvents()
    isCasting = false
    hasCastPhaseTwo = {[30] = false} -- Reset phase status on death
end

-- Register events
RegisterCreatureEvent(NPCID, 1, UrsocH_OnEnterCombat) -- EVENT_ON_ENTER_COMBAT
RegisterCreatureEvent(NPCID, 2, UrsocH_OnLeaveCombat) -- EVENT_ON_LEAVE_COMBAT
RegisterCreatureEvent(NPCID, 4, UrsocH_OnDied) -- EVENT_ON_DIED
