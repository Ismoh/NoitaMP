-- local fu = require("file_util")
-- local sock = require("sock")
-- local Guid = require("guid")
-- local util = require("util")
-- local em = require("entity_manager")

-- -- https://www.tutorialspoint.com/lua/lua_object_oriented.htm
-- -- Meta class
-- Server = {
--     super = nil,
--     address = nil,
--     port = nil,
--     SERVER = "SERVER"
-- }

-- Derived class method new
-- function Server:new(o, super, address, port)
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     self.super = super
--     self.address = tostring(address)
--     self.port = tonumber(port)
--     return o
-- end

-- function Server:setGuid()
--     local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))
--     if guid == "" or Guid.isPatternValid(guid) == false then
--         guid = Guid:getGuid()
--         ModSettingSetNextValue("noita-mp.guid", guid, false)
--         self.super.guid = guid
--         util.pprint("client_class.lua | guid set to " .. guid)
--     else
--         self.super.guid = guid
--         util.pprint("client_class.lua | guid was already set to " .. self.super.guid)
--     end
-- end

-- function Server:setSettings()
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
-- function Server:createCallbacks()
--     util.pprint("server_class.lua | Creating servers callback functions.")

--     -- Called when someone connects to the server
--     self.super:on(
--         "connect",
--         function(data, peer)
--             local local_player_id = em:getLocalPlayerId()
--             local x, y, rot, scale_x, scale_y = EntityGetTransform(local_player_id)

--             util.pprint("server_class.lua | on_connect: ")
--             util.pprint("server_class.lua | on_connect: data = " .. tostring(data))
--             util.pprint("server_class.lua | on_connect: client = " .. tostring(peer))
--             em:SpawnEntity(
--                 {
--                     peer.username,
--                     peer.guid
--                 },
--                 NuidUtils.getNextNuid(),
--                 x,
--                 y,
--                 rot,
--                 nil,
--                 "mods/noita-mp/data/enemies_gfx/client_player_base.xml",
--                 nil
--             )
--         end
--     )

--     self.super:on(
--         "clientInfo",
--         function(data, peer)
--             logger:debug("on_clientInfo: data =")
--             util.pprint(data)
--             logger:debug("on_clientInfo: peer =")
--             util.pprint(peer)

--             self:setClientInfo(data, peer)
--         end
--     )

--     self.super:on(
--         "worldFilesFinished",
--         function(data, peer)
--             logger:debug("on_worldFilesFinished: data =")
--             util.pprint(data)
--             logger:debug("on_worldFilesFinished: peer =")
--             util.pprint(peer)

--             -- Send restart command
--             peer:send("restart", {"Restart now!"})
--         end
--     )

--     -- Called when the client disconnects from the server
--     self.super:on(
--         "disconnect",
--         function(data)
--             logger:debug("on_disconnect: data =")
--             util.pprint(data)
--         end
--     )

--     -- see lua-enet/enet.c
--     self.super:on(
--         "receive",
--         function(data, channel, client)
--             logger:debug("on_receive: data =")
--             util.pprint(data)
--             logger:debug("on_receive: channel =")
--             util.pprint(channel)
--             logger:debug("on_receive: client =")
--             util.pprint(client)
--         end
--     )

