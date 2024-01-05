---@class NetworkCacheUtils
--- Class for caching network messages.
local NetworkCacheUtils = {}

--- Returns the sum of the data.
---@param event string
---@param data table
---@return unknown
function NetworkCacheUtils:getSum(event, data)
    self.logger:trace(self.logger.channels.testing, "getSum: " .. self.utils:pformat(data))
    if not event or self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("Unable to calculate sum, when event is nil or not a string: '%s'"):format(event), 2)
    end
    if not data or self.utils:isEmpty(data) or type(data) ~= "table" then
        error(("Unable to calculate sum, when data is nil or not a table: '%s'"):format(data), 2)
    end

    if not self.networkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    self.logger:trace(self.logger.channels.testing, "data: " .. self.utils:pformat(data))
    local dataCopy = self.networkUtils:zipTable(data, self.networkUtils.events[event].schema, event)
    self.logger:trace(self.logger.channels.testing, "dataCopy zipped: " .. self.utils:pformat(dataCopy))
    if event ~= self.networkUtils.events.acknowledgement.name then
        -- when event is NOT acknowledgement, remove networkMessageId,
        -- but we need the networkMessageId to find the previous cached network message, when the event is acknowledgement
        dataCopy.networkMessageId = nil
    end
    self.logger:trace(self.logger.channels.testing, "dataCopy without networkMessageId: " .. self.utils:pformat(dataCopy))
    local sum = ""
    if self.networkUtils.events[event].resendIdentifiers ~= nil then
        local newData = {}
        for i = 1, #self.networkUtils.events[event].resendIdentifiers do
            local v = self.networkUtils.events[event].resendIdentifiers[i]
            if dataCopy[v] == nil then
                error(("dataCopy: data for event '%s' was missing '%s' resendIdentifier"):format(event, v), 2)
            end
            newData[v] = dataCopy[v]
            sum        = table.join(newData, self.logger, self.utils)
        end
    else
        sum = table.join(dataCopy, self.logger, self.utils)
    end
    self.logger:trace(self.logger.channels.testing, ("sum from %s = %s"):format(self.utils:pformat(dataCopy), sum))
    return sum
end

