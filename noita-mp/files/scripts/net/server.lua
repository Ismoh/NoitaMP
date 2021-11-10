

package.path = debug.getinfo(1,"S").source:match[[^@?(.*[\/])[^\/]-$]] .."?.lua;".. package.path

GamePrintImportant( "package path in server.lua", tostring(package.path) )

local sock = require("sock")

if not Server then Server = {} end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.

--end

-- server.lua
--function love.load()
    local port = 23476;
    -- Creating a server on any IP, port 22122
    Server = sock.newServer("*", port)
    
    -- Called when someone connects to the server
    Server:on("connect", function(data, client)
        -- Send a message back to the connected client
        local msg = "Hello from the server!"
        client:send("hello", msg)
    end)

    GamePrintImportant( "Starting server", "localhost:" .. tostring(port) )
end

Server:update()
