TestNoitaMpSettings = {}

function TestNoitaMpSettings:setUp()
end

function TestNoitaMpSettings:tearDown()
end

function TestNoitaMpSettings:testClearAndCreateSettings()
    NoitaMpSettings.clearAndCreateSettings()
    local files = FileUtils.GetAllFilesInDirectory(FileUtils.GetAbsolutePathOfNoitaMpSettingsDirectory(), "json")
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