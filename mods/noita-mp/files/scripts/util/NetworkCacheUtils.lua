---
--- Created by Ismoh-PC.
--- DateTime: 23.01.2023 17:28
---
-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------
local util        = require("util")
local md5         = require("md5")

------------------------------------------------------------------------------------------------------------------------
--- NetworkUtils
------------------------------------------------------------------------------------------------------------------------
NetworkCacheUtils = {}

function NetworkCacheUtils.getSum(event, data)
    Logger.trace(Logger.channels.testing, "getSum: " .. util.pformat(data))
    if not event or type(event) ~= "string" then
        error(("Unable to calculate sum, when event is nil or not a string: '%s'"):format(event), 2)
    end
    if not data or type(data) ~= "table" then
        error(("Unable to calculate sum, when data is nil or not a table: '%s'"):format(data), 2)
    end
    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    local sumWithNetworkMessageId = table.contentToString(data)
    Logger.trace(Logger.channels.testing, ("sumWithNetworkMessageId = %s"):format(sumWithNetworkMessageId))
    local firstCommaIndex = string.find(sumWithNetworkMessageId:lower(), ",", 1, true) + 1
    Logger.trace(Logger.channels.testing, ("firstCommaIndex = %s"):format(firstCommaIndex))
    local sum = string.sub(sumWithNetworkMessageId, firstCommaIndex)

    Logger.trace(Logger.channels.testing, "getSum-end: " .. util.pformat(data))
    Logger.trace(Logger.channels.testing, ("sum = %s"):format(sum))
    return sum
end

--- Manipulates parameters to use Cache-CAPI.
--- @param peerGuid string peer.guid
--- @param networkMessageId number
---
function NetworkCacheUtils.set(peerGuid, networkMessageId, event, status, ackedAt, sendAt, data)
    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end
    local sum          = NetworkCacheUtils.getSum(event, data)
    local dataChecksum = md5.sumhexa(sum)
    NetworkCache.set(GuidUtils.toNumber(peerGuid), networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    return dataChecksum
end

--- @return table data { ackedAt, dataChecksum, event, messageId, sentAt, status}
function NetworkCacheUtils.get(peerGuid, networkMessageId, event)
    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end
    Logger.info(Logger.channels.testing,
                ("NetworkCacheUtils.get(%s, %s, %s)"):format(peerGuid, networkMessageId, event))
    Logger.info(Logger.channels.testing,
                ("NetworkCache.get(%s, %s, %s)"):format(GuidUtils.toNumber(peerGuid), event, networkMessageId))
    local data = NetworkCache.get(GuidUtils.toNumber(peerGuid), event, tonumber(networkMessageId))
    return data
end

--- @return table cacheData { ackedAt, dataChecksum, event, messageId, sentAt, status}
function NetworkCacheUtils.getByChecksum(peerGuid, data, event)
    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end
    local sum          = NetworkCacheUtils.getSum(event, data)
    local dataChecksum = md5.sumhexa(sum)
    local cacheData    = NetworkCache.getChecksum(GuidUtils.toNumber(peerGuid), dataChecksum)
    return cacheData
end