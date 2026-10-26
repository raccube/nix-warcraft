local instanceType = "none"
local enabled, advanced, onEvent
local registered = {}
function CreateFrame()
    return {
        RegisterEvent = function(_, event) registered[event] = true end,
        SetScript = function(_, event, handler)
            assert(event == "OnEvent")
            onEvent = handler
        end,
    }
end
function SetCVar(name, value)
    assert(name == "advancedCombatLogging")
    advanced = value
end
function IsInInstance() return instanceType ~= "none", instanceType end
function LoggingCombat(value) enabled = value end

dofile(arg[1])
assert(registered.PLAYER_ENTERING_WORLD)
assert(registered.ZONE_CHANGED_NEW_AREA)
for _, scenario in ipairs({
    {"none", false},
    {"raid", true},
    {"raid", true}, -- Reloading or moving within a raid keeps logging enabled.
    {"party", true},
    {"none", false},
    {"arena", false},
    {"pvp", false},
}) do
    instanceType = scenario[1]
    onEvent()
    assert(advanced == "1")
    assert(enabled == scenario[2], "Unexpected logging state for " .. instanceType)
end
print("Auto logging: raid/dungeon entry, reload, exit, and PvP checks passed")
