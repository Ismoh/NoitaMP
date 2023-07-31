local params = { ... }
print("params", table.concat(params, ", "))

---@type string The directory where the report will be saved.
local reportDirectory = nil
local reportFilename  = "report.html"

local pid             = nil
local lfs             = nil
local winapi          = nil
local socket          = nil
local udp             = nil
local cache           = {}
local plotly          = nil

---Initilizes the external profiler. All dependencies were loaded here.
local init            = function()
    _G.MAX_MEMORY_USAGE = 524438 -- KB = 524,438 MB

    pid = params[1]
    print("pid", pid)

    local noitaRootPath = io.popen("cd .. && cd .. && cd"):read("*l")
    print("noitaRootPath", noitaRootPath)

    dofile(noitaRootPath .. "/mods/noita-mp/files/scripts/init/init_package_loading.lua")

    lfs = require("lfs")

    local pathToMods = lfs.currentdir() .. "/../.."
    print("pathToMods: " .. pathToMods)

    local gDofile = dofile
    dofile        = function(path)
        if path:sub(1, 4) == "mods" then
            local pathToMod = pathToMods .. "/" .. path
            print("dofile path: " .. pathToMod)
            return gDofile(pathToMod)
        else
            return gDofile(path)
        end
    end

    -- dofile("mods/noita-mp/files/scripts/init/init_.lua") DO NOT LOAD ALL DEPENDENCIES!
    dofile("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
    dofile("mods/noita-mp/files/scripts/extensions/stringExtensions.lua")
    dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
    dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")

    if not _G.ModSettingGet then
        _G.ModSettingGet = function(id)
            if not id then
                return "UNKNOWN ModSettingGet id - FIX ME!"
            end
            if string.contains(id, "noita-mp.log_level_") then
                return { "trace", "debug, info, warn", "WARN" }
            end
        end
    end

    if not _G.Logger then
        _G.Logger = require("Logger")
    end

    if not _G.Utils then
        _G.Utils = require("Utils")
    end

    winapi = require("winapi")

    socket = require("socket")
    udp = assert(socket.udp())
    udp:settimeout(0)
    assert(udp:setsockname("*", 71041))

    plotly = require("plotly")

    if not _G.FileUtils then
        _G.FileUtils = require("FileUtils")
    end

    reportDirectory = ("%s%sNoitaMP-Reports%s%s")
        :format(FileUtils.GetDesktopDirectory(), pathSeparator, pathSeparator, os.date("%Y-%m-%d_%H-%M-%S", os.time()))


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

local report          = function()
    print("cache size " .. cache["size"] .. " >= 1024")
    print("Forcing Plotly to run..")

    if not FileUtils.Exists(reportDirectory) then
        FileUtils.MkDir(reportDirectory)
    end

    local x            = {}
    local y            = {}
    local xMemoryStart = {}
    local yMemoryStart = {}
    local xMemoryStop  = {}
    local yMemoryStop  = {}

    for functionName, cpcEntries in pairs(cache) do
        --print("key", functionName)
        --print("value", Utils.pformat(cpcEntries))

        if functionName ~= "size" then
            for cpc, cpcStartStop in pairs(cpcEntries) do
                --print("key", cpc)
                --print("value", Utils.pformat(cpcStartStop))

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
local report2         = function(functionName, customProfilerCounter)
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
local run             = function()
    local P = winapi.process_from_id(pid)
    local exitCode = P:get_exit_code()

    print("Will die at " .. MAX_MEMORY_USAGE .. " KB")

    while exitCode ~= 0 do
        --[[ Recieve data from Noita.exe-Client ]]
        local dataString = udp:receive() --local data, msgOrIp, portOrNil = udp:receivefrom()
        if dataString then
            local frame                 = tonumber(dataString:split(", ")[1])
            local customProfilerCounter = tonumber(dataString:split(", ")[2])
            local startOrStop           = dataString:split(", ")[3]
            local time                  = tonumber(dataString:split(", ")[4])
            local functionName          = dataString:split(", ")[5]
            local noitaMemoryUsage      = tonumber(dataString:split(", ")[6])


            print(("%s %s %s %s %s %s"):format(frame, customProfilerCounter, startOrStop, time, functionName, noitaMemoryUsage))

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

            --print(Utils.pformat(cache))
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
local exit            = function()
    print("exiting..")

    print("Stoping udp server..")
    udp:close()
    print("Done!")

    print("Updating report..")
    report()
    print("Done!")

    print("Entries left without a stop entry:" .. Utils.pformat(cache))
    os.exit(0)
    print("Bye, enjoy your day!")
end

init()
run()
exit()
