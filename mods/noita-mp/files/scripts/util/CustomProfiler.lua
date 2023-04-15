local plotly                             = require("plotly")
local Utils                              = require("Utils")
local fu                                 = require("FileUtils")

---Simple profiler that can be used to measure the duration of a function and the memory usage of a function.
---@class CustomProfiler
local CustomProfiler                     = {}

---@type table<string, table<number, table<string, number>>> A cache that stores all the data that is used to generate the report.
CustomProfiler.reportCache               = {}

---@private
---@type number The counter that is used to determine the order of the function calls.
CustomProfiler.counter                   = 1

---@type number The threshold in milliseconds. If a function takes longer than this threshold, it will be reported.
CustomProfiler.threshold                 = 16.5 -- Default: 16.5ms = 60.60 fps

---@type number The ceiling in milliseconds. If a function takes longer than this ceiling, it will be truncated.
CustomProfiler.ceiling                   = 1001 -- Default: 1001 ms

---@type number The maximum amount of entries per trace.
CustomProfiler.maxEntries                = 50 -- Default: 50

---@type string The directory where the report will be saved.
CustomProfiler.reportDirectory           = ("%s%sNoitaMP-Reports%s%s")
    :format(fu.GetDesktopDirectory(), pathSeparator, pathSeparator, os.date("%Y-%m-%d_%H-%M-%S", os.time()))

---@type string The filename of the report.
CustomProfiler.reportFilename            = "report.html" -- Default: report.html

---@type string The filename pattern of the report.
CustomProfiler.reportJsonFilenamePattern = "%s.json" -- Default: %s.json

---Starts the profiler. This has to be called before the function (or first line of function code) that you want to measure.
---@see CustomProfiler.stop(functionName, customProfilerCounter)
---@param functionName string The name of the function that you want to measure. This has to be the same as the one used in CustomProfiler.stop(functionName, customProfilerCounter)
---@return number returnCounter The counter that is used to determine the order of the function calls. This has to be passed to CustomProfiler.stop(functionName, customProfilerCounter)
function CustomProfiler.start(functionName)
    if not ModSettingGetNextValue("noita-mp.toggle_profiler") then
        return -1
    end

    if not CustomProfiler.reportCache[functionName] then
        CustomProfiler.reportCache[functionName] = {}
    end

    local frame                                                      = GameGetFrameNum()
    local start                                                      = GameGetRealWorldTimeSinceStarted() * 1000

    CustomProfiler.reportCache[functionName][CustomProfiler.counter] = {
        frame       = frame,
        start       = start,
        stop        = nil,
        duration    = nil,
        memoryStart = collectgarbage("count") / 1024,
        memoryStop  = nil,
    }

    if not CustomProfiler.reportCache[functionName]["size"] then
        CustomProfiler.reportCache[functionName]["size"] = 0
    end
    CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] + 1
    local returnCounter                              = CustomProfiler.counter
    CustomProfiler.counter                           = CustomProfiler.counter + 1
    return returnCounter
end

---Simply returns the duration of a specific function. This is used to determine the duration of a function.
---@param functionName string The name of the function that you want to measure. This has to be the same as the one used in @see CustomProfiler.start(functionName)
---@param customProfilerCounter number The counter that is used to determine the order of the function calls. This has to same as the one returned by @see CustomProfiler.start(functionName)
---@return number duration The duration of the function in milliseconds.
function CustomProfiler.getDuration(functionName, customProfilerCounter)
    if not ModSettingGetNextValue("noita-mp.toggle_profiler") then
        return 0
    end
    local entry    = CustomProfiler.reportCache[functionName][customProfilerCounter]
    local stop     = GameGetRealWorldTimeSinceStarted() * 1000
    local duration = stop - entry.start
    return duration
end

---Stops all profiled functions. Is used to get a correct report.
function CustomProfiler.stopAll()
    for i, v in ipairs(CustomProfiler.reportCache) do
        CustomProfiler.stop(v)
    end
end

