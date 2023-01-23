local params           = ...

-- [[ Mock Noita API functions, which are needed before/during require is used ]] --
mockedModSettingGetNextValue = ModSettingGetNextValue
ModSettingGetNextValue = function(id)
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
    local mockedModSettingGet = ModSettingGet
    ModSettingGet    = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return { "trace, debug, info, warn", "TRACE" }
        end
        if id == "noita-mp.name" then
            return "noita-mp.name"
        end
        if id == "noita-mp.guid" then
            return "noita-mp.guid"
        end

        mockedModSettingGet(id)
    end
    ModSettingGetNextValue = function()
        -- return false to disable CustomProfiler
        return false
    end
    ModSettingSetNextValue = function(id, value, is_default)
        print("ModSettingSetNextValue: " .. id .. " = " .. tostring(value) .. " (is_default: " .. tostring(is_default) .. ")")
    end
    GamePrintImportant     = function(title, description, ui_custom_decoration_file)
        print("GamePrintImportant: " .. title .. " - " .. description .. " - " .. " (ui_custom_decoration_file: " .. tostring(ui_custom_decoration_file) .. ")")
    end
end

--- Teardown function for each test.
function TestNetworkUtils:tearDown()
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

end

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

end

--- Tests if the function NetworkUtils.alreadySent() returns true,
--- if the client send a message, which was already sent.
function TestNetworkUtils:testAlreadySentNeedNuidShouldFail()
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
    lu.assertIs(NetworkUtils.alreadySent(Client, "needNuid", data), false,
                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
    Client.disconnect()
    Server.stop()
end

--- Tests if the function NetworkUtils.alreadySent() returns true,
--- if the client send a message, which was already sent.
function TestNetworkUtils:testAlreadySentNeedNuidShouldSucceed()
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
        NetworkUtils.getNextNetworkMessageId(), { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
        filename, health, EntityUtils.isEntityPolymorphed(entityId)
    }

    print(("Let's see if this was already sent: entity %s with data %s"):format(entityId, util.pformat(data)))
    -- [[ Check if the message was already sent ]] --
    lu.assertIs(NetworkUtils.alreadySent(Client, "needNuid", data), true,
                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
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
