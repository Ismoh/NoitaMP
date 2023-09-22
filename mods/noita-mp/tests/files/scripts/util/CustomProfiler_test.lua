-- Thanks to GitHub Copilot chat for helping me write this test file!

-- Import the necessary modules
local CustomProfiler = require("CustomProfiler")
local lu = require("luaunit")

-- Create a mock object for the NoitaMpSettings class
local noitaMpSettingsMock = {
    get = function() return true end
}

-- Create a mock object for the FileUtils class
local fileUtilsMock = {
    WriteFile = function() end,
    GetAbsoluteDirectoryPathOfNoitaMP = function() return "path/to/noitamp" end
}

-- Create a mock object for the Plotly class
local plotlyMock = {
    figure = function() return {} end,
    tofilewithjsondatafile = function() end
}

-- Create a mock object for the Utils class
local utilsMock = {
    execLua = function() end
}

-- Create a mock object for the WinAPI class
local winapiMock = {}

-- Create a mock object for the Socket class
local socketMock = {
    udp = function() return {
        settimeout = function() end,
        setpeername = function() end,
        send = function() end
    } end
}

-- Create a new instance of the CustomProfiler class for each test
local customProfiler

function test_CustomProfiler_init_toggle_profiler_false()
    noitaMpSettingsMock.get = function() return false end
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    customProfiler:init()
    lu.assert_not_called(fileUtilsMock.WriteFile)
    lu.assert_not_called(utilsMock.execLua)
end

function test_CustomProfiler_init_toggle_profiler_true()
    noitaMpSettingsMock.get = function() return true end
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    customProfiler:init()
    lu.assert_called(fileUtilsMock.WriteFile)
    lu.assert_called(utilsMock.execLua)
end

function test_CustomProfiler_start_toggle_profiler_false()
    noitaMpSettingsMock.get = function() return false end
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    local result = customProfiler:start("testFunction")
    lu.assert_equals(-1, result)
end

function test_CustomProfiler_start_toggle_profiler_true()
    noitaMpSettingsMock.get = function() return true end
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    local result = customProfiler:start("testFunction")
    lu.assert_is_number(result)
end

function test_CustomProfiler_stop_toggle_profiler_false()
    noitaMpSettingsMock.get = function() return false end
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    local result = customProfiler:stop("testFunction", 1)
    lu.assert_equals(-1, result)
end

function test_CustomProfiler_stop_toggle_profiler_true()
    noitaMpSettingsMock.get = function() return true end
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    local result = customProfiler:stop("testFunction", 1)
    lu.assert_equals(0, result)
end

function test_CustomProfiler_report()
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    customProfiler:report()
    lu.assert_called(plotlyMock.figure)
    lu.assert_called(plotlyMock.tofilewithjsondatafile)
end

function test_CustomProfiler_getSize()
    customProfiler = CustomProfiler:new(nil, fileUtilsMock, noitaMpSettingsMock, plotlyMock, socketMock, utilsMock, winapiMock)
    customProfiler.reportCache = {
        testFunction1 = { size = 10 },
        testFunction2 = { size = 5 },
        testFunction3 = { size = 3 }
    }
    local result = customProfiler:getSize()
    lu.assert_equals(18, result)
end
