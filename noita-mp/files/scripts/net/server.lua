local sock = require("sock")

if not Server then
    local ip = ModSettingGet("noita-mp.server_ip")
    print("Server IP = " .. ip)
    local port = tonumber(ModSettingGet("noita-mp.server_port"))
    print("Server Port = " .. port)
    Server = sock.newServer(ip, port)
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.

--end

-- server.lua
--function love.load()
    --local port = 23476;
    -- Creating a server on any IP, port 22122
    --Server = sock.newServer("*", port)
    
    -- Called when someone connects to the server
    Server:on("connect", function(data, client)
        -- Send a message back to the connected client
        local msg = "Hello from the server!"
        client:send("hello", msg)
    end)

    GamePrintImportant( "Server started", "Your server is running on "
        .. Server:getAddress() .. ":" .. Server:getPort() .. ". Tell your friends to join!")
end

--print("Server update..")
Server:update()