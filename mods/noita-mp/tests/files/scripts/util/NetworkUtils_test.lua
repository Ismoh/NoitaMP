local params                 = ...

-- [[ Mock Noita API functions, which are needed before/during require is used ]] --
mockedModSettingGetNextValue = ModSettingGetNextValue
ModSettingGetNextValue       = function(id)
    if mockedModSettingGetNextValue then
        mockedModSettingGetNextValue(id)
    end
end

-- [[ require ]] --
require("noitamp_cache")
require("EntityUtils")
require("NetworkUtils")
require("GuidUtils")
require("CustomProfiler")
require("Server")
require("Client")

local lu         = require("luaunit")
local util       = require("util")

-- [[ Test ]] --
TestNetworkUtils = {}

--- Setup function for each test.
function TestNetworkUtils:setUp()
    -- Make absolutely sure, that the already mocked Noita API function is not overwritten
    local mockedModSettingGet        = ModSettingGet
    ModSettingGet                    = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return { "trace, debug, info, warn", "TRACE" }
        end
        if id == "noita-mp.name" then
            Logger.warn(Logger.channels.testing, ("RESET this value manually in your current test: %s"):format(id))
            return "RESET THIS!!"
        end
        if id == "noita-mp.guid" then
            Logger.warn(Logger.channels.testing, ("RESET this value manually in your current test: %s"):format(id))
            return "RESET THIS"
        end
        if id == "noita-mp.tick_rate" then
            return 1
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
        print("GamePrintImportant: " .. title .. " - " .. description .. " - " .. " (ui_custom_decoration_file: " .. tostring(ui_custom_decoration_file) .. ")")
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
    print("\n-------------------------------------------------------")
end

function TestNetworkUtils:testAlreadySent()
    lu.assertErrorMsgContains("'peer' must not be nil!",
                              NetworkUtils.alreadySent, nil, event, data)
    lu.assertErrorMsgContains("'event' must not be nil!",
                              NetworkUtils.alreadySent, Client, nil, data)
    lu.assertErrorMsgContains("is unknown. Did you add this event in NetworkUtils.events?",
                              NetworkUtils.alreadySent, Client, "ASDF", data)
    lu.assertErrorMsgContains("'data' must not be nil!",
                              NetworkUtils.alreadySent, Client, "needNuid", nil)
end

function TestNetworkUtils:testAlreadySentConnect2()
    -- [[ Prepare mocked data for sending Connect2! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local name             = "ClientOwnerName"
    local guid             = GuidUtils:getGuid()

    local data             = {
        networkMessageId,
        name,
        guid
    }

    local event            = NetworkUtils.events.connect2.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Server           = ServerInit.new(sock.newServer("*", 1337))
    Server.name            = "ServerOwnerName"
    Server.guid            = GuidUtils:getGuid({ guid })
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = name
    Client.guid            = guid

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel %s, self.sendMode %s)' executed!")
                             :format(util.pformat(serializedMessage), sendChannel, sendMode))
    end

    -- [[ Send message ]] --
    Server.clients[1]      = Client
    local sent             = Server:sendToAll(NetworkUtils.events.connect2.name,
                                              { NetworkUtils.getNextNetworkMessageId(), Client.name, Client.guid })
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentDisconnect2()
    -- [[ Prepare mocked data for sending Disconnect2! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local name             = "ClientOwnerName"
    local guid             = GuidUtils:getGuid()

    local data             = {
        networkMessageId,
        name,
        guid
    }

    local event            = NetworkUtils.events.disconnect2.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Server           = ServerInit.new(sock.newServer("*", 1337))
    Server.name            = "ServerOwnerName"
    Server.guid            = GuidUtils:getGuid({ guid })
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = name
    Client.guid            = guid

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel %s, self.sendMode %s)' executed!")
                             :format(util.pformat(serializedMessage), sendChannel, sendMode))
    end

    -- [[ Send message ]] --
    Server.clients[1]      = Client
    local sent             = Server:sendToAll(event, data)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentAcknowledgement()
    lu.assertIsFalse(NetworkUtils.events.acknowledgement.isCacheable,
                     "Acknowledgement network messages won't be cached or resend!")
end

function TestNetworkUtils:testAlreadySentSeed()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local seed             = "4294967295"

    local data             = {
        networkMessageId,
        seed
    }

    local event            = NetworkUtils.events.seed.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Server           = ServerInit.new(sock.newServer("*", 1337))
    Server.name            = "ServerOwnerName"
    Server.guid            = GuidUtils:getGuid({ guid })
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = name
    Client.guid            = guid

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel %s, self.sendMode %s)' executed!")
                             :format(util.pformat(serializedMessage), sendChannel, sendMode))
    end

    -- [[ Send message ]] --
    Server.clients[1]      = Client
    local sent             = Server:send(Server.clients[1], event, data)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentPlayerInfo()
    local fu               = require("file_util")

    -- [[ Prepare mocked data for sending PlayerInfo! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local name             = "ClientOwnerName"
    local guid             = GuidUtils:getGuid()
    local version          = fu.getVersionByFile()
    local nuid             = nil

    local data             = {
        networkMessageId,
        name,
        guid,
        version,
        nuid
    }

    local event            = NetworkUtils.events.playerInfo.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Server           = ServerInit.new(sock.newServer("*", 1337))
    Server.name            = "ServerOwnerName"
    Server.guid            = GuidUtils:getGuid({ guid })
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = name
    Client.guid            = guid

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel %s, self.sendMode %s)' executed!")
                             :format(util.pformat(serializedMessage), sendChannel, sendMode))
    end

    -- [[ Send message ]] --
    Server.clients[1]      = Client
    local sent             = Server:send(Server.clients[1], event, data)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentNewGuid()

