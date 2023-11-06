---@class NetworkUtils
--- Class for network related stuff.
local NetworkUtils = {
    --[[ Attributes ]]

    networkMessageIdCounter = 0,
    --- Network events with name, schema, resendIdentifiers and isCacheable
    events                  = {
        connect         = {
            name        = "connect",
            schema      = { "code" },
            isCacheable = false
        },
        --- connect2 is used to let the other clients know, who was connected
        connect2        = {
            name              = "connect2",
            schema            = { "networkMessageId", "name", "guid" },
            resendIdentifiers = { "name", "guid" },
            isCacheable       = true
        },
        disconnect      = {
            name        = "disconnect",
            schema      = { "code" },
            isCacheable = false
        },
        --- disconnect2 is used to let the other clients know, who was disconnected
        disconnect2     = {
            name              = "disconnect2",
            schema            = { "networkMessageId", "name", "guid" },
            resendIdentifiers = { "name", "guid" },
            isCacheable       = true
        },
        --- acknowledgement is used to let the sender know if the message was acknowledged
        acknowledgement = {
            name              = "acknowledgement",
            schema            = { "networkMessageId", "event", "status", "ackedAt" },
            ack               = "ack",
            sent              = "sent",
            resendIdentifiers = { "networkMessageId", "status" },
            isCacheable       = false
        },
        --- seed is used to send the servers seed
        seed            = {
            name              = "seed",
            schema            = { "networkMessageId", "seed" },
            resendIdentifiers = { "seed" },
            isCacheable       = true
        },
        --- minaInformation is used to send local mina name, guid, etc pp to all peers.
        minaInformation = {
            name              = "minaInformation",
            schema            = { "networkMessageId", "version", "name", "guid", "entityId", "nuid", "transform", "health" },
            resendIdentifiers = { "version", "name", "guid" },
            isCacheable       = true
        },
        --- newGuid is used to send a new GUID to a client, which GUID isn't unique all peers
        newGuid         = {
            name              = "newGuid",
            schema            = { "networkMessageId", "oldGuid", "newGuid" },
            resendIdentifiers = { "oldGuid", "newGuid" },
            isCacheable       = true
        },
        --- newNuid is used to let clients spawn entities by the servers permission
        newNuid         = {
            --- constant name for the event
            name              = "newNuid",

            --- network schema to decode the message
            schema            = { "networkMessageId", "ownerName", "ownerGuid", "localEntityId", "x", "y",
                "initSerializedB64Str", "currentSerializedB64Str", "nuid" },

            --- resendIdentifiers defines the schema for detection of resend mechanism.
            --- Based on the values the network message will be send again.
            resendIdentifiers = { "ownerName", "ownerGuid", "localEntityId", "initSerializedB64Str", "nuid" },

            --- identifier whether to cache this message, if it wasn't acknowledged
            isCacheable       = true,
        },
        --- needNuid is used to ask for a nuid from client to servers
        needNuid        = {
            name              = "needNuid",
            schema            = { "networkMessageId", "ownerName", "ownerGuid", "localEntityId", "x", "y",
                "initSerializedB64Str", "currentSerializedB64Str" },
            resendIdentifiers = { "ownerGuid", "localEntityId", "initSerializedB64Str" },
            isCacheable       = true
        },
        --- lostNuid is used to ask for the entity to spawn, when a client has a nuid stored, but no entityId (not sure
        --- atm, why this is happening, but this is due to reduce out of sync stuff)
        lostNuid        = {
            name              = "lostNuid",
            schema            = { "networkMessageId", "nuid" },
            resendIdentifiers = { "nuid" },
            isCacheable       = true
        },
        --- deadNuids is used to let clients know, which entities were killed or destroyed
        deadNuids       = {
            name              = "deadNuids",
            schema            = { "networkMessageId", "deadNuids" },
            resendIdentifiers = { "deadNuids" },
            isCacheable       = true
        },
        --- needModList is used to let clients sync enabled mods with the server
        needModList     = {
            name              = "needModList",
            schema            = { "networkMessageId", "workshop", "external" },
            resendIdentifiers = { "workshop", "external" },
            isCacheable       = true
        },
        --- needModContent is used to sync mod content from server to client
        needModContent  = {
            name              = "needModContent",
            schema            = { "networkMessageId", "get", "items" },
            resendIdentifiers = { "get", "items" },
            isCacheable       = true
        }
    }
}


--- Finding index from schema based on resendIdentifier
---@deprecated Will be removed in future, beacuse unused
---@private
---@param self NetworkUtils
---@param data table
---@param schema table
---@param resendIdentifier string
---@return integer index
local getIndexFromSchema = function(self, data, schema, resendIdentifier)
    local cpc = self.customProfiler:start("NetworkUtils.getIndexFromSchema")

    for i, value in ipairs(data) do
        if schema[i] == resendIdentifier then
            self.customProfiler:stop("NetworkUtils.getIndexFromSchema", cpc)
            return i
        end
    end

    self.customProfiler:stop("NetworkUtils.getIndexFromSchema", cpc)
    return -1
