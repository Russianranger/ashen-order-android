local EventFixer = {}
EventFixer.holidayEventIds = {17, 91, 92}

local function FixEvents()
    print("Running Event Fix Script for server startup...")

    for _, eventId in ipairs(EventFixer.holidayEventIds) do
        local isHolidayActive = IsGameEventActive(eventId)

        if isHolidayActive then
            StopGameEvent(eventId)
            StartGameEvent(eventId)
        end
    end

    print("Event Fix Script run complete.")
end

RegisterServerEvent(14, FixEvents)
