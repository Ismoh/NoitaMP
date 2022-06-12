-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- 'Imports'
----------------------------------------
local util                           = require("util")

----------------------------------------------------------------------------------------------------
--- NetworkUtils
----------------------------------------------------------------------------------------------------
NetworkUtils                         = {}

NetworkUtils.networkMessageIdCounter = 0

NetworkUtils.events                  = {
    connect         = { name = "connect", schema = { "code" } },

    --- connect2 is used to let the other clients know, who was connected
    connect2        = { name = "connect2", schema = { "name", "guid" } },

    disconnect      = { name = "disconnect", schema = { "code" } },

    --- disconnect2 is used to let the other clients know, who was disconnected
    disconnect2     = { name = "disconnect2", schema = { "networkMessageId", "name", "guid" } },

    --- acknowledgement is used to let the sender know if the message was acknowledged
    acknowledgement = { name = "acknowledgement", schema = { "networkMessageId", "status" }, ack = "ack", sent = "sent" },

    --- seed is used to send the servers seed
    seed            = { name = "seed", schema = { "networkMessageId", "seed" } },

    --- playerInfo is used to send localPlayerInfo name and guid to all peers
    playerInfo      = { name = "playerInfo", schema = { "networkMessageId", "name", "guid", "nuid" } },

    --- newNuid is used to let clients spawn entities by the servers permission
    newNuid         = { name = "newNuid", schema = { "networkMessageId", "owner", "localEntityId", "newNuid", "x", "y", "rotation", "velocity", "filename" } },

    --- needNuid is used to ask for a nuid from client to servers
    needNuid        = { name = "needNuid", schema = { "networkMessageId", "owner", "localEntityId", "x", "y", "rotation", "velocity", "filename" } }
}

function NetworkUtils.getNextNetworkMessageId()
    NetworkUtils.networkMessageIdCounter = NetworkUtils.networkMessageIdCounter + 1
    return NetworkUtils.networkMessageIdCounter
end

function NetworkUtils.alreadySent(event, data, entityId)
    local clientOrServer = nil

    if _G.whoAmI() == Client.iAm then
        clientOrServer = Client
    elseif _G.whoAmI() == Server.iAm then
        clientOrServer = Server
    else
        error("Unable to identify whether I am Client or Server..", 3)
    end

    local networkMessageId = data[1]
    local rtt              = clientOrServer:getRoundTripTime()

    if util.IsEmpty(networkMessageId) then
        error("networkMessageId is empty!", 3)
    end

    -- Is the networkMessageId already stored?
    if clientOrServer.acknowledge[networkMessageId] ~= nil then
        local acknowledgement = clientOrServer.acknowledge[networkMessageId]
        if acknowledgement.status == NetworkUtils.events.acknowledgement.ack then
            -- network message was already acknowledged
            return true
        end

        local pasted = os.time() - acknowledgement.sentAt
        if pasted >= rtt then
            return false -- resend after RTT
        end
    else
        return false
    end
    --
    ----
    --
    ---- self.acknowledge[data.networkMessageId] = { event = event, data = data, entityId = data.entityId, status = NetworkUtils.events.acknowledgement.sent }
    --for i = 1, #clientOrServer.acknowledge or {} do
    --    if clientOrServer.acknowledge[i].entityId == nil then
    --        -- network message wasn't entity related
    --        -- compare events
    --        if clientOrServer.acknowledge[i].event == event then
    --            return clientOrServer.acknowledge[i].status == NetworkUtils.events.acknowledgement.ack
    --        end
    --    elseif clientOrServer.acknowledge[i].entityId == entityId then
    --        return clientOrServer.acknowledge[i].status == NetworkUtils.events.acknowledgement.ack
    --    else
    --        -- neither event nor entityId matches
    --        -- compare networkMessageId
    --        if data.networkMessageId then
    --            if clientOrServer.acknowledge[i].data.networkMessageId == data.networkMessageId then
    --                return clientOrServer.acknowledge[i].status == NetworkUtils.events.acknowledgement.ack
    --            end
    --        end
    --    end
    --end
    --
    logger:error(logger.channels.network, "Unable to get status of network message.")
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NetworkUtils = NetworkUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NetworkUtils
