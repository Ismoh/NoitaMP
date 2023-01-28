---
--- Created by Ismoh-PC.
--- DateTime: 23.01.2023 17:37
---
local params = ...

-- [[ require ]] --
require("NetworkUtils")
require("NetworkCacheUtils")
require("noitamp_cache")
require("CustomProfiler")
local lu                           = require("luaunit")
local md5                          = require("md5")

-- [[ Test ]] --
TestNetworkCacheUtils              = {}

--- Setup function for each test.
--- Make absolutely sure, that the already mocked Noita API function is not overwritten
local mockedModSettingGetNextValue = ModSettingGetNextValue
function TestNetworkCacheUtils:setUp()
    ModSettingGetNextValue = function(id)
        if id == "noita-mp.toggle_profiler" then
            return false
        end
        if mockedModSettingGetNextValue then
            mockedModSettingGetNextValue(id)
        end
        error(("Trying to access '%s', but it isn't mocked yet!"):format(id), 2)
    end
end

--- Teardown function for each test.
function TestNetworkCacheUtils:tearDown()
end

function TestNetworkCacheUtils:testGetSum()
    local dataSimple  = { 9999,
                          { name = "test", guid = "guid" }, 1234, 3, 1.2, 3.4, 0.5, { 12, 3 } }
    local sumSimple   = NetworkCacheUtils.getSum(NetworkUtils.events.newNuid.name, dataSimple)
    local sumExpected = "test,guid,1234,3,1.2,3.4,0.5,12,3"
    lu.assertEquals(sumSimple, sumExpected)

    local guid             = GuidUtils:getGuid()
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local data             = { networkMessageId,
                               { name = "test", guid = guid }, 1234, 3, 1.2, 3.4, 0.5, { 12, 3 },
                               "/test/filename.xml", { current = 57, max = 100 }, false }
    local sum              = NetworkCacheUtils.getSum(NetworkUtils.events.newNuid.name, data)
    local sum2             = NetworkCacheUtils.getSum(NetworkUtils.events.newNuid.name, data)
    lu.assertEquals(sum, sum2)
end

function TestNetworkCacheUtils:testSet()
    local guid             = GuidUtils:getGuid()
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local data             = { networkMessageId, { name = "test", guid = guid },
                               1234, 3, 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local expectedChecksum = NetworkCacheUtils.set(guid, networkMessageId, NetworkUtils.events.newNuid.name,
                                                   NetworkUtils.events.acknowledgement.sent, 0, os.clock(), data)
    local cached           = NetworkCacheUtils.get(guid, networkMessageId, NetworkUtils.events.newNuid.name)
    lu.assertEquals(cached.dataChecksum, expectedChecksum)

    local guid2             = GuidUtils:getGuid({ guid })
    local networkMessageId2 = NetworkUtils.getNextNetworkMessageId()
    local data2             = { networkMessageId2--[[ different ]], { name = "test2", guid = guid2 },
                                1234, 5--[[ different ]], 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local expectedChecksum2 = NetworkCacheUtils.set(guid2, networkMessageId2, NetworkUtils.events.newNuid.name,
                                                    NetworkUtils.events.acknowledgement.sent, 0, os.clock(), data2)
    local cached2           = NetworkCacheUtils.getByChecksum(guid2, data2, NetworkUtils.events.newNuid.name)
    lu.assertEquals(cached2.dataChecksum, expectedChecksum2)
end

function TestNetworkCacheUtils:testGet()
    --local guid             = GuidUtils:getGuid()
    --NetworkCacheUtils.get(guid, networkMessageId, event)
end

lu.LuaUnit.run(params)