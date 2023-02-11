local params                 = ...

-- [[ Mock Noita API functions, which are needed before/during require is used ]] --
mockedModSettingGetNextValue = ModSettingGetNextValue
ModSettingGetNextValue       = function(id)
    if id == "noita-mp.guid" then
        return GuidUtils:getGuid()
    end

    if mockedModSettingGetNextValue then
        mockedModSettingGetNextValue(id)
    end
end
--logger.log = function(channel, text)
--    local level = "TESTING"
--    local file = "file"
--    local msg = ("%s [%s][%s] %s ( in %s )"):format("00:00:00", channel, level, text, file)
--    print(msg)
--end
--logger.debug = logger.log
--logger.info = logger.log
--logger.warn = logger.log
--logger.error = logger.log

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
            return "noita-mp.name"
        end
        if id == "noita-mp.guid" then
            return GuidUtils:getGuid()
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

    print("\n-------------------------------------------------------")
end

--- Teardown function for each test.
function TestNetworkUtils:tearDown()
    Server.stop()
    Client.disconnect()
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

--function TestNetworkUtils:testAlreadySentConnect2()
--    Server.start("*", 1337)
--    Client.connect("localhost", 1337, 0)
--    local client2 = ClientInit.new(sock.newClient())
--
--    local data        = { NetworkUtils.getNextNetworkMessageId(), ModSettingGet("noita-mp.name"), ModSettingGet("noita-mp.guid") }
--
--    local alreadySent = NetworkUtils.alreadySent(clients, NetworkUtils.events.connect2.name, data)
--    lu.assertIs(alreadySent, true,
--                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
--end

function TestNetworkUtils:testAlreadySentDisconnect2()

end

function TestNetworkUtils:testAlreadySentAcknowledgement()

end

function TestNetworkUtils:testAlreadySentSeed()

end

function TestNetworkUtils:testAlreadySentPlayerInfo()

end

function TestNetworkUtils:testAlreadySentNewGuid()

end

function TestNetworkUtils:testAlreadySentNewNuid()
    -- [[ Mocked data ]] --
    local owner                         = { name = "ownerName", guid = GuidUtils:getGuid() }
    local localEntityId                 = 123
    local newNuid                       = 6
    local x                             = 0
    local y                             = 1
    local rotation                      = 4.73
    local velocity                      = { x = 2, y = 3 }
    local filename                      = "player.xml"
    local health                        = { current = 45, max = 100 }
    local isPolymorphed                 = false

    EntityGetWithTag                    = function(tag)
        return {}
    end
    EntityGetComponentIncludingDisabled = function(entityId, componentTypeName)
        return {}
    end
    StatsGetValue                       = function(key)
        return "2118579845"
    end

    -- [[ Mock functions inside Server.update() and Client.update() ]] --
    require("NetworkVscUtils")
    local originalProcessAndSyncEntityNetworking = EntityUtils.processAndSyncEntityNetworking
    EntityUtils.processAndSyncEntityNetworking   = function()
        Logger.trace(Logger.channels.testing, "EntityUtils.processAndSyncEntityNetworking mocked, is doing nothing!")
    end
    local originalSyncDeadNuids                  = EntityUtils.syncDeadNuids
    EntityUtils.syncDeadNuids                    = function()
        Logger.trace(Logger.channels.testing, "EntityUtils.syncDeadNuids mocked, is doing nothing!")
    end
    local originalIsNetworkEntityByNuidVsc       = NetworkVscUtils.isNetworkEntityByNuidVsc
    NetworkVscUtils.isNetworkEntityByNuidVsc     = function(entityId)
        return true
    end
    local originalGetAllVcsValuesByEntityId      = NetworkVscUtils.getAllVcsValuesByEntityId
    NetworkVscUtils.getAllVcsValuesByEntityId    = function(entityId)
        return owner.name, owner.guid, newNuid
    end
    local originalSpawnEntity                    = EntityUtils.spawnEntity
    EntityUtils.spawnEntity                      = function(owner, newNuid, x, y, rotation, velocity, filename, localEntityId, health,
                                                            isPolymorphed)
        return 'boom boom pow'
    end
    local originalHasNetworkLuaComponents        = NetworkVscUtils.hasNetworkLuaComponents
    NetworkVscUtils.hasNetworkLuaComponents      = function(entityId)
        return true
    end
    local fu                                     = require("file_util")
    local originalReadFile                       = fu.ReadFile
    fu.ReadFile                                  = function(path)
        if path == fu.GetAbsoluteDirectoryPathOfParentSave() .. "\\save00\\mod_config.xml" then
            return "<Mods>\n</Mods>"
        end
        return originalReadFile(path)
    end
    local originalGetLocalPlayerInfo             = util.getLocalPlayerInfo
    util.getLocalPlayerInfo                      = function()
        return {
            name     = owner.name,
            guid     = owner.guid,
            entityId = localEntityId,
            nuid     = newNuid
        }
    end


    -- [[ actual sending ]] --
    Server.start("*", 1337)
    Logger.trace(Logger.channels.testing, ("Server guid = %s"):format(Server.guid))
    Server.update()

    Logger.trace(Logger.channels.testing, ("Client guid = %s"):format(Client.guid))
    if Server.guid == Client.guid then
        -- make 100% sure, clients guid is unique
        Client.guid = GuidUtils:getGuid({ Server.guid })
        Logger.trace(Logger.channels.testing, ("Client guid = %s"):format(Client.guid))
    end
    Client.connect("localhost", 1337, 0)
    Client.update()

    Server.update()
    Client.update()

    Server.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename, health, isPolymorphed)

    Server.update()
    Client.update()

    -- [[ pseudo sending, but checking if the data was already sent ]] --
    local data                                 = {
        NetworkUtils.getNextNetworkMessageId(),
        owner,
        localEntityId,
        newNuid,
        x, y,
        rotation,
        velocity,
        filename,
        health,
        isPolymorphed
    }

    -- [[ Make sure mocked function are set back to originals ]] --
    EntityUtils.processAndSyncEntityNetworking = originalProcessAndSyncEntityNetworking
    EntityUtils.syncDeadNuids                  = originalSyncDeadNuids
    NetworkVscUtils.isNetworkEntityByNuidVsc   = originalIsNetworkEntityByNuidVsc
    NetworkVscUtils.getAllVcsValuesByEntityId  = originalGetAllVcsValuesByEntityId
    EntityUtils.spawnEntity                    = originalSpawnEntity
    NetworkVscUtils.hasNetworkLuaComponents    = originalHasNetworkLuaComponents
    fu.ReadFile                                = originalReadFile
    util.getLocalPlayerInfo                    = originalGetLocalPlayerInfo

    local alreadySent                          = NetworkUtils.alreadySent(Server.clients[1], NetworkUtils.events.newNuid.name,
                                                                          data)
    lu.assertIs(alreadySent, true,
                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
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
