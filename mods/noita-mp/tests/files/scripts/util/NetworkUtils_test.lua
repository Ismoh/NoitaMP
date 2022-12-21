local lu           = require("luaunit")
local NetworkUtils = require("NetworkUtils")
local sock         = require("sock")

TestNetworkUtils   = {}

function TestNetworkUtils:setUp()

end

function TestNetworkUtils:tearDown()

end

function TestNetworkUtils:testAlreadySent()
    local event  = NetworkUtils.events.newNuid.name
    local data   = {
        networkMessageId = 367,
        owner            = { "ownerName", "ownerGuid" },
        localEntityId    = 4673,
        newNuid          = 4,
        x                = 0.25,
        y                = 3.55,
        rotation         = 49,
        velocity         = { x = 0, y = 3 },
        filename         = "/mods/",
        health           = { current = 123, max = 125 },
        isPolymorphed    = false
    }

    local server = sock.newServer("*", 22122)
    local client = sock.newClient("*", 22122)

    client.connect("*", 22122)

    local result = NetworkUtils.alreadySent(client, event, data)
    lu.assertIsFalse(result)

    server.send(client, event, data)

    local result = NetworkUtils.alreadySent(client, event, data)
    lu.assertIsTrue(result)
end

lu.LuaUnit.run()