--- Creates a new network cache entry.
---@param peerGuid string peer.guid
---@param networkMessageId number
function NetworkCacheUtils:set(peerGuid, networkMessageId, event, status, ackedAt, sendAt, data)
    if not peerGuid or self.utils:isEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(peerGuid), 2)
    end
    if not networkMessageId or self.utils:isEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId '%s' must not be nil or empty or isn't type of number!"):format(networkMessageId), 2)
    end
    if not event or self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(event), 2)
    end
    if not status or self.utils:isEmpty(status) or type(status) ~= "string" then
        error(("status '%s' must not be nil or empty or isn't type of string!"):format(status), 2)
    end
    if not ackedAt or self.utils:isEmpty(ackedAt) or type(ackedAt) ~= "number" then
        error(("ackedAt '%s' must not be nil or empty or isn't type of number!"):format(ackedAt), 2)
    end
    if not sendAt or self.utils:isEmpty(sendAt) or type(sendAt) ~= "number" then
        error(("sendAt '%s' must not be nil or empty or isn't type of number!"):format(sendAt), 2)
    end
    if not data or self.utils:isEmpty(data) or type(data) ~= "table" then
        error(("data '%s' must not be nil or empty or isn't type of table!"):format(utils:pformat(data)), 2)
    end

    if not self.networkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    local sum = self:getSum(event, data)
    if self.utils:isEmpty(sum) then
        self.logger:warn(self.logger.channels.cache, ("sum is empty '%s'. Setting it to '%s'."):format(sum, event))
        sum = event
    end

    local dataChecksum = ("%s"):format(self.md5.sumhexa(sum))
    if type(dataChecksum) ~= "string" then
        self.logger:warn(self.logger.channels.cache,
            ("dataChecksum is a string '%s'. Converting it to a string!."):format(dataChecksum))
        dataChecksum = tostring(dataChecksum)
        self.logger:warn(self.logger.channels.cache, ("dataChecksum converted to string '%s'."):format(dataChecksum))
    end

    if self.utils:isEmpty(dataChecksum) then
        error(("Unable to set cache, when dataChecksum is empty %s!"):format(dataChecksum), 2)
    end

    local clientCacheId = self.guidUtils:toNumber(peerGuid)

    self.logger:trace(self.logger.channels.cache, ("NetworkCache.set: %s"):format(self.utils:pformat(data)))
    self.logger:trace(self.logger.channels.cache,
        ("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum))
    self.logger:trace(self.logger.channels.testing,
        ("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum))

    self.networkCache:set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    self.logger:info(self.logger.channels.cache,
        ("Set nCache for clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, dataChecksum))
    return dataChecksum
end

--- Returns the cached network message.
---@param peerGuid string
---@param networkMessageId number
---@param event string
---@return table|nil data { ackedAt, dataChecksum, event, messageId, sendAt, status}
function NetworkCacheUtils:get(peerGuid, networkMessageId, event)
    if not peerGuid or self.utils:isEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(peerGuid), 2)
    end
    if not networkMessageId or self.utils:isEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId '%s' must not be nil or empty or isn't type of number!"):format(networkMessageId), 2)
    end
    if not event or self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(event), 2)
    end

    if not self.networkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    if not self.networkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end
    self.logger:info(self.logger.channels.testing,
        ("NetworkCacheUtils.get(peerGuid %s, networkMessageId %s, event %s)"):format(peerGuid, networkMessageId,
            event))
    self.logger:info(self.logger.channels.testing,
        ("NetworkCache.get(clientCacheId %s, networkMessageId %s, event %s)"):format(self.guidUtils:toNumber(peerGuid),
            networkMessageId, event))

    local clientCacheId = self.guidUtils:toNumber(peerGuid)
    local data          = self.networkCache:get(clientCacheId, event, tonumber(networkMessageId))
    self.logger:info(self.logger.channels.cache,
        ("Get nCache by clientCacheId %s, event %s, networkMessageId %s, data %s")
        :format(clientCacheId, event, networkMessageId, self.utils:pformat(data)))
    return data
end

--- Returns the cached network message by checksum.
---@param peerGuid string
---@param event string
---@param data table
--- @return table|nil cacheData { ackedAt, dataChecksum, event, messageId, sendAt, status}
function NetworkCacheUtils:getByChecksum(peerGuid, event, data)
    if not peerGuid or self.utils:isEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(utils:pformat(peerGuid)), 2)
    end
    if not event or self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(utils:pformat(event)), 2)
    end
    if not data or self.utils:isEmpty(data) or type(data) ~= "table" then
        error(("data '%s' must not be nil or empty or isn't type of table!"):format(utils:pformat(data)), 2)
    end

    if not self.networkUtils.events[event].isCacheable then
        error(("Event '%s' shouldn't be cached!"):format(event), 2)
    end

    local sum           = self:getSum(event, data)
    local dataChecksum  = ("%s"):format(self.md5.sumhexa(sum))
    local clientCacheId = self.guidUtils:toNumber(peerGuid)
    local cacheData     = self.networkCache:getChecksum(clientCacheId, dataChecksum)
    self.logger:info(self.logger.channels.cache,
        ("Get nCache by clientCacheId %s, dataChecksum %s, event %s, cacheData %s")
        :format(clientCacheId, dataChecksum, event, self.utils:pformat(cacheData)))
    return cacheData
end

--- Sets a acknoledgement for a cached network message.
---@param peerGuid string
---@param networkMessageId number
---@param event string
---@param status string
---@param ackedAt ?
---@param sendAt ?
---@param checksum string
function NetworkCacheUtils:ack(peerGuid, networkMessageId, event, status, ackedAt, sendAt, checksum)
    if not peerGuid or self.utils:isEmpty(peerGuid) or type(peerGuid) ~= "string" then
        error(("peerGuid '%s' must not be nil or empty or isn't type of string!"):format(peerGuid), 2)
    end
    if not networkMessageId or self.utils:isEmpty(networkMessageId) or type(networkMessageId) ~= "number" then
        error(("networkMessageId '%s' must not be nil or empty or isn't type of number!"):format(networkMessageId), 2)
    end
    if not event or self.utils:isEmpty(event) or type(event) ~= "string" then
        error(("event '%s' must not be nil or empty or isn't type of string!"):format(event), 2)
    end
    if not status or self.utils:isEmpty(status) or type(status) ~= "string" then
        error(("status '%s' must not be nil or empty or isn't type of string!"):format(status), 2)
    end
    if not ackedAt or self.utils:isEmpty(ackedAt) or type(ackedAt) ~= "number" then
        error(("ackedAt '%s' must not be nil or empty or isn't type of number!"):format(ackedAt), 2)
    end
    if not sendAt or self.utils:isEmpty(sendAt) or type(sendAt) ~= "number" then
        error(("sendAt '%s' must not be nil or empty or isn't type of number!"):format(sendAt), 2)
    end
    if not checksum or self.utils:isEmpty(checksum) or type(checksum) ~= "string" then
        error(("checksum '%s' must not be nil or empty or isn't type of string!"):format(utils:pformat(checksum)), 2)
    end

    local clientCacheId = self.guidUtils:toNumber(peerGuid)

    self.logger:trace(self.logger.channels.cache,
        ("NetworkCache.ack(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, checksum))
    self.logger:trace(self.logger.channels.testing,
        ("NetworkCache.set(clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s)")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, checksum))
    self.networkCache:set(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, tostring(checksum))
    self.logger:info(self.logger.channels.cache,
        ("Set nCache for clientCacheId %s, networkMessageId %s, event %s, status %s, ackedAt %s, sendAt %s, dataChecksum %s")
        :format(clientCacheId, networkMessageId, event, status, ackedAt, sendAt, checksum))
end

--- Logs all cached network messages. Only for debugging.
function NetworkCacheUtils:logAll()
    local all = self.networkCache:getAll()
    for i = 1, #all do
        if not self.utils:isEmpty(all[i].dataChecksum) and string.contains(all[i].dataChecksum, "%%") then
            all[i].dataChecksum = string.gsub(all[i].dataChecksum, "percent sign")
        end
        self.logger:trace(self.logger.channels.cache,
            ("event = %s, messageId = %s, dataChecksum = %s, status = %s, ackedAt = %s, sendAt = %s")
            :format(all[i].event, all[i].messageId, all[i].dataChecksum, all[i].status, all[i].ackedAt,
                all[i].sendAt))
    end
end

--- NetworkCacheUtils constructor.
---@param customProfiler CustomProfiler required
---@param guidUtils GuidUtils required
---@param logger Logger required
---@param md5 md5|nil optional
---@param networkCache NetworkCache required
---@param networkUtils NetworkUtils|nil optional
---@param utils Utils|nil optional
---@return NetworkCacheUtils
function NetworkCacheUtils:new(customProfiler, guidUtils, logger, md5, networkCache, networkUtils, utils)
    ---@class NetworkCacheUtils
    local networkCacheUtils = setmetatable(self, NetworkCacheUtils)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not networkCacheUtils.customProfiler then
        networkCacheUtils.customProfiler = customProfiler or
            error("NetworkCacheUtils:new requires a CustomProfiler object", 2)
    end

    if not networkCacheUtils.guidUtils then
        networkCacheUtils.guidUtils = guidUtils or
            error("NetworkCacheUtils:new requires a GuidUtils object", 2)
    end

    if not networkCacheUtils.logger then
        networkCacheUtils.logger = logger or
            error("NetworkCacheUtils:new requires a Logger object", 2)
    end

    if not networkCacheUtils.md5 then
        networkCacheUtils.md5 = md5 or require("md5")
    end

    if not networkCacheUtils.networkCache then
        networkCacheUtils.networkCache = networkCache or
            error("NetworkCacheUtils:new requires a NetworkCache object", 2)
    end

    if not networkCacheUtils.utils then
        networkCacheUtils.utils = utils or
            require("Utils"):new()
    end

    if not networkCacheUtils.networkUtils then
        networkCacheUtils.networkUtils = networkUtils or
            require("NetworkUtils")
            :new(networkCacheUtils.customProfiler, guidUtils, logger,
                networkCacheUtils, utils)
    end

    return networkCacheUtils
end

return NetworkCacheUtils
