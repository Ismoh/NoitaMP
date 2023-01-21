local params           = ...

-- [[ Mock Noita API functions, which are needed before/during require is used ]] --
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
require("guid")
require("CustomProfiler")
require("Server")
require("Client")

local lu         = require("luaunit")
local util       = require("util")

-- [[ Test ]] --
TestNetworkUtils = {}

--- Setup function for each test.
function TestNetworkUtils:setUp()
end

--- Teardown function for each test.
function TestNetworkUtils:tearDown()
end

function TestNetworkUtils:alreadySentErrors()
    lu.assertErrorMsgContains("'peer' must not be nil!",
                              NetworkUtils.alreadySent, nil, event, data)
    lu.assertErrorMsgContains("'event' must not be nil!",
                              NetworkUtils.alreadySent, Client, nil, data)
    lu.assertErrorMsgContains("is unknown. Did you add this event in NetworkUtils.events?",
                              NetworkUtils.alreadySent, peer, "ASDF", data)
    lu.assertErrorMsgContains("'data' must not be nil!",
                              NetworkUtils.alreadySent, peer, "needNuid", nil)
end

function TestNetworkUtils:alreadySentConnect2()

end

function TestNetworkUtils:alreadySentDisconnect2()

end

function TestNetworkUtils:alreadySentAcknowledgement()

end

function TestNetworkUtils:alreadySentSeed()

end

function TestNetworkUtils:alreadySentPlayerInfo()

end

function TestNetworkUtils:alreadySentNewGuid()

end

function TestNetworkUtils:alreadySentNewNuid()

end

--- Tests if the function NetworkUtils.alreadySent() returns true,
--- if the client send a message, which was already sent.
function TestNetworkUtils:alreadySentNeedNuidShouldFail()
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
    local ownerGuid = Guid:getGuid()
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
    lu.assertIs(NetworkUtils.alreadySent(peer, "needNuid", data), true,
                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
    Client.disconnect()
    Server.stop()
end

--- Tests if the function NetworkUtils.alreadySent() returns true,
--- if the client send a message, which was already sent.
function TestNetworkUtils:alreadySentNeedNuidShouldSucceed()
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
    local ownerGuid = Guid:getGuid()
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
    lu.assertIs(NetworkUtils.alreadySent(peer, "needNuid", data), true,
                "The message was already sent, but the function NetworkUtils.alreadySent() returned false!")
    Client.disconnect()
    Server.stop()
end

function TestNetworkUtils:alreadySentLostNuid()

end

function TestNetworkUtils:alreadySentEntityData()

end

function TestNetworkUtils:alreadySentDeadNuids()

end

function TestNetworkUtils:alreadySentNeedModList()

end

function TestNetworkUtils:alreadySentNeedModContent()

end

lu.LuaUnit.run(params)
