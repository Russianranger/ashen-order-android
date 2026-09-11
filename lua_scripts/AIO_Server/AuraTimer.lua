local AIO = AIO or require("AIO")
if AIO.AddAddon() then return end
local auraFrames = {}
local trackedAuras = {
    [800232] = {name = "Spatial Rift", color = {r = 0.75, g = 0.5, b = 0.75}},

}

local function FormatTime(timeLeft)
    local hours = math.floor(timeLeft / 3600)
    local minutes = math.floor((timeLeft % 3600) / 60)
    local seconds = math.floor(timeLeft % 60) -- Rounded to the nearest second
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function CreateAuraFrame(spellID, auraInfo)
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(200, 50)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 500)
    frame:SetMovable(true)  -- Make the frame movable
    frame:SetClampedToScreen(true)  -- Prevent the frame from being dragged off screen
    frame:EnableMouse(true)  -- Enable mouse interaction for the frame

    frame.text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    frame.text:SetAllPoints(true)
    frame.text:SetFont("Fonts\\FRIZQT__.TTF", 16)
    frame.text:SetText(auraInfo.name .. ": 00:00:00")
    frame.text:SetTextColor(auraInfo.color.r, auraInfo.color.g, auraInfo.color.b)

    -- Script to start dragging the frame
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "LeftButton" then
            self:StartMoving()
        end
    end)

    -- Script to stop dragging the frame
    frame:SetScript("OnMouseUp", function(self, button)
        self:StopMovingOrSizing()
    end)

    frame:Hide()
    return frame
end


local function UpdateAuraTimer(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed < 0.1 then return end  -- Update every 0.1 seconds for millisecond precision
    self.elapsed = 0

    for i = 1, 40 do
        local name, _, _, _, _, duration, expirationTime, _, _, _, spellID = UnitAura("player", i, "HELPFUL")
        if spellID == self.spellID then
            local timeLeft = expirationTime - GetTime()
            if timeLeft > 0 then
                local auraInfo = trackedAuras[spellID]  -- Retrieve the aura info from the trackedAuras table
                self.text:SetText(auraInfo.name .. ": " .. FormatTime(timeLeft))  -- Include the aura name in the text
            else
                self:Hide()
            end
            return
        end
    end

    self:Hide()
end

local function InitializeAuraTimers()
    for spellID, auraInfo in pairs(trackedAuras) do
        local name = UnitAura("player", spellID, nil, "HELPFUL")
        if name then
            if not auraFrames[spellID] then
                auraFrames[spellID] = CreateAuraFrame(spellID, auraInfo)
            end
            local frame = auraFrames[spellID]
            frame.spellID = spellID
            frame:SetScript("OnUpdate", UpdateAuraTimer)
            frame:Show()
        end
    end
end

local function OnEvent(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "AuraTimer" then
            InitializeAuraTimers()
        end
    elseif event == "UNIT_AURA" then
        local unit = ...
        if unit == "player" then
            for spellID, auraInfo in pairs(trackedAuras) do
                if not auraFrames[spellID] then
                    auraFrames[spellID] = CreateAuraFrame(spellID, auraInfo)
                end
                local frame = auraFrames[spellID]
                frame.spellID = spellID

                local found = false
                for i = 1, 40 do
                    local _, _, _, _, _, _, _, _, _, _, foundSpellID = UnitAura("player", i, "HELPFUL")
                    if foundSpellID == spellID then
                        found = true
                        break
                    end
                end

                if found then
                    frame:SetScript("OnUpdate", UpdateAuraTimer)
                    frame:Show()
                else
                    frame:SetScript("OnUpdate", nil)
                    frame:Hide()
                end
            end
        end
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("UNIT_AURA")
eventFrame:SetScript("OnEvent", OnEvent)
