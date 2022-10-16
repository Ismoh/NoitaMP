---
--- Created by Ismoh.
--- DateTime: 03.09.2022 20:23
---
--- OOP class definition is found here: Closure approach
--- http://lua-users.org/wiki/ObjectOrientationClosureApproach
--- Naming convention is found here:
--- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local json                               = require("dkjson")
local plotly                             = require("plotly")
local util                               = require("util")
local fu                                 = require("file_util")

CustomProfiler                           = {}
CustomProfiler.keys                      = { "", "", "", "", "" }
CustomProfiler.reportCache               = {}
CustomProfiler.counter                   = 1
CustomProfiler.threshold                 = 1 -- ms
CustomProfiler.ceiling                   = 1001 -- ms
CustomProfiler.maxEntries                = 100
CustomProfiler.reportDirectory           = ("%s%sreports%s%s"):format(fu.GetAbsoluteDirectoryPathOfMods(),
                                                                      path_separator, path_separator,
                                                                      os.date("%Y-%m-%d_%H-%M-%S",
                                                                              os.time()))
CustomProfiler.reportFilename            = "report.html"
CustomProfiler.reportJsonFilenamePattern = "%s.json"

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

    if not CustomProfiler.reportCache[functionName]["size"] then
        CustomProfiler.reportCache[functionName]["size"] = 0
    end
    CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] + 1

    local returnCounter                              = CustomProfiler.counter
    CustomProfiler.counter                           = CustomProfiler.counter + 1
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
            CustomProfiler.reportCache[functionName]["size"]                = CustomProfiler.reportCache[functionName]["size"] - 1
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
                    CustomProfiler.reportCache[functionName][index]  = nil
                    CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] - 1
                end
                break
            end
        end
    end

    if CustomProfiler.reportCache[functionName]["size"] >= CustomProfiler.maxEntries then
        local x = {}
        local y = {}
        for index in orderedPairs(CustomProfiler.reportCache[functionName]) do
            local entry2 = CustomProfiler.reportCache[functionName][index]
            if entry2.frame and entry2.duration then
                if entry2.duration > CustomProfiler.ceiling then
                    entry2.duration = CustomProfiler.ceiling
                end
                table.insert(x, entry2.frame)
                table.insert(y, entry2.duration)
                CustomProfiler.reportCache[functionName][index]  = nil
                CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] - 1
            end

        end
        -- https://plotly.com/javascript/bar-charts/#grouped-bar-chart-with-direct-labels
        local data              = {
            x       = x,
            y       = y,
      type= "bar",
            --mode    = "lines",
      textposition="auto",
            name    = functionName,
      text = functionName,
            --line    = { width = 1 },
            opacity = 0.75,
            --font    = { size = 8 },

        }
        local fig1              = plotly.figure()
        fig1:write_trace_to_file(data, CustomProfiler.reportDirectory)
        CustomProfiler.reportCache[functionName] = nil
    end
end

--- Creates a report of all the functions that were profiled into profiler_2022-11-24_20-23-00.json
---@public
function CustomProfiler.report()
    local fig1 = plotly.figure()

    fig1:update_layout {
        width  = 1920,
        height = 1080,
        title  = "NoitaMP Profiler Report of " .. whoAmI() .. " " .. NoitaMPVersion,
        xaxis  = { title = { text = "Frames" } },
        yaxis  = { title = { text = "Execution time [ms]" } },
    barmode="group"
    }
    fig1:update_config {
        scrollZoom = true,
        responsive = true
    }
    fig1:tofilewithjsondatafile(CustomProfiler.reportDirectory .. path_separator .. CustomProfiler.reportFilename,
                                CustomProfiler.reportDirectory)
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.CustomProfiler = CustomProfiler

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return CustomProfiler
