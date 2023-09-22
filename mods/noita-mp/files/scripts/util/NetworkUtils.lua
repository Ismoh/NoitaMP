NetworkUtils                         = {}

NetworkUtils.networkMessageIdCounter = 0

NetworkUtils.events                  = {
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
    --- minaInformation is used to send local mina name, guid, etc pp to all peers. @see MinaUtils.getLocalMinaInformation()
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
            "initialSerializedEntityString", "currentSerializedEntityString", "nuid" },

        --- resendIdentifiers defines the schema for detection of resend mechanism.
        --- Based on the values the network message will be send again.
        resendIdentifiers = { "ownerName", "ownerGuid", "localEntityId", "initialSerializedEntityString", "nuid" },

        --- identifier whether to cache this message, if it wasn't acknowledged
        isCacheable       = true,
    },
    --- needNuid is used to ask for a nuid from client to servers
    needNuid        = {
        name              = "needNuid",
        schema            = { "networkMessageId", "ownerName", "ownerGuid", "localEntityId", "x", "y",
            "initialSerializedEntityString", "currentSerializedEntityString" },
        resendIdentifiers = { "ownerGuid", "localEntityId", "initialSerializedEntityString" },
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

local function getIndexFromSchema(data, schema, resendIdentifier)
    local cpc = CustomProfiler.start("NetworkUtils.getIndexFromSchema")

    for i, value in ipairs(data) do
        if schema[i] == resendIdentifier then
            CustomProfiler.stop("NetworkUtils.getIndexFromSchema", cpc)
            return i
        end
    end

    CustomProfiler.stop("NetworkUtils.getIndexFromSchema", cpc)
    return nil
end

---Default enhanced serialization function
---@param value any
---@return unknown
function NetworkUtils:serialize(value)
    local cpc = self.customProfiler:start("NetworkUtils:serialize")
    self.logger:trace(self.logger.channels.network, ("Serializing value: %s"):format(value))

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

--- Sometimes you don't care if it's the client or server, but you need one of them to send the messages.
--- @return Client|Server Client or Server 'object'
--- @public
function NetworkUtils.getClientOrServer()
    local cpc = CustomProfiler.start("NetworkUtils.getClientOrServer")
    local who = _G.whoAmI()
    if who == Client.iAm then
        CustomProfiler.stop("NetworkUtils.getClientOrServer", cpc)
        return Client
    elseif who == Server.iAm then
        CustomProfiler.stop("NetworkUtils.getClientOrServer", cpc)
        return Server
    else
        CustomProfiler.stop("NetworkUtils.getClientOrServer", cpc)
        error(("Unable to identify whether I am Client or Server.. whoAmI() == %s"):format(who), 2)
    end
end

function NetworkUtils.getNextNetworkMessageId()
    local cpc                            = CustomProfiler.start("NetworkUtils.getNextNetworkMessageId")
    NetworkUtils.networkMessageIdCounter = NetworkUtils.networkMessageIdCounter + 1
    CustomProfiler.stop("NetworkUtils.getNextNetworkMessageId", cpc)
    return NetworkUtils.networkMessageIdCounter
end

--- Checks if the event within its data was already sent
--- @param peer table If Server, then it's the peer, if Client, then it's the 'self' object
--- @param event string
--- @param data table
--- @return boolean
function NetworkUtils.alreadySent(peer, event, data)
    local cpc = CustomProfiler.start("NetworkUtils.alreadySent")
    if not peer then
        error("'peer' must not be nil! When Server, then peer or Server.clients[i]. When Client, then self.", 2)
    end
    if not event then
        error("'event' must not be nil!", 2)
    end
    if not NetworkUtils.events[event] then
        error(("'event' \"%s\" is unknown. Did you add this event in NetworkUtils.events?"):format(event), 2)
    end
    if not data then
        error("'data' must not be nil!", 2)
    end
    if Utils.IsEmpty(peer.clientCacheId) then
        Logger.info(Logger.channels.testing, ("peer.guid = '%s'"):format(peer.guid))
        peer.clientCacheId = GuidUtils.toNumber(peer.guid) --error("peer.clientCacheId must not be nil!", 2)
    end

    local clientCacheId    = peer.clientCacheId
    local networkMessageId = data[1]
    if not networkMessageId then
        error("'networkMessageId' must not be nil!", 2)
    end

    -- [[ if the event isn't store in the cache, it wasn't already send ]] --
    if not NetworkUtils.events[event].isCacheable then
        Logger.trace(Logger.channels.testing, ("event %s is not cacheable!"):format(event))
        CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
        return false
    end

    --[[ if the network message is already stored ]]
    --
    local message = NetworkCacheUtils.get(peer.guid, networkMessageId, event)
    if message ~= nil then
        print(("Got message %s by cache with clientCacheId '%s', event '%s' and networkMessageId '%s'")
            :format(message, clientCacheId, event, networkMessageId))
        if message.status == NetworkUtils.events.acknowledgement.ack then
            print(("Got message %s by cache with clientCacheId '%s', event '%s' and networkMessageId '%s'")
                :format(message, clientCacheId, event, networkMessageId))
            CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
            return true
        end
    else
        Logger.trace(Logger.channels.testing,
            ("NetworkUtils.alreadySent: NetworkCacheUtils.get(peer.guid %s, networkMessageId %s, event %s) returned message = nil")
            :format(peer.guid, networkMessageId, event))
    end
    --- Compare if the current data matches the cached checksum
    local matchingData = NetworkCacheUtils.getByChecksum(peer.guid, event, data)
    if matchingData ~= nil then
        if matchingData.status == NetworkUtils.events.acknowledgement.sent then
            local now = GameGetRealWorldTimeSinceStarted()
            local diff = now - matchingData.sendAt
            if diff >= peer:getRoundTripTime() then
                print(("Resend after %s ms: %s"):format(diff, Utils.pformat(data)))
                return false
            end
        end
        return true
    else
        Logger.trace(Logger.channels.testing,
            ("NetworkUtils.alreadySent: NetworkCacheUtils.getByChecksum(peer.guid %s, event %s, data %s) returned matchingData = nil")
            :format(peer.guid, event, data))
    end
    CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    return false
end

local prevTimeInMs = 0
function NetworkUtils.isTick()
    -- TODO: ADD LuaDoc
    local cpc         = CustomProfiler.start("NetworkUtils.isTick")
    local nowTimeInMs = GameGetRealWorldTimeSinceStarted() * 1000
    local elapsedTime = nowTimeInMs - prevTimeInMs
    local cpc2        = CustomProfiler.start("ModSettingGet")
    local oneTickInMs = 1000 / tonumber(ModSettingGet("noita-mp.tick_rate"))
    CustomProfiler.stop("ModSettingGet", cpc2)
    if elapsedTime >= oneTickInMs then
        prevTimeInMs = nowTimeInMs
        CustomProfiler.stop("NetworkUtils.isTick", cpc)
        return true
    end
    CustomProfiler.stop("NetworkUtils.isTick", cpc)
    return false
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NetworkUtils = NetworkUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NetworkUtils
