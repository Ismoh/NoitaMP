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
    local guid             = GuidUtils:getGuid()
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local data             = { networkMessageId, { name = "test", guid = guid },
                               1234, 3, 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local sum              = NetworkCacheUtils.getSum(data)
    local sum2             = NetworkCacheUtils.getSum(data)
    lu.assertEquals(sum, sum2)
end

function TestNetworkCacheUtils:testSet()
    local guid             = GuidUtils:getGuid()
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local data             = { networkMessageId, { name = "test", guid = guid },
                               1234, 3, 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local sum              = NetworkCacheUtils.getSum(data)
    local checksum         = md5.sumhexa(sum)
    NetworkCacheUtils.set(guid, networkMessageId, NetworkUtils.events.newNuid.name, NetworkUtils.events.acknowledgement.sent,
                          0, os.clock(), checksum)
    local cached = NetworkCacheUtils.get(guid, networkMessageId, NetworkUtils.events.newNuid.name)
    lu.assertEquals(checksum, cached.dataChecksum)

    local guid2             = GuidUtils:getGuid({ guid })
    local networkMessageId2 = NetworkUtils.getNextNetworkMessageId()
    local data2             = { networkMessageId2--[[ different ]], { name = "test2", guid = guid2 },
                                1234, 5--[[ different ]], 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local sum2              = NetworkCacheUtils.getSum(data2)
    local checksum2         = md5.sumhexa(sum2)
    NetworkCacheUtils.set(guid2, networkMessageId2, NetworkUtils.events.newNuid.name,
                          NetworkUtils.events.acknowledgement.sent,
                          0, os.clock(), checksum2)
    local cached2 = NetworkCacheUtils.getByChecksum(guid2, checksum2)
    lu.assertEquals(checksum2, cached2.dataChecksum)
end

function TestNetworkCacheUtils:testGet()
    --local guid             = GuidUtils:getGuid()
    --NetworkCacheUtils.get(guid, networkMessageId, event)
end

lu.LuaUnit.run(params)