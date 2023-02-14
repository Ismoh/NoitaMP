---
--- Created by Ismoh.
--- DateTime: 14.02.2023 12:01
---
local params        = ...

local lu            = require("luaunit")

TestNoitaMpSettings = {}

function TestNoitaMpSettings:setUp()

    local mockedModSettingGetNextValue = ModSettingGetNextValue
    ModSettingGetNextValue             = function(id)
        if id == "noita-mp.guid" then
            return MinaUtils.getLocalMinaGuid()
        end
    end

    if not NoitaMpSettings then
        require("NoitaMpSettings")
    end
    if not GuidUtils then
        require("GuidUtils")
    end
    if not CustomProfiler then
        require("CustomProfiler")
    end
    if not Server then
        require("Server")
    end
    if not Client then
        require("Client")
    end
end

function TestNoitaMpSettings:tearDown()

end

function TestNoitaMpSettings:testClearAndCreateSettings()

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
