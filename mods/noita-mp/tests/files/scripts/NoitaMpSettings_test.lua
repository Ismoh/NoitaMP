---
--- Created by Ismoh.
--- DateTime: 14.02.2023 12:01
---
local params        = ...

local lu            = require("luaunit")
local fu            = require("file_util")

TestNoitaMpSettings = {}

function TestNoitaMpSettings:setUp()
end

function TestNoitaMpSettings:tearDown()
end

function TestNoitaMpSettings:testClearAndCreateSettings()
    NoitaMpSettings.clearAndCreateSettings()
    local files = fu.getAllFilesInDirectory(fu.getAbsolutePathOfNoitaMpSettingsDirectory(), "json")
    lu.assertEquals(files, {}, "Settings directory wasn't empty!")
end

function TestNoitaMpSettings:testWriteSettings()
    lu.assertError(NoitaMpSettings.writeSettings, "key", nil)
    lu.assertError(NoitaMpSettings.writeSettings, nil, "value")
    lu.assertError(NoitaMpSettings.writeSettings, "key", "")
    lu.assertError(NoitaMpSettings.writeSettings, "", "value")

    local name = "TestName1"
    local guid = GuidUtils:getGuid()
    NoitaMpSettings.writeSettings("name", name)
    local content = NoitaMpSettings.writeSettings("guid", guid)
    lu.assertStrContains(content, name)
    lu.assertStrContains(content, guid)
end

function TestNoitaMpSettings:testGetSetting()
    lu.assertErrorMsgContains("", NoitaMpSettings.getSetting, "asd")

    local name = "NameExists"
    NoitaMpSettings.writeSettings("name", name)
    local nameSetting = NoitaMpSettings.getSetting("name")
    lu.assertEquals(nameSetting, name)
end

lu.LuaUnit.run(params)
