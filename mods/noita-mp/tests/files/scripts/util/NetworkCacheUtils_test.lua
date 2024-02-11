TestNetworkCacheUtils = {}

if not server then
    server = require("Server").new(nil, nil, nil, nil, nil, nil, {}, nil)
end
if not client then
    clinet = require("Client").new(nil, nil, nil, server, {}, nil)
end

noitaMpSettings = noitaMpSettings or
    require("NoitaMpSettings")
    :new(nil, nil, {}, nil, nil, nil, nil, nil, nil)

customProfiler = customProfiler or
    require("CustomProfiler")
    :new(nil, nil, noitaMpSettings, nil, nil, nil, nil)

networkCache = networkCache or
    require("NetworkCache")
    :new(customProfiler, nil, nil)

networkCacheUtils = networkCacheUtils or
    require("NetworkCacheUtils")
    :new(customProfiler, guidUitls, logger, nil, networkCache, nil, nil)

networkUtils = networkUtils or
    require("NetworkUtils")
    :new(customProfiler, guidUitls, logger, networkCacheUtils, nil)

--- Setup function for each test.
function TestNetworkCacheUtils:setUp()
    logger:trace(logger.channels.testing, "-------------------- setUp")
end

--- Teardown function for each test.
function TestNetworkCacheUtils:tearDown()
    logger:trace(logger.channels.testing, "-------------------- tearDown")
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestNetworkCacheUtils:testGetSum()
    local dataSimple  = { 9999, { name = "test", guid = "guid" }, 1234, 3, 1.2, 3.4, 0.5, { 12, 4 }, "player.xml", { max = 100, current = 48 }, false }
    local sumSimple   = networkCacheUtils:getSum(networkUtils.events.newNuid.name, dataSimple)
    local sumExpected = "test,guid,3,player.xml,1234"
    lu.assertEquals(sumSimple, sumExpected)

    local dataSimple2  = { 9999, { name = "test", guid = "guid" }, 9876, 33, 1.22, 3.44, 0.55, { 24, 8 }, "player.xml", { max = 200, current = 123 }, false }
    local sumSimple2   = networkCacheUtils:getSum(networkUtils.events.newNuid.name, dataSimple2)
    local sumExpected2 = "test,guid,33,player.xml,9876"
    lu.assertEquals(sumSimple2, sumExpected2)

    local guid             = guidUtils:generateNewGuid()
    local networkMessageId = networkUtils:getNextNetworkMessageId()
    local data             = { networkMessageId, { name = "test", guid = guid }, 1234, 3, 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local sum              = networkCacheUtils:getSum(networkUtils.events.newNuid.name, data)
    local sum2             = networkCacheUtils:getSum(networkUtils.events.newNuid.name, data)
    lu.assertEquals(sum, sum2)
end

function TestNetworkCacheUtils:testSet()
    local guid             = guidUtils:generateNewGuid()
    local networkMessageId = networkUtils:getNextNetworkMessageId()
    local data             = { networkMessageId, { name = "test", guid = guid }, 1234, 3, 1.2, 3.4, 0.5, { 12, 3 }, "/test/filename.xml", { current = 57, max = 100 }, false }
    local expectedChecksum = networkCacheUtils:set(guid, networkMessageId, networkUtils.events.newNuid.name,
        networkUtils.events.acknowledgement.status.sent, 0, os.clock(), data)
    local cached           = networkCacheUtils:get(guid, networkMessageId, networkUtils.events.newNuid.name)
    lu.assertEquals(cached.dataChecksum, expectedChecksum)

    local guid2             = guidUtils:generateNewGuid({ guid })
    local networkMessageId2 = networkUtils:getNextNetworkMessageId()
    local data2             = { networkMessageId2 --[[ different ]], { name = "test2", guid = guid2 }, 1234, 5 --[[ different ]], 1.2, 3.4, 0.5, { 12, 3 },
        "/test/filename.xml", { current = 57, max = 100 }, false }
    local expectedChecksum2 = networkCacheUtils:set(guid2, networkMessageId2, networkUtils.events.newNuid.name,
        networkUtils.events.acknowledgement.status.sent, 0, os.clock(), data2)
    local cached2           = networkCacheUtils:getByChecksum(guid2, networkUtils.events.newNuid.name, data2)
    lu.assertEquals(cached2.dataChecksum, expectedChecksum2)
end

function TestNetworkCacheUtils:testGet()
    --local guid             = GuidUtils:getGuid()
    --networkCacheUtils:get(guid, networkMessageId, event)
end
