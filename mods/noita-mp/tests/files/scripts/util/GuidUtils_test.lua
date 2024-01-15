TestGuidUtils   = {}

function TestGuidUtils:setUp()

end

function TestGuidUtils:tearDown()
    print("\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print("\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestGuidUtils:testGetGuid()
    local guid = GuidUtils:getGuid()
    lu.assertNotIsNil(guid)
    lu.assertIsTrue(GuidUtils.isPatternValid(guid))

    lu.assertIsFalse(GuidUtils.isPatternValid(""))
    lu.assertIsFalse(GuidUtils.isPatternValid(nil))

    local number = tonumber(1)
    lu.assertIsFalse(GuidUtils.isPatternValid(number))
end

function TestGuidUtils:testRandomness()
    local t = {}
    for i = 1, 10, 1 do
        local new_guid = GuidUtils:getGuid()
        lu.assertIsFalse(table.contains(t, new_guid))
        table.insert(t, new_guid)
    end
end

function TestGuidUtils:testToNumber()
    local guid   = GuidUtils:getGuid()
    local number = GuidUtils.toNumber(guid)
    lu.assertNotIsNil(number)
    lu.assertIsTrue(type(number) == "number", "GuidUtils.toNumber didn't return a number!")
end
