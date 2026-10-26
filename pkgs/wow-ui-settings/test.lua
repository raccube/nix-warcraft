-- Mock the game boundary to check login/reload, combat deferral and isolation.
local callback, timer, combat
local applied, warnings = 0, 0
local registered = {}
local events = {}
function events:RegisterEvent(event) registered[event] = true end
function events:UnregisterEvent(event) registered[event] = nil end
function events:SetScript(_, fn) callback = fn end
function CreateFrame() return events end
function InCombatLockdown() return combat end
C_Timer = { After = function(_, fn) timer = fn end }
C_CVar = {
    GetCVar = function(name) if name == "valid" then return "0" end end,
    SetCVar = function(name, value)
        assert(name == "valid" and value == "1")
        applied = applied + 1
    end,
}
local originalPrint = print
function print() warnings = warnings + 1 end
ChatTypeGroup = { SAY = {} }
ChatFrame1 = {
    groups = { "GUILD" },
    SetFading = function(self, value) self.fading = value end,
    RemoveAllMessageGroups = function(self) self.groups = {} end,
    AddMessageGroup = function(self, group) table.insert(self.groups, group) end,
}
local settings = {
    cvars = { valid = "1", invalid = "1" },
    chatFrames = { ["1"] = { fading = false, messageGroups = { "SAY" } } },
}
assert(loadfile(arg[1]))("HMUISettings", { settings = settings })
assert(registered.PLAYER_ENTERING_WORLD)
callback(events, "PLAYER_ENTERING_WORLD", true, false)
assert(applied == 0)
timer()
assert(applied == 1 and warnings == 1)
assert(ChatFrame1.fading == false and ChatFrame1.groups[1] == "SAY")
timer = nil
callback(events, "PLAYER_ENTERING_WORLD", false, false)
assert(timer == nil, "Zoning must not reapply settings")
combat = true
callback(events, "PLAYER_ENTERING_WORLD", false, true)
timer()
assert(applied == 1 and registered.PLAYER_REGEN_ENABLED)
combat = false
callback(events, "PLAYER_REGEN_ENABLED")
assert(applied == 2 and not registered.PLAYER_REGEN_ENABLED)
assert(#ChatFrame1.groups == 1, "Reload must not duplicate filters")
settings.chatFrames["1"].messageGroups = { "INVALID" }
callback(events, "PLAYER_ENTERING_WORLD", false, true)
timer()
assert(ChatFrame1.groups[1] == "SAY", "Invalid groups must preserve subscriptions")
settings.chatFrames["1"] = {}
callback(events, "PLAYER_ENTERING_WORLD", false, true)
timer()
assert(ChatFrame1.fading == false and ChatFrame1.groups[1] == "SAY")
settings.chatFrames["1"].messageGroups = {}
callback(events, "PLAYER_ENTERING_WORLD", false, true)
timer()
assert(#ChatFrame1.groups == 0, "An empty list must clear filters")
originalPrint("WoW UI settings tests passed")
