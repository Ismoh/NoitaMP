TestNoitaMpSettings = {}

noitaMpSettings = noitaMpSettings or
    require("NoitaMpSettings")
    :new(nil, nil, {}, nil, nil, nil, nil, nil, nil)

fileUtils = fileUtils or
    require("FileUtils")
    :new(nil, nil, nil, noitaMpSettings, nil, nil)

function TestNoitaMpSettings:setUp()
end

function TestNoitaMpSettings:tearDown()
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestNoitaMpSettings:testClearAndCreateSettings()
    noitaMpSettings:clearAndCreateSettings()
    local files = fileUtils:GetAllFilesInDirectory(fileUtils:GetAbsolutePathOfNoitaMpSettingsDirectory(), "json")
    lu.assertEquals(files, {}, "Settings directory wasn't empty!")
end

function TestNoitaMpSettings:testSet()
    lu.assertError(noitaMpSettings.set, "key", nil)
    lu.assertError(noitaMpSettings.set, nil, "value")
    lu.assertError(noitaMpSettings.set, "key", "")
    lu.assertError(noitaMpSettings.set, "", "value")

    local name = "TestName1"
    local guid = guidUtils:generateNewGuid()
    noitaMpSettings:set("name", name)
    local content = noitaMpSettings:set("guid", guid)
    lu.assertStrContains(content, name)
    lu.assertStrContains(content, guid)
end

function TestNoitaMpSettings:testGet()
    lu.assertErrorMsgContains("", noitaMpSettings.get, "asd")

    local name = "NameExists"
    noitaMpSettings:set("name", name)
    local nameSetting = noitaMpSettings:get("name")
    lu.assertEquals(nameSetting, name)
end
