local fu = require("file_util")
local sock = require("sock")
local Guid = require("guid")

-- https://www.tutorialspoint.com/lua/lua_object_oriented.htm
-- Meta class
Server = {
    super = nil,
    address = nil,
    port = nil
}

-- Derived class method new
function Server:new(o, super, address, port)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.super = super
    self.address = tostring(address)
    self.port = tonumber(port)
    return o
end

function Server:setGuid()
    local guid = tostring(ModSettingGetNextValue("noita-mp.guid"))
    if guid == "" or Guid.isPatternValid(guid) == false then
        guid = Guid:getGuid()
        ModSettingSetNextValue("noita-mp.guid", guid, false)
        self.super.guid = guid
        print("client_class.lua | guid set to " .. guid)
    else
        self.super.guid = guid
        print("client_class.lua | guid was already set to " .. self.super.guid)
    end
end

function Server:setSettings()
    self.super:setSchema("worldFiles", {"relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles"})
    self.super:setSchema("worldFilesFinished", {"progress"})
    self.super:setSchema("seed", {"seed"})
    self.super:setSchema("clientInfo", {"username", "guid"})
    self.super:setSchema("playerState", {"index", "player"})
end

-- Derived class methods
function Server:createCallbacks()
    print("server_class.lua | Creating servers callback functions.")

    -- Called when someone connects to the server
    self.super:on(
        "connect",
        function(data, peer)
            print("server_class.lua | on_connect: ")
            print("server_class.lua | on_connect: data = " .. tostring(data))
            print("server_class.lua | on_connect: client = " .. tostring(peer))
        end
    )

    self.super:on(
        "clientInfo",
        function(data, peer)
            print("server_class.lua | on_clientInfo: ")
            print("server_class.lua | on_clientInfo: data = " .. tostring(data))
            print("server_class.lua | on_clientInfo: client = " .. tostring(peer))
            self:setClientInfo(data, peer)
        end
    )

    self.super:on(
        "worldFilesFinished",
        function(data, peer)
            print("server_class.lua | on_worldFilesFinished: ")
            print("server_class.lua | on_worldFilesFinished: data = " .. tostring(data))
            print("server_class.lua | on_worldFilesFinished: client = " .. tostring(peer))

            -- Send restart command
            peer:send("restart", {"Restart now!"})
        end
    )

    -- Called when the client disconnects from the server
    self.super:on(
        "disconnect",
        function(data)
            print("server_class.lua | Server disconnected. data = " .. tostring(data))
        end
    )

    -- see lua-enet/enet.c
    self.super:on(
        "receive",
        function(data, channel, client)
            print(
                "server_class.lua | Server received: data = " ..
                    tostring(data) .. ", channel = " .. tostring(channel) .. ", client = " .. tostring(client)
            )
        end
    )
end

function Server:create()
    print("server_class.lua | Starting server and fetching ip and port..")

    local ip = tostring(ModSettingGet("noita-mp.server_ip"))
    local port = tonumber(ModSettingGet("noita-mp.server_port"))
    print("server_class.lua | Starting server on " .. ip .. ":" .. port)

    self.super = sock.newServer(ip, port)
    print("server_class.lua | Server started on " .. self.super:getAddress() .. ":" .. self.super:getPort())

    self:setGuid()
    self:setSettings()
    self:createCallbacks()

    GamePrintImportant(
        "Server started",
        "Your server is running on " ..
            self.super:getAddress() .. ":" .. self.super:getPort() .. ". Tell your friends to join!"
    )
end

function Server:setClientInfo(data, peer)
    local username = data.username
    local guid = data.guid

    for _, client in pairs(self.super.clients) do
        if client == peer then
            self.super.clients[_].username = username
            self.super.clients[_].guid = guid
        end
    end
end

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
        if c.connection == client.connection and c.connectId == client.connectId then
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
        --local clientString = { client.username, client.isAllowed, client.isMapReceived }
        --local serialised = self.super:pack(clientString)
        --WriteFile(GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "_" .. _G.path_separator .. "clients", serialised)
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

function Server:destroy()
    _G.Server.super:destroy()
    _G.Server = Server:new()
end

function Server:update()
    if not self.super then
        return -- server not established
    end

    self.super:update()
end

-- Create a new global object of the server
_G.Server = Server:new()
if ModSettingGet("noita-mp.server_start_when_world_loaded") then
    _G.Server:create()
else
    GamePrintImportant(
        "Server not started",
        "Your server wasn't started yet. Check ModSettings to change this or Press M to open multiplayer menu."
    )
end
