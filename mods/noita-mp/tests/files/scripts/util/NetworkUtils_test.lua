TestNetworkUtils                  = {}

local gui                         = {} -- Mocked gui
local utils                       = require("Utils")
    :new()
local noitaMpSettings             = require("NoitaMpSettings")
    :new(nil, nil, gui, nil, nil, nil, nil, utils, nil)
local customProfiler              = noitaMpSettings.customProfiler
local logger                      = noitaMpSettings.logger
local fileUtils                   = noitaMpSettings.fileUtils
local guidUtils                   = require("GuidUtils")
    :new(nil, customProfiler, fileUtils, logger, nil, nil, utils, nil)
local networkCache                = require("NetworkCache")
    :new(customProfiler, logger, utils)
local md5                         = require("md5")
local networkCacheUtils           = require("NetworkCacheUtils")
    :new(customProfiler, guidUtils, logger, md5, networkCache, nil, utils)
local networkUtils                = networkCacheUtils.networkUtils
local np                          = {} -- Mocked NoitaPatcher
local server                      = require("Server")
    .new(nil, nil, nil, nil, nil, nil, np, nil)
local client                      = require("Client")
    .new(nil, nil, nil, server, np, server.nativeEntityMap)
local noitaComponentUtils         = {} -- Mocked NoitaComponentUtils
noitaComponentUtils.getEntityData = function(entityId, ownerName, ownerGuid)
    local compOwnerName = ownerName
    local compOwnerGuid = ownerGuid
    local compNuid      = 484
    local filename      = "data/entities/player.xml"
    local health        = { current = 100, max = 100 }
    local rotation      = 139
    local velocity      = { x = 0, y = 0 }
    local x             = 0
    local y             = 0
    return compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y
end
local entityUtils                 = {} -- Mocked EntityUtils
entityUtils.isEntityAlive         = function(entityId)
    return true
end
entityUtils.isEntityPolymorphed   = function(entityId)
    return false
end
entityUtils.destroyByNuid         = function(peer, deadNuid)
    logger:trace(logger.channels.testing,
        ("Mocked 'EntityUtils.destroyByNuid' on '%s' destroyed a dead nuid '%s'!")
        :format(utils:pformat(peer), deadNuid))
end
-- entityCache.deleteNuid       = function(deadNuid)
--     logger:trace(logger.channels.testing,
--         ("Mocked 'EntityCache.deleteNuid' deleted a dead nuid '%s'!"):format(deadNuid))
-- end

--- Setup function for each test.
function TestNetworkUtils:setUp()
    -- Make absolutely sure, that the already mocked Noita API function is not overwritten
    local mockedModSettingGet        = ModSettingGet
    ModSettingGet                    = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return { "trace, debug, info, warn", "TRACE" }
        end
        if id == "noita-mp.name" then
            logger:warn(logger.channels.testing, ("RESET this value manually in your current test: %s"):format(id))
            return "RESET THIS!!"
        end
        if id == "noita-mp.guid" then
            logger:warn(logger.channels.testing, ("RESET this value manually in your current test: %s"):format(id))
            return "RESET THIS"
        end
        if id == "noita-mp.tick_rate" then
            return 1
        end
        if id == "noita-mp.connect_server_ip" then
            return "localhost"
        end
        if id == "noita-mp.connect_server_port" then
            return 1337
        end

        mockedModSettingGet(id)
    end
    ModSettingGetNextValue           = function()
        -- return false to disable CustomProfiler
        return false
    end
    ModSettingSetNextValue           = function(id, value, is_default)
        print("ModSettingSetNextValue: " .. id .. " = " .. tostring(value) .. " (is_default: " .. tostring(is_default) .. ")")
    end
    GamePrintImportant               = function(title, description, ui_custom_decoration_file)
        print("GamePrintImportant: " ..
            title .. " - " .. description .. " - " .. " (ui_custom_decoration_file: " .. tostring(ui_custom_decoration_file) .. ")")
    end
    GameGetRealWorldTimeSinceStarted = function()
        return os.clock()
    end
    ModGetActiveModIDs               = function()
        return { "noita-mp" }
    end
end

