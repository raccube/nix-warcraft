local _, addon = ...

local function report(message)
    print("|cffff8040HMUISettings:|r " .. tostring(message))
end

local function applyFrame(id, settings)
    local frame = _G["ChatFrame" .. id]
    if not frame then
        error("Chat frame " .. id .. " is unavailable")
    end
    if settings.name ~= nil then
        FCF_SetWindowName(frame, settings.name)
    end
    if settings.fontSize ~= nil then
        FCF_SetChatWindowFontSize(nil, frame, settings.fontSize)
    end
    if settings.alpha ~= nil then
        FCF_SetWindowAlpha(frame, settings.alpha)
    end
    if settings.fading ~= nil then
        frame:SetFading(settings.fading)
    end
    if settings.messageGroups ~= nil then
        -- Validate before clearing existing subscriptions.
        for _, group in ipairs(settings.messageGroups) do
            if not ChatTypeGroup[group] then
                error("Unknown message group: " .. group)
            end
        end
        frame:RemoveAllMessageGroups()
        for _, group in ipairs(settings.messageGroups) do
            frame:AddMessageGroup(group)
        end
    end
end

local function apply()
    for name, value in pairs(addon.settings.cvars) do
        local ok, err = pcall(function()
            if C_CVar.GetCVar(name) == nil then
                error("Unknown CVar: " .. name)
            end
            C_CVar.SetCVar(name, value)
        end)
        if not ok then report(err) end
    end
    for id, settings in pairs(addon.settings.chatFrames) do
        local ok, err = pcall(applyFrame, id, settings)
        if not ok then report(err) end
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:SetScript("OnEvent", function(self, event, initialLogin, reloadingUI)
    if event == "PLAYER_ENTERING_WORLD" then
        if not initialLogin and not reloadingUI then return end
        -- Run after Blizzard's login handlers and the Edit Mode layout addon.
        C_Timer.After(0, function()
            if InCombatLockdown() then
                self:RegisterEvent("PLAYER_REGEN_ENABLED")
            else
                apply()
            end
        end)
    else
        self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        apply()
    end
end)