end

function TestNetworkUtils:testAlreadySentNewNuid()
    -- [[ Prepare mocked data for sending a new nuid! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local owner            = { name = "ServerOwnerName", guid = GuidUtils:getGuid() }
    local localEntityId    = 3456
    local newNuid          = 34
    local x                = 6
    local y                = 7
    local rotation         = 5.67
    local velocity         = { x = 2, y = 5 }
    local filename         = "player.xml"
    local health           = { current = 490, max = 1000 }
    local isPolymorphed    = false

    local data             = {
        networkMessageId,
        owner,
        localEntityId,
        newNuid,
        x,
        y,
        rotation,
        velocity,
        filename,
        health,
        isPolymorphed
    }

    local event            = NetworkUtils.events.newNuid.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Server           = ServerInit.new(sock.newServer("*", 1337))
    Server.name            = owner.name
    Server.guid            = owner.guid
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = "ClientOwnerName"
    if Server.guid == Client.guid then
        Client.guid = GuidUtils:getGuid({ Server.guid })
    end

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel %s, self.sendMode %s)' executed!")
                             :format(util.pformat(serializedMessage), sendChannel, sendMode))
    end

    -- [[ Send message ]] --
    Server.clients[1]      = Client
    local sent             = Server.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename,
                                                health,
                                                isPolymorphed)
    lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Server.clients[1], event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

--- Tests if the function NetworkUtils.alreadySent() returns TRUE,
--- if the client send a message, which WAS already sent.
function TestNetworkUtils:testAlreadySentNeedNuidShouldReturnTrue()
    -- [[ Mock functions inside of Client.sendNeedNuid ]] --
    EntityUtils.isEntityAlive       = function(entityId)
        return true
    end
    EntityUtils.isEntityPolymorphed = function(entityId)
        return false
    end

    Server.start("*", 1337)
    Client.connect("localhost", 1337, 0)

    -- [[ Prepare data and send the event message ]] --
    local ownerName = "TestOwnerName"
    local ownerGuid = GuidUtils:getGuid()
    local entityId  = 456378

    -- [[ Mock functions inside of Client.sendNeedNuid ]] --
    if not NoitaComponentUtils then
        NoitaComponentUtils = {}
    end
    NoitaComponentUtils.getEntityData = function(entityId)
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

    Client.sendNeedNuid(ownerName, ownerGuid, entityId)

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
    local data                                                                               = {
        NetworkUtils.getNextNetworkMessageId() - 1, { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
        filename, health, EntityUtils.isEntityPolymorphed(entityId)
    }

    print(("Let's see if this was already sent: entity %s with data %s"):format(entityId, util.pformat(data)))
    -- [[ Check if the message was already sent ]] --
    lu.assertIs(NetworkUtils.alreadySent(Client, "needNuid", data), true,
                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
    Client.disconnect()
    Server.stop()
end

--- Tests if the function NetworkUtils.alreadySent() returns FALSE,
--- if the client send a message, which WASN'T already sent.
function TestNetworkUtils:testAlreadySentNeedNuidShouldReturnFalse()
    -- [[ Mock functions inside of Client.sendNeedNuid ]] --
    EntityUtils.isEntityAlive       = function(entityId)
        return true
    end
    EntityUtils.isEntityPolymorphed = function(entityId)
        return false
    end

    Server.start("*", 1337)
    Client.connect("localhost", 1337, 0)

    -- [[ Prepare data and send the event message ]] --
    local event     = NetworkUtils.events.needNuid.name
    local ownerName = "TestOwnerName"
    local ownerGuid = GuidUtils:getGuid()
    local entityId  = 456378

    -- [[ Mock functions inside of Client.sendNeedNuid ]] --
    if not NoitaComponentUtils then
        NoitaComponentUtils = {}
    end
    NoitaComponentUtils.getEntityData = function(entityId)
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

    Client.sendNeedNuid(ownerName, ownerGuid, entityId)

    -- [[ CHANGE entityId to simulate a new NeedNuid networkMessage ]] --
    entityId                                                                                 = entityId + 1

    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
    local data                                                                               = {
        NetworkUtils.getNextNetworkMessageId(), { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
        filename, health, EntityUtils.isEntityPolymorphed(entityId)
    }

    print(("Let's see if this WASN'T already sent: entity %s with data %s"):format(entityId, util.pformat(data)))
    -- [[ Check if the message WASN'T already sent ]] --
    lu.assertIs(NetworkUtils.alreadySent(Client, event, data), false,
                "The message WASN'T already sent, but the function NetworkUtils.alreadySent() returned true!")
    Client.disconnect()
    Server.stop()
end

function TestNetworkUtils:testAlreadySentLostNuid()

end

function TestNetworkUtils:testAlreadySentEntityData()

end

function TestNetworkUtils:testAlreadySentDeadNuids()

end

function TestNetworkUtils:testAlreadySentNeedModList()

end

function TestNetworkUtils:testAlreadySentNeedModContent()

end

lu.LuaUnit.run(params)
