---Simple profiler that can be used to measure the duration of a function and the memory usage of a function.
---@class CustomProfiler
local CustomProfiler = {

    --[[ Attributes ]]

    ---@type table<string, table<number, table<string, number>>> A cache that stores all the data that is used to generate the report.
    reportCache               = {},
    ---@private
    ---@type number The counter that is used to determine the order of the function calls.
    counter                   = 1,
    ---@type number The threshold in milliseconds. If a function takes longer than this threshold, it will be reported.
    threshold                 = 16.5,          -- Default: 16.5ms = 60.60 fps
    ---@type number The ceiling in milliseconds. If a function takes longer than this ceiling, it will be truncated.
    ceiling                   = 1001,          -- Default: 1001 ms
    ---@type number The maximum amount of entries per trace.
    maxEntries                = 50,            -- Default: 50
    ---@type string The directory where the report will be saved.
    reportDirectory           = "reports",     -- Default: reports
    ---@type string The filename of the report.
    reportFilename            = "report.html", -- Default: report.html
    ---@type string The filename pattern of the report.
    reportJsonFilenamePattern = "%s.json",     -- Default: %s.json
}

function CustomProfiler:init()
    if not self.noitaMpSettings:get("noita-mp.toggle_profiler", "boolean") or not require or _G.profilerIsRunning then
        return
    end

    local content = ('cd "%s" && cmd /k lua.bat files\\scripts\\bin\\profiler.lua'):format(self.fileUtils:GetAbsoluteDirectoryPathOfNoitaMP())
    content = content .. " %1"
    self.fileUtils:WriteFile(("%s/profiler.bat"):format(self.fileUtils:GetAbsoluteDirectoryPathOfNoitaMP()), content)
    self:startExternalProfiler(self.winapi.get_current_pid())
    _G.profilerIsRunning = true

    self.udp:settimeout(0)
    self.udp:setpeername("localhost", 71041)
end

---Starts the external profiler.
---@param pid number The process id of Noita.
function CustomProfiler:startExternalProfiler(pid)
    local command = nil
    if self.ffi.os == "Windows" then
        command = ('start "NoitaMP - Profiler" /D "%s" profiler.bat %s 2>&1 &'):format(self.fileUtils:GetAbsoluteDirectoryPathOfNoitaMP(), pid)
        print(command)
    else
        error("Unix system are not supported yet :(", 2)
    end
    os.execute(command)
end

---Starts the profiler. This has to be called before the function (or first line of function code) that you want to measure.
---@see CustomProfiler:stop(functionName, customProfilerCounter)
---@param functionName string The name of the function that you want to measure. This has to be the same as the one used in CustomProfiler:stop(functionName, customProfilerCounter)
---@return number returnCounter The counter that is used to determine the order of the function calls. This has to be passed to CustomProfiler:stop(functionName, customProfilerCounter)
function CustomProfiler:start(functionName)
    if not self.noitaMpSettings:get("noita-mp.toggle_profiler", "boolean") or not require then
        return -1
    end
    if not self.udp:getsockname() then
        print("CustomProfilers udp isn't connected yet!")
        return -1
    end

    -- if not self.reportCache[functionName] then
    --     self.reportCache[functionName] = {}
    -- end

    local frame       = GameGetFrameNum()
    local time        = GameGetRealWorldTimeSinceStarted() * 1000
    self.counter      = self.counter + 1

    local networkData = ("%s, %s, %s, %s, %s, %s"):format(frame, self.counter, "start", time, functionName, collectgarbage("count") / 1024)
    self.udp:send(networkData)
    return self.counter
end

---Stops the profiler. This has to be called after the function (or last line of function code, but before any `return`) that you want to measure.
---@param functionName string The name of the function that you want to measure. This has to be the same as the one used in @see CustomProfiler.start(functionName)
---@param customProfilerCounter number The counter that is used to determine the order of the function calls. This has to same as the one returned by @see CustomProfiler.start(functionName)
function CustomProfiler:stop(functionName, customProfilerCounter)
    if not self.noitaMpSettings:get("noita-mp.toggle_profiler", "boolean") or not require then
        return -1
    end
    if not self.udp:getsockname() then
        print("CustomProfilers udp isn't connected yet!")
        return -1
    end

    local frame       = GameGetFrameNum()
    local time        = GameGetRealWorldTimeSinceStarted() * 1000

    local networkData = ("%s, %s, %s, %s, %s, %s"):format(frame, customProfilerCounter, "stop", time, functionName, collectgarbage("count") / 1024)
    self.udp:send(networkData)
    return 0
