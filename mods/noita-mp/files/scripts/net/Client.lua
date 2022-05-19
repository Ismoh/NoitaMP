-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local sock = require("sock")

--------------------
-- Client:
--------------------
Client = {}

-- Global private variables:

-- Global private methods:

-- Access to global private variables

-- Global public variables:

-- Constructor
function Client.new(sockClient)
    local self = sockClient -- {}

    self.name = tostring(ModSettingGet("noita-mp.name"))

    -- Private variables:

    -- Public variables:

    -- Private methods:
    --#region Settings

    local function setConfigSettings()
        self:setTimeout(320, 50000, 100000)
    end

    local function setSchemas()
        self:setSchema("duplicatedGuid", { "newGuid" })
        self:setSchema("worldFiles", { "relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles" })
        self:setSchema("worldFilesFinished", { "progress" })
        self:setSchema("seed", { "seed" })
        self:setSchema("clientInfo", { "name", "guid" })
        self:setSchema("needNuid", { "owner", "localEntityId", "x", "y", "rot", "velocity", "filename" })
        self:setSchema("newNuid", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "filename" })
        self:setSchema("entityAlive", { "owner", "localEntityId", "nuid", "isAlive" })
        self:setSchema("entityState", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "health" })
    end

    local function setGuid(newGuid)
        local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))
        if guid == "" or Guid.isPatternValid(guid) == false and not newGuid then
            guid = Guid:getGuid(nil)
            ModSettingSetNextValue("noita-mp.guid", guid, false)
            self.guid = guid
            logger:debug(logger.channels.network, "Clients guid set to " .. guid)
        end

        if newGuid then
            self.guid = newGuid
            ModSettingSet("noita-mp.guid", newGuid)
            logger:debug(logger.channels.network, "Clients guid was already set, but updated to " .. self.guid)
        end
    end

    --#endregion

    --#region Callbacks

    local function createCallbacks()
        logger:debug(logger.channels.network, "Client creating clients callback functions.")

        self:on(
            "connect",
            function(data)
                logger:debug(logger.channels.network, "Client connected to the server. Sending client info to server..")
                util.pprint(data)

                local name = tostring(ModSettingGet("noita-mp.name"))
                self.name = name
                self:send("clientInfo", { name, self.guid })

                local playerEntityId = EntityUtils.getLocalPlayerEntityId()
                --for i = 1, #playerEntityIds do
                if not NetworkVscUtils.hasNetworkLuaComponents(playerEntityId) then
                    local localOwner = util.getLocalOwner()
                    self.sendNeedNuid(localOwner, playerEntityId)
                    NetworkVscUtils.addOrUpdateAllVscs(playerEntityId, localOwner.name, localOwner.guid, nil)
                end
                --end
            end
        )

        self:on("duplicatedGuid", function(data)
            logger:warn(logger.channels.network, "Duplicated guid!")
            setGuid(data.newGuid)
        end)

        self:on(
            "worldFiles",
            function(data)
                if not data or next(data) == nil then
                    GamePrint(
                        "Client receiving world files from server, but data is nil or empty. " .. tostring(data)
                    )
                    return
                end

                local rel_dir_path = data.relDirPath
                local file_name = data.fileName
                local file_content = data.fileContent
                local file_index = data.fileIndex
                local amount_of_files = data.amountOfFiles

                local msg =
                ("Client receiving world file: dir:%s, file:%s, content:%s, index:%s, amount:%s"):format(
                    rel_dir_path,
                    file_name,
                    file_content,
                    file_index,
                    amount_of_files
                )
                logger:debug(logger.channels.network, msg)
                GamePrint(msg)

                local save06_parent_directory_path = fu.GetAbsoluteDirectoryPathOfParentSave()

                -- if file_name ~= nil and file_name ~= ""
                -- then -- file in save06 | "" -> directory was sent
                --     WriteBinaryFile(save06_dir .. _G.path_separator .. file_name, file_content)
                -- elseif rel_dir_path ~= nil and file_name ~= ""
                -- then -- file in subdirectory was sent
                --     WriteBinaryFile(save06_dir .. _G.path_separator .. rel_dir_path .. _G.path_separator .. file_name, file_content)
                -- elseif rel_dir_path ~= nil and (file_name == nil or file_name == "")
                -- then -- directory name was sent
                --     MkDir(save06_dir .. _G.path_separator .. rel_dir_path)
                -- else
                --     GamePrint("Unable to write file, because path and content aren't set.")
                -- end
                local archive_directory = fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. rel_dir_path
                fu.WriteBinaryFile(archive_directory .. _G.path_separator .. file_name, file_content)

                if fu.Exists(fu.GetAbsoluteDirectoryPathOfSave06()) then -- Create backup if save06 exists
                    os.execute('cd "' .. fu.GetAbsoluteDirectoryPathOfParentSave() .. '" && move save06 save06_backup')
                end

                fu.Extract7zipArchive(archive_directory, file_name, save06_parent_directory_path)

                if file_index >= amount_of_files then
                    self:send("worldFilesFinished", { "" .. file_index .. "/" .. amount_of_files })
                end
            end
        )

        self:on(
            "seed",
            function(data)
                local server_seed = tonumber(data.seed)
                logger:debug(logger.channels.network, "Client got seed from the server. Seed = " .. server_seed)
                util.pprint(data)
                --ModSettingSet("noita-mp.connect_server_seed", server_seed)

                logger:debug(logger.channels.network,
                    "Client creating magic numbers file to set clients world seed and restart the game."
                )
                fu.WriteFile(
                    fu.GetAbsoluteDirectoryPathOfMods() .. "/files/tmp/magic_numbers/world_seed.xml",
                    [[<MagicNumbers WORLD_SEED="]] .. tostring(server_seed) .. [["/>]]
                )
                --ModTextFileSetContent( GetRelativeDirectoryPathOfMods()
                --    .. "/files/data/magic_numbers.xml", )

                --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
            end
        )

        self:on(
            "restart",
            function(data)
                fu.StopWithoutSaveAndStartNoita()
                --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
            end
        )

        -- Called when the client disconnects from the server
        self:on(
            "disconnect",
            function(data)
                logger:debug(logger.channels.network, "Client disconnected from the server.")
                util.pprint(data)
            end
        )

        -- see lua-enet/enet.c
        self:on(
            "receive",
            function(data, channel)
                logger:debug(logger.channels.network, "on_receive: data =")
                util.pprint(data)
                logger:debug(logger.channels.network, "on_receive: channel =")
                util.pprint(channel)
            end
        )

        self:on(
            "newNuid",
            function(data)
                logger:debug(logger.channels.network,
                    "%s (%s) needs a new NUID. nuid=%s, x=%s, y=%s, rot=%s, velocity=%s, filename=%s, localEntityId=%s",
                    data.owner.name,
                    data.owner.guid,
                    data.nuid,
                    data.x,
                    data.y,
                    data.rot,
                    data.velocity,
                    data.filename,
                    data.localEntityId
                )
                util.pprint(data)
                EntityUtils.SpawnEntity(data.owner, data.nuid, data.x, data.y, data.rot, data.velocity, data.filename, data.localEntityId)
            end
        )

        self:on(
            "entityAlive",
            function(data)
                util.pprint(data)

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
                    logger:warn(logger.channels.network,
                        "Got entityState, but unable to find the network component!" ..
                        " owner(%s, %s), localEntityId(%s), nuid(%s), x(%s), y(%s), rot(%s), velocity(x %s, y %s), health(%s)",
                        data.owner.name,
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
            end
        )
    end

    --#endregion

    -- Public methods:
    --#region Connect and disconnect

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientConnect = sockClient.connect
    --- Connects to a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number 1 - 65535 or nil
    function self.connect(ip, port)

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
        --self = _G.ClientInit.new(sock.newClient(ip, port))
        --_G.Client = self

        setGuid()
        setConfigSettings()
        setSchemas()
        createCallbacks()

        GamePrintImportant("Client is connecting..",
            "You are trying to connect to " .. self:getAddress() .. ":" .. self:getPort() .. "!",
            ""
        )

        sockClientConnect(self)

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

        EntityUtils.despawnClientEntities()

        sockClientUpdate(self)
    end

    function self.sendNeedNuid(owner, entityId)
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end
        local x, y, rot = EntityGetTransform(entityId)
        ---@diagnostic disable-next-line: missing-parameter
        local velocityCompId = EntityGetFirstComponent(entityId, "VelocityComponent")
        local veloX, veloY = ComponentGetValue2(velocityCompId, "mVelocity")
        local velocity = { veloX, veloY }
        local filename = EntityGetFilename(entityId)
        self:send("needNuid", { owner, entityId, x, y, rot, velocity, filename })
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

    -- Apply some private methods

    return self
end

-- Init this object:

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.ClientInit = Client
_G.Client = Client.new(sock.newClient(), true)

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Client
