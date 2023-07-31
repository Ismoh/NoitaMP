if not Server then
    require("Server")
end
if not Client then
    require("Client")
end

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
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
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
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
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
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
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
    local fu               = require("FileUtils")

    -- [[ Prepare mocked data for sending PlayerInfo! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local name             = "ClientOwnerName"
    local guid             = GuidUtils:getGuid()
    local version          = fu.GetVersionByFile()
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
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
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
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local oldGuid          = GuidUtils:getGuid()
    local newGuid          = GuidUtils:getGuid({ oldGuid })

    local data             = {
        networkMessageId,
        oldGuid,
        newGuid
    }

    local event            = NetworkUtils.events.newGuid.name

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
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
    end

    -- [[ Send message ]] --
    Server.clients[1]      = Client
    local sent             = Server.sendNewGuid(Server.clients[1], oldGuid, newGuid)
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

-- function TestNetworkUtils:testAlreadySentNewNuid()
--     -- [[ Prepare mocked data for sending a new nuid! ]] --
--     local networkMessageId = NetworkUtils.getNextNetworkMessageId()
--     local owner            = { name = "ServerOwnerName", guid = GuidUtils:getGuid() }
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

--     local event            = NetworkUtils.events.newNuid.name

--     -- [[ Expected checksum in NetworkCache ]] --
--     local md5              = require("md5")
--     local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

--     -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
--     local sock             = require("sock")
--     local Server           = ServerInit.new(sock.newServer("*", 1337))
--     Server.name            = owner.name
--     Server.guid            = owner.guid
--     local Client           = ClientInit.new(sock.newClient("*", 1337))
--     Client.name            = "ClientOwnerName"
--     if Server.guid == Client.guid then
--         Client.guid = GuidUtils:getGuid({ Server.guid })
--     end

--     -- [[ Mock functions ]] --
--     Client.connection      = {}
--     Client.connection.send = function(serializedMessage, sendChannel, sendMode)
--         Logger.trace(Logger.channels.testing,
--                      ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
--                              :format(Utils.pformat(serializedMessage)))
--     end

--     -- [[ Send message ]] --
--     Server.clients[1]      = Client
--     local sent             = Server.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename,
--                                                 health,
--                                                 isPolymorphed)
--     lu.assertIsTrue(sent, "Server didn't send network message. Is the client set in Server.clients?")

--     local cachedData = NetworkCacheUtils.getByChecksum(Server.clients[1].guid, event, data)
--     lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
--                     "Checksum in NetworkCache isn't equal! Something bad is broken!")
--     Logger.trace(Logger.channels.testing,
--                  ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

--     local alreadySent = NetworkUtils.alreadySent(Server.clients[1], event, data)
--     lu.assertIsTrue(alreadySent,
--                     "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
-- end

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

    print(("Let's see if this was already sent: entity %s with data %s"):format(entityId, Utils.pformat(data)))
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

    print(("Let's see if this WASN'T already sent: entity %s with data %s"):format(entityId, Utils.pformat(data)))
    -- [[ Check if the message WASN'T already sent ]] --
    lu.assertIs(NetworkUtils.alreadySent(Client, event, data), false,
                "The message WASN'T already sent, but the function NetworkUtils.alreadySent() returned true!")
    Client.disconnect()
    Server.stop()
end

function TestNetworkUtils:testAlreadySentLostNuid()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local nuid             = 234

    local data             = {
        networkMessageId,
        nuid
    }

    local event            = NetworkUtils.events.lostNuid.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = "ClientOwnerName"
    Client.guid            = GuidUtils:getGuid()

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
    end

    -- [[ Send message ]] --
    local sent             = Client.sendLostNuid(nuid)
    lu.assertIsTrue(sent, "Client didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Client.guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Client, event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentEntityData()
    lu.assertIsFalse(NetworkUtils.events.entityData.isCacheable,
                     "EntityData network messages won't resend!")
end

function TestNetworkUtils:testAlreadySentDeadNuids()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId      = NetworkUtils.getNextNetworkMessageId()
    local deadNuids             = { -64, -84, -94 }

    local data                  = {
        networkMessageId,
        deadNuids
    }

    local event                 = NetworkUtils.events.deadNuids.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5                   = require("md5")
    local expectedChecksum      = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock                  = require("sock")
    local Client                = ClientInit.new(sock.newClient("*", 1337))
    Client.name                 = "ClientOwnerName"
    Client.guid                 = GuidUtils:getGuid()

    -- [[ Mock functions ]] --
    Client.connection           = {}
    Client.connection.send      = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
    end
    local originalDestroyByNuid = EntityUtils.destroyByNuid
    EntityUtils.destroyByNuid   = function(peer, deadNuid)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'EntityUtils.destroyByNuid' on '%s' destroyed a dead nuid '%s'!")
                             :format(Utils.pformat(peer), deadNuid))
    end
    require("GlobalsUtils")
    local originalRemoveDeadNuid = GlobalsUtils.removeDeadNuid
    GlobalsUtils.removeDeadNuid  = function(deadNuid)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'GlobalsUtils.removeDeadNuid' removed a dead nuid '%s'!"):format(deadNuid))
    end
    local originalDeleteNuid     = EntityCache.deleteNuid
    EntityCache.deleteNuid       = function(deadNuid)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'EntityCache.deleteNuid' deleted a dead nuid '%s'!"):format(deadNuid))
    end

    -- [[ Send message ]] --
    local sent                   = Client.sendDeadNuids(deadNuids)
    lu.assertIsTrue(sent, "Client didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Client.guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Client, event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")

    -- [[ Make sure mocked function are reset to originals ]] --
    EntityUtils.destroyByNuid   = originalDestroyByNuid
    GlobalsUtils.removeDeadNuid = originalRemoveDeadNuid
    EntityCache.deleteNuid      = originalDeleteNuid
end

function TestNetworkUtils:testAlreadySentNeedModList()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local workshop         = {
        {
            workshop_id = "2721954559",
            name        = "spells_evolutions"
        },
        {
            workshop_id = "2826066666",
            name        = "always-cast-anvil"
        }
    }
    local external         = {
        {
            workshop_id = nil,
            name        = "mould_n"
        },
        {
            workshop_id = nil,
            name        = "noita-mp"
        }
    }

    local data             = {
        networkMessageId,
        workshop,
        external
    }

    local event            = NetworkUtils.events.needModList.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = "ClientOwnerName"
    Client.guid            = GuidUtils:getGuid()

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
    end

    -- [[ Send message ]] --
    local sent             = Client:send(event,
                                         data)
    lu.assertIsTrue(sent, "Client didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Client.guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Client, event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end

function TestNetworkUtils:testAlreadySentNeedModContent()
    -- [[ Prepare mocked data for sending Seed! ]] --
    local networkMessageId = NetworkUtils.getNextNetworkMessageId()
    local get              = {
        {
            workshop_id = nil,
            name        = "mould_n"
        },
        {
            workshop_id = nil,
            name        = "noita-mp"
        }
    }
    local items            = {
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

    local data             = {
        networkMessageId,
        get,
        items
    }

    local event            = NetworkUtils.events.needModContent.name

    -- [[ Expected checksum in NetworkCache ]] --
    local md5              = require("md5")
    local expectedChecksum = md5.sumhexa(NetworkCacheUtils.getSum(event, data))

    -- [[ Set up client and server, but do not do a actual start and connect, because this would execute to many other functions ]] --
    local sock             = require("sock")
    local Client           = ClientInit.new(sock.newClient("*", 1337))
    Client.name            = "ClientOwnerName"
    Client.guid            = GuidUtils:getGuid()

    -- [[ Mock functions ]] --
    Client.connection      = {}
    Client.connection.send = function(serializedMessage, sendChannel, sendMode)
        Logger.trace(Logger.channels.testing,
                     ("Mocked 'self.connection:send(serializedMessage %s, self.sendChannel, self.sendMode)' executed!")
                             :format(Utils.pformat(serializedMessage)))
    end

    -- [[ Send message ]] --
    local sent             = Client:send(event,
                                         data)
    lu.assertIsTrue(sent, "Client didn't send network message. Is the client set in Server.clients?")

    local cachedData = NetworkCacheUtils.getByChecksum(Client.guid, event, data)
    lu.assertEquals(cachedData.dataChecksum, expectedChecksum,
                    "Checksum in NetworkCache isn't equal! Something bad is broken!")
    Logger.trace(Logger.channels.testing,
                 ("Actual checksum '%s' == '%s' expected checksum"):format(cachedData.dataChecksum, expectedChecksum))

    local alreadySent = NetworkUtils.alreadySent(Client, event, data)
    lu.assertIsTrue(alreadySent,
                    "NetworkMessage was already send, but NetworkUtils.alreadySent didn't find it in the cache?")
end