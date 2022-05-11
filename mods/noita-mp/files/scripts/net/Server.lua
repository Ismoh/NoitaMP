-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local sock = require("sock")

--------------------
-- Server:
--------------------
Server = {}

-- Global private variables:

-- Global private methods

-- Access to global private variables

-- Global public variables:

-- Constructor
function Server.new(sockServer)
    local self = sockServer -- {}

    self.username = tostring(ModSettingGet("noita-mp.username"))

    -- Private variables:

    -- Public variables:

    -- Private methods:
    --#region Settings

    local function setSchemas()
        self:setSchema("worldFiles", { "relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles" })
        self:setSchema("worldFilesFinished", { "progress" })
        self:setSchema("seed", { "seed" })
        self:setSchema("clientInfo", { "username", "guid" })
        self:setSchema("needNuid", { "owner", "localEntityId", "x", "y", "rot", "velocity", "filename" })
        self:setSchema("newNuid", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "filename" })
        self:setSchema("entityAlive", { "owner", "localEntityId", "nuid", "isAlive" })
        self:setSchema("entityState", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "health" })
    end

    local function setGuid()
        local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))
        if guid == "" or Guid.isPatternValid(guid) == false then
            guid = Guid:getGuid()
            ModSettingSetNextValue("noita-mp.guid", guid, false)
            self.guid = guid
            util.pprint("client_class.lua | guid set to " .. guid)
        else
            self.guid = guid
            util.pprint("client_class.lua | guid was already set to " .. self.guid)
        end
    end

    --#endregion

    --#region Callbacks

    local function createCallbacks()
        util.pprint("server_class.lua | Creating servers callback functions.")

        -- Called when someone connects to the server
        self:on(
            "connect",
            function(data, peer)
            local local_player_id = em:getLocalPlayerId()
            local x, y, rot, scale_x, scale_y = EntityGetTransform(local_player_id)

            util.pprint("server_class.lua | on_connect: ")
            util.pprint("server_class.lua | on_connect: data = " .. tostring(data))
            util.pprint("server_class.lua | on_connect: client = " .. tostring(peer))
            em:SpawnEntity(
                {
                    peer.username,
                    peer.guid
                },
                NuidUtils.getNextNuid(),
                x,
                y,
                rot,
                nil,
                "mods/noita-mp/data/enemies_gfx/client_player_base.xml",
                nil
            )
        end
        )

        self:on(
            "clientInfo",
            function(data, peer)
            logger:debug("on_clientInfo: data =")
            util.pprint(data)
            logger:debug("on_clientInfo: peer =")
            util.pprint(peer)

            self:setClientInfo(data, peer)
        end
        )

        self:on(
            "worldFilesFinished",
            function(data, peer)
            logger:debug("on_worldFilesFinished: data =")
            util.pprint(data)
            logger:debug("on_worldFilesFinished: peer =")
            util.pprint(peer)

            -- Send restart command
            peer:send("restart", { "Restart now!" })
        end
        )

        -- Called when the client disconnects from the server
        self:on(
            "disconnect",
            function(data)
            logger:debug("on_disconnect: data =")
            util.pprint(data)
        end
        )

        -- see lua-enet/enet.c
        self:on(
            "receive",
            function(data, channel, client)
            logger:debug("on_receive: data =")
            util.pprint(data)
            logger:debug("on_receive: channel =")
            util.pprint(channel)
            logger:debug("on_receive: client =")
            util.pprint(client)
        end
        )

        self:on(
            "needNuid",
            function(data)
            logger:debug("%s (%s) needs a new nuid.", data.owner.username, data.owner.guid)
            util.pprint(data)

            local new_nuid = NuidUtils.getNextNuid()

            -- tell the clients that there is a new entity, they have to spawn, besides the client, who sent the request
            self:sendNewNuid(
                data.owner,
                data.localEntityId,
                new_nuid,
                data.x,
                data.y,
                data.rot,
                data.velocity,
                data.filename
            )

            -- spawn the entity on server only
            em:SpawnEntity(data.owner, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
        end
        )

        self:on(
            "newNuid",
            function(data)
            util.pprint(data)

            if self.guid == data.owner.guid then
                logger:debug(
                "Got a new nuid, but the owner is me and therefore I don't care :). For data content see above!"
                )
                return -- skip if this entity is my own
            end

            logger:debug("Got a new nuid and spawning entity. For data content see above!")
            em:SpawnEntity(data.owner, data.nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
        end
        )

        self:on(
            "entityAlive",
            function(data)
            util.pprint(data)

            self:sendToAll2("entityAlive", data)
            em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
        end
        )

        self:on(
            "entityState",
            function(data)
            util.pprint(data)

            local nc = em:GetNetworkComponent(data.owner, data.localEntityId, data.nuid)
            if nc then
                EntityApplyTransform(nc.local_entity_id, data.x, data.y, data.rot)
            else
                logger:warn(
                    "Got entityState, but unable to find the network component!" ..
                    " owner(%s, %s), localEntityId(%s), nuid(%s), x(%s), y(%s), rot(%s), velocity(x %s, y %s), health(%s)",
                    data.owner.username,
                    data.owner.guid,
                    data.localEntityId,
                    data.nuid,
                    data.x,
                    data.y,
                    data.rot,
                    data.velocity.x,
                    data.velocity.y,
                    data.health
                )
            end
            self:sendToAll2("entityState", data)
        end
        )
    end

    local function setClientInfo(data, peer)
        local username = data.username
        local guid = data.guid

        for i, client in pairs(self.clients) do
            if client == peer then
                self.clients[i].username = username
                self.clients[i].guid = guid
            end
        end
    end

    --#endregion

    -- Public methods:
    --#region Start and stop

    --- Starts a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number 1 - 65535 or nil
    function self.start(ip, port)
        if not ip then
            ip = tostring(ModSettingGet("noita-mp.server_ip"))
        end

        if not port then
            port = tonumber(ModSettingGet("noita-mp.server_port"))
        end

        logger:info("Starting server on %s:%s ..", ip, port)

        self = sock.newServer(ip, port)
        logger:info("Server started on %s:%s", self:getAddress(), self:getPort())

        setGuid()
        setSchemas()
        createCallbacks()

        GamePrintImportant("Server started",
            ("Your server is running on %s. Tell your friends to join!"):format(self:getAddress(), self:getPort()),
            nil)
    end

    --- Stops the server.
    function self.stop()
        self:destroy()
    end

    --#endregion

    --#region Additional methods

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockServerUpdate = self.update -- sockServer.update
    --- Updates the server by checking for network events and handling them.
    function self.update()
        if not self.host then
            return -- server not established
        end

        EntityUtils.initNetworkVscs()

        sockServerUpdate()
    end

    function self.sendNewNuid(owner, localEntityId, newNuid, x, y, rot, velocity, filename)
        self:sendToAll2("newNuid",
            {
            owner,
            localEntityId,
            newNuid,
            x,
            y,
            rot,
            velocity,
            filename
        })
    end

    --- Checks if the current local user is the server
    --- @return boolean iAm true if server
    function self.amIServer()
        -- this can happen when you started and stop a server and then connected to a different server!
        -- if _G.Server.super and _G.Client.super then
        --     error("Something really strange is going on. You are server and client at the same time?", 2)
        -- end

        if _G.Server.host and _G.Server.guid == self.guid then
            return true
        end

        return false
    end

    --#endregion

    -- Apply some private methods

    return self
end

-- Init this object:

local startOnLoad = ModSettingGet("noita-mp.server_start_when_world_loaded")

if startOnLoad then
    -- Polymorphism sample
    _G.Server = Server.new(sock.newServer())
    _G.Server.start(nil, nil)
else
    GamePrintImportant("Server not started",
        "Your server wasn't started yet. Check ModSettings to change this or Press M to open multiplayer menu.",
        nil
    )
end