--- Teardown function for each test.
function TestNetworkUtils:tearDown()
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestNetworkUtils:testSerialize()
    print("JSFGLKNDKFJNGKJNDFGKJ")
    local data = {
        "serilaze",
        123,
        { x = 1,         y = 2 },
        { current = 100, max = 100 },
        "\000asdf\000", -- binary string
        "qwerty"
    }

    local serializedData = networkUtils:serialize(data)
    local desializedData = networkUtils:deserialize(serializedData)

    lu.assertEquals(#data, #desializedData, "Serialized and deserialized data isn't equal!")
    lu.assertEquals(data, desializedData, "Serialized and deserialized data isn't equal!")
end

function TestNetworkUtils:testAlreadySent()
    print("jksndkfjnskdjnfskjd")
    local event = networkUtils.events.connect2.name
    local data = { networkUtils:getNextNetworkMessageId(), "TestNetworkUtils Player Name", "anyGuid" }

    lu.assertErrorMsgContains("'peer' must not be nil!",
        networkUtils.alreadySent, networkUtils, nil, event, data)
    lu.assertErrorMsgContains("'event' must not be nil!",
        networkUtils.alreadySent, networkUtils, client, nil, data)
    lu.assertErrorMsgContains("Did you add this event in NetworkUtils.events?",
        networkUtils.alreadySent, networkUtils, client, "ASDF", data)
    lu.assertErrorMsgContains("'data' must not be nil!",
        networkUtils.alreadySent, networkUtils, client, "needNuid", nil)
end

function TestNetworkUtils:testAlreadySentConnect2()
    -- [[ Prepare mocked data for sending Connect2! ]] --
    local networkMessageId                     = networkUtils:getNextNetworkMessageId()
    local name                                 = "clientOwnerName"
    local guid                                 = guidUtils:generateNewGuid()

    local data                                 = {
        networkMessageId,
        name,
        guid
    }

    local event                                = networkUtils.events.connect2.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                     = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                               = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    Server.name                                = "ServerOwnerName"
    Server.guid                                = guidUtils:generateNewGuid({ guid })
    local Client                               = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection            = {}
    getmetatable(Client).connection.timeout    = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send       = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end
    getmetatable(Client).connection.state      = function()
        logger:trace(logger.channels.testing, "Mocked 'self.connection:state()' executed!")
        return "connected"
    end
    getmetatable(Client).connection.disconnect = function(code)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(code %s)' executed!")
            :format(utils:pformat(code)))
    end

    Client.name                                = name
    Client.guid                                = guid

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    Server.clients[1] = Client
    local sent = Server:sendToAll(networkUtils.events.connect2.name,
        { networkUtils:getNextNetworkMessageId(), Client.name, Client.guid })
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Server.clients[1].guid, event, data)
    lu.assertNotIsNil(cachedData,
        ("NetworkCache didn't cache the network message. Something bad is broken! cachedData = %s"):format(cachedData))
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentDisconnect2()
    -- [[ Prepare mocked data for sending Disconnect2! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local name                              = "clientOwnerName"
    local guid                              = guidUtils:generateNewGuid()

    local data                              = {
        networkMessageId,
        name,
        guid
    }

    local event                             = networkUtils.events.disconnect2.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    Server.name                             = "ServerOwnerName"
    Server.guid                             = guidUtils:generateNewGuid({ guid })
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = name
    Client.guid                             = guid

    Server:stop()
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    Server.clients[1] = Client
    local sent        = Server:sendToAll(event, data)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Server.clients[1].guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentAcknowledgement()
    lu.assertIsFalse(networkUtils.events.acknowledgement.isCacheable,
        "Acknowledgement network messages won't be cached or resend!")
end

function TestNetworkUtils:testAlreadySentSeed()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local seed                              = "4294967295"

    local data                              = {
        networkMessageId,
        seed
    }

    local event                             = networkUtils.events.seed.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    Server.name                             = "ServerOwnerName"
    Server.guid                             = guidUtils:generateNewGuid({ guid })
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = name
    Client.guid                             = guid

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    Server.clients[1] = Client
    local sent        = Server:send(Server.clients[1], event, data)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Server.clients[1].guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentMinaInformation()
    -- [[ Prepare mocked data for sending MinaInformation! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local name                              = "clientOwnerName"
    local guid                              = guidUtils:generateNewGuid()
    local version                           = fileUtils:GetVersionByFile()
    local entityId                          = 8487
    local nuid                              = nil
    local transform                         = { x = 1, y = 2 }
    local health                            = { current = 100, max = 100 }

    local data                              = {
        networkMessageId,
        version,
        name,
        guid,
        entityId,
        nuid,
        transform,
        health
    }

    local event                             = networkUtils.events.minaInformation.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    Server.name                             = "ServerOwnerName"
    Server.guid                             = guidUtils:generateNewGuid({ guid })
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = name
    Client.guid                             = guid

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    Server.clients[1] = Client
    local sent        = Server:send(Server.clients[1], event, data)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Server.clients[1].guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentNewGuid()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local oldGuid                           = guidUtils:generateNewGuid()
    local newGuid                           = guidUtils:generateNewGuid({ oldGuid })

    local data                              = {
        networkMessageId,
        oldGuid,
        newGuid
    }

    local event                             = networkUtils.events.newGuid.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    Server.name                             = "ServerOwnerName"
    Server.guid                             = guidUtils:generateNewGuid({ guid })
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = name
    Client.guid                             = guid

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    Server.clients[1] = Client
    local sent        = Server:sendNewGuid(Server.clients[1], oldGuid, newGuid)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Server.clients[1].guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end

-- function TestNetworkUtils:testAlreadySentNewNuid()
--     -- [[ Prepare mocked data for sending a new nuid! ]] --
--     local networkMessageId = networkUtils:getNextNetworkMessageId()
--     local owner            = { name = "ServerOwnerName", guid = guidUtils:generateNewGuid() }
--     local localEntityId    = 3456
--     local newNuid          = 34
--     local x                = 6
--     local y                = 7
--     local rotation         = 5.67
--     local velocity         = { x = 2, y = 5 }
--     local filename         = "player.xml"
--     local health           = { current = 490, max = 1000 }
--     local isPolymorphed    = false

--     local data             = {
--         networkMessageId,
--         owner,
--         localEntityId,
--         newNuid,
--         x,
--         y,
--         rotation,
--         velocity,
--         filename,
--         health,
--         isPolymorphed
--     }

--     local event            = networkUtils.events.newNuid.name

--     -- [[ Expected checksum in NetworkCache ]] --
--     local md5              = require("md5")
--     local expectedChecksum = md5.sumhexa(networkCacheUtils.getSum(event, data))

--     -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
--     local sock             = require("sock")
--     local Server           = ServerInit.new(sock.newServer("*", 1337))
--     Server.name            = owner.name
--     Server.guid            = owner.guid
--     local client           = clientInit.new(sock.newclient("*", 1337))
--     client.name            = "clientOwnerName"
--     if Server.guid == Client.guid then
--         Client.guid = guidUtils:generateNewGuid({ Server.guid })
--     end

--     -- [[ Mock functions ]] --
--     client.connection      = {}
--     client.connection.send = function(serializedMessage, sendChannel, sendMode)
--         logger:trace(logger.channels.testing,
--                      ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
--                              :format(utils:pformat(serializedMessage)))
--     end

--     -- [[ Send message ]] --
--     Server.clients[1]      = client
--     local sent             = Server.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename,
--                                                 health,
--                                                 isPolymorphed)
--     lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

--     local cachedData = networkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
--     lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
--                     "Checksum in NetworkCache isn't equal! Something bad is broken!")
--     logger:trace(logger.channels.testing,
--                  ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

--     local alreadySent = networkUtils:alreadySent(Server.clients[1], event, data)
--     lu.assertIsTrue(alreadySent,
--                     "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")
-- end

--- Tests if the function networkUtils:alreadySent() returns TRUE,
--- if the client send a message, which WAS already sent.
function TestNetworkUtils:testAlreadySentNeedNuidShouldReturnTrue()
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Prepare data and send the event message ]] --
    local ownerName = "TestOwnerName"
    local ownerGuid = guidUtils:generateNewGuid()
    local entityId  = 456378

    Client:sendNeedNuid(ownerName, ownerGuid, entityId)

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y =
        noitaComponentUtils.getEntityData(entityId, ownerName, ownerGuid)
    local data                                                                               = {
        networkUtils:getNextNetworkMessageId() - 1, { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
        filename, health, entityUtils.isEntityPolymorphed(entityId)
    }

    print(("Let's see if this was already sent: entity %s with data %s"):format(entityId, utils:pformat(data)))
    -- [[ Check if the message was already sent ]] --
    lu.assertIs(networkUtils:alreadySent(Client, "needNuid", data), true,
        "The message was already sent, but the function networkUtils:alreadySent() returned false!")

    Client:preDisconnect()
    Server:stop()
end

--- Tests if the function networkUtils:alreadySent() returns FALSE,
--- if the client send a message, which WASN'T already sent.
function TestNetworkUtils:testAlreadySentNeedNuidShouldReturnFalse()
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Prepare data and send the event message ]] --
    local event     = networkUtils.events.needNuid.name
    local ownerName = "TestOwnerName"
    local ownerGuid = guidUtils:generateNewGuid()
    local entityId  = 456378

    Client:sendNeedNuid(ownerName, ownerGuid, entityId)

    -- [[ CHANGE entityId to simulate a new NeedNuid networkMessage ]] --
    entityId                                                                                 = entityId + 1

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = noitaComponentUtils.getEntityData(entityId, ownerName,
        ownerGuid)
    local data                                                                               = {
        networkUtils:getNextNetworkMessageId(), { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
        filename, health, entityUtils.isEntityPolymorphed(entityId)
    }

    print(("Let's see if this WASN'T already sent: entity %s with data %s"):format(entityId, utils:pformat(data)))
    -- [[ Check if the message WASN'T already sent ]] --
    lu.assertIs(networkUtils:alreadySent(Client, event, data), false,
        "The message WASN'T already sent, but the function networkUtils:alreadySent() returned true!")

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentLostNuid()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local nuid                              = 234

    local data                              = {
        networkMessageId,
        nuid
    }

    local event                             = networkUtils.events.lostNuid.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = "clientOwnerName"
    Client.guid                             = guidUtils:generateNewGuid()

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    local sent = Client:sendLostNuid(nuid)
    lu.assertIsTrue(sent, "client didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Client.guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(client, event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentEntityData()
    lu.assertIsFalse(networkUtils.events.entityData.isCacheable,
        "EntityData network messages won't resend!")
end

function TestNetworkUtils:testAlreadySentDeadNuids()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local deadNuids                         = { -64, -84, -94 }

    local data                              = {
        networkMessageId,
        deadNuids
    }

    local event                             = networkUtils.events.deadNuids.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = "clientOwnerName"
    Client.guid                             = guidUtils:generateNewGuid()

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- globalsUtils.removeDeadNuid  = function(deadNuid)
    --     logger:trace(logger.channels.testing,
    --         ("Mocked 'GlobalsUtils.removeDeadNuid' removed a dead nuid '%s'!"):format(deadNuid))
    -- end

    -- [[ Send message ]] --
    local sent = Client:sendDeadNuids(deadNuids)
    lu.assertIsTrue(sent, "client didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Client.guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(client, event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    -- [[ Make sure mocked function are reset to originals ]] --
    -- EntityUtils.destroyByNuid   = originalDestroyByNuid
    -- GlobalsUtils.removeDeadNuid = originalRemoveDeadNuid
    -- EntityCache.deleteNuid      = originalDeleteNuid

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentNeedModList()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local workshop                          = {
        {
            workshop_id = "2721954559",
            name        = "spells_evolutions"
        },
        {
            workshop_id = "2826066666",
            name        = "always-cast-anvil"
        }
    }
    local external                          = {
        {
            workshop_id = nil,
            name        = "mould_n"
        },
        {
            workshop_id = nil,
            name        = "noita-mp"
        }
    }

    local data                              = {
        networkMessageId,
        workshop,
        external
    }

    local event                             = networkUtils.events.needModList.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = "clientOwnerName"
    Client.guid                             = guidUtils:generateNewGuid()

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    local sent = Client:preSend(event, data)
    lu.assertIsTrue(sent, "client didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Client.guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(client, event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end

function TestNetworkUtils:testAlreadySentNeedModContent()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId                  = networkUtils:getNextNetworkMessageId()
    local get                               = {
        {
            workshop_id = nil,
            name        = "mould_n"
        },
        {
            workshop_id = nil,
            name        = "noita-mp"
        }
    }
    local items                             = {
        {
            workshop_id = nil,
            name        = "mould_n",
            data        = "10101001010101010101001011010101010"
        },
        {
            workshop_id = nil,
            name        = "noita-mp",
            data        = "some binary"
        }
    }

    local data                              = {
        networkMessageId,
        get,
        items
    }

    local event                             = networkUtils.events.needModContent.name

    -- [[ Expected checksum in NetworkCache ]] --
    local expectedChecksum                  = md5.sumhexa(networkCacheUtils:getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local Server                            = require("Server")
        .new("0.0.0.0", 1337, nil, nil, nil, nil, np, nil)
    local Client                            = require("Client")
        .new("localhost", 1337, nil, Server, np, Server.nativeEntityMap)

    -- [[ Mock functions ]] --
    getmetatable(Client).connection         = {}
    getmetatable(Client).connection.timeout = function(limit, minimum, maximum)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:timeout(limit %s, minimum %s, maximum)' executed!")
            :format(limit, minimum, maximum))
    end
    getmetatable(Client).connection.send    = function(serializedMessage, sendChannel, sendMode)
        logger:trace(logger.channels.testing,
            ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
            :format(utils:pformat(serializedMessage)))
    end

    Client.name                             = "clientOwnerName"
    Client.guid                             = guidUtils:generateNewGuid()

    Server:stop()
    utils:wait(2)
    Server:preStart()
    Client:preConnect()

    -- [[ Send message ]] --
    local sent = Client:preSend(event, data)
    lu.assertIsTrue(sent, "client didn't send network message. Is the client set in Server.clients?")

    local cachedData = networkCacheUtils:getByChecksum(Client.guid, event, data)
    lu.assertNotIsNil(cachedData, "NetworkCache didn't cache the network message. Something bad is broken!")
    ---@diagnostic disable-next-line: need-check-nil
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
        "Checksum in NetworkCache isn't equal! Something bad is broken!")
    logger:trace(logger.channels.testing,
        ---@diagnostic disable-next-line: need-check-nil
        ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = networkUtils:alreadySent(client, event, data)
    lu.assertIsTrue(alreadySent,
        "NetworkMessage was already send, but networkUtils:alreadySent didn't find it in the cache?")

    Client:preDisconnect()
    Server:stop()
end
