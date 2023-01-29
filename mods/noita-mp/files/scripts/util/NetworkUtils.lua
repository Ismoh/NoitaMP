-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------
local util                           = require("util")

------------------------------------------------------------------------------------------------------------------------
--- NetworkUtils
------------------------------------------------------------------------------------------------------------------------
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
        name        = "connect2",
        schema      = { "name", "guid" },
        isCacheable = false
    },

    disconnect      = {
        name        = "disconnect",
        schema      = { "code" },
        isCacheable = false
    },

    --- disconnect2 is used to let the other clients know, who was disconnected
    disconnect2     = {
        name        = "disconnect2",
        schema      = { "networkMessageId", "name", "guid" },
        isCacheable = false
    },

    --- acknowledgement is used to let the sender know if the message was acknowledged
    acknowledgement = {
        name        = "acknowledgement",
        schema      = { "networkMessageId", "event", "status" },
        ack         = "ack",
        sent        = "sent",
        isCacheable = true
    },

    --- seed is used to send the servers seed
    seed            = {
        name        = "seed",
        schema      = { "networkMessageId", "seed" },
        isCacheable = true
    },

    --- playerInfo is used to send localPlayerInfo name and guid to all peers
    playerInfo      = {
        name        = "playerInfo",
        schema      = { "networkMessageId", "name", "guid", "version", "nuid" },
        isCacheable = true
    },

    --- newGuid is used to send a new GUID to a client, which GUID isn't unique all peers
    newGuid         = {
        name        = "newGuid",
        schema      = { "networkMessageId", "oldGuid", "newGuid" },
        isCacheable = true
    },

    --- newNuid is used to let clients spawn entities by the servers permission
    newNuid         = {
        --- constant name for the event
        name             = "newNuid",
        --- network schema to decode the message
        schema           = { "networkMessageId", "owner", "localEntityId", "newNuid", "x", "y", "rotation", "velocity",
                             "filename", "health", "isPolymorphed" },
        --- identifier whether to send this message again, if it wasn't acknowledged
        resendIdentifier = { "newNuid" },
        --- identifier whether to cache this message, if it wasn't acknowledged
        isCacheable      = true
    },

    --- needNuid is used to ask for a nuid from client to servers
    needNuid        = {
        name             = "needNuid",
        schema           = { "networkMessageId", "owner", "localEntityId", "x", "y",
                             "rotation", "velocity", "filename", "health", "isPolymorphed" },
        resendIdentifier = { "localEntityId", "filename" },
        isCacheable      = true
    },

    --- lostNuid is used to ask for the entity to spawn, when a client has a nuid stored, but no entityId (not sure
    --- atm, why this is happening, but this is due to reduce out of sync stuff)
    lostNuid        = {
        name        = "lostNuid",
        schema      = { "networkMessageId", "nuid" },
        isCacheable = true
    },

    --- entityData is used to sync position, velocity and health
    entityData      = {
        name        = "entityData",
        schema      = { "networkMessageId", "owner", "nuid", "x", "y", "rotation", "velocity", "health" },
        isCacheable = false
    },

    --- deadNuids is used to let clients know, which entities were killed or destroyed
    deadNuids       = {
        name        = "deadNuids",
        schema      = { "networkMessageId", "deadNuids" },
        isCacheable = true
    },

    --- needModList is used to let clients sync enabled mods with the server
    needModList     = {
        name        = "needModList",
        schema      = { "networkMessageId", "workshop", "external" },
        isCacheable = true
    },

    --- needModContent is used to sync mod content from server to client
    needModContent  = {
        name        = "needModContent",
        schema      = { "networkMessageId", "get", "items" },
        isCacheable = true
    }
}

--- Copy from sock.lua, because I am lazy
local function zipTable(items, keys, event)
    local cpc  = CustomProfiler.start("NetworkUtils.zipTable")
    local data = {}

    -- convert variable at index 1 into the value for the key value at index 1, and so on
    for i, value in ipairs(items) do
        local key = keys[i]

        if not key then
            error("Event '" .. event .. "' missing data key. Is the schema different between server and client?")
        end

        data[key] = value
    end

    CustomProfiler.stop("NetworkUtils.zipTable", cpc)
    return data
end

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

