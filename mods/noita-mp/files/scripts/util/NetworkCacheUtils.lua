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
local Utils        = require("Utils")
local md5         = require("md5")

------------------------------------------------------------------------------------------------------------------------
--- NetworkUtils
------------------------------------------------------------------------------------------------------------------------
NetworkCacheUtils = {}

function NetworkCacheUtils.getSum(event, data)
    local cpc = CustomProfiler.start("NetworkCacheUtils.getSum")
    Logger.trace(Logger.channels.testing, "getSum: " .. Utils.pformat(data))
    if not event or Utils.IsEmpty(event) or type(event) ~= "string" then
        error(("Unable to calculate sum, when event is nil or not a string: '%s'"):format(event), 2)
    end
    if not data or Utils.IsEmpty(data) or type(data) ~= "table" then
        error(("Unable to calculate sum, when data is nil or not a table: '%s'"):format(data), 2)
    end

    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    Logger.trace(Logger.channels.testing, "data: " .. Utils.pformat(data))
    local dataCopy = NetworkUtils.getClientOrServer().zipTable(data, NetworkUtils.events[event].schema, event)
    Logger.trace(Logger.channels.testing, "dataCopy zipped: " .. Utils.pformat(dataCopy))
    if event ~= NetworkUtils.events.acknowledgement.name then
        -- when event is NOT acknowledgement, remove networkMessageId,
        -- but we need the networkMessageId to find the previous cached network message, when the event is acknowledgement
        dataCopy.networkMessageId = nil
    end
    Logger.trace(Logger.channels.testing, "dataCopy without networkMessageId: " .. Utils.pformat(dataCopy))
    local sum = ""
    if NetworkUtils.events[event].resendIdentifiers ~= nil then
        local newData = {}
        for i = 1, #NetworkUtils.events[event].resendIdentifiers do
            local v = NetworkUtils.events[event].resendIdentifiers[i]
            if dataCopy[v] == nil then
                error(("dataCopy: data for event '%s' was missing '%s' resendIdentifier"):format(event, v), 2)
            end
            newData[v] = dataCopy[v]
            sum        = table.contentToString(newData)
        end
    else
        sum = table.contentToString(dataCopy)
    end
    Logger.trace(Logger.channels.testing, ("sum from %s = %s"):format(Utils.pformat(dataCopy), sum))
    CustomProfiler.stop("NetworkCacheUtils.getSum", cpc)
    return sum
end

--- Manipulates parameters to use Cache-CAPI.
--- @param peerGuid string peer.guid
--- @param networkMessageId number
---
function NetworkCacheUtils.set(peerGuid, networkMessageId, event, status, ackedAt, sendAt, data)
    local cpc = CustomProfiler.start("NetworkCacheUtils.set")
    if not peerGuid or Utils.IsEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(peerGuid), 2)
    end
    if not networkMessageId or Utils.IsEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId '%s' must not be nil or empty or isn't type of number!"):format(networkMessageId), 2)
    end
    if not event or Utils.IsEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(event), 2)
    end
    if not status or Utils.IsEmpty(status) or type(status) ~= "string" then
        error(("status '%s' must not be nil or empty or isn't type of string!"):format(status), 2)
    end
    if not ackedAt or Utils.IsEmpty(ackedAt) or type(ackedAt) ~= "number" then
        error(("ackedAt '%s' must not be nil or empty or isn't type of number!"):format(ackedAt), 2)
    end
    if not sendAt or Utils.IsEmpty(sendAt) or type(sendAt) ~= "number" then
        error(("sendAt '%s' must not be nil or empty or isn't type of number!"):format(sendAt), 2)
    end
    if not data or Utils.IsEmpty(data) or type(data) ~= "table" then
        error(("data '%s' must not be nil or empty or isn't type of table!"):format(Utils.pformat(data)), 2)
    end

    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    local sum           = NetworkCacheUtils.getSum(event, data)
    local dataChecksum  = md5.sumhexa(sum)
    local clientCacheId = GuidUtils.toNumber(peerGuid)
    print(("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
                  :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum))
    Logger.trace(Logger.channels.testing,
                 ("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
                         :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum))
    NetworkCache.set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    Logger.info(Logger.channels.cache,
                ("Set nCache for clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s")
                        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum))
    CustomProfiler.stop("NetworkCacheUtils.set", cpc)
    return dataChecksum
end

--- @return table data { ackedAt, dataChecksum, event, messageId, sentAt, status}
function NetworkCacheUtils.get(peerGuid, networkMessageId, event)
    local cpc = CustomProfiler.start("NetworkCacheUtils.get")
    if not peerGuid or Utils.IsEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(peerGuid), 2)
    end
    if not networkMessageId or Utils.IsEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId '%s' must not be nil or empty or isn't type of number!"):format(networkMessageId), 2)
    end
    if not event or Utils.IsEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(event), 2)
    end

    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end
    Logger.info(Logger.channels.testing,
                ("NetworkCacheUtils.get(peerGuid %s, networkMessageId %s, event %s)"):format(peerGuid, networkMessageId,
                                                                                             event))
    Logger.info(Logger.channels.testing,
                ("NetworkCache.get(clientCacheId %s, networkMessageId %s, event %s)"):format(GuidUtils.toNumber(peerGuid),
                                                                                             networkMessageId, event))
    local clientCacheId = GuidUtils.toNumber(peerGuid)
    local data          = NetworkCache.get(clientCacheId, event, tonumber(networkMessageId))
    Logger.info(Logger.channels.cache,
                ("Get nCache by clientCacheId %s, event %s, networkMessageId %s, data %s")
                        :format(clientCacheId, event, networkMessageId, Utils.pformat(data)))
    CustomProfiler.stop("NetworkCacheUtils.get", cpc)
    return data
end

--- @return table cacheData { ackedAt, dataChecksum, event, messageId, sentAt, status}
function NetworkCacheUtils.getByChecksum(peerGuid, event, data)
    local cpc = CustomProfiler.start("NetworkCacheUtils.getByChecksum")
    if not peerGuid or Utils.IsEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(Utils.pformat(peerGuid)), 2)
    end
    if not event or Utils.IsEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(Utils.pformat(event)), 2)
    end
    if not data or Utils.IsEmpty(data) or type(data) ~= "table" then
        error(("data '%s' must not be nil or empty or isn't type of table!"):format(Utils.pformat(data)), 2)
    end

    if not NetworkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    local sum           = NetworkCacheUtils.getSum(event, data)
    local dataChecksum  = md5.sumhexa(sum)
    local clientCacheId = GuidUtils.toNumber(peerGuid)
    local cacheData     = NetworkCache.getChecksum(clientCacheId, dataChecksum)
    Logger.info(Logger.channels.cache,
                ("Get nCache by clientCacheId %s, dataChecksum %s, event %s, cacheData %s")
                        :format(clientCacheId, dataChecksum, event, Utils.pformat(cacheData)))
    CustomProfiler.stop("NetworkCacheUtils.getByChecksum", cpc)
    return cacheData
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NetworkCacheUtils = NetworkCacheUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NetworkCacheUtils