---Stops the profiler. This has to be called after the function (or last line of function code, but before any `return`) that you want to measure.
---@param functionName string The name of the function that you want to measure. This has to be the same as the one used in @see CustomProfiler.start(functionName)
---@param customProfilerCounter number The counter that is used to determine the order of the function calls. This has to same as the one returned by @see CustomProfiler.start(functionName)
function CustomProfiler.stop(functionName, customProfilerCounter)
    if not ModSettingGetNextValue("noita-mp.toggle_profiler") then
        return 0
    end

    if Utils.IsEmpty(CustomProfiler.reportCache) then
        return 0
    end

    if not CustomProfiler.reportCache[functionName] then
        Logger.warn(Logger.channels.profiler,
            ("No entry found for function '%s'. Profiling will be skipped."):format(functionName))
        return 0
    end

    --if not CustomProfiler.reportCache[functionName][customProfilerCounter] then
    --    Logger.warn(Logger.channels.profiler,
    --                "No entry found for function '%s' with counter '%s'. Profiling will be skipped.", functionName,
    --                customProfilerCounter)
    --    return
    --end

    local entry = CustomProfiler.reportCache[functionName][customProfilerCounter]
    if entry then
        local stop     = GameGetRealWorldTimeSinceStarted() * 1000
        local duration = stop - entry.start
        if duration >= CustomProfiler.threshold then
            -- only profile functions that take longer than 30ms (1000ms / 30ms per frame = 33fps)
            entry.stop       = stop
            entry.duration   = duration
            entry.memoryStop = collectgarbage("count") / 1024
        else
            --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName][customProfilerCounter], "v")
            CustomProfiler.reportCache[functionName][customProfilerCounter] = nil
            CustomProfiler.reportCache[functionName]["size"]                = CustomProfiler.reportCache[functionName]["size"] - 1
            if CustomProfiler.reportCache[functionName]["size"] == 0 then
                --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName], "kv")
                CustomProfiler.reportCache[functionName] = nil
            end
        end
    else
        for index = 1, #CustomProfiler.reportCache[functionName] do
            entry       = CustomProfiler.reportCache[functionName][index]
            local frame = GameGetFrameNum()
            if not entry.duration and entry.frame == frame then
                local stop     = GameGetRealWorldTimeSinceStarted() * 1000
                local duration = stop - entry.start
                if duration >= CustomProfiler.threshold then
                    entry.stop       = stop
                    entry.duration   = duration
                    entry.memoryStop = collectgarbage("count") / 1024
                else
                    --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName][index], "v")
                    CustomProfiler.reportCache[functionName][index]  = nil
                    CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] - 1
                    if CustomProfiler.reportCache[functionName]["size"] == 0 then
                        --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName], "kv")
                        CustomProfiler.reportCache[functionName] = nil
                    end
                end
                break
            end
        end
    end

    if CustomProfiler.reportCache[functionName] and
        CustomProfiler.reportCache[functionName]["size"] and
        CustomProfiler.reportCache[functionName]["size"] >= CustomProfiler.maxEntries
    then
        if not fu.Exists(CustomProfiler.reportDirectory) then
            fu.MkDir(CustomProfiler.reportDirectory)
        end

        local x            = {}
        local y            = {}
        local xMemoryStart = {}
        local yMemoryStart = {}
        local xMemoryStop  = {}
        local yMemoryStop  = {}

        for index in orderedPairs(CustomProfiler.reportCache[functionName]) do
            local entry2 = CustomProfiler.reportCache[functionName][index]
            if entry2.frame and entry2.duration then
                if entry2.duration > CustomProfiler.ceiling then
                    entry2.duration = CustomProfiler.ceiling
                end
                table.insert(x, entry2.frame)
                table.insert(y, entry2.duration)
                table.insert(xMemoryStart, entry2.frame)
                table.insert(yMemoryStart, entry2.memoryStart)
                table.insert(xMemoryStop, entry2.frame)
                table.insert(yMemoryStop, entry2.memoryStop)
                --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName][index], "v")
                CustomProfiler.reportCache[functionName][index]  = nil
                CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] - 1
                if CustomProfiler.reportCache[functionName]["size"] == 0 then
                    --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName], "kv")
                    CustomProfiler.reportCache[functionName] = nil
                end
            end
        end

        -- https://plotly.com/javascript/bar-charts/#grouped-bar-chart-with-direct-labels
        local dataTime = {
            x            = x,
            y            = y,
            type         = "bar",
            --mode    = "lines",
            textposition = "auto",
            name         = functionName,
            text         = functionName,
            --line    = { width = 1 },
            opacity      = 0.75,
            --font    = { size = 8 },
        }
        local figTime  = plotly.figure()
        figTime:write_trace_to_file(dataTime, CustomProfiler.reportDirectory)

        local dataMemoryStart = {
            x            = xMemoryStart,
            y            = yMemoryStart,
            type         = "bar",
            --mode    = "lines",
            textposition = "auto",
            name         = functionName .. " mb start",
            text         = functionName .. " mb start",
            --line    = { width = 1 },
            opacity      = 0.75,
            --font    = { size = 8 },
        }
        local figMemoryStart  = plotly.figure()
        figMemoryStart:write_trace_to_file(dataMemoryStart, CustomProfiler.reportDirectory)

        local dataMemoryStop = {
            x            = xMemoryStop,
            y            = yMemoryStop,
            type         = "bar",
            --mode    = "lines",
            textposition = "auto",
            name         = functionName .. " mb stop",
            text         = functionName .. " mb stop",
            --line    = { width = 1 },
            opacity      = 0.75,
            --font    = { size = 8 },
        }
        local figMemoryStop  = plotly.figure()
        figMemoryStop:write_trace_to_file(dataMemoryStop, CustomProfiler.reportDirectory)

        CustomProfiler.reportCache[functionName] = nil
    end
    return 0
end

---Creates a report of all the functions that were profiled into profiler_2022-11-24_20-23-00.json
function CustomProfiler.report()
    CustomProfiler.stopAll()

    local fig1 = plotly.figure()

    fig1:update_layout {
        width   = 1920,
        height  = 1080,
        title   = "NoitaMP Profiler Report of " .. whoAmI() .. " " .. fu.getVersionByFile(),
        xaxis   = { title = { text = "Frames" } },
        yaxis   = { title = { text = "Execution time [ms]" } },
        barmode = "group"
    }
    fig1:update_config {
        scrollZoom = true,
        responsive = true
    }
    fig1:tofilewithjsondatafile(CustomProfiler.reportDirectory .. pathSeparator .. CustomProfiler.reportFilename,
        CustomProfiler.reportDirectory)
end

---Returns the size of the report cache.
---@return number size
function CustomProfiler.getSize()
    local size = 0
    for i = 1, #CustomProfiler.reportCache do
        size = size + tonumber(CustomProfiler.reportCache[i]["size"])
    end
    return size
end

---Globally accessible CustomProfiler in _G.CustomProfiler.
---@alias _G.CustomProfiler CustomProfiler
_G.CustomProfiler = CustomProfiler

return CustomProfiler
