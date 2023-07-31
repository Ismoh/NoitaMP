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

function TestNoitaMpSettings:testSet()
    lu.assertError(NoitaMpSettings.set, "key", nil)
    lu.assertError(NoitaMpSettings.set, nil, "value")
    lu.assertError(NoitaMpSettings.set, "key", "")
    lu.assertError(NoitaMpSettings.set, "", "value")

    local name = "TestName1"
    local guid = GuidUtils:getGuid()
    NoitaMpSettings.set("name", name)
    local content = NoitaMpSettings.set("guid", guid)
    lu.assertStrContains(content, name)
    lu.assertStrContains(content, guid)
end

function TestNoitaMpSettings:testGet()
    lu.assertErrorMsgContains("", NoitaMpSettings.get, "asd")

    local name = "NameExists"
    NoitaMpSettings.set("name", name)
    local nameSetting = NoitaMpSettings.get("name")
    lu.assertEquals(nameSetting, name)
end