end

--- Double checks if the schema order is correct, but only in dev build.
---@param event string
---@param data table
function NetworkUtils:checkSchemaOrder(event, data)
    if DebugGetIsDevBuild() then
        local result = self:zipTable(data, self.events[event].schema, event)
        if table.size(result) ~= table.size(data) then
            error(("Something wrong with network event schema! event %s, data %s and result %s"):format(event, data, result), 2)
        end
        result = nil
    end
end

--- Default enhanced serialization function
---@param value any
---@return unknown
function NetworkUtils:serialize(value)
    local cpc = self.customProfiler:start("NetworkUtils:serialize")
    self.logger:trace(self.logger.channels.network, ("Serializing value: %s"):format(value))

    if not self.messagePack then
        self.messagePack = require("MessagePack")
    end
    if not self.zstandard then
        self.zstandard = require("zstd")
    end

    local serialized      = self.messagePack.pack(value)
    local zstd, zstdError = self.zstandard:new() -- new zstd instance for every serialization, otherwise it will crash
    if not zstd or zstdError then
        error("Error while creating zstd: " .. zstdError, 2)
    end

    self.logger:debug(self.logger.channels.network, ("Uncompressed size: %s"):format(string.len(serialized)))

    local compressed, err = zstd:compress(serialized)
    if err then
        error("Error while compressing: " .. err, 2)
    end

    self.logger:debug(self.logger.channels.network, ("Compressed size: %s"):format(string.len(compressed)))
    self.logger:debug(self.logger.channels.network, ("Serialized and compressed value: %s"):format(compressed))

    zstd:free()
    self.customProfiler:stop("NetworkUtils:serialize", cpc)
    return compressed
end

---Default enhanced serialization function
---@param value any
---@return unknown
function NetworkUtils:deserialize(value)
    local cpc = self.customProfiler:start("NetworkUtils:deserialize")
    self.logger:debug(self.logger.channels.network, ("Serialized and compressed value: %s"):format(value))

    if not self.messagePack then
        self.messagePack = require("MessagePack")
    end
    if not self.zstandard then
        self.zstandard = require("zstd")
    end

    local zstd, zstdError = self.zstandard:new() -- new zstd instance for every serialization, otherwise it will crash
    if not zstd or zstdError then
        error("Error while creating zstd: " .. zstdError, 2)
    end

    self.logger:debug(self.logger.channels.network, ("Compressed size: %s"):format(string.len(value)))
    local decompressed, err = zstd:decompress(value)
    if err then
        error("Error while decompressing: " .. err, 2)
    end
    self.logger:debug(self.logger.channels.network, ("Uncompressed size: %s"):format(string.len(decompressed)))
    local deserialized = self.messagePack.unpack(decompressed)
    self.logger:debug(self.logger.channels.network, ("Deserialized and uncompressed value: %s"):format(deserialized))
    zstd:free()
    self.customProfiler:stop("NetworkUtils:deserialize", cpc)
    return deserialized
end

--- Returns the network message id counter and increases it by one
---@return integer networkMessageIdCounter
function NetworkUtils:getNextNetworkMessageId()
    local cpc                    = self.customProfiler:start("NetworkUtils.getNextNetworkMessageId")
    self.networkMessageIdCounter = self.networkMessageIdCounter + 1
    self.customProfiler:stop("NetworkUtils.getNextNetworkMessageId", cpc)
    return self.networkMessageIdCounter
end

--- Checks if the event within its data was already sent
---@param peer table If Server, then it's the peer, if Client, then it's the 'self' object
---@param event string
---@param data table
---@return boolean
function NetworkUtils:alreadySent(peer, event, data)
    local cpc = self.customProfiler:start("NetworkUtils.alreadySent")
    if not peer then
        error("'peer' must not be nil! When Server, then peer or Server.clients[i]. When Client, then self.", 2)
    end
    if not event then
        error("'event' must not be nil!", 2)
    end
    if not self.events[event] then
        error(("'event' \"%s\" is unknown. Did you add this event in NetworkUtils.events?"):format(event), 2)
    end
    if not data then
        error("'data' must not be nil!", 2)
    end

    self:checkSchemaOrder(event, data)

    if self.utils:isEmpty(peer.clientCacheId) then
        self.logger:info(self.logger.channels.testing, ("peer.guid = '%s'"):format(peer.guid))
        peer.clientCacheId = self.guidUtils:toNumber(peer.guid) --error("peer.clientCacheId must not be nil!", 2)
    end

    local clientCacheId    = peer.clientCacheId
    local networkMessageId = data[1]
    if not networkMessageId then
        error("'networkMessageId' must not be nil!", 2)
    end

    -- [[ if the event isn't store in the cache, it wasn't already send ]] --
    if not self.events[event].isCacheable then
        self.logger:trace(self.logger.channels.testing, ("event %s is not cacheable!"):format(event))
        self.customProfiler:stop("NetworkUtils.alreadySent", cpc)
        return false
    end

    --[[ if the network message is already stored ]]
    --
    local message = self.networkCacheUtils:get(peer.guid, networkMessageId, event)
    if message ~= nil then
        print(("Got message %s by cache with clientCacheId '%s', event '%s' and networkMessageId '%s'")
            :format(message, clientCacheId, event, networkMessageId))
        if message.status == self.events.acknowledgement.ack then
            print(("Got message %s by cache with clientCacheId '%s', event '%s' and networkMessageId '%s'")
                :format(message, clientCacheId, event, networkMessageId))
            self.customProfiler:stop("NetworkUtils.alreadySent", cpc)
            return true
        end
    else
        self.logger:trace(self.logger.channels.testing,
            ("NetworkUtils.alreadySent: NetworkCacheUtils.get(peer.guid %s, networkMessageId %s, event %s) returned message = nil")
            :format(peer.guid, networkMessageId, event))
    end
    --- Compare if the current data matches the cached checksum
    local matchingData = self.networkCacheUtils:getByChecksum(peer.guid, event, data)
    if matchingData ~= nil then
        if matchingData.status == self.events.acknowledgement.sent then
            local now = GameGetRealWorldTimeSinceStarted()
            local diff = now - matchingData.sendAt
            if diff >= peer:getRoundTripTime() then
                print(("Resend after %s ms: %s"):format(diff, utils:pformat(data)))
                return false
            end
        end
        return true
    else
        self.logger:trace(self.logger.channels.testing,
            ("NetworkUtils.alreadySent: NetworkCacheUtils.getByChecksum(peer.guid %s, event %s, data %s) returned matchingData = nil")
            :format(peer.guid, event, data))
    end
    self.customProfiler:stop("NetworkUtils.alreadySent", cpc)
    return false
end

local prevTimeInMs = 0
--- Checks if the current time is a tick.
---@return boolean
function NetworkUtils:isTick()
    local cpc         = self.customProfiler:start("NetworkUtils.isTick")
    local nowTimeInMs = GameGetRealWorldTimeSinceStarted() * 1000
    local elapsedTime = nowTimeInMs - prevTimeInMs
    local cpc2        = self.customProfiler:start("ModSettingGet")
    local oneTickInMs = 1000 / tonumber(ModSettingGet("noita-mp.tick_rate"))
    self.customProfiler:stop("ModSettingGet", cpc2)
    if elapsedTime >= oneTickInMs then
        prevTimeInMs = nowTimeInMs
        self.customProfiler:stop("NetworkUtils.isTick", cpc)
        return true
    end
    self.customProfiler:stop("NetworkUtils.isTick", cpc)
    return false
end

--- links variables to keys based on their order
--- note that it only works for boolean and number values, not strings.
--- Credits to sock.lua
---@param items table data
---@param keys table schema
---@param event string
---@return table
function NetworkUtils:zipTable(items, keys, event)
    local data = {}

    -- convert variable at index 1 into the value for the key value at index 1, and so on
    for i, value in ipairs(items) do
        local key = keys[i]

        if not key then
            error(("Missing data key for event '%s'! items = %s schema = %s")
                :format(event, self.utils:pformat(items), self.utils:pformat(keys)), 2)
        end

        data[key] = value
    end

    return data
end

--- Constructor for NetworkUtils class.
---@param customProfiler CustomProfiler
---@param guidUtils GuidUtils
---@param logger Logger
---@param networkCacheUtils NetworkCacheUtils
---@param utils Utils|nil
---@return NetworkUtils
function NetworkUtils:new(customProfiler, guidUtils, logger, networkCacheUtils, utils)
    ---@class NetworkUtils
    local networkUtils = setmetatable(self, NetworkUtils)

    local cpc = customProfiler:start("NetworkUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not networkUtils.customProfiler then
        networkUtils.customProfiler = customProfiler or error("NetworkUtils:new requires a CustomProfiler object", 2)
    end
    if not networkUtils.guidUtils then
        networkUtils.guidUtils = guidUtils or error("NetworkUtils:new requires a GuidUtils object", 2)
    end
    if not networkUtils.logger then
        networkUtils.logger = logger or error("NetworkUtils:new requires a Logger object", 2)
    end
    if not networkUtils.messagePack then
        networkUtils.messagePack = require("MessagePack")
    end
    if not networkUtils.networkCacheUtils then
        networkUtils.networkCacheUtils = networkCacheUtils or error("NetworkUtils:new requires a NetworkCacheUtils object", 2)
    end
    if not networkUtils.utils then
        networkUtils.utils = utils or require("Utils"):new(nil)
    end
    if not networkUtils.zstandard then
        networkUtils.zstandard = require("zstd")
    end

    networkUtils.customProfiler:stop("NetworkUtils:new", cpc)
    return networkUtils
end

return NetworkUtils
