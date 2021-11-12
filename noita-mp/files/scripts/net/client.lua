local sock = require("sock")

local Client = nil

if Client == nil then
    local ip = ModSettingGet("noita-mp.connect_server_ip")
    print("Client IP = " .. ip)
    local port = tonumber(ModSettingGet("noita-mp.connect_server_port"))
    print("Client Port = " .. port)
    Client = sock.newClient(ip, port)
end


function OnWorldInitialized()

    -- Called when a connection is made to the server
    Client:on("connect", function(data)
        GamePrintImportant( "Client connected to the server.")
    end)

    -- Called when the client disconnects from the server
    Client:on("disconnect", function(data)
        GamePrintImportant( "Client disconnected from the server.")
    end)

    -- Custom callback, called whenever you send the event from the server
    Client:on("hello", function(msg)
        GamePrintImportant( "The server replied: " .. msg)
    end)
end


Client.connectClient = function()
    Client:connect()
end


Client.updateClient = function()
    --print("Client update..")
    if Client:isConnected() or Client:isDisconnecting() then

        Client:update()
        --  You can send different types of data
        Client:send("greeting", "Hello, my name is Inigo Montoya.")
        Client:send("isShooting", true)
        Client:send("bulletsLeft", 1)
        Client:send("position", {
            x = 465.3,
            y = 50,
        })
    end
end


return Client
