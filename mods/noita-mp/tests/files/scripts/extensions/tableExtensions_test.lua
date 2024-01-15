require("tableExtensions") -- load table extensions into _G.table

TestTableExtensions = {}

local gui = {}
local noitaMpSettings = require("NoitaMpSettings")
    :new(nil, nil, gui, nil, nil, nil, nil, nil, nil)
local guidUtils = require("GuidUtils")
    :new(nil, noitaMpSettings.customProfiler, nil, noitaMpSettings.logger, nil, nil, noitaMpSettings.utils, nil)
local networkCache = require("NetworkCache")
    :new(noitaMpSettings.customProfiler, noitaMpSettings.logger, noitaMpSettings.utils)
local networkCacheUtils = require("NetworkCacheUtils")
    :new(noitaMpSettings.customProfiler, guidUtils, noitaMpSettings.logger, nil, networkCache, nil, noitaMpSettings.utils)
local networkUtils = networkCacheUtils.networkUtils

function TestTableExtensions:test_contains()
    -- add something to network cache and check if it's there
    local peerGuid = guidUtils:generateNewGuid()
    local networkMessageId = networkUtils:getNextNetworkMessageId()
    local event = networkUtils.events.connect2.name
    local status = networkUtils.events.acknowledgement.sent
    local ackedAt = 0
    local sendAt = os.clock()
    local data = { networkMessageId, "PlayerName", "PlayerGuid" }

    networkCacheUtils:set(peerGuid, networkMessageId, event, status, ackedAt, sendAt, data)

    local sum = networkCacheUtils:getSum(event, data)
    local expectedChecksum = ("%s"):format(networkCacheUtils.md5.sumhexa(sum))
    local found, index, index2 = table.contains(networkCache.cache, expectedChecksum)
    local cachedChecksum = networkCache.cache[index][index2].dataChecksum
    lu.assertEquals(cachedChecksum, expectedChecksum)
end
