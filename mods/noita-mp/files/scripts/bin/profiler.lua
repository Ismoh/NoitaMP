local params = { ... }
print("params", table.concat(params, ", "))

--require "luadebug" : start "127.0.0.1:4980" : event "wait"

local cache            = {}
---@type FileUtils
local fileUtils        = nil
local lfs              = nil
---@type Logger
local logger           = nil
local pid              = nil
---@type plotly
local plotly           = nil
local reportDirectory  = nil
local reportFilename   = "report.html"
local socket           = nil
local udp              = nil
---@type Utils
local utils            = nil
local winapi           = nil

local getNoitaRootPath = function()

end

string.split           = function(str, pat)
    local t         = {}
    local fpat      = "(.-)" .. pat
    local last_end  = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end  = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

string.trim            = function(s)
    if type(s) ~= "string" then
        error("Unable to trim(s), because s is not a string.", 2)
    end
    -- http://lua-users.org/wiki/StringTrim -> trim12(s)
    local from = s:match "^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end

--- Contains on lower case
--- @param str string String
--- @param pattern string String, Char, Regex
--- @return boolean found: 'true' if found, else 'false'.
string.contains        = function(str, pattern)
    if not str or str == "" then
        error("str must not be nil!", 2)
    end
    if not pattern or pattern == "" then
        error("pattern must not be nil!", 2)
    end
    local found = string.find(str:lower(), pattern:lower(), 1, true)
    if not found or found < 1 then
        return false
    else
        return true
    end
end

