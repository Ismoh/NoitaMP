local sock = require("..\\..\\..\\libs\\sock")

if not Client then Client = {} end

function OnWorldInitialized()

--end
-- client.lua
--function love.load()
    -- Creating a new client on localhost:22122
    Client = sock.newClient("localhost", 23476)
    
    -- Creating a client to connect to some ip address
    Client = sock.newClient("198.51.100.0", 23476)

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

    Client:connect()
    
    --  You can send different types of data
    Client:send("greeting", "Hello, my name is Inigo Montoya.")
    Client:send("isShooting", true)
    Client:send("bulletsLeft", 1)
    Client:send("position", {
        x = 465.3,
        y = 50,
    })
end


Client:update()
