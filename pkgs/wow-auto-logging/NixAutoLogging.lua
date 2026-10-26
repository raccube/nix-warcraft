local frame = CreateFrame("Frame")
local function updateLogging()
    SetCVar("advancedCombatLogging", "1")
    local _, instanceType = IsInInstance()
    LoggingCombat(instanceType == "raid" or instanceType == "party")
end

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
frame:SetScript("OnEvent", updateLogging)