--     self.super:on(
--         "needNuid",
--         function(data)
--             logger:debug("%s (%s) needs a new nuid.", data.owner.username, data.owner.guid)
--             util.pprint(data)

--             local new_nuid = NuidUtils.getNextNuid()

--             -- tell the clients that there is a new entity, they have to spawn, besides the client, who sent the request
--             self:sendNewNuid(
--                 data.owner,
--                 data.localEntityId,
--                 new_nuid,
--                 data.x,
--                 data.y,
--                 data.rot,
--                 data.velocity,
--                 data.filename
--             )

--             -- spawn the entity on server only
--             em:SpawnEntity(data.owner, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
--         end
--     )

--     self.super:on(
--         "newNuid",
--         function(data)
--             util.pprint(data)

--             if self.super.guid == data.owner.guid then
--                 logger:debug(
--                     "Got a new nuid, but the owner is me and therefore I don't care :). For data content see above!"
--                 )
--                 return -- skip if this entity is my own
--             end

--             logger:debug("Got a new nuid and spawning entity. For data content see above!")
--             em:SpawnEntity(data.owner, data.nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
--         end
--     )

--     self.super:on(
--         "entityAlive",
--         function(data)
--             util.pprint(data)

--             self.super:sendToAll2("entityAlive", data)
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
--             self.super:sendToAll2("entityState", data)
--         end
--     )
-- end

-- function Server:start()
--     util.pprint("server_class.lua | Starting server and fetching ip and port..")

--     local ip = tostring(ModSettingGet("noita-mp.server_ip"))
--     local port = tonumber(ModSettingGet("noita-mp.server_port"))
--     util.pprint("server_class.lua | Starting server on " .. ip .. ":" .. port)

--     self.super = sock.newServer(ip, port)
--     util.pprint("server_class.lua | Server started on " .. self.super:getAddress() .. ":" .. self.super:getPort())

--     self:setGuid()
--     self:setSettings()
--     self:createCallbacks()

--     GamePrintImportant(
--         "Server started",
--         "Your server is running on " ..
--             self.super:getAddress() .. ":" .. self.super:getPort() .. ". Tell your friends to join!"
--     )
-- end

-- function Server:stop()
--     -- _G.Server.super:destroy()
--     -- _G.Server.super = nil
--     -- _G.Server = Server:new()
--     self.super:destroy()
--     self.super = nil
--     -- _G.Server = Server:new()
-- end

-- function Server:setClientInfo(data, peer)
--     local username = data.username
--     local guid = data.guid

--     for _, client in pairs(self.super.clients) do
--         if client == peer then
--             self.super.clients[_].username = username
--             self.super.clients[_].guid = guid
--         end
--     end
-- end

function Server:checkIsAllowed(peer)
    local restoredClients = self:getStoredClients()
    if restoredClients then
        for _, client in pairs(restoredClients) do
            -- TODO add something like GUID to the client and mod settings to identify the user by its unique user id
            -- local peer_string_stored = tostring(client.connection)
            -- local index_of_collon_stored = string.find(peer_string_stored, ":")
            -- local ip_stored = string.sub(peer_string_stored, 0, index_of_collon_stored)
            -- local peer_string = tostring(peer.connection)
            -- local index_of_collon = string.find(peer_string, ":")
            -- local ip = string.sub(peer_string, 0, index_of_collon)
            -- if ip_stored == ip and client.username == peer.username then
            --     self.super.clients[_].isAllowed = true
            --     peer.isAllowed = true
            --     return true
            -- end

            if client.guid == peer.guid then
                self.super.clients[_].isAllowed = true
                peer.isAllowed = true
                return true
            end
        end
    end
    return false
end

function Server:setIsAllowed(client, isAllowed)
    for _, c in pairs(self.super.clients) do
        if c.guid == client.guid then
            self.super.clients[_].isAllowed = isAllowed
        end
    end
end

function Server:setMapReceived(peer, isMapReceived)
    for _, client in pairs(self.super.clients) do
        if client == peer then
            self.super.clients[_].isMapReceived = isMapReceived
        end
    end
end

function Server:storeClients()
    local t = {}
    for _, client in pairs(self.super:getClients()) do
        local serialiseable_client = {
            connection = tostring(client.connection),
            connectId = tostring(client.connectId),
            guid = tostring(client.guid),
            username = tostring(client.username),
            isAllowed = tostring(client.isAllowed),
            isMapReceived = tostring(client.isMapReceived)
        }
        table.insert(t, serialiseable_client)
    end
    local serialised = self.super:pack(t)
    fu.WriteFile(
        fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "_" .. _G.path_separator .. "clients",
        serialised
    )
end

function Server:getStoredClients()
    local full_path = fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "_" .. _G.path_separator .. "clients"
    if fu.Exists(full_path) then
        local serialised_content = fu.ReadFile(full_path)
        local stored_clients = self.super:unpack(serialised_content)
        return stored_clients
    end
    return nil
end

function Server:sendMap(client)
end

-- function Server:sendNewNuid(owner, local_entity_id, new_nuid, x, y, rot, velocity, filename)
--     self.super:sendToAll2(
--         "newNuid",
--         {
--         owner,
--         local_entity_id,
--         new_nuid,
--         x,
--         y,
--         rot,
--         velocity,
--         filename
--     }
--     )
-- end

-- function Server:update()
--     if not self.super then
--         return -- server not established
--     end

--     EntityUtils.initNetworkVscs()

--     -- em:AddNetworkComponents()

--     -- em:UpdateEntities()

--     self.super:update()
-- end

-- --- Checks if the current local user is the server
-- --- @return boolean iAm true if server
-- function Server:amIServer()
--     -- this can happen when you started and stop a server and then connected to a different server!
--     -- if _G.Server.super and _G.Client.super then
--     --     error("Something really strange is going on. You are server and client at the same time?", 2)
--     -- end

--     if _G.Server.super and _G.Server.super.guid == self.super.guid then
--         return true
--     end

--     return false
-- end

-- -- Create a new global object of the server
-- _G.Server = Server:new()
-- if ModSettingGet("noita-mp.server_start_when_world_loaded") then
--     _G.Server:start()
-- else
--     GamePrintImportant(
--         "Server not started",
--         "Your server wasn't started yet. Check ModSettings to change this or Press M to open multiplayer menu."
--     )
-- end
