NetworkCache             = {}
NetworkCache.cache       = {}
NetworkCache.usingC      = false -- not _G.disableLuaExtensionsDLL
NetworkCache.set         = function(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    local cpc = CustomProfiler.start("NetworkCache.set")

    if Utils.IsEmpty(clientCacheId) or type(clientCacheId) ~= "number" then
        error(("clientCacheId must not be nil or empty '%s' or type is not number '%s'")
            :format(clientCacheId, type(clientCacheId)), 2)
    end
    if Utils.IsEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId must not be nil or empty '%s' or type is not number '%s'")
            :format(networkMessageId, type(networkMessageId)), 2)
    end
    if Utils.IsEmpty(event) or type(event) ~= "string" then
        error(("event must not be nil or empty '%s' or type is not string '%s'")
            :format(event, type(event)), 2)
    end
    if Utils.IsEmpty(status) or type(status) ~= "string" then
        error(("status must not be nil or empty '%s' or type is not string '%s'")
            :format(status, type(status)), 2)
    end
    if Utils.IsEmpty(ackedAt) or type(ackedAt) ~= "number" then
        error(("ackedAt must not be nil or empty '%s' or type is not number '%s'")
            :format(ackedAt, type(ackedAt)), 2)
    end
    if Utils.IsEmpty(sendAt) or type(sendAt) ~= "number" then
        error(("sendAt must not be nil or empty '%s' or type is not number '%s'")
            :format(sendAt, type(sendAt)), 2)
    end
    if Utils.IsEmpty(dataChecksum) or type(dataChecksum) ~= "string" then
        error(("dataChecksum must not be nil or empty '%s' or type is not string '%s'")
            :format(dataChecksum, type(dataChecksum)), 2)
    end

    if NetworkCache.usingC then
        return NetworkCacheC.set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    end
    if not NetworkCache.cache[clientCacheId] then
        NetworkCache.cache[clientCacheId] = {}
    end
    NetworkCache.cache[clientCacheId][networkMessageId] = {
        clientCacheId    = clientCacheId,
        networkMessageId = networkMessageId,
        event            = event,
        status           = status,
        ackedAt          = ackedAt,
        sendAt           = sendAt,
        dataChecksum     = dataChecksum
    }
    CustomProfiler.stop("NetworkCache.set", cpc)
end

NetworkCache.get         = function(clientCacheId, event, networkMessageId)
    local cpc = CustomProfiler.start("NetworkCache.get")

    if Utils.IsEmpty(clientCacheId) or type(clientCacheId) ~= "number" then
        error(("clientCacheId must not be nil or empty '%s' or type is not number '%s'")
            :format(clientCacheId, type(clientCacheId)), 2)
    end
    if Utils.IsEmpty(event) or type(event) ~= "string" then
        error(("event must not be nil or empty '%s' or type is not string '%s'")
            :format(event, type(event)), 2)
    end
    if Utils.IsEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId must not be nil or empty '%s' or type is not number '%s'")
            :format(networkMessageId, type(networkMessageId)), 2)
    end

    if NetworkCache.usingC then
        return NetworkCacheC.get(clientCacheId, event, networkMessageId)
    end

    if not NetworkCache.cache then
        NetworkCache.cache = {}
        return nil
    end

    if not NetworkCache.cache[clientCacheId] then
        Logger.trace(Logger.channels.cache,
            ("There is no cache entry for clientCacheId %s, event %s and networkMessageId %s")
            :format(clientCacheId, event, networkMessageId))
        CustomProfiler.stop("NetworkCache.get", cpc)
        return nil
    end
    if not NetworkCache.cache[clientCacheId][networkMessageId] then
        CustomProfiler.stop("NetworkCache.get", cpc)
        return nil
    end
    if not NetworkCache.cache[clientCacheId][networkMessageId].event == event then
        CustomProfiler.stop("NetworkCache.get", cpc)
        return nil
    end

    CustomProfiler.stop("NetworkCache.get", cpc)
    return NetworkCache.cache[clientCacheId][networkMessageId]
end

NetworkCache.getChecksum = function(clientCacheId, dataChecksum)
    local cpc = CustomProfiler.start("NetworkCache.getChecksum")

    if Utils.IsEmpty(clientCacheId) or type(clientCacheId) ~= "number" then
        error(("clientCacheId must not be nil or empty '%s' or type is not number '%s'")
            :format(clientCacheId, type(clientCacheId)), 2)
    end
    if Utils.IsEmpty(dataChecksum) or type(dataChecksum) ~= "string" then
        error(("dataChecksum must not be nil or empty '%s' or type is not string '%s'")
            :format(dataChecksum, type(dataChecksum)), 2)
    end

    if NetworkCache.usingC then
        return NetworkCacheC.getChecksum(clientCacheId, dataChecksum)
    end
    if not NetworkCache.cache[clientCacheId] then
        Logger.trace(Logger.channels.cache,
            ("There is no cache entry for clientCacheId %s and dataChecksum %s")
            :format(clientCacheId, dataChecksum))
        CustomProfiler.stop("NetworkCache.getChecksum", cpc)
        return nil
    end

    local found, index = table.contains(NetworkCache.cache[clientCacheId], dataChecksum)
    if found then
        CustomProfiler.stop("NetworkCache.getChecksum", cpc)
        return NetworkCache.cache[clientCacheId][index]
    end

    for k, v in pairs(NetworkCache.cache[clientCacheId]) do
        if v.dataChecksum == dataChecksum then
            CustomProfiler.stop("NetworkCache.getChecksum", cpc)
            return v
        end
    end

    CustomProfiler.stop("NetworkCache.get", cpc)
    return nil
end

NetworkCache.size        = function()
    if NetworkCache.usingC then
        return NetworkCacheC.size()
    end
    return table.size(NetworkCache.cache)
end

NetworkCache.usage       = function()
    if not NetworkCache.usingC then
        error("NetworkCache.usage requires the luaExtensions dll to be enabled", 2)
    end
    return NetworkCacheC.usage()
end

NetworkCache.getAll      = function()
    if NetworkCache.usingC then
        return NetworkCacheC.getAll()
    end
    return NetworkCache.cache
end

NetworkCache.clear       = function(clientCacheId)
    if NetworkCache.usingC then
        return NetworkCacheC.clear(clientCacheId)
    end
    NetworkCache.cache[clientCacheId] = nil
end

return NetworkCache
