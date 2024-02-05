TestGuidUtils   = {}

function TestGuidUtils:setUp()

end

function TestGuidUtils:tearDown()
    print("\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print("\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestGuidUtils:testGetGuid()
    local guid = guidUtils:generateNewGuid()
    lu.assertNotIsNil(guid)
    lu.assertIsTrue(guidUtils:isPatternValid(guid))

    lu.assertIsFalse(guidUtils:isPatternValid(""))
    lu.assertIsFalse(guidUtils:isPatternValid(nil))

    local number = tonumber(1)
    lu.assertIsFalse(guidUtils:isPatternValid(number))
end

function TestGuidUtils:testRandomness()
    local t = {}
    for i = 1, 10, 1 do
        local new_guid = guidUtils:generateNewGuid()
        lu.assertIsFalse(table.contains(t, new_guid))
        table.insert(t, new_guid)
    end
end

function TestGuidUtils:testToNumber()
    local guid   = guidUtils:generateNewGuid()
    local number = guidUtils:toNumber(guid)
    lu.assertNotIsNil(number)
    lu.assertIsTrue(type(number) == "number", "GuidUtils.toNumber didn't return a number!")
end
