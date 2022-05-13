local fu = require("file_util")
local sock = require("sock")
local Guid = require("guid")
local em = require("entity_manager")
local util = require("util")

-- https://www.tutorialspoint.com/lua/lua_object_oriented.htm
-- Meta class
Client = {
    super = nil,
    address = nil,
    port = nil,
    CLIENT = "CLIENT"
}

-- Derived class method new
-- function Client:new(o, super, address, port)
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     self.super = super
--     self.address = tostring(address)
--     self.port = tonumber(port)
--     return o
-- end

-- function Client:setGuid()
--     local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))
--     if guid == "" or Guid.isPatternValid(guid) == false then
--         guid = Guid:getGuid()
--         ModSettingSetNextValue("noita-mp.guid", guid, false)
--         self.super.guid = guid
--         logger:debug("client_class.lua | guid set to " .. guid)
--     else
--         self.super.guid = guid
--         logger:debug("client_class.lua | guid was already set to " .. self.super.guid)
--     end
-- end

-- function Client:setSettings()
--     self.super:setTimeout(320, 50000, 100000)
--     self.super:setSchema("worldFiles", {"relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles"})
--     self.super:setSchema("worldFilesFinished", {"progress"})
--     self.super:setSchema("seed", {"seed"})
--     self.super:setSchema("clientInfo", {"username", "guid"})
--     self.super:setSchema("needNuid", {"owner", "localEntityId", "x", "y", "rot", "velocity", "filename"})
--     self.super:setSchema("newNuid", {"owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "filename"})
--     self.super:setSchema("entityAlive", {"owner", "localEntityId", "nuid", "isAlive"})
--     self.super:setSchema("entityState", {"owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "health"})
-- end

-- -- Derived class methods
-- function Client:createCallbacks()
--     logger:debug("client_class.lua | Creating clients callback functions.")

--     self.super:on(
--         "connect",
--         function(data)
--             logger:debug("client_class.lua | Client connected to the server. Sending client info to server..")
--             util.pprint(data)

--             local connection_id = tostring(self.super:getConnectId())
--             local ip = tostring(self.super:getAddress())
--             local username = tostring(ModSettingGet("noita-mp.username"))
--             self.super.username = username
--             self.super:send("clientInfo", {username, self.super.guid})
--         end
--     )

--     self.super:on(
--         "worldFiles",
--         function(data)
--             if not data or next(data) == nil then
--                 GamePrint(
--                     "client_class.lua | Receiving world files from server, but data is nil or empty. " .. tostring(data)
--                 )
--                 return
--             end

--             local rel_dir_path = data.relDirPath
--             local file_name = data.fileName
--             local file_content = data.fileContent
--             local file_index = data.fileIndex
--             local amount_of_files = data.amountOfFiles

--             local msg =
--                 ("client_class.lua | Receiving world file: dir:%s, file:%s, content:%s, index:%s, amount:%s"):format(
--                 rel_dir_path,
--                 file_name,
--                 file_content,
--                 file_index,
--                 amount_of_files
--             )
--             logger:debug(msg)
--             GamePrint(msg)

--             local save06_parent_directory_path = fu.GetAbsoluteDirectoryPathOfParentSave()

--             -- if file_name ~= nil and file_name ~= ""
--             -- then -- file in save06 | "" -> directory was sent
--             --     WriteBinaryFile(save06_dir .. _G.path_separator .. file_name, file_content)
--             -- elseif rel_dir_path ~= nil and file_name ~= ""
--             -- then -- file in subdirectory was sent
--             --     WriteBinaryFile(save06_dir .. _G.path_separator .. rel_dir_path .. _G.path_separator .. file_name, file_content)
--             -- elseif rel_dir_path ~= nil and (file_name == nil or file_name == "")
--             -- then -- directory name was sent
--             --     MkDir(save06_dir .. _G.path_separator .. rel_dir_path)
--             -- else
--             --     GamePrint("client_class.lua | Unable to write file, because path and content aren't set.")
--             -- end
--             local archive_directory = fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. rel_dir_path
--             fu.WriteBinaryFile(archive_directory .. _G.path_separator .. file_name, file_content)

--             if fu.Exists(fu.GetAbsoluteDirectoryPathOfSave06()) then -- Create backup if save06 exists
--                 os.execute('cd "' .. fu.GetAbsoluteDirectoryPathOfParentSave() .. '" && move save06 save06_backup')
--             end

--             fu.Extract7zipArchive(archive_directory, file_name, save06_parent_directory_path)

--             if file_index >= amount_of_files then
--                 self.super:send("worldFilesFinished", {"" .. file_index .. "/" .. amount_of_files})
--             end
--         end
--     )

--     self.super:on(
--         "seed",
--         function(data)
--             local server_seed = tonumber(data.seed)
--             logger:debug("client_class.lua | Client got seed from the server. Seed = " .. server_seed)
--             util.pprint(data)
--             --ModSettingSet("noita-mp.connect_server_seed", server_seed)

--             logger:debug(
--                 "client_class.lua | Creating magic numbers file to set clients world seed and restart the game."
--             )
--             fu.WriteFile(
--                 fu.GetAbsoluteDirectoryPathOfMods() .. "/files/tmp/magic_numbers/world_seed.xml",
--                 [[<MagicNumbers WORLD_SEED="]] .. tostring(server_seed) .. [["/>]]
--             )
--             --ModTextFileSetContent( GetRelativeDirectoryPathOfMods()
--             --    .. "/files/data/magic_numbers.xml", )

--             --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
--         end
--     )

--     self.super:on(
--         "restart",
--         function(data)
--             fu.StopWithoutSaveAndStartNoita()
--             --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
--         end
--     )

--     -- Called when the client disconnects from the server
--     self.super:on(
--         "disconnect",
--         function(data)
--             logger:debug("client_class.lua | Client disconnected from the server.")
--             util.pprint(data)
--         end
--     )

--     -- see lua-enet/enet.c
--     self.super:on(
--         "receive",
--         function(data, channel)
--             logger:debug("on_receive: data =")
--             util.pprint(data)
--             logger:debug("on_receive: channel =")
--             util.pprint(channel)
--         end
--     )

--     self.super:on(
--         "newNuid",
--         function(data)
--             logger:debug(
--                 "%s (%s) needs a new NUID. nuid=%s, x=%s, y=%s, rot=%s, velocity=%s, filename=%s, localEntityId=%s",
--                 data.owner.username,
--                 data.owner.guid,
--                 data.nuid,
--                 data.x,
--                 data.y,
--                 data.rot,
--                 data.velocity,
--                 data.filename,
--                 data.localEntityId
--             )
--             util.pprint(data)
--             em:SpawnEntity(
--                 data.owner,
--                 data.nuid,
--                 data.x,
--                 data.y,
--                 data.rot,
--                 data.velocity,
--                 data.filename,
--                 data.localEntityId
--             )
--         end
--     )

--     self.super:on(
--         "entityAlive",
--         function(data)
--             util.pprint(data)

--             em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
--         end
--     )

--     self.super:on(
--         "entityState",
--         function(data)
--             util.pprint(data)

--             local nc = em:GetNetworkComponent(data.owner, data.localEntityId, data.nuid)
--             if nc then
--                 EntityApplyTransform(nc.local_entity_id, data.x, data.y, data.rot)
--             else
--                 logger:warn(
--                     "Got entityState, but unable to find the network component!" ..
--                         " owner(%s, %s), localEntityId(%s), nuid(%s), x(%s), y(%s), rot(%s), velocity(x %s, y %s), health(%s)",
--                     data.owner.username,
--                     data.owner.guid,
--                     data.localEntityId,
--                     data.nuid,
--                     data.x,
--                     data.y,
--                     data.rot,
--                     data.velocity.x,
--                     data.velocity.y,
--                     data.health
--                 )
--             end
--         end
--     )
-- end

-- function Client:connect()
--     if not self.super then
--         logger:debug("client_class.lua | Clients super wasn't set. Also refreshing ip and port.")
--         local ip = tostring(ModSettingGet("noita-mp.connect_server_ip"))
--         local port = tonumber(ModSettingGet("noita-mp.connect_server_port"))
--         logger:debug("client_class.lua | Connecting to server on " .. ip .. ":" .. port)

--         self.super = sock.newClient(ip, port)
--     end

--     self:setGuid()
--     self:setSettings()
--     self:createCallbacks()

--     GamePrintImportant(
--         "Client is connecting..",
--         "You are trying to connect to " .. self.super:getAddress() .. ":" .. self.super:getPort() .. "!"
--     )

--     self.super:connect(0)

--     --  You can send different types of data
--     self.super:send("greeting", "Hello, my name is Inigo Montoya.")
--     self.super:send("isShooting", true)
--     self.super:send("bulletsLeft", 1)
--     self.super:send(
--         "position",
--         {
--             x = 465.3,
--             y = 50
--         }
--     )
-- end

-- function Client:disconnect()
--     self.super:disconnect()
-- end

-- function Client:update()
--     if not self.super then
--         return -- Client not established
--     end

--     -- em:DespawnClientEntities(self.super)

--     -- em:AddNetworkComponents()

--     -- em:UpdateEntities()

--     EntityUtils.despawnClientEntities()

--     self.super:update()
-- end

-- function Client:sendNeedNuid(owner, entity_id)
--     if not EntityUtils.isEntityAlive(entity_id) then
--         return
--     end
--     local x, y, rot = EntityGetTransform(entity_id)
--     local velo_comp_id = EntityGetFirstComponent(entity_id, "VelocityComponent")
--     local velo_x, velo_y = ComponentGetValue2(velo_comp_id, "mVelocity")
--     local velocity = {velo_x, velo_y}
--     local filename = EntityGetFilename(entity_id)
--     self.super:send("needNuid", {owner, entity_id, x, y, rot, velocity, filename})
-- end

-- --- Checks if the current local user is a client
-- --- @return boolean iAm true if client
-- function Client:amIClient()
--     if self.super ~= nil then
--        return self.super.whoAmI == "CLIENT"
--     end
--     return false
-- end

-- Create a new global object of the server
--_G.Client = Client:new()
