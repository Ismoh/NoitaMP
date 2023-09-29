
if not md5 then
    if not require then
        md5 = {}
    else
        md5 = require("md5")
    end
end

--- NetworkCacheUtils

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

    local sum = NetworkCacheUtils.getSum(event, data)
    if Utils.IsEmpty(sum) then
        Logger.warn(Logger.channels.cache, ("sum is empty '%s'. Setting it to '%s'."):format(sum, event))
        sum = event
    end

    local dataChecksum = ("%s"):format(md5.sumhexa(sum))
    if type(dataChecksum) ~= "string" then
        Logger.warn(Logger.channels.cache,
            ("dataChecksum is a string '%s'. Converting it to a string!."):format(dataChecksum))
        dataChecksum = tostring(dataChecksum)
        Logger.warn(Logger.channels.cache, ("dataChecksum converted to string '%s'."):format(dataChecksum))
    end

    if Utils.IsEmpty(dataChecksum) then
        error(("Unable to set cache, when dataChecksum is empty %s!"):format(dataChecksum), 2)
    end

    local clientCacheId = GuidUtils.toNumber(peerGuid)

    Logger.trace(Logger.channels.cache, ("NetworkCache.set: %s"):format(Utils.pformat(data)))
    Logger.trace(Logger.channels.cache,
        ("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
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

--- @return table data { ackedAt, dataChecksum, event, messageId, sendAt, status}
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

--- @return table cacheData { ackedAt, dataChecksum, event, messageId, sendAt, status}
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
    local dataChecksum  = ("%s"):format(md5.sumhexa(sum))
    local clientCacheId = GuidUtils.toNumber(peerGuid)
    local cacheData     = NetworkCache.getChecksum(clientCacheId, dataChecksum)
    Logger.info(Logger.channels.cache,
        ("Get nCache by clientCacheId %s, dataChecksum %s, event %s, cacheData %s")
        :format(clientCacheId, dataChecksum, event, Utils.pformat(cacheData)))
    CustomProfiler.stop("NetworkCacheUtils.getByChecksum", cpc)
    return cacheData
end

NetworkCacheUtils.ack    = function(peerGuid, networkMessageId, event, status, ackedAt, sendAt, checksum)
    local cpc = CustomProfiler.start("NetworkCacheUtils.ack")
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
    if not checksum or Utils.IsEmpty(checksum) or type(checksum) ~= "string" then
        error(("checksum '%s' must not be nil or empty or isn't type of string!"):format(Utils.pformat(checksum)), 2)
    end

    local clientCacheId = GuidUtils.toNumber(peerGuid)

    Logger.trace(Logger.channels.cache,
        ("NetworkCache.ack(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, checksum))
    Logger.trace(Logger.channels.testing,
        ("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, checksum))
    NetworkCache.set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, tostring(checksum))
    Logger.info(Logger.channels.cache,
        ("Set nCache for clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, checksum))
    CustomProfiler.stop("NetworkCacheUtils.ack", cpc)
end

NetworkCacheUtils.logAll = function()
    local all = NetworkCache.getAll()
    for i = 1, #all do
        if not Utils.IsEmpty(all[i].dataChecksum) and string.contains(all[i].dataChecksum, "%%") then
            all[i].dataChecksum = string.gsub(all[i].dataChecksum, "percent sign")
        end
        Logger.trace(Logger.channels.cache,
            ("event = %s, messageId = %s, dataChecksum = %s, status = %s, ackedAt = %s, sendAt = %s")
            :format(all[i].event, all[i].messageId, all[i].dataChecksum, all[i].status, all[i].ackedAt,
                all[i].sendAt))
    end
end


return NetworkCacheUtils
