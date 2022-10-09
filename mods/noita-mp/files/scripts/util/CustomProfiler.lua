---
--- Created by Ismoh.
--- DateTime: 03.09.2022 20:23
---
--- OOP class definition is found here: Closure approach
--- http://lua-users.org/wiki/ObjectOrientationClosureApproach
--- Naming convention is found here:
--- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

--local json                 = require("json")
local plotly               = require("plotly")
local util                 = require("util")

CustomProfiler             = {}
CustomProfiler.keys        = { "", "", "", "", "" }
CustomProfiler.reportCache = {}
CustomProfiler.counter     = 0
CustomProfiler.threshold   = 1 -- ms
CustomProfiler.ceiling     = 100 -- ms


function CustomProfiler.start(functionName)
    if not ModSettingGetAtIndex("noita-mp.toggle_profiler") then
        return
    end

    if not CustomProfiler.reportCache[functionName] then
        CustomProfiler.reportCache[functionName] = {}
    end

    local frame                                                      = GameGetFrameNum()
    local start                                                      = GameGetRealWorldTimeSinceStarted() * 1000

    CustomProfiler.reportCache[functionName][CustomProfiler.counter] = {
        frame    = frame,
        start    = start,
        stop     = nil,
        duration = nil,
    }
    local returnCounter                                              = CustomProfiler.counter
    CustomProfiler.counter                                           = CustomProfiler.counter + 1
    return returnCounter
end

--- Simply returns the duration of a specific function. This is used to determine the duration of a function.
--- @param functionName string Has to be the same as the one used in start()
--- @param customProfilerCounter number Has to be the same as the one returned by start()
function CustomProfiler.getDuration(functionName, customProfilerCounter)
    local entry    = CustomProfiler.reportCache[functionName][customProfilerCounter]
    local stop     = GameGetRealWorldTimeSinceStarted() * 1000
    local duration = stop - entry.start
    return duration
end


function CustomProfiler.stop(functionName, customProfilerCounter)
    if not ModSettingGetAtIndex("noita-mp.toggle_profiler") then
        return
    end

    if util.IsEmpty(CustomProfiler.reportCache) then
        return
    end

    local entry = CustomProfiler.reportCache[functionName][customProfilerCounter]
    if entry then
        local stop     = GameGetRealWorldTimeSinceStarted() * 1000
        local duration = stop - entry.start
        if duration >= CustomProfiler.threshold then
            -- only profile functions that take longer than 30ms (1000ms / 30ms per frame = 33fps)
            entry.stop     = stop
            entry.duration = duration
        else
            CustomProfiler.reportCache[functionName][customProfilerCounter] = nil
        end
    else
        for index = 1, #CustomProfiler.reportCache[functionName] do
            entry       = CustomProfiler.reportCache[functionName][index]
            local frame = GameGetFrameNum()
            if not entry.duration and entry.frame == frame then
                local stop     = GameGetRealWorldTimeSinceStarted() * 1000
                local duration = stop - entry.start
                if duration >= CustomProfiler.threshold then
                    entry.stop     = stop
                    entry.duration = duration
                else
                    CustomProfiler.reportCache[functionName][index] = nil
                end
                break
            end
        end
    end
end


--- Creates a report of all the functions that were profiled into profiler_2022-11-24_20-23-00.json
---@param clearCache boolean
---@return table
---@public
function CustomProfiler.report(clearCache)
    local dir      = fu.GetAbsoluteDirectoryPathOfMods() .. path_separator .. "reports"
    local filename = ("%s_profiler_%s_%s.html"):format(os.date("%Y-%m-%d_%H-%M-%S", os.time()), whoAmI(),
                                                       NoitaMPVersion)
    local fig1     = plotly.figure()

    if not fu.Exists(dir) then
        fu.MkDir(dir)
    end

    for functionName in pairs(CustomProfiler.reportCache) do
        local x = {}
        local y = {}
        for index in orderedPairs(CustomProfiler.reportCache[functionName]) do
            local entry = CustomProfiler.reportCache[functionName][index]
            if entry.frame and entry.duration then
                if entry.duration > CustomProfiler.ceiling then
                    entry.duration = CustomProfiler.ceiling
                end
                table.insert(x, entry.frame)
                table.insert(y, entry.duration)
            end
        end
        fig1:add_trace {
            x       = x,
            y       = y,
            mode    = "lines",
            name    = functionName,
            line    = { width = 1 },
            opacity = 0.75,
            font    = { size = 8 },
        }
    end

    fig1:update_layout {
        width  = 1920,
        height = 1080,
        title  = "NoitaMP Profiler Report of " .. whoAmI() .. " " .. NoitaMPVersion,
        xaxis  = { title = { text = "Frames" } },
        yaxis  = { title = { text = "Execution time [ms]" } }
    }
    fig1:update_config {
        scrollZoom = true,
        responsive = true
    }
    fig1:tofile(dir .. path_separator .. filename)

    if clearCache then
        CustomProfiler.reportCache = {}
    end

    ModSettingSetNextValue("noita-mp.toggle_profiler", false, false)
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.CustomProfiler = CustomProfiler

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return CustomProfiler
