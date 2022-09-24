---
--- Created by Ismoh-PC.
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

function CustomProfiler.start(functionName)
    if not ModSettingGetAtIndex("noita-mp.toggle_profiler") then
        return
    end

    if not CustomProfiler.reportCache[functionName] then
        CustomProfiler.reportCache[functionName] = {}
    end

    local frame                                                = GameGetFrameNum()
    local start                                                = GameGetRealWorldTimeSinceStarted() * 1000
    --local fps1  = CustomProfiler.fps1
    --if fps1 > 60 then
    --    fps1 = 61
    --end
    --local fps2 = CustomProfiler.fps2
    --if fps2 > 60 then
    --    fps2 = 61
    --end

    CustomProfiler
            .reportCache[functionName][CustomProfiler.counter] = {
        --functionName = functionName,
        --counter  = CustomProfiler.counter,
        --fps1     = fps1,
        --fps2     = fps2,
        frame    = frame,
        start    = start,
        stop     = nil,
        duration = nil,
    }
    local returnCounter                                        = CustomProfiler.counter
    CustomProfiler.counter                                     = CustomProfiler.counter + 1
    return returnCounter
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

    --local fps1 = { x = {}, y = {}, mode = "markers+lines", name = "avg.FPS1" }
    --local fps2 = { x = {}, y = {}, mode = "markers+lines", name = "avg.FPS2" }
    for functionName in pairs(CustomProfiler.reportCache) do
        local x = {}
        local y = {}
        --table.sort(CustomProfiler.reportCache[functionName], function(a, b)
        --    if not a or not a.frame then
        --        return false
        --    end
        --    if not b or not b.frame then
        --        return true
        --    end
        --    if a.frame > b.frame then
        --        return false
        --    end
        --    if a.frame < b.frame then
        --        return true
        --    end
        --    if a.frame == b.frame then
        --        if a.start > b.start then
        --            return false
        --        end
        --        if a.start < b.start then
        --            return true
        --        end
        --    end
        --    return false
        --end)
        for index in orderedPairs(CustomProfiler.reportCache[functionName]) do
            local entry = CustomProfiler.reportCache[functionName][index]
            if entry.frame and entry.duration then
                table.insert(x, entry.frame)
                table.insert(y, entry.duration)
                --table.insertIfNotExist(fps1.x, entry.frame)
                --table.insertIfNotExist(fps1.y, entry.fps1)
                --table.insertIfNotExist(fps2.x, entry.frame)
                --table.insertIfNotExist(fps2.y, entry.fps2)
            end
        end
        fig1:add_trace {
            x        = x,
            y        = y,
            mode     = "lines",
            name     = functionName,
            line     = { width = 1 },
            --autobinx = false,
            --histnorm = "count",
            opacity  = 0.75,
            --type     = "histogram"
        }
    end
    --fig1:add_trace(fps1)
    --fig1:add_trace(fps2)

    fig1:update_layout {
        width  = 1920,
        height = 1080,
        --barmode = "overlay",
        title  = "NoitaMP Profiler Report of " .. whoAmI() .. " " .. NoitaMPVersion,
        xaxis  = { title = { text = "Frames" } },
        yaxis  = { title = { text = "Execution time [ms]" } }
    }
    fig1:update_config {
        scrollZoom = true,
        --editable   = true,
        responsive = true
    }
    fig1:tofile(dir .. path_separator .. filename)

    if clearCache then
        CustomProfiler.reportCache = {}
    end

    ModSettingSetNextValue("noita-mp.toggle_profiler", false, false)
end

local oldTime         = 0
local framesPerSecond = {}
framesPerSecond[1]    = GameGetRealWorldTimeSinceStarted()
function CustomProfiler.updateFps()
    local cpc                             = CustomProfiler.start("CustomProfiler.updateFps")
    frame_times                           = frame_times or {}
    local now_time                        = GameGetRealWorldTimeSinceStarted()
    local seconds_passed_since_last_frame = GameGetRealWorldTimeSinceStarted() - (last_frame_time or now_time)
    last_frame_time                       = now_time
    table.insert(frame_times, seconds_passed_since_last_frame)
    if #frame_times > 60 then
        table.remove(frame_times, 1)
    end
    local average_frame_time = 0
    for i, v in ipairs(frame_times) do
        average_frame_time = average_frame_time + v
    end
    average_frame_time                    = average_frame_time / #frame_times
    CustomProfiler.fps1                   = 1 / average_frame_time

    framesPerSecond[#framesPerSecond + 1] = now_time
    if now_time - framesPerSecond[1] > 1 then
        table.remove(framesPerSecond, 1)
    end
    CustomProfiler.fps2 = #framesPerSecond
    CustomProfiler.stop("CustomProfiler.updateFps", cpc)
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.CustomProfiler = CustomProfiler

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return CustomProfiler
