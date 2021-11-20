dofile("mods/noita-mp/files/scripts/util/file_util.lua")

local sock = require "sock"


-- https://www.tutorialspoint.com/lua/lua_object_oriented.htm
-- Meta class
Client = {
    super   = nil,
    address = nil,
    port    = nil
}


-- Derived class method new
function Client:new(o, super, address, port)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.super = super
    self.address = tostring(address)
    self.port = tonumber(port)
    return o
end


function Client:setSettings()
    self.super:setTimeout(320, 50000, 100000)
    self.super:setSchema("worldFiles", {"fileFullpath", "fileContent"})
    self.super:setSchema("seed", { "seed" })
    self.super:setSchema("playerState", { "index", "player"})
end


-- Derived class methods
function Client:createCallbacks()
    print("client_class.lua | Creating clients callback functions.")

    self.super:on("connect", function(data)
        print("client_class.lua | Client connected to the server.")
    end)

    self.super:on("worldFiles", function(data)
        local file_fullpath = data.fileFullpath
        local file_content = data.fileContent

        print("client_class.lua | Receiving world files from server: " .. file_fullpath)
        GamePrint("client_class.lua | Receiving world files from server: " .. file_fullpath)

        WriteSavegameWorldFile(file_fullpath, file_content)
    end)

    self.super:on("restart", function(data)
        BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
    end)

    self.super:on("seed", function(data)
        local server_seed = tonumber(data.seed)
        print("client_class.lua | Client got seed from the server. Seed = " .. server_seed)
        ModSettingSet("noita-mp.connect_server_seed", server_seed)
        --BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map_newgame_plus.lua", "data/biome/_pixel_scenes_newgame_plus.xml") -- StartReload(0)
    end)

    -- Called when the client disconnects from the server
    self.super:on("disconnect", function(data)
        print("client_class.lua | Client disconnected from the server.")
    end)

    -- see lua-enet/enet.c
    self.super:on("receive", function(data, channel)
        print("client_class.lua | Client received: data = " .. tostring(data) .. ", channel = " .. tostring(channel))
    end)

    -- Custom callback, called whenever you send the event from the server
    self.super:on("hello", function(msg)
        print("client_class.lua | The server replied: " .. msg)
    end)
end


function Client:connect()
    if not self.super then
        print("client_class.lua | Clients super wasn't set. Also refreshing ip and port.")
        local ip = tostring(ModSettingGet("noita-mp.connect_server_ip"))
        local port = tonumber(ModSettingGet("noita-mp.connect_server_port"))
        print("client_class.lua | Connecting to server on " .. ip .. ":" .. port)

        self.super = sock.newClient(ip, port)
    end

    self:setSettings()
    self:createCallbacks()

    GamePrintImportant( "Client is connecting..", "You are trying to connect to "
        .. self.super:getAddress() .. ":" .. self.super:getPort() .. "!")

    self.super:connect(0)

    --  You can send different types of data
    self.super:send("greeting", "Hello, my name is Inigo Montoya.")
    self.super:send("isShooting", true)
    self.super:send("bulletsLeft", 1)
    self.super:send("position", {
        x = 465.3,
        y = 50,
    })
end


function Client:update()
    if not self.super then
        return -- Client not established
    end

    self.super:update()
end


-- Create a new global object of the server
_G.Client = Client:new()