Munira = Munira or {}

local MUNIRA_NPC_ID = 1000026
local MUNIRA_WP_ID_7 = 6
local MUNIRA_WP_ID_8 = 10
local MUNIRA_WP_ID_18 = 18


local MUNIRA_EMOTE_ID_22 = 22
local MUNIRA_EMOTE_ID_18 = 18


local DAUGHTER_NPC_NAME = "Selene"


function Munira.OnReachWaypoint(event, creature, type, id)
    local currentWpId = creature:GetCurrentWaypointId()

    if currentWpId == MUNIRA_WP_ID_7 or currentWpId == MUNIRA_WP_ID_8 then
        local yellText = string.format("%s! %s! Where are you? Please come 'ome! 'As anyone seen %s?", DAUGHTER_NPC_NAME, DAUGHTER_NPC_NAME, DAUGHTER_NPC_NAME)
        creature:SendUnitYell(yellText, 0)
        creature:PerformEmote(MUNIRA_EMOTE_ID_22)
    elseif currentWpId == MUNIRA_WP_ID_18 then
        creature:PerformEmote(MUNIRA_EMOTE_ID_18)
    end
end

RegisterCreatureEvent(MUNIRA_NPC_ID, 6, Munira.OnReachWaypoint)
