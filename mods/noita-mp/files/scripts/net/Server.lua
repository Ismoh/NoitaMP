-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
-- 'Imports'
----------------------------------------
local sock = require("sock")

----------------------------------------------------------------------------------------------------
--- Server
----------------------------------------------------------------------------------------------------
Server = {}

----------------------------------------
-- Global private variables:
----------------------------------------

----------------------------------------
-- Global private methods:
----------------------------------------

----------------------------------------
-- Access to global private variables
----------------------------------------

----------------------------------------
-- Global public variables:
----------------------------------------

----------------------------------------------------------------------------------------------------
--- Server constructor
----------------------------------------------------------------------------------------------------
--- Creates a new instance of server 'class'
---@param sockServer table sock.lua#newServer
---@return table Server
function Server.new(sockServer)
    local self       = sockServer

    ------------------------------------
    -- Private variables:
    ------------------------------------

    ------------------------------------
    --- Public variables:
    ------------------------------------
    self.iAm         = "SERVER"
    self.name        = tostring(ModSettingGet("noita-mp.name"))
    -- guid might not be set here or will be overwritten at the end of the constructor. @see setGuid
    self.guid        = tostring(ModSettingGet("noita-mp.guid"))
    self.nuid        = nil
    self.acknowledge = {} -- sock.lua#Client:send -> self.acknowledge[packetsSent] = { event = event, data = data, entityId = data.entityId, status = NetworkUtils.events.acknowledgement.sent }
    self.transform   = { x = 0, y = 0 }
    self.health      = { current = 234, max = 2135 }
    self.entityCache = {}


    ------------------------------------
    --- Private methods:
    ------------------------------------

    ------------------------------------------------------------------------------------------------
    --- Set servers settings
    ------------------------------------------------------------------------------------------------
    local function setConfigSettings()

    end

    ------------------------------------------------------------------------------------------------
    --- Set servers guid
    ------------------------------------------------------------------------------------------------
    local function setGuid()
        local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))

        if guid == "" or Guid.isPatternValid(guid) == false then
            guid = Guid:getGuid()
            ModSettingSetNextValue("noita-mp.guid", guid, false)
            self.guid = guid
            logger:debug(logger.channels.network, "Servers guid set to " .. guid)
        else
            logger:debug(logger.channels.network, "Servers guid was already set to " .. guid)
        end

        if DebugGetIsDevBuild() then
            guid = guid .. self.iAm
        end
    end

    ------------------------------------------------------------------------------------------------
    --- Send acknowledgement
    ------------------------------------------------------------------------------------------------
    local function sendAck(networkMessageId, peer)
        local data = { networkMessageId, NetworkUtils.events.acknowledgement.ack }
        self:sendToPeer(peer, NetworkUtils.events.acknowledgement.name, data)
        logger:debug(logger.channels.network, ("Sent ack with data = %s"):format(util.pformat(data)))
    end

    ------------------------------------------------------------------------------------------------
    --- onAcknowledgement
    ------------------------------------------------------------------------------------------------
    local function onAcknowledgement(data, peer)
        logger:debug(logger.channels.network, "onAcknowledgement: Acknowledgement received.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onAcknowledgement data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if not data.networkMessageId then
            logger:error(logger.channels.network,
                         ("Unable to get acknowledgement with networkMessageId = %s, data = %s, peer = %s")
                                 :format(networkMessageId, data, peer))
            return
        end

        if not self.acknowledge[data.networkMessageId] then
            self.acknowledge[data.networkMessageId] = {}
        end

        self.acknowledge[data.networkMessageId].status = data.status
    end

    ------------------------------------------------------------------------------------------------
    --- onConnect
    ------------------------------------------------------------------------------------------------
    --- Callback when client connected to server.
    --- @param data number not in use atm
    --- @param peer table
    local function onConnect(data, peer)
        logger:debug(logger.channels.network, ("Peer %s connected! data = %s")
                :format(util.pformat(peer), util.pformat(data)))

        if util.IsEmpty(peer) then
            error(("onConnect peer is empty: %s"):format(peer), 3)
        end

        if util.IsEmpty(data) then
            error(("onConnect data is empty: %s"):format(data), 3)
        end

        -- sendAck(data.networkMessageId, peer)

        local localPlayerInfo            = util.getLocalPlayerInfo()
        local name                       = localPlayerInfo.name
        local guid                       = localPlayerInfo.guid
        local entityId                   = localPlayerInfo.entityId
        local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)

        self:sendToPeer(peer, NetworkUtils.events.playerInfo.name,
                        { NetworkUtils.getNextNetworkMessageId(), name, guid, nuid })
        self:sendToPeer(peer, NetworkUtils.events.seed.name,
                        { NetworkUtils.getNextNetworkMessageId(), StatsGetValue("world_seed") })
        -- Let the other clients know, that one client connected
        self:sendToAllBut(peer, NetworkUtils.events.connect2.name,
                          { NetworkUtils.getNextNetworkMessageId(), peer.name, peer.guid })

        local filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        self.sendNewNuid({ name, guid }, entityId, nuid, x, y, rotation, velocity, filename)
    end

    ------------------------------------------------------------------------------------------------
    --- onDisconnect
    ------------------------------------------------------------------------------------------------
    --- Callback when client disconnected from server.
    --- @param data table
    --- @param peer table
    local function onDisconnect(data, peer)
        logger:debug(logger.channels.network, "Disconnected from server!", util.pformat(data))

        if util.IsEmpty(peer) then
            error(("onConnect peer is empty: %s"):format(peer), 3)
        end

        if util.IsEmpty(data) then
            error(("onDisconnect data is empty: %s"):format(data), 3)
        end

        -- sendAck(data.networkMessageId, peer)

        logger:debug(logger.channels.network, "Disconnected from server!", util.pformat(data))
        -- Let the other clients know, that one client disconnected
        self:sendToAllBut(peer, NetworkUtils.events.disconnect2.name,
                          { NetworkUtils.getNextNetworkMessageId(), peer.name, peer.guid, peer.nuid })
        EntityUtils.destroyByNuid(peer.nuid)
    end

    ------------------------------------------------------------------------------------------------
    --- onPlayerInfo
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent his playerInfo to the client
    --- @param data table data { networkMessageId, name, guid }
    local function onPlayerInfo(data, peer)
        logger:debug(logger.channels.network, "onPlayerInfo: Player info received.", util.pformat(data))

        if util.IsEmpty(peer) then
            error(("onConnect peer is empty: %s"):format(peer), 3)
        end

        if util.IsEmpty(data.networkMessageId) then
            error(("onPlayerInfo data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.name) then
            error(("onPlayerInfo data.name is empty: %s"):format(data.name), 3)
        end

        if util.IsEmpty(data.guid) then
            error(("onPlayerInfo data.guid is empty: %s"):format(data.guid), 3)
        end

        if util.IsEmpty(data.nuid) then
            error(("onPlayerInfo data.nuid is empty: %s"):format(data.nuid), 3)
        end

        sendAck(data.networkMessageId, peer)

        for i, client in pairs(self.clients) do
            if client == peer then
                self.clients[i].name = data.name
                self.clients[i].guid = data.guid
                self.clients[i].nuid = data.nuid
            end
        end
    end

    ------------------------------------------------------------------------------------------------
    --- onNeedNuid
    ------------------------------------------------------------------------------------------------
    local function onNeedNuid(data, peer)
        logger:debug(logger.channels.network, ("Peer %s needs a new nuid. data = %s")
                :format(util.pformat(peer), util.pformat(data)))

        if util.IsEmpty(peer) then
            error(("onNeedNuid peer is empty: %s"):format(util.pformat(peer)), 3)
        end

        if util.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(util.pformat(data.owner)), 3)
        end

        if util.IsEmpty(data.localEntityId) then
            error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
        end

        if util.IsEmpty(data.x) then
            error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
        end

        if util.IsEmpty(data.y) then
            error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
        end

        if util.IsEmpty(data.rotation) then
            error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
        end

        if util.IsEmpty(data.velocity) then
            error(("onNewNuid data.velocity is empty: %s"):format(util.pformat(data.velocity)), 3)
        end

        if util.IsEmpty(data.filename) then
            error(("onNewNuid data.filename is empty: %s"):format(data.filename), 3)
        end

        sendAck(data.networkMessageId, peer)

        local owner         = data.owner
        local localEntityId = data.localEntityId
        local x             = data.x
        local y             = data.y
        local rotation      = data.rotation
        local velocity      = data.velocity
        local filename      = data.filename

        local newNuid       = NuidUtils.getNextNuid()
        self.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename)
        EntityUtils.SpawnEntity(owner, newNuid, x, y, rotation, velocity, filename, localEntityId)
    end

    ------------------------------------------------------------------------------------------------
    --- onLostNuid
    ------------------------------------------------------------------------------------------------
    local function onLostNuid(data, peer)
        logger:debug(logger.channels.network, ("Peer %s lost a nuid and ask for the entity to spawn. data = %s")
                :format(util.pformat(peer), util.pformat(data)))

        if util.IsEmpty(peer) then
            error(("onLostNuid peer is empty: %s"):format(util.pformat(peer)), 3)
        end

        if util.IsEmpty(data.networkMessageId) then
            error(("onLostNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.nuid) then
            error(("onLostNuid data.nuid is empty: %s"):format(util.pformat(data.nuid)), 3)
        end

        local nuid, entityId                             = GlobalsUtils.getNuidEntityPair(data.nuid)
        local compOwnerName, compOwnerGuid, compNuid     = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
        local filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)

        self.sendNewNuid({ compOwnerName, compOwnerGuid },
                         "unknown", nuid, x, y, rotation, velocity, filename)
    end

    local function onEntityData(data, peer)
        logger:debug(logger.channels.network, ("Received entityData for nuid = %s! data = %s")
                :format(data.nuid, util.pformat(data)))

        if util.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(util.pformat(data.owner)), 3)
        end

        --if util.IsEmpty(data.localEntityId) then
        --    error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
        --end

        if util.IsEmpty(data.nuid) then
            error(("onNewNuid data.nuid is empty: %s"):format(data.nuid), 3)
        end

        if util.IsEmpty(data.x) then
            error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
        end

        if util.IsEmpty(data.y) then
            error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
        end

        if util.IsEmpty(data.rotation) then
            error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
        end

        if util.IsEmpty(data.velocity) then
            error(("onNewNuid data.velocity is empty: %s"):format(util.pformat(data.velocity)), 3)
        end

        if util.IsEmpty(data.health) then
            error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
        end

        sendAck(data.networkMessageId, peer)

        local owner                = data.owner
        local nnuid, localEntityId = GlobalsUtils.getNuidEntityPair(data.nuid)
        local nuid                 = data.nuid
        local x                    = data.x
        local y                    = data.y
        local rotation             = data.rotation
        local velocity             = data.velocity
        local health               = data.health

        NoitaComponentUtils.setEntityData(localEntityId, x, y, rotation, velocity, health)

        --self:sendToAllBut(peer, NetworkUtils.events.entityData.name, data)
    end

    --self:sendToAllBut(peer, NetworkUtils.events.playerInfo.name)

    local function setClientInfo(data, peer)
        local name = data.name
        local guid = data.guid

        if not name then
            error("Unable to get clients name!", 2)
        end

        if not guid then
            error("Unable to get clients guid!", 2)
        end

        -- if not Guid:isUnique(guid) then
        --     guid = Guid:getGuid({ guid })
        --     self:sendToPeer(peer, "duplicatedGuid", { guid })
        -- end

        for i, client in pairs(self.clients) do
            if client == peer then
                self.clients[i].name = name
                self.clients[i].guid = guid
            end
        end
    end

    -- Called when someone connects to the server
    -- self:on("connect", function(data, peer)
    --     logger:debug(logger.channels.network, "Someone connected to the server:", util.pformat(data))

    --     local local_player_id = EntityUtils.getLocalPlayerEntityId()
    --     local x, y, rot, scale_x, scale_y = EntityGetTransform(local_player_id)

    --     EntityUtils.SpawnEntity({ peer.name, peer.guid }, NuidUtils.getNextNuid(), x, y, rot,
    --         nil, "mods/noita-mp/data/enemies_gfx/client_player_base.xml", nil)
    -- end
    -- )

    -- self:on(
    --     "clientInfo",
    --     function(data, peer)
    --         logger:debug(logger.channels.network, "on_clientInfo: data =", util.pformat(data))
    --         logger:debug(logger.channels.network, "on_clientInfo: peer =", util.pformat(peer))
    --         setClientInfo(data, peer)
    --     end
    -- )

    -- self:on(
    --     "worldFilesFinished",
    --     function(data, peer)
    --         logger:debug(logger.channels.network, "on_worldFilesFinished: data =", util.pformat(data))
    --         logger:debug(logger.channels.network, "on_worldFilesFinished: peer =", util.pformat(peer))
    --         -- Send restart command
    --         peer:send("restart", { "Restart now!" })
    --     end
    -- )

    -- -- Called when the client disconnects from the server
    -- self:on(
    --     "disconnect",
    --     function(data)
    --         logger:debug(logger.channels.network, "on_disconnect: data =", util.pformat(data))
    --     end
    -- )

    -- -- see lua-enet/enet.c
    -- self:on(
    --     "receive",
    --     function(data, channel, client)
    --         logger:debug(logger.channels.network, "on_receive: data =", util.pformat(data))
    --         logger:debug(logger.channels.network, "on_receive: channel =", util.pformat(channel))
    --         logger:debug(logger.channels.network, "on_receive: client =", util.pformat(client))
    --     end
    -- )

    -- self:on(
    --     "needNuid",
    --     function(data)
    --         logger:debug(logger.channels.network, "%s (%s) needs a new nuid.", data.owner.name, data.owner.guid, util.pformat(data))

    --         local new_nuid = NuidUtils.getNextNuid()
    --         -- tell the clients that there is a new entity, they have to spawn, besides the client, who sent the request
    --         self.sendNewNuid(data.owner, data.localEntityId, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename)
    --         -- spawn the entity on server only
    --         EntityUtils.SpawnEntity(data.owner, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename, data.localEntityId) --em:SpawnEntity(data.owner, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
    --     end
    -- )

    -- self:on(
    --     "newNuid",
    --     function(data)
    --         logger:debug(logger.channels.network, util.pformat(data))

    --         if self.guid == data.owner.guid then
    --             logger:debug(logger.channels.network,
    --                 "Got a new nuid, but the owner is me and therefore I don't care :). For data content see above!"
    --             )
    --             return -- skip if this entity is my own
    --         end

    --         logger:debug(logger.channels.network, "Got a new nuid and spawning entity. For data content see above!")
    --         em:SpawnEntity(data.owner, data.nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
    --     end
    -- )

    -- self:on(
    --     "entityAlive",
    --     function(data)
    --         logger:debug(logger.channels.network, util.pformat(data))

    --         self:sendToAll2("entityAlive", data)
    --         em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
    --     end
    -- )

    -- self:on(
    --     "entityState",
    --     function(data)
    --         logger:debug(logger.channels.network, util.pformat(data))

    --         local nc = em:GetNetworkComponent(data.owner, data.localEntityId, data.nuid)
    --         if nc then
    --             EntityApplyTransform(nc.local_entity_id, data.x, data.y, data.rot)
    --         else
    --             logger:warn(logger.channels.network,
    --                 "Got entityState, but unable to find the network component!" ..
    --                 " owner(%s, %s), localEntityId(%s), nuid(%s), x(%s), y(%s), rot(%s), velocity(x %s, y %s), health(%s)",
    --                 data.owner.name,
    --                 data.owner.guid,
    --                 data.localEntityId,
    --                 data.nuid,
    --                 data.x,
    --                 data.y,
    --                 data.rot,
    --                 data.velocity.x,
    --                 data.velocity.y,
    --                 data.health
    --             )
    --         end
    --         self:sendToAll2("entityState", data)
    --     end
    -- )

    --#endregion

    ------------------------------------------------------------------------------------------------
    --- setCallbackAndSchemas
    ------------------------------------------------------------------------------------------------
    --- Sets callbacks and schemas of the server.
    local function setCallbackAndSchemas()
        --self:setSchema(NetworkUtils.events.connect, { "code" })
        self:on(NetworkUtils.events.connect.name, onConnect)

        --self:setSchema(NetworkUtils.events.disconnect, { "code" })
        self:on(NetworkUtils.events.disconnect.name, onDisconnect)

        self:setSchema(NetworkUtils.events.acknowledgement.name, NetworkUtils.events.acknowledgement.schema)
        self:on(NetworkUtils.events.acknowledgement.name, onAcknowledgement)

        --self:setSchema(NetworkUtils.events.seed.name, NetworkUtils.events.seed.schema)
        --self:on(NetworkUtils.events.seed.name, onSeed)

        self:setSchema(NetworkUtils.events.playerInfo.name, NetworkUtils.events.playerInfo.schema)
        self:on(NetworkUtils.events.playerInfo.name, onPlayerInfo)

        -- self:setSchema(NetworkUtils.events.newNuid.name, NetworkUtils.events.newNuid.schema)
        -- self:on(NetworkUtils.events.newNuid.name, onNewNuid)

        self:setSchema(NetworkUtils.events.needNuid.name, NetworkUtils.events.needNuid.schema)
        self:on(NetworkUtils.events.needNuid.name, onNeedNuid)

        self:setSchema(NetworkUtils.events.lostNuid.name, NetworkUtils.events.lostNuid.schema)
        self:on(NetworkUtils.events.lostNuid.name, onLostNuid)

        self:setSchema(NetworkUtils.events.entityData.name, NetworkUtils.events.entityData.schema)
        self:on(NetworkUtils.events.entityData.name, onEntityData)

        -- self:setSchema("duplicatedGuid", { "newGuid" })
        -- self:setSchema("worldFiles", { "relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles" })
        -- self:setSchema("worldFilesFinished", { "progress" })
        -- self:setSchema("seed", { "seed" })
        -- self:setSchema("clientInfo", { "name", "guid" })
        -- self:setSchema("needNuid", { "owner", "localEntityId", "x", "y", "rot", "velocity", "filename" })
        -- self:setSchema("newNuid", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "filename" })
        -- self:setSchema("entityAlive", { "owner", "localEntityId", "nuid", "isAlive" })
        -- self:setSchema("entityState", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "health" })
    end

    local function updateVariables()
        local entityId = util.getLocalPlayerInfo().entityId
        if entityId then
            local filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
            self.health                                      = health
            self.transform                                   = { x = math.floor(x), y = math.floor(y) }
        end
    end

    -- Public methods:
    --#region Start and stop

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockServerStart = sockServer.start
    --- Starts a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number port number from 1 to max of 65535 or nil
    function self.start(ip, port)
        if not ip then
            ip = tostring(ModSettingGet("noita-mp.server_ip"))
        end

        if not port then
            port = tonumber(ModSettingGet("noita-mp.server_port"))
        end

        self.stop()
        _G.Server.stop() -- stop if any server is already running

        logger:info(logger.channels.network, "Starting server on %s:%s ..", ip, port)
        --self = _G.ServerInit.new(sock.newServer(ip, port), false)
        --_G.Server = self
        sockServerStart(self, ip, port)
        logger:info(logger.channels.network, "Server started on %s:%s", self:getAddress(), self:getPort())

        setGuid()
        setConfigSettings()
        setCallbackAndSchemas()

        GamePrintImportant("Server started",
                           ("Your server is running on %s. Tell your friends to join!"):format(self:getAddress(),
                                                                                               self:getPort()),
                           "")
    end

    --- Stops the server.
    function self.stop()
        if self.isRunning() then
            self:destroy()
        else
            logger:info(logger.channels.network, "Server isn't running, there cannot be stopped.")
        end
    end

    --#endregion

    --#region Additional methods

    function self.isRunning()
        local status, result = pcall(self.getSocketAddress, self)
        if not status then
            return false
        end
        return true
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockServerUpdate = sockServer.update
    --- Updates the server by checking for network events and handling them.
    function self.update()
        if not self.isRunning() then
            --if not self.host then
            -- server not established
            return
        end

        updateVariables()

        EntityUtils.initNetworkVscs()
        EntityUtils.syncEntityData()

        sockServerUpdate(self)
    end

    function self.sendNewNuid(owner, localEntityId, newNuid, x, y, rot, velocity, filename)
        self:sendToAll2("newNuid",
                        { NetworkUtils.getNextNetworkMessageId(), owner, localEntityId, newNuid, x, y, rot, velocity, filename })
    end

    function self.sendEntityData(entityId)
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end

        local compOwnerName, compOwnerGuid, compNuid     = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
        local filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local data                                       = {
            NetworkUtils.getNextNetworkMessageId(), { compOwnerName, compOwnerGuid }, compNuid, x, y, rotation, velocity, health
        }

        if util.IsEmpty(compNuid) then
            -- nuid must not be empty, when Server!
            logger:error(logger.channels.network, "Unable to send entity data, because nuid is empty.")
            return
        end

        if util.getLocalPlayerInfo().guid == compOwnerGuid then
            self:sendToAll2(NetworkUtils.events.entityData.name, data)
        end
    end

    --- Checks if the current local user is the server
    --- @return boolean iAm true if server
    function self.amIServer()
        -- this can happen when you started and stop a server and then connected to a different server!
        -- if _G.Server.super and _G.Client.super then
        --     error("Something really strange is going on. You are server and client at the same time?", 2)
        -- end

        if _G.Server.isRunning() then
            --if _G.Server.host and _G.Server.guid == self.guid then
            return true
        end

        return false
    end

    function self.kick(name)
        logger:debug(logger.channels.network, "Minä %s was kicked!", name)
    end

    function self.ban(name)
        logger:debug(logger.channels.network, "Minä %s was banned!", name)
    end

    --#endregion

    -- Apply some private methods

    return self
end

-- Init this object:

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.ServerInit     = Server
_G.Server         = Server.new(sock.newServer())

local startOnLoad = ModSettingGet("noita-mp.server_start_when_world_loaded")
if startOnLoad then
    -- Polymorphism sample
    _G.Server.start(nil, nil)
else
    GamePrintImportant("Server not started",
                       "Your server wasn't started yet. Check ModSettings to change this or Press M to open multiplayer menu.",
                       ""
    )
end


-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Server
