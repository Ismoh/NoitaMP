---@class NetworkCache
--- Class for caching network messages.
local NetworkCache = {
    --[[ Attributes ]]

    cache  = {},
    usingC = false -- not _G.disableLuaExtensionsDLL
}

--- Sets the cache entry for the given clientCacheId, networkMessageId and event.
---@param clientCacheId number
---@param networkMessageId number
---@param event string
---@param status string
---@param ackedAt ?
---@param sendAt ?
---@param dataChecksum string
---@return
function NetworkCache:set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    if self.utils:isEmpty(clientCacheId) or type(clientCacheId) ~= "number" then
        error(("clientCacheId must not be nil or empty '%s' or type is not number '%s'")
            :format(clientCacheId, type(clientCacheId)), 2)
    end
    if self.utils:isEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId must not be nil or empty '%s' or type is not number '%s'")
            :format(networkMessageId, type(networkMessageId)), 2)
    end
    if self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("event must not be nil or empty '%s' or type is not string '%s'")
            :format(event, type(event)), 2)
    end
    if self.utils:isEmpty(status) or type(status) ~= "string" then
        error(("status must not be nil or empty '%s' or type is not string '%s'")
            :format(status, type(status)), 2)
    end
    if self.utils:isEmpty(ackedAt) or type(ackedAt) ~= "number" then
        error(("ackedAt must not be nil or empty '%s' or type is not number '%s'")
            :format(ackedAt, type(ackedAt)), 2)
    end
    if self.utils:isEmpty(sendAt) or type(sendAt) ~= "number" then
        error(("sendAt must not be nil or empty '%s' or type is not number '%s'")
            :format(sendAt, type(sendAt)), 2)
    end
    if self.utils:isEmpty(dataChecksum) or type(dataChecksum) ~= "string" then
        error(("dataChecksum must not be nil or empty '%s' or type is not string '%s'")
            :format(dataChecksum, type(dataChecksum)), 2)
    end

    if self.usingC then
        return NetworkCacheC.set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    end
    if not self.cache[clientCacheId] then
        self.cache[clientCacheId] = {}
    end
    self.cache[clientCacheId][networkMessageId] = {
        clientCacheId    = clientCacheId,
        networkMessageId = networkMessageId,
        event            = event,
        status           = status,
        ackedAt          = ackedAt,
        sendAt           = sendAt,
        dataChecksum     = dataChecksum
    }
end

--- Gets the cache entry for the given clientCacheId, event and networkMessageId.
---@param clientCacheId number
---@param event string
---@param networkMessageId number
---@return table|nil entry self.cache[clientCacheId][networkMessageId] or nil if not found
function NetworkCache:get(clientCacheId, event, networkMessageId)
    if self.utils:isEmpty(clientCacheId) or type(clientCacheId) ~= "number" then
        error(("clientCacheId must not be nil or empty '%s' or type is not number '%s'")
            :format(clientCacheId, type(clientCacheId)), 2)
    end
    if self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("event must not be nil or empty '%s' or type is not string '%s'")
            :format(event, type(event)), 2)
    end
    if self.utils:isEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId must not be nil or empty '%s' or type is not number '%s'")
            :format(networkMessageId, type(networkMessageId)), 2)
    end

    if self.usingC then
        return NetworkCacheC.get(clientCacheId, event, networkMessageId)
    end

    if not self.cache then
        self.cache = {}
        return nil
    end

    if not self.cache[clientCacheId] then
        self.logger:trace(self.logger.channels.cache,
            ("There is no cache entry for clientCacheId %s, event %s and networkMessageId %s")
            :format(clientCacheId, event, networkMessageId))
        return nil
    end
    if not self.cache[clientCacheId][networkMessageId] then
        return nil
    end
    if not self.cache[clientCacheId][networkMessageId].event == event then
        return nil
    end

    return self.cache[clientCacheId][networkMessageId]
end

--- Gets the checksum of a cache entry for the given clientCacheId and dataChecksum.
---@param clientCacheId number
---@param dataChecksum string
---@return table|nil entry self.cache[clientCacheId][index] or nil if not found
function NetworkCache:getChecksum(clientCacheId, dataChecksum)
    if self.utils:isEmpty(clientCacheId) or type(clientCacheId) ~= "number" then
        error(("clientCacheId must not be nil or empty '%s' or type is not number '%s'")
            :format(clientCacheId, type(clientCacheId)), 2)
    end
    if self.utils:isEmpty(dataChecksum) or type(dataChecksum) ~= "string" then
        error(("dataChecksum must not be nil or empty '%s' or type is not string '%s'")
            :format(dataChecksum, type(dataChecksum)), 2)
    end

    if self.usingC then
        return NetworkCacheC.getChecksum(clientCacheId, dataChecksum)
    end
    if not self.cache[clientCacheId] then
        self.logger:trace(self.logger.channels.cache,
            ("There is no cache entry for clientCacheId %s and dataChecksum %s")
            :format(clientCacheId, dataChecksum))
        return nil
    end

    local found, index = table.contains(self.cache[clientCacheId], dataChecksum)
    if found then
        return self.cache[clientCacheId][index]
    end

    for k, v in pairs(self.cache[clientCacheId]) do
        if v.dataChecksum == dataChecksum then
            return v
        end
    end

    return nil
end

--- Returns the size of the cache.
---@return number size
function NetworkCache:size()
    if self.usingC then
        return NetworkCacheC.size()
    end
    return table.size(self.cache)
end

--- Returns the usage of the cache.
---@return unknown
function NetworkCache:usage()
    if not self.usingC then
        error("NetworkCache.usage requires the luaExtensions dll to be enabled", 2)
    end
    return NetworkCacheC.usage()
end

--- Returns all cache entries.
---@return table self.cache
function NetworkCache:getAll()
    if self.usingC then
        return NetworkCacheC.getAll()
    end
    return self.cache
end

--- Clears the cache entry for the given clientCacheId.
---@param clientCacheId number
---@return unknown
function NetworkCache:clear(clientCacheId)
    if self.usingC then
        return NetworkCacheC.clear(clientCacheId)
    end
    self.cache[clientCacheId] = nil
end

function NetworkCache:removeOldest()
    if self.usingC then
        return NetworkCacheC.removeOldest()
    end
    local oldest = nil
    for clientCacheId, cache in pairs(self.cache) do
        for networkMessageId, entry in pairs(cache) do
            if not oldest or entry.sendAt < oldest.sendAt then
                oldest = entry
            end
        end
    end
    if oldest then
        self.cache[oldest.clientCacheId][oldest.networkMessageId] = nil
    end
end

--- NetworkCache constructor.
---@param customProfiler CustomProfiler required
---@param logger Logger|nil optional
---@param utils Utils|nil optional
---@return NetworkCache networkCache
function NetworkCache:new(customProfiler, logger, utils)
    ---@class NetworkCache
    local networkCache = setmetatable(self, NetworkCache)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not networkCache.customProfiler then
        ---@type CustomProfiler
        networkCache.customProfiler = customProfiler or
            error("NetworkCache:new requires a CustomProfiler object", 2)
    end

    if not networkCache.logger then
        ---@type Logger
        networkCache.logger = logger or
            require("Logger")
            :new(nil, customProfiler.noitaMpSettings)
    end

    if not networkCache.utils then
        ---@type Utils
        networkCache.utils = utils or require("Utils"):new()
    end

    return networkCache
end

return NetworkCache