---Initilizes the external profiler. All dependencies were loaded here.
local init             = function()
    _G.MAX_MEMORY_USAGE    = 524438 -- KB = 524,438 MB

    local settingsFilePath = {}
    local partitions       = string.split(assert(io.popen("wmic logicaldisk get caption"):read("*a")), "\r\n")
    for i = 1, #partitions do
        partitions[i] = string.trim(partitions[i])
        if partitions[i] == "Caption" or partitions[i] == "" then
            partitions[i] = nil
        else
            local partitionName = tostring(partitions[i])
            local command = ("%s && dir /s /b *settings.json*"):format(partitionName)
            local result = assert(io.popen(command):read("*a"))
            settingsFilePath[partitionName] = string.split(result, "\n")
        end
    end

    for partitionName, entries in pairs(settingsFilePath) do
        if type(settingsFilePath) == "string" then break end
        for i = 1, #entries do
            local foundPath = entries[i]
            if string.contains(foundPath, "noita-mp") and not string.contains(foundPath, "Recycle") then
                settingsFilePath = nil -- free memory
                settingsFilePath = entries[i]
                print("Found noitaMpSettings file at: " .. settingsFilePath)
                break
            end
        end
    end
    partitions          = nil -- free memory

    local i, j          = string.find(tostring(settingsFilePath):lower(), "mods\\noita%-mp")
    local noitaRootPath = settingsFilePath:sub(1, i - 2)
    if not noitaRootPath or noitaRootPath == "" then
        error("Noita root path is nil or empty!", 2)
    end
    print("Found noita root path at: " .. noitaRootPath)

    local gDofile = dofile
    dofile        = function(path)
        if path:sub(1, 4) == "mods" then
            local pathToMod = noitaRootPath .. "/" .. path
            print("dofile path: " .. pathToMod)
            return gDofile(pathToMod)
        else
            return gDofile(path)
        end
    end

    if not _G.ModSettingGet then
        _G.ModSettingGet = function(id)
            if not id then
                error("UNKNOWN ModSettingGet id - FIX ME!", 2)
            end
            if string.find(id:lower(), "noita-mp.log_level_", 1, true) then
                return { "trace", "debug, info, warn", "WARN" }
            end

            error("UNKNOWN ModSettingGet id - FIX ME!", 2)
        end
    end

    if not _G.ModSettingGetNextValue then
        _G.ModSettingGetNextValue = function(id)
            if not id or id == "" then
                error("UNKNOWN ModSettingGetNextValue id - FIX ME!", 2)
            end
            if string.find(id:lower(), "noita-mp.toggle_profiler", 1, true) then
                return false -- do not profile the profiler :KAPPA:
            end
            error("UNKNOWN ModSettingGetNextValue id - FIX ME!", 2)
        end
    end

    if not _G.ModGetActiveModIDs then
        _G.ModGetActiveModIDs = function()
            return {}
        end
    end

    if not _G.ModIsEnabled then
        _G.ModIsEnabled = function(id)
            return true
        end
    end

    if not _G.GameGetRealWorldTimeSinceStarted then
        _G.GameGetRealWorldTimeSinceStarted = function()
            return 0
        end
    end


    -- dofile("mods/noita-mp/files/scripts/init/init_.lua") DO NOT LOAD ALL DEPENDENCIES!
    dofile("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
    dofile("mods/noita-mp/files/scripts/extensions/stringExtensions.lua")
    dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
    dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")

    pid = params[1]
    print("pid", pid)

    lfs    = require("lfs")
    winapi = require("winapi")
    socket = require("socket")
    udp    = assert(socket.udp())

    udp:settimeout(0)
    assert(udp:setsockname("*", 71041))

    plotly                = require("plotly")
    utils                 = require("Utils")
        :new(nil)
    local noitaMpSettings = require("NoitaMpSettings")
        :new(nil, nil, {}, nil, nil, lfs, nil, utils, winapi)
    local customProfiler  = noitaMpSettings.customProfiler or error("NoitaMpSettings.customProfiler is nil!", 2)
    logger                = noitaMpSettings.logger or error("NoitaMpSettings.logger is nil!", 2)
    fileUtils             = noitaMpSettings.fileUtils or error("NoitaMpSettings.fileUtils is nil!", 2)

    reportDirectory       = ("%s%sNoitaMP-Reports%s%s")
        :format(fileUtils:GetDesktopDirectory(), pathSeparator, pathSeparator, os.date("%Y-%m-%d_%H-%M-%S", os.time()))


    -- local json = require 'dkjson' REMOVE ME!
    -- local debuggee = require 'vscode-debuggee'
    -- local startResult, breakerType = debuggee.start(json)
    -- print('debuggee start ->', startResult, breakerType)

    print("    _   __      _ __        __  _______     ____             _____ __            ")
    print("   / | / /___  (_) /_____ _/  |/  / __ \\   / __ \\_________  / __(_) /__  _____ ")
    print("  /  |/ / __ \\/ / __/ __ `/ /|_/ / /_/ /  / /_/ / ___/ __ \\/ /_/ / / _ \\/ ___/")
    print(" / /|  / /_/ / / /_/ /_/ / /  / / ____/  / ____/ /  / /_/ / __/ / /  __/ /       ")
    print("/_/ |_/\\____/_/\\__/\\__,_/_/  /_/_/      /_/   /_/   \\____/_/ /_/_/\\___/_/   ")
    print("")
    print(" Why Profiler?! Because NoitaMP 'nom nom' your memory. :KAPPA: Just skill issue! :( ")
    print("")
end

local report           = function()
    print("cache size " .. cache["size"] or 0 .. " >= 1024")
    print("Forcing Plotly to run..")

    if not fileUtils:Exists(reportDirectory) then
        fileUtils:MkDir(reportDirectory)
    end

    local x            = {}
    local y            = {}
    local xMemoryStart = {}
    local yMemoryStart = {}
    local xMemoryStop  = {}
    local yMemoryStop  = {}

    for functionName, cpcEntries in pairs(cache) do
        --print("key", functionName)
        --print("value", utils:pformat(cpcEntries))

        if functionName ~= "size" then
            for cpc, cpcStartStop in pairs(cpcEntries) do
                --print("key", cpc)
                --print("value", utils:pformat(cpcStartStop))

                local startEntry = cpcStartStop["start"]
                local stopEntry  = cpcStartStop["stop"]
                local duration   = 0

                if not startEntry then
                    --print(("startEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
                    --Logger.warn(Logger.channels.profiler, ("startEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
                end

                if not stopEntry then
                    --Logger.warn(Logger.channels.profiler, ("stopEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
                    --print(("stopEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
                end

                if startEntry and stopEntry then
                    duration = stopEntry.time - startEntry.time -- ms
                end

                if duration > 0 then
                    print(("%s ms for %s"):format(duration, functionName))
                    table.insert(x, startEntry.frame)
                    table.insert(y, duration)

                    cache[functionName][cpc] = nil -- free memory
                    cache["size"] = cache["size"] - 1
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
            figTime:write_trace_to_file(dataTime, reportDirectory)
        end
    end
    -- for functionName in orderedPairs(cache) do
    --     print("functionName", functionName)
    --     local entry2 = CustomProfiler.reportCache[functionName][index]
    --     if entry2.frame and entry2.duration then
    --         if entry2.duration > CustomProfiler.ceiling then
    --             entry2.duration = CustomProfiler.ceiling
    --         end
    --         table.insert(x, entry2.frame)
    --         table.insert(y, entry2.duration)
    --         table.insert(xMemoryStart, entry2.frame)
    --         table.insert(yMemoryStart, entry2.memoryStart)
    --         table.insert(xMemoryStop, entry2.frame)
    --         table.insert(yMemoryStop, entry2.memoryStop)
    --         --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName][index], "v")
    --         CustomProfiler.reportCache[functionName][index]  = nil
    --         CustomProfiler.reportCache[functionName]["size"] = CustomProfiler.reportCache[functionName]["size"] - 1
    --         if CustomProfiler.reportCache[functionName]["size"] == 0 then
    --             --table.setNoitaMpDefaultMetaMethods(CustomProfiler.reportCache[functionName], "kv")
    --             CustomProfiler.reportCache[functionName] = nil
    --         end
    --     end
    -- end



    -- local dataMemoryStart = {
    --     x            = xMemoryStart,
    --     y            = yMemoryStart,
    --     type         = "bar",
    --     --mode    = "lines",
    --     textposition = "auto",
    --     name         = functionName .. " mb start",
    --     text         = functionName .. " mb start",
    --     --line    = { width = 1 },
    --     opacity      = 0.75,
    --     --font    = { size = 8 },
    -- }
    -- local figMemoryStart  = plotly.figure()
    -- figMemoryStart:write_trace_to_file(dataMemoryStart, CustomProfiler.reportDirectory)

    -- local dataMemoryStop = {
    --     x            = xMemoryStop,
    --     y            = yMemoryStop,
    --     type         = "bar",
    --     --mode    = "lines",
    --     textposition = "auto",
    --     name         = functionName .. " mb stop",
    --     text         = functionName .. " mb stop",
    --     --line    = { width = 1 },
    --     opacity      = 0.75,
    --     --font    = { size = 8 },
    -- }
    -- local figMemoryStop  = plotly.figure()
    -- figMemoryStop:write_trace_to_file(dataMemoryStop, CustomProfiler.reportDirectory)

    -- CustomProfiler.reportCache[functionName] = nil

    local fig1 = plotly.figure()
    fig1:update_layout {
        width   = 1920,
        height  = 1080,
        title   = ("NoitaMP Profiler Report of %s %s"):format(pid, "FileUtils.GetVersionByFile()"),
        xaxis   = { title = { text = "Frames" } },
        yaxis   = { title = { text = "Execution time [ms]" }, range = { 0, 100 } },
        barmode = "group"
    }
    fig1:update_config {
        scrollZoom = true,
        responsive = true
    }
    fig1:tofilewithjsondatafile(reportDirectory .. "\\" .. reportFilename, reportDirectory)
end

---comment
---@param functionName string
---@param customProfilerCounter number
local report2          = function(functionName, customProfilerCounter)
    local cpcStartStop = cache[functionName][customProfilerCounter]
    local startEntry   = cpcStartStop["start"]
    local stopEntry    = cpcStartStop["stop"]
    local duration     = 0
    local x            = {}
    local y            = {}

    if not startEntry then
        --print(("startEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
        --Logger.warn(Logger.channels.profiler, ("startEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
        return false
    end

    if not stopEntry then
        --Logger.warn(Logger.channels.profiler, ("stopEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
        --print(("stopEntry is nil for functionName '%s' and cpc '%s'"):format(functionName, cpc))
        return false
    end

    if startEntry and stopEntry then
        duration = stopEntry.time - startEntry.time -- ms
    end

    if duration > 0 then
        print(("%s ms (cpc %s frame %s) for %s"):format(duration, customProfilerCounter, startEntry.frame, functionName))
        table.insert(x, startEntry.frame)
        table.insert(y, duration)

        cache[functionName][customProfilerCounter] = nil -- free memory
        cache["size"] = cache["size"] - 1
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
    figTime:write_trace_to_file(dataTime, reportDirectory)

    --[[ Create report directory ]]
    local fig1 = plotly.figure()
    figTime:update_layout {
        width   = 1920,
        height  = 1080,
        title   = ("NoitaMP Profiler Report of %s %s"):format(pid, "FileUtils.GetVersionByFile()"),
        xaxis   = { title = { text = "Frames" } },
        yaxis   = { title = { text = "Execution time [ms]" }, range = { 0, 100 } },
        barmode = "group"
    }
    figTime:update_config {
        scrollZoom = true,
        responsive = true
    }
    figTime:tofilewithjsondatafile(reportDirectory .. "\\" .. reportFilename, reportDirectory)

    return true
end

---`run` will run the profiler until Noita is closed.
local run              = function()
    local P = winapi.process_from_id(pid)
    local exitCode = P:get_exit_code()

    print("Will die at " .. MAX_MEMORY_USAGE .. " KB")

    while exitCode ~= 0 do
        --[[ Recieve data from Noita.exe-Client ]]
        local dataString = udp:receive() --local data, msgOrIp, portOrNil = udp:receivefrom()
        if dataString then
            local frame                 = dataString:split(", ")[1]
            local customProfilerCounter = dataString:split(", ")[2]
            local startOrStop           = dataString:split(", ")[3]
            local time                  = dataString:split(", ")[4]
            local functionName          = dataString:split(", ")[5]
            local noitaMemoryUsage      = dataString:split(", ")[6]


            print(("Frame %s cpc %s %s time %s %s memoryUsage %s"):format(
                string.ExtendOrCutStringToLength(frame, 8, " ", true),
                string.ExtendOrCutStringToLength(customProfilerCounter, 8, " ", true),
                string.ExtendOrCutStringToLength(startOrStop, 5, " ", true),
                string.ExtendOrCutStringToLength(time, 12, " ", true),
                string.ExtendOrCutStringToLength(functionName, 50, " ", true),
                string.ExtendOrCutStringToLength(noitaMemoryUsage, 15, " ", true))
            )

            frame = tonumber(frame)
            customProfilerCounter = tonumber(customProfilerCounter) or error("customProfilerCounter is nil!", 2)
            time = tonumber(time)
            noitaMemoryUsage = tonumber(noitaMemoryUsage)

            if not cache[functionName] then
                cache[functionName] = {}
            end

            if not cache[functionName][customProfilerCounter] then
                cache[functionName][customProfilerCounter] = {}
            end

            if not cache["size"] then
                cache["size"] = 1
            end
            cache["size"] = cache["size"] + 1

            if startOrStop == "start" then --Utils.IsEmpty(cache[functionName][customProfilerCounter]) then
                cache[functionName][customProfilerCounter]["start"] = {
                    ["frame"] = frame,
                    ["time"] = time,
                    ["noitaMemoryUsage"] = noitaMemoryUsage
                }
            else
                cache[functionName][customProfilerCounter]["stop"] = {
                    ["frame"] = frame,
                    ["time"] = time,
                    ["noitaMemoryUsage"] = noitaMemoryUsage
                }
                local success = report2(functionName, customProfilerCounter)
                if success then
                    cache[functionName][customProfilerCounter] = nil
                end
            end

            if cache["size"] >= 1024 then
                --report()
            end

            --print(utils:pformat(cache))
        end

        --[[ Just some memory double checking! ]]
        local memoryUsage = math.ceil(collectgarbage("count"))
        if memoryUsage >= MAX_MEMORY_USAGE then
            print("memory usage " .. memoryUsage .. " >= " .. MAX_MEMORY_USAGE .. " KB")
            print("Forcing Garbage Collector to run..")
            collectgarbage("collect")
            memoryUsage = math.ceil(collectgarbage("count"))
            print("memory usage after collectgarbage " .. memoryUsage .. " KB")
            break
        end

        --[[ Track Noita.exe's exit code ]]
        exitCode = P:get_exit_code()
    end
    print("Noita is not running!")
end

---`exit` will exit the profiler and clean up.
local exit             = function()
    print("exiting..")

    print("Stoping udp server..")
    udp:close()
    print("Done!")

    print("Updating report..")
    report()
    print("Done!")

    print("Entries left without a stop entry:" .. utils:pformat(cache))
    os.exit(0)
    print("Bye, enjoy your day!")
    _G.profilerIsRunning = false
end

init()
run()
exit()
