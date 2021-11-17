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


-- Derived class methods
function Client:createCallbacks()
    print("client_class.lua | Creating clients callback functions.")

    self.super:on("connect", function(data)
        print("client_class.lua | Client connected to the server.")
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