local NAME = "@LAYOUT_NAME@"
local FALLBACK = "@LAYOUT_FALLBACK@"

local function switchToLayout(name)
    local info = C_EditMode.GetLayouts()
    if not info then return false end
    for i, layoutInfo in ipairs(info.layouts) do
        if layoutInfo.layoutName == name then
            C_EditMode.SetActiveLayout(i + 2)
            return true
        end
    end
    return false
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    if switchToLayout(NAME) then return end
    switchToLayout(FALLBACK)
end)
