-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
-- 'Imports'
----------------------------------------
local sock = require("sock")
local util = require("util")

----------------------------------------------------------------------------------------------------
--- Client
----------------------------------------------------------------------------------------------------
Client = {}

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
--- Client constructor
----------------------------------------------------------------------------------------------------
--- Creates a new instance of client 'class'.
--- @param sockClient table sock.lua#newClient
--- @return table Client
function Client.new(sockClient)
    local self = sockClient

    ------------------------------------
    -- Private variables:
    ------------------------------------

    ------------------------------------
    -- Public variables:
    ------------------------------------
    self.name = tostring(ModSettingGet("noita-mp.name"))
    -- guid might not be set here or will be overwritten at the end of the constructor. @see setGuid
    self.guid = tostring(ModSettingGet("noita-mp.guid"))
    self.iAm = "CLIENT"
    self.transform = { x = 0, y = 0 }
    self.health = { current = 234, max = 2135 }
    self.serverInfo = {}
    self.otherClients = {}

    ------------------------------------
    -- Private methods:
    ------------------------------------

    ------------------------------------------------------------------------------------------------
    --- Set clients settings
    ------------------------------------------------------------------------------------------------
    local function setConfigSettings()
        self:setTimeout(320, 50000, 100000)
    end

    ------------------------------------------------------------------------------------------------
    --- Set clients guid
    ------------------------------------------------------------------------------------------------
    local function setGuid()
        local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))
        if guid == "" or Guid.isPatternValid(guid) == false then
            guid = Guid:getGuid()
            ModSettingSetNextValue("noita-mp.guid", guid, false)
            self.guid = guid
            logger:debug(logger.channels.network, "Clients guid set to " .. guid)
        else
            logger:debug(logger.channels.network, "Clients guid was already set to " .. guid)
        end
    end

    ------------------------------------------------------------------------------------------------
    --- onConnect
    ------------------------------------------------------------------------------------------------
    --- Callback when connected to server.
    --- @param data number not in use atm
    local function onConnect(data)
        logger:debug(logger.channels.network, "Connected to server!", util.pformat(data))

        local localPlayerInfo = util.getLocalPlayerInfo()
        local name = localPlayerInfo.name
        local guid = localPlayerInfo.guid
        local entityId = localPlayerInfo.entityId

        self:send(NetworkUtils.events.playerInfo.name, { name = name, guid = guid })

        if not NetworkVscUtils.hasNetworkLuaComponents(entityId) then
            NetworkVscUtils.addOrUpdateAllVscs(entityId, name, guid, nil)
        end

        if not NetworkVscUtils.hasNuidSet(entityId) then
            self.sendNeedNuid(name, guid, entityId)
        end
    end

    ------------------------------------------------------------------------------------------------
    --- onConnect2
    ------------------------------------------------------------------------------------------------
    --- Callback when one of the other clients connected.
    --- @param data table { "name", "guid" } @see NetworkUtils.events.disconnect2.schema
    local function onConnect2(data)
        logger:debug(logger.channels.network, "Another client connected.", util.pformat(data))
        table.insertIfNotExist(self.otherClients, { name = data.name, guid = data.guid })
    end

    ------------------------------------------------------------------------------------------------
    --- onDisconnect
    ------------------------------------------------------------------------------------------------
    --- Callback when disconnected from server.
    --- @param data table { code = 0 }
    local function onDisconnect(data)
        logger:debug(logger.channels.network, "Disconnected from server!", util.pformat(data))
        self.serverInfo = {}
    end

    ------------------------------------------------------------------------------------------------
    --- onDisconnect2
    ------------------------------------------------------------------------------------------------
    --- Callback when one of the other clients disconnected.
    --- @param data table { "name", "guid" } @see NetworkUtils.events.disconnect2.schema
    local function onDisconnect2(data)
        logger:debug(logger.channels.network, "Another client disconnected.", util.pformat(data))
        for i = 1, #self.otherClients do
            -- table.insertIfNotExist(self.otherClients, { name = data.name, guid = data.guid })
        end
    end

    ------------------------------------------------------------------------------------------------
    --- onPlayerInfo
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent his playerInfo to the client
    --- @param data table { name, guid }
    local function onPlayerInfo(data)
        self.serverInfo.name = data.name
        self.serverInfo.guid = data.guid
    end

    ------------------------------------------------------------------------------------------------
    --- onSeed
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent his seed to the client
    --- @param data table { seed = "" }
    local function onSeed(data)
        local serversSeed = tonumber(data.seed)
        logger:info(logger.channels.network, "Client received servers seed (%s) and stored it. Restarting Noita with that seed and auto connect now!", serversSeed)

        local localSeed = tonumber(StatsGetValue("world_seed"))
        if localSeed ~= serversSeed then
            util.reloadMap(serversSeed)
        end
    end

    ------------------------------------------------------------------------------------------------
    --- onNewNuid
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent a new nuid to the client
    --- @param data table { owner, localEntityId, newNuid, x, y, rotation, velocity, filename }
    local function onNewNuid(data)
        logger:debug(logger.channels.network, "Received a new nuid!", util.pformat(data))

        local owner         = data[1]
        local localEntityId = data[2]
        local newNuid       = data[3]
        local x             = data[4]
        local y             = data[5]
        local rotation      = data[6]
        local velocity      = data[7]
        local filename      = data[8]

        EntityUtils.SpawnEntity(owner, newNuid, x, y, rotation, velocity, filename, localEntityId)
    end

    -- self:on(
    --     "entityAlive",
    --     function(data)
    --         logger:debug(util.pformat(data))

    --         em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
    --     end
    -- )

    -- self:on(
    --     "entityState",
    --     function(data)
    --         logger:debug(util.pformat(data))

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
    --     end
    -- )

    ------------------------------------------------------------------------------------------------
    --- setCallbackAndSchemas
    ------------------------------------------------------------------------------------------------
    --- Sets callbacks and schemas of the client.
    local function setCallbackAndSchemas()
        --self:setSchema(NetworkUtils.events.connect, { "code" })
        self:on(NetworkUtils.events.connect.name, onConnect)

        self:setSchema(NetworkUtils.events.connect2.name, NetworkUtils.events.connect2.schema)
        self:on(NetworkUtils.events.connect2.name, onConnect2)

        --self:setSchema(NetworkUtils.events.disconnect, { "code" })
        self:on(NetworkUtils.events.disconnect.name, onDisconnect)

        self:setSchema(NetworkUtils.events.disconnect2.name, NetworkUtils.events.disconnect2.schema)
        self:on(NetworkUtils.events.disconnect2.name, onDisconnect2)

        self:setSchema(NetworkUtils.events.seed.name, NetworkUtils.events.seed.schema)
        self:on(NetworkUtils.events.seed.name, onSeed)

        self:setSchema(NetworkUtils.events.playerInfo, NetworkUtils.events.playerInfo.schema)
        self:on(NetworkUtils.events.playerInfo.name, onPlayerInfo)

        self:setSchema(NetworkUtils.events.newNuid, NetworkUtils.events.newNuid.schema)
        self:on(NetworkUtils.events.newNuid.name, onNewNuid)

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
            ---@diagnostic disable-next-line: missing-parameter
            local hpCompId = EntityGetFirstComponentIncludingDisabled(entityId, "DamageModelComponent")
            local hpCurrent = math.floor(tonumber(ComponentGetValue2(hpCompId, "hp")) * 25)
            local hpMax = math.floor(tonumber(ComponentGetValue2(hpCompId, "max_hp")) * 25)
            self.health = { current = hpCurrent, max = hpMax }
            local x, y, rot, scale_x, scale_y = EntityGetTransform(entityId)
            self.transform = { x = math.floor(x), y = math.floor(y) }
        end
    end

    ------------------------------------
    -- Public methods:
    ------------------------------------

    --#region Connect and disconnect

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientConnect = sockClient.connect
    --- Connects to a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number 1 - 65535 or nil
    --- @param code number 0 = connecting first time, 1 = connected second time with loaded seed
    function self.connect(ip, port, code)

        if self:isConnecting() or self:isConnected() then
            logger:warn(logger.channels.network, "Client is still connected to %s:%s. Disconnecting!", self:getAddress(), self:getPort())
            self:disconnect()
        end

        if not ip then
            ip = tostring(ModSettingGet("noita-mp.connect_server_ip"))
        end

        if not port then
            port = tonumber(ModSettingGet("noita-mp.connect_server_port"))
        end

        port = tonumber(port)

        self.disconnect()
        _G.Client.disconnect() -- stop if any server is already running

        logger:info(logger.channels.network, "Connecting to server on %s:%s", ip, port)
        if not self.host then
            self:establishClient(ip, port)
        end

        GamePrintImportant("Client is connecting..",
            "You are trying to connect to " .. self:getAddress() .. ":" .. self:getPort() .. "!",
            ""
        )

        sockClientConnect(self, code)

        -- FYI: If you want to send data after connected, do it in the "connect" callback function
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientDisconnect = sockClient.disconnect
    function self.disconnect()
        if self.isConnected() then
            sockClientDisconnect()
        else
            logger:info(logger.channels.network, "Client isn't connected, no need to disconnenct!")
        end
    end

    --#endregion

    --#region Additional methods

    local sockClientIsConnected = sockClient.isConnected
    function self.isConnected()
        return sockClientIsConnected(self)
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientUpdate = sockClient.update
    --- Updates the Client by checking for network events and handling them.
    function self.update()
        if not self.isConnected() and not self:isConnecting() or self:isDisconnected() then
            return
        end

        updateVariables()

        EntityUtils.despawnClientEntities()
        EntityUtils.initNetworkVscs()

        sockClientUpdate(self)
    end

    function self.sendNeedNuid(ownerName, ownerGuid, entityId)
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end
        local x, y, rotation = EntityGetTransform(entityId)
        ---@diagnostic disable-next-line: missing-parameter
        local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
        local veloX, veloY = ComponentGetValue2(velocityCompId, "mVelocity")
        local velocity = { veloX, veloY }
        local filename = EntityGetFilename(entityId)
        self:send("needNuid", { { ownerName, ownerGuid }, entityId, x, y, rotation, velocity, filename })
    end

    --- Checks if the current local user is a client
    --- @return boolean iAm true if client
    function self.amIClient()
        if not _G.Server.amIServer() then
            return true
        end
        return false
    end

    --#endregion

    ------------------------------------
    -- Apply some private methods
    ------------------------------------
    setGuid()
    setConfigSettings()
    setCallbackAndSchemas()

    return self
end

------------------------------------
-- Init this object:
------------------------------------

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.ClientInit = Client
_G.Client = Client.new(sock.newClient())

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Client