--- Sometimes you don't care if it's the client or server, but you need one of them to send the messages.
--- @return Client|Server Client or Server 'object'
--- @public
function NetworkUtils.getClientOrServer()
    local cpc = CustomProfiler.start("NetworkUtils.getClientOrServer")
    if _G.whoAmI() == Client.iAm then
        CustomProfiler.stop("NetworkUtils.getClientOrServer", cpc)
        return Client
    elseif _G.whoAmI() == Server.iAm then
        CustomProfiler.stop("NetworkUtils.getClientOrServer", cpc)
        return Server
    else
        error("Unable to identify whether I am Client or Server..", 3)
    end
    CustomProfiler.stop("NetworkUtils.getClientOrServer", cpc)
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
        error("'peer' must not be nil! When Server, then peer. When Client, then self.", 2)
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
    if util.IsEmpty(peer.clientCacheId) then
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
        CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
        return false
    end

    --[[ if the network message is already stored ]]--
    print(("peer.guid = '%s'"):format(peer.guid))
    print(("peer.clientCacheId = '%s'"):format(peer.clientCacheId))
    local message = NetworkCacheUtils.get(peer.guid, networkMessageId, event)
    if message ~= nil then
        print(("Got message %s by cache with clientCacheId '%s', event '%s' and networkMessageId '%s'")
                      :format(message, clientCacheId, event, networkMessageId))
        if message.status == NetworkUtils.events.acknowledgement.ack then
            print(("2Got message %s by cache with clientCacheId '%s', event '%s' and networkMessageId '%s'")
                          :format(message, clientCacheId, event, networkMessageId))
            CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
            return true
        end
    end

    --- Compare if the current data matches the cached checksum
    local matchingData = NetworkCacheUtils.getByChecksum(peer.guid, data, event)
    if matchingData ~= nil then
        return true;
    end
    --end

    --logger:warn(logger.channels.network, "Unable to get status of network message.")
    CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    return false

    --local alreadySent      = false
    ---- We need to compare the data, because networkMessageId isn't stored
    --local data1            = table.deepcopy(data)
    --data1.networkMessageId = nil
    --table.setNoitaMpDefaultMetaMethods(data1)
    ----table.remove(data1, 1)
    --
    --for key, value in pairs(clientOrServer.acknowledge) do
    --    if value.event == event then
    --        --local eventSchema = nil
    --        --for key2, value2 in pairs(NetworkUtils.events) do
    --        --    if value2.name == event then
    --        --        eventSchema = value2.schema
    --        --        break
    --        --    end
    --        --end
    --        --local readableData = zipTable(value.data, eventSchema, event)
    --        --for d1 = 1, #data do
    --        --    for d2 = 1, #value.data do
    --        --        if data[d1] == value.data[d2] then
    --        --            return true
    --        --        end
    --        --    end
    --        --end
    --
    --        if event == NetworkUtils.events.newNuid.name then
    --            if data.localEntityId == value.data.localEntityId and
    --                    value.status ~= NetworkUtils.events.acknowledgement.ack
    --            then
    --                CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    --                return true
    --            end
    --        end
    --
    --        local data2            = table.deepcopy(value.data) -- TODO: memory leak?
    --        data2.networkMessageId = nil
    --        table.setNoitaMpDefaultMetaMethods(data2)
    --        --table.remove(data2, 1)
    --
    --        -- if position of entity changes, while trying to get nuid, this compare will fail, because x and y is
    --        -- different. Therefore there is an additional check below, for simply comparing ownerName, ownerGuid and
    --        -- entityId, if this was already sent in combination.
    --        local ran, errorMsg = pcall(luaunit.assertItemsEquals, data1, data2)
    --        if ran and not errorMsg then
    --            if value.status ~= NetworkUtils.events.acknowledgement.ack then
    --                local pasted = os.time() - value.sentAt
    --                if pasted >= rtt then
    --                    CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    --                    return false -- resend after RTT
    --                end
    --            end
    --            CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    --            return true
    --        end
    --        data2 = nil
    --    end
    --
    --    -- double check if ownerName, ownerGuid and entityId already was sent
    --    if event == NetworkUtils.events.needNuid.name and value.event == NetworkUtils.events.needNuid.name then
    --        local eventSchema = nil
    --        for key2, value2 in pairs(NetworkUtils.events) do
    --            if value2.name == event then
    --                eventSchema = value2.schema
    --                break
    --            end
    --        end
    --        local dataNow       = zipTable(data, eventSchema, event)
    --        local ownerNameNow  = dataNow.owner[1] or data[2][1]
    --        local ownerGuidNow  = dataNow.owner[2] or data[2][2]
    --        local entityIdNow   = dataNow.localEntityId or data[3]
    --
    --        local dataPrev      = zipTable(value.data, eventSchema, event)
    --        local ownerNamePrev = dataPrev.owner[1] or value.data[2][1]
    --        local ownerGuidPrev = dataPrev.owner[2] or value.data[2][2]
    --        local entityIdPrev  = dataPrev.localEntityId or value.data[3]
    --
    --        if ownerNameNow == ownerNamePrev and ownerGuidNow == ownerGuidPrev and entityIdNow == entityIdPrev then
    --            CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    --            return true
    --        end
    --    end
    --    data1 = nil
    --end
    --
    ----
    ------
    ----
    ------ self.acknowledge[data.networkMessageId] = { event = event, data = data, entityId = data.entityId, status = NetworkUtils.events.acknowledgement.sent }
    ----for i = 1, #clientOrServer.acknowledge or {} do
    ----    if clientOrServer.acknowledge[i].entityId == nil then
    ----        -- network message wasn't entity related
    ----        -- compare events
    ----        if clientOrServer.acknowledge[i].event == event then
    ----            return clientOrServer.acknowledge[i].status == NetworkUtils.events.acknowledgement.ack
    ----        end
    ----    elseif clientOrServer.acknowledge[i].entityId == entityId then
    ----        return clientOrServer.acknowledge[i].status == NetworkUtils.events.acknowledgement.ack
    ----    else
    ----        -- neither event nor entityId matches
    ----        -- compare networkMessageId
    ----        if data.networkMessageId then
    ----            if clientOrServer.acknowledge[i].data.networkMessageId == data.networkMessageId then
    ----                return clientOrServer.acknowledge[i].status == NetworkUtils.events.acknowledgement.ack
    ----            end
    ----        end
    ----    end
    ----end
    ----
    --logger:warn(logger.channels.network, "Unable to get status of network message.")
    --clientOrServer.acknowledge[networkMessageId] = { event = event, data = data, status = NetworkUtils.events.acknowledgement.sent }
    --CustomProfiler.stop("NetworkUtils.alreadySent", cpc)
    --return false
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