end

---Creates a report of all the functions that were profiled into profiler_2022-11-24_20-23-00.json
function CustomProfiler:report()
    local fig1 = self.plotly.figure()

    fig1:update_layout {
        width   = 1920,
        height  = 1080,
        title   = "NoitaMP Profiler Report of " .. whoAmI() or nil .. " " .. self.fileUtils:GetVersionByFile(),
        xaxis   = { title = { text = "Frames" } },
        yaxis   = { title = { text = "Execution time [ms]" } },
        barmode = "group"
    }
    fig1:update_config {
        scrollZoom = true,
        responsive = true
    }
    fig1:tofilewithjsondatafile(self.reportDirectory .. pathSeparator .. self.reportFilename, self.reportDirectory)
end

---Returns the size of the report cache.
---@return number size
function CustomProfiler:getSize()
    local size = 0
    for i = 1, #self.reportCache do
        size = size + tonumber(self.reportCache[i]["size"])
    end
    return size
end

---CustomProfiler constructor.
---@param customProfiler CustomProfiler|nil require("CustomProfiler") or nil
---@param fileUtils FileUtils|nil can be nil
---@param noitaMpSettings NoitaMpSettings required
---@param plotly plotly|nil can be nil
---@param socket socket|nil can be nil
---@param utils Utils|nil can be nil
---@param winapi winapi|nil can be nil
---@return CustomProfiler
function CustomProfiler:new(customProfiler, fileUtils, noitaMpSettings, plotly, socket, utils, winapi)
    ---@class CustomProfiler
    customProfiler = setmetatable(customProfiler or self, CustomProfiler)

    --local cpc      = customProfiler:start("CustomProfiler:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not customProfiler.noitaMpSettings then
        noitaMpSettings.customProfiler = customProfiler
        ---@type NoitaMpSettings
        customProfiler.noitaMpSettings = noitaMpSettings or error("CustomProfiler:new requires a NoitaMpSettings object", 2)
    end

    if not customProfiler.socket then
        ---@type socket
        customProfiler.socket = socket or require("socket")
    end

    if not customProfiler.udp then
        customProfiler.udp = assert(self.socket.udp())
    end

    if not customProfiler.fileUtils then
        ---@type FileUtils
        customProfiler.fileUtils = fileUtils or require("FileUtils"):new(nil, customProfiler, nil, noitaMpSettings, plotly, utils)
    end

    if not customProfiler.plotly then
        customProfiler.plotly = plotly or require("plotly") --:new()
    end

    if not customProfiler.utils then
        ---@type Utils
        customProfiler.utils = utils or require("Utils") --:new()
    end

    if not customProfiler.winapi then
        customProfiler.winapi = winapi or require("winapi")
    end

    if not customProfiler.ffi then
        customProfiler.ffi = require("ffi")
    end

    -- Fix missing dependencies for noitaMpSettings, when starting the first time

    if not noitaMpSettings.customProfiler then
        noitaMpSettings.customProfiler = customProfiler
    end

    if not noitaMpSettings.fileUtils then
        noitaMpSettings.fileUtils = customProfiler.fileUtils
    end

    if not noitaMpSettings.winapi then
        noitaMpSettings.winapi = customProfiler.winapi
    end

    if not noitaMpSettings.utils then
        noitaMpSettings.utils = customProfiler.utils
    end

    if not noitaMpSettings.json then
        noitaMpSettings.json = require("json")
    end

    local cpc = customProfiler:start("CustomProfiler:new")

    --[[ Attributes ]]

    customProfiler.reportDirectory = ("%s%sNoitaMP-Reports%s%s")
        :format(customProfiler.fileUtils:GetDesktopDirectory(), pathSeparator, pathSeparator, os.date("%Y-%m-%d_%H-%M-%S", os.time()))

    customProfiler:stop("CustomProfiler:new", cpc)
    return customProfiler
end

return CustomProfiler
