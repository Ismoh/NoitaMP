-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- 'Imports'
----------------------------------------
local sock        = require("sock")
local util        = require("util")
local zstandard   = require("zstd")
local messagePack = require("MessagePack")

----------------------------------------------------------------------------------------------------
--- Client
----------------------------------------------------------------------------------------------------
Client            = {}
----------------------------------------
-- Global private variables:
----------------------------------------

----------------------------------------
-- Global private methods:
----------------------------------------

----------------------------------------
-- Access to global private variables
----------------------------------------

----------------------------------------
-- Global public variables:
----------------------------------------

----------------------------------------------------------------------------------------------------
--- Client constructor
----------------------------------------------------------------------------------------------------
--- Creates a new instance of client 'class'.
--- @param sockClient table sock.lua#newClient
--- @return table Client
function Client.new(sockClient)
    local cpc         = CustomProfiler.start("Client.new")
    local self        = sockClient

    ------------------------------------
    --- Private variables:
    ------------------------------------

    ------------------------------------
    --- Public variables:
    ------------------------------------
    self.iAm          = "CLIENT"
    self.name         = tostring(ModSettingGet("noita-mp.name"))
    -- guid might not be set here or will be overwritten at the end of the constructor. @see setGuid
    self.guid         = tostring(ModSettingGet("noita-mp.guid"))
    self.nuid         = nil
    self.acknowledge  = {} -- sock.lua#Client:send -> self.acknowledge[packetsSent] = { event = event, data = data, entityId = data.entityId, status = NetworkUtils.events.acknowledgement.sent }
    table.setNoitaMpDefaultMetaMethods(self.acknowledge)
    self.acknowledgeMaxSize = 500
    self.transform    = { x = 0, y = 0 }
    self.health       = { current = 99, max = 100 }
    self.serverInfo   = {}
    self.otherClients = {}
    self.missingMods  = nil
    self.requiredMods = nil
    self.syncedMods   = false

    ------------------------------------
    --- Private methods:
    ------------------------------------

    ------------------------------------------------------------------------------------------------
    --- Set clients settings
    ------------------------------------------------------------------------------------------------
    local function setConfigSettings()
        local cpc1        = CustomProfiler.start("Client.setConfigSettings")
        local serialize   = function(anyValue)
            local cpc2            = CustomProfiler.start("Client.setConfigSettings.serialize")
            --logger:debug(logger.channels.network, ("Serializing value: %s"):format(anyValue))
            local serialized      = messagePack.pack(anyValue)
            local zstd            = zstandard:new()
            --logger:debug(logger.channels.network, "Uncompressed size:", string.len(serialized))
            local compressed, err = zstd:compress(serialized)
            if err then
                logger:error(logger.channels.network, "Error while compressing: " .. err)
            end
            --logger:debug(logger.channels.network, "Compressed size:", string.len(compressed))
            --logger:debug(logger.channels.network, ("Serialized and compressed value: %s"):format(compressed))
            zstd:free()
            CustomProfiler.stop("Client.setConfigSettings.serialize", cpc2)
            return compressed
        end

        local deserialize = function(anyValue)
            local cpc3              = CustomProfiler.start("Client.setConfigSettings.deserialize")
            --logger:debug(logger.channels.network, ("Serialized and compressed value: %s"):format(anyValue))
            local zstd              = zstandard:new()
            --logger:debug(logger.channels.network, "Compressed size:", string.len(anyValue))
            local decompressed, err = zstd:decompress(anyValue)
            if err then
                logger:error(logger.channels.network, "Error while decompressing: " .. err)
            end
            --logger:debug(logger.channels.network, "Uncompressed size:", string.len(decompressed))
            local deserialized = messagePack.unpack(decompressed)
            logger:debug(logger.channels.network, ("Deserialized and uncompressed value: %s"):format(deserialized))
            zstd:free()
            CustomProfiler.stop("Client.setConfigSettings.deserialize", cpc3)
            return deserialized
        end

        self:setSerialization(serialize, deserialize)
        self:setTimeout(320, 50000, 100000)
        CustomProfiler.stop("Client.setConfigSettings", cpc1)
    end

    ------------------------------------------------------------------------------------------------
    --- Set clients guid
    ------------------------------------------------------------------------------------------------
    local function setGuid()
        local cpc1  = CustomProfiler.start("Client.setGuid")
        local cpc25 = CustomProfiler.start("ModSettingGetNextValue")
        local guid  = tostring(ModSettingGetNextValue("noita-mp.guid"))
        CustomProfiler.stop("ModSettingGetNextValue", cpc25)

        if guid == "" or Guid.isPatternValid(guid) == false then
            guid        = Guid:getGuid()
            local cpc26 = CustomProfiler.start("ModSettingSetNextValue")
            ModSettingSetNextValue("noita-mp.guid", guid, false)
            CustomProfiler.stop("ModSettingSetNextValue", cpc26)
            self.guid = guid
            logger:debug(logger.channels.network, "Clients guid set to " .. guid)
        else
            logger:debug(logger.channels.network, "Clients guid was already set to " .. guid)
        end

        if DebugGetIsDevBuild() then
            guid = guid .. self.iAm
        end
        CustomProfiler.stop("Client.setGuid", cpc1)
    end

    ------------------------------------------------------------------------------------------------
    --- Send acknowledgement
    ------------------------------------------------------------------------------------------------
    local function sendAck(networkMessageId)
        local cpc2 = CustomProfiler.start("Client.sendAck")
        local data = { networkMessageId, NetworkUtils.events.acknowledgement.ack }
        self:send(NetworkUtils.events.acknowledgement.name, data)
        logger:debug(logger.channels.network, ("Sent ack with data = %s"):format(util.pformat(data)))
        CustomProfiler.stop("Client.sendAck", cpc2)
    end

    ------------------------------------------------------------------------------------------------
    --- onAcknowledgement
    ------------------------------------------------------------------------------------------------
    local function onAcknowledgement(data)
        local cpc3 = CustomProfiler.start("Client.onAcknowledgement")
        logger:debug(logger.channels.network, "onAcknowledgement: Acknowledgement received.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onAcknowledgement data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
        end

        if not data.networkMessageId then
            logger:error(logger.channels.network,
                ("Unable to get acknowledgement with networkMessageId = %s, data = %s, peer = %s")
                :format(networkMessageId, util.pformat(data), util.pformat(peer)))
            return
        end

        if not self.acknowledge[data.networkMessageId] then
            self.acknowledge[data.networkMessageId] = {}
        end
        self.acknowledge[data.networkMessageId].status = data.status

        if #self.acknowledge > self.acknowledgeMaxSize then
            table.remove(self.acknowledge, 1)
        end
        CustomProfiler.stop("Client.onAcknowledgement", cpc3)
    end

    ------------------------------------------------------------------------------------------------
    --- onConnect
    ------------------------------------------------------------------------------------------------
    --- Callback when connected to server.
    --- @param data number not in use atm
    local function onConnect(data)
        local cpc4 = CustomProfiler.start("Client.onConnect")
        logger:debug(logger.channels.network, "Connected to server!", util.pformat(data))

        if util.IsEmpty(data) then
            error(("onConnect data is empty: %s"):format(data), 3)
        end
        self:send(NetworkUtils.events.needModList.name, {NetworkUtils.getNextNetworkMessageId()})
        -- sendAck(data.networkMessageId)
        CustomProfiler.stop("Client.onConnect", cpc4)
    end

    ------------------------------------------------------------------------------------------------
    --- onConnect2
    ------------------------------------------------------------------------------------------------
    --- Callback when one of the other clients connected.
    --- @param data table data = { "name", "guid" } @see NetworkUtils.events.connect2.schema
    local function onConnect2(data)
        local cpc5 = CustomProfiler.start("Client.onConnect2")
        logger:debug(logger.channels.network, "Another client connected.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onConnect2 data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.name) then
            error(("onConnect2 data.name is empty: %s"):format(data.name), 3)
        end

        if util.IsEmpty(data.guid) then
            error(("onConnect2 data.guid is empty: %s"):format(data.guid), 3)
        end

        sendAck(data.networkMessageId)

        table.insertIfNotExist(self.otherClients, { name = data.name, guid = data.guid })
        CustomProfiler.stop("Client.onConnect2", cpc5)
    end

    ------------------------------------------------------------------------------------------------
    --- onDisconnect
    ------------------------------------------------------------------------------------------------
    --- Callback when disconnected from server.
    --- @param data number data(.code) = 0
    local function onDisconnect(data)
        local cpc6 = CustomProfiler.start("Client.onDisconnect")
        logger:debug(logger.channels.network, "Disconnected from server!", util.pformat(data))

        if util.IsEmpty(data) then
            error(("onDisconnect data is empty: %s"):format(data), 3)
        end

        -- sendAck(data.networkMessageId)

        if self.serverInfo.nuid then
            EntityUtils.destroyByNuid(self.serverInfo.nuid)
        end

        -- TODO remove all NUIDS from entities. I now need a nuid-entityId-cache.
        local nuid, entityId = GlobalsUtils.getNuidEntityPair(self.nuid)
        NetworkVscUtils.addOrUpdateAllVscs(entityId, self.name, self.guid, nil)

        self.acknowledge  = {}
        self.nuid         = nil
        self.otherClients = {}
        self.serverInfo   = {}
        CustomProfiler.stop("Client.onDisconnect", cpc6)
    end

    ------------------------------------------------------------------------------------------------
    --- onDisconnect2
    ------------------------------------------------------------------------------------------------
    --- Callback when one of the other clients disconnected.
    --- @param data table data { "name", "guid" } @see NetworkUtils.events.disconnect2.schema
    local function onDisconnect2(data)
        local cpc7 = CustomProfiler.start("Client.onDisconnect2")
        logger:debug(logger.channels.network, "onDisconnect2: Another client disconnected.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onDisconnect2 data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.name) then
            error(("onDisconnect2 data.name is empty: %s"):format(data.name), 3)
        end

        if util.IsEmpty(data.guid) then
            error(("onDisconnect2 data.guid is empty: %s"):format(data.guid), 3)
        end

        sendAck(data.networkMessageId)

        for i = 1, #self.otherClients do
            -- table.insertIfNotExist(self.otherClients, { name = data.name, guid = data.guid })
        end
        CustomProfiler.stop("Client.onDisconnect2", cpc7)
    end

    ------------------------------------------------------------------------------------------------
    --- onPlayerInfo
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent his playerInfo to the client
    --- @param data table data { networkMessageId, name, guid }
    local function onPlayerInfo(data)
        local cpc8 = CustomProfiler.start("Client.onPlayerInfo")
        logger:debug(logger.channels.network, "onPlayerInfo: Player info received.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onPlayerInfo data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.name) then
            error(("onPlayerInfo data.name is empty: %s"):format(data.name), 3)
        end

        if util.IsEmpty(data.guid) then
            error(("onPlayerInfo data.guid is empty: %s"):format(data.guid), 3)
        end

        if util.IsEmpty(data.nuid) then
            error(("onPlayerInfo data.nuid is empty: %s"):format(data.nuid), 3)
        end

        if util.IsEmpty(data.version) then
            error(("onPlayerInfo data.version is empty: %s"):format(data.version), 3)
        end

        if data.guid == self.guid then
            logger:error(logger.channels.network,
                "onPlayerInfo: Clients GUID isn't unique! Server will fix this!")
            --self.guid = Guid:getGuid({ self.guid })
            --logger:info(logger.channels.network, "onPlayerInfo: New clients GUID: %s", self.guid)
            self:disconnect()
        end

        if _G.NoitaMPVersion ~= tostring(data.version) then
            error(("Version mismatch: NoitaMP version of Server: %s and your version: %s")
                :format(data.version, _G.NoitaMPVersion), 3)
            self:disconnect()
        end

        sendAck(data.networkMessageId)

        self.serverInfo.name = data.name
        self.serverInfo.guid = data.guid
        self.serverInfo.nuid = data.nuid

        CustomProfiler.stop("Client.onPlayerInfo", cpc8)
    end

    ------------------------------------------------------------------------------------------------
    --- onNewGuid
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent a new GUID for a specific client.
    --- @param data table data { "networkMessageId", "oldGuid", "newGuid" }
    local function onNewGuid(data)
        local cpc9 = CustomProfiler.start("Client.onNewGuid")
        logger:debug(logger.channels.network, "onNewGuid: New GUID from server received.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onNewGuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.oldGuid) then
            error(("onNewGuid data.oldGuid is empty: %s"):format(data.oldGuid), 3)
        end

        if util.IsEmpty(data.newGuid) then
            error(("onNewGuid data.newGuid is empty: %s"):format(data.newGuid), 3)
        end

        sendAck(data.networkMessageId)

        if data.oldGuid == self.guid then
            local entityId                               = util.getLocalPlayerInfo().entityId
            local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)

            self.guid                                    = data.newGuid
            local cpc27                                  = CustomProfiler.start("ModSettingSet")
            ModSettingSet("noita-mp.guid", self.guid)
            CustomProfiler.stop("ModSettingGet", cpc27)
            local cpc28 = CustomProfiler.start("ModSettingSet")
            ModSettingSet("noita-mp.guid_readonly", self.guid)
            CustomProfiler.stop("ModSettingGet", cpc28)

            NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, self.guid, compNuid)
        else
            for i = 1, #self.otherClients do
                if self.otherClients[i].guid == data.oldGuid then
                    self.otherClients[i].guid = data.newGuid
                end
            end
        end
        CustomProfiler.stop("Client.onNewGuid", cpc9)
    end

    ------------------------------------------------------------------------------------------------
    --- onSeed
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent his seed to the client
    --- @param data table data { networkMessageId, seed }
    local function onSeed(data)
        local cpc10 = CustomProfiler.start("Client.onSeed")
        logger:debug(logger.channels.network, "onSeed: Seed from server received.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onSeed data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.seed) then
            error(("onSeed data.seed is empty: %s"):format(data.seed), 3)
        end

        sendAck(data.networkMessageId)

        local serversSeed = tonumber(data.seed)
        logger:info(logger.channels.network,
            "Client received servers seed (%s) and stored it. Reloading map with that seed!", serversSeed)

        local localSeed = tonumber(StatsGetValue("world_seed"))
        if localSeed ~= serversSeed then
            --util.reloadMap(serversSeed) TODO enable again, when custom map/biome isn't used anymore
        end

        local localPlayerInfo = util.getLocalPlayerInfo()
        local name            = localPlayerInfo.name
        local guid            = localPlayerInfo.guid
        local nuid            = localPlayerInfo.nuid -- Could be nil. Timing issue. Will be set after this.
        local entityId        = localPlayerInfo.entityId

        self:send(NetworkUtils.events.playerInfo.name,
            { NetworkUtils.getNextNetworkMessageId(), name, guid, nuid, _G.NoitaMPVersion })

        if not NetworkVscUtils.hasNetworkLuaComponents(entityId) then
            NetworkVscUtils.addOrUpdateAllVscs(entityId, name, guid, nil)
        end

        if not NetworkVscUtils.hasNuidSet(entityId) then
            self.sendNeedNuid(name, guid, entityId)
        end
        CustomProfiler.stop("Client.onSeed", cpc10)
    end

    ------------------------------------------------------------------------------------------------
    --- onNewNuid
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent a new nuid to the client
    --- @param data table data { networkMessageId, owner { name, guid }, localEntityId, newNuid, x, y, rotation,
    --- velocity { x, y }, filename }
    local function onNewNuid(data)
        local cpc11 = CustomProfiler.start("Client.onNewNuid")
        logger:debug(logger.channels.network, ("Received a new nuid! data = %s"):format(util.pformat(data)))

        if util.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(util.pformat(data.owner)), 3)
        end

        if util.IsEmpty(data.localEntityId) then
            error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
        end

        if util.IsEmpty(data.newNuid) then
            error(("onNewNuid data.newNuid is empty: %s"):format(data.newNuid), 3)
        end

        if util.IsEmpty(data.x) then
            error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
        end

        if util.IsEmpty(data.y) then
            error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
        end

        if util.IsEmpty(data.rotation) then
            error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
        end

        if util.IsEmpty(data.velocity) then
            error(("onNewNuid data.velocity is empty: %s"):format(util.pformat(data.velocity)), 3)
        end

        if util.IsEmpty(data.filename) then
            error(("onNewNuid data.filename is empty: %s"):format(data.filename), 3)
        end

        if util.IsEmpty(data.health) then
            error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
        end

        if util.IsEmpty(data.isPolymorphed) then
            error(("onNewNuid data.isPolymorphed is empty: %s"):format(data.isPolymorphed), 3)
        end

        sendAck(data.networkMessageId)

        local owner         = data.owner
        local localEntityId = data.localEntityId
        local newNuid       = data.newNuid
        local x             = data.x
        local y             = data.y
        local rotation      = data.rotation
        local velocity      = data.velocity
        local filename      = data.filename
        local health        = data.health
        local isPolymorphed = data.isPolymorphed

        if owner.guid == util.getLocalPlayerInfo().guid then
            if localEntityId == util.getLocalPlayerInfo().entityId then
                self.nuid = newNuid
            end
        end

        EntityUtils.spawnEntity(owner, newNuid, x, y, rotation, velocity, filename, localEntityId, health,
            isPolymorphed)
        CustomProfiler.stop("Client.onNewNuid", cpc11)
    end

    local function onEntityData(data)
        local cpc12 = CustomProfiler.start("Client.onEntityData")
        logger:debug(logger.channels.network, ("Received entityData for nuid = %s! data = %s")
            :format(data.nuid, util.pformat(data)))

        if util.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(util.pformat(data.owner)), 3)
        end

        --if util.IsEmpty(data.localEntityId) then
        --    error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
        --end

        if util.IsEmpty(data.nuid) then
            error(("onNewNuid data.nuid is empty: %s"):format(data.nuid), 3)
        end

        if util.IsEmpty(data.x) then
            error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
        end

        if util.IsEmpty(data.y) then
            error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
        end

        if util.IsEmpty(data.rotation) then
            error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
        end

        if util.IsEmpty(data.velocity) then
            error(("onNewNuid data.velocity is empty: %s"):format(util.pformat(data.velocity)), 3)
        end

        if util.IsEmpty(data.health) then
            error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
        end

        -- sendAck(data.networkMessageId) do not send ACK for position data, network will explode

        local owner                = data.owner
        local gNuid, localEntityId = GlobalsUtils.getNuidEntityPair(data.nuid)
        local nuid                 = data.nuid
        local x                    = data.x
        local y                    = data.y
        local rotation             = data.rotation
        local velocity             = data.velocity
        local health               = data.health

        if self.nuid ~= nuid then
            NoitaComponentUtils.setEntityData(localEntityId, x, y, rotation, velocity, health)
        else
            logger:warn(logger.channels.network, ("Received entityData for self.nuid = %s! data = %s")
                :format(data.nuid, util.pformat(data)))
        end
        CustomProfiler.stop("Client.onEntityData", cpc12)
    end

    local function onDeadNuids(data)
        local cpc13     = CustomProfiler.start("Client.onDeadNuids")
        local deadNuids = data.deadNuids or data or {}
        for i = 1, #deadNuids do
            local deadNuid = deadNuids[i]
            if util.IsEmpty(deadNuid) or deadNuid == "nil" then
                logger:error(logger.channels.network, ("onDeadNuids deadNuid is empty: %s"):format(deadNuid), 3)
            else
                EntityUtils.destroyByNuid(deadNuid)
                GlobalsUtils.removeDeadNuid(deadNuid)
            end
        end
        CustomProfiler.stop("Client.onDeadNuids", cpc13)
    end

    local function onNeedModList(data)
        local cpc        = CustomProfiler.start("Client.onNeedModList")
        local activeMods = ModGetActiveModIDs()
        local function contains(elem)
            for _, value in pairs(activeMods) do
                if value == elem then
                    return true
                end
            end
            return false
        end

        self.requiredMods = data.workshop
        local conflicts = {}
        for _, v in ipairs(data.workshop) do
            if not contains(v.name) then
                table.insert(conflicts, v)
            end
        end
        for _, v in ipairs(data.external) do
            table.insert(self.requiredMods, v)
            if not contains(v.name) then
                table.insert(conflicts, v)
            end
        end

        -- Display a prompt if mod conflicts are detected
        if #conflicts > 0 then
            self.missingMods = conflicts
            logger:info("Mod conflicts detected: Missing " .. table.concat(conflicts, ", "))
        end
        CustomProfiler.stop("Client.onNeedModList", cpc)
    end

    local function onNeedModContent(data)
        local cpc = CustomProfiler.start("Client.onNeedModContent")
        for _, v in ipairs(data.items) do
            local modName = v.name
            local modID = v.workshopID
            local modData = v.data
            if modID == "0" then
                if not fu.IsDirectory((fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName)) then
                    local fileName = ("%s_%s_mod_sync.7z"):format(tostring(os.date("!")), modName)
                    fu.WriteBinaryFile(fu.GetAbsoluteDirectoryPathOfMods() .. "/" .. fileName, modData)
                    fu.Extract7zipArchive(fu.GetAbsoluteDirectoryPathOfMods(), fileName,
                        (fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName))
                end
            else
                if not fu.IsDirectory(("C:/Program Files (x86)/Steam/steamapps/workshop/content/881100/%s/"):format(modID)) then
                    if not fu.IsDirectory((fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName)) then
                        local fileName = ("%s_%s_mod_sync.7z"):format(tostring(os.date("!")), modName)
                        fu.WriteBinaryFile(fu.GetAbsoluteDirectoryPathOfMods() .. "/" .. fileName, modData)
                        fu.Extract7zipArchive(fu.GetAbsoluteDirectoryPathOfMods(), fileName,
                            (fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName))
                    end
                end
            end
        end
        CustomProfiler.stop("Client.onNeedModContent", cpc)
    end

    -- self:on(
    --     "entityAlive",
    --     function(data)
    --         logger:debug(util.pformat(data))

    --         em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
    --     end
    -- )

    -- self:on(
    --     "entityState",
    --     function(data)
    --         logger:debug(util.pformat(data))

    --         local nc = em:GetNetworkComponent(data.owner, data.localEntityId, data.nuid)
    --         if nc then
    --             EntityApplyTransform(nc.local_entity_id, data.x, data.y, data.rot)
    --         else
    --             logger:warn(logger.channels.network,
    --                 "Got entityState, but unable to find the network component!" ..
    --                 " owner(%s, %s), localEntityId(%s), nuid(%s), x(%s), y(%s), rot(%s), velocity(x %s, y %s), health(%s)",
    --                 data.owner.name,
    --                 data.owner.guid,
    --                 data.localEntityId,
    --                 data.nuid,
    --                 data.x,
    --                 data.y,
    --                 data.rot,
    --                 data.velocity.x,
    --                 data.velocity.y,
    --                 data.health
    --             )
    --         end
    --     end
    -- )

    ------------------------------------------------------------------------------------------------
    --- setCallbackAndSchemas
    ------------------------------------------------------------------------------------------------
    --- Sets callbacks and schemas of the client.
    local function setCallbackAndSchemas()
        local cpc14 = CustomProfiler.start("Client.setCallbackAndSchemas")
        --self:setSchema(NetworkUtils.events.connect, { "code" })
        self:on(NetworkUtils.events.connect.name, onConnect)

        self:setSchema(NetworkUtils.events.connect2.name, NetworkUtils.events.connect2.schema)
        self:on(NetworkUtils.events.connect2.name, onConnect2)

        --self:setSchema(NetworkUtils.events.disconnect, { "code" })
        self:on(NetworkUtils.events.disconnect.name, onDisconnect)

        self:setSchema(NetworkUtils.events.disconnect2.name, NetworkUtils.events.disconnect2.schema)
        self:on(NetworkUtils.events.disconnect2.name, onDisconnect2)

        self:setSchema(NetworkUtils.events.acknowledgement.name, NetworkUtils.events.acknowledgement.schema)
        self:on(NetworkUtils.events.acknowledgement.name, onAcknowledgement)

        self:setSchema(NetworkUtils.events.seed.name, NetworkUtils.events.seed.schema)
        self:on(NetworkUtils.events.seed.name, onSeed)

        self:setSchema(NetworkUtils.events.playerInfo.name, NetworkUtils.events.playerInfo.schema)
        self:on(NetworkUtils.events.playerInfo.name, onPlayerInfo)

        self:setSchema(NetworkUtils.events.newGuid.name, NetworkUtils.events.newGuid.schema)
        self:on(NetworkUtils.events.newGuid.name, onNewGuid)

        self:setSchema(NetworkUtils.events.newNuid.name, NetworkUtils.events.newNuid.schema)
        self:on(NetworkUtils.events.newNuid.name, onNewNuid)

        self:setSchema(NetworkUtils.events.entityData.name, NetworkUtils.events.entityData.schema)
        self:on(NetworkUtils.events.entityData.name, onEntityData)

        self:setSchema(NetworkUtils.events.deadNuids.name, NetworkUtils.events.deadNuids.schema)
        self:on(NetworkUtils.events.deadNuids.name, onDeadNuids)

        self:setSchema(NetworkUtils.events.needModList.name, NetworkUtils.events.needModList.schema)
        self:on(NetworkUtils.events.needModList.name, onNeedModList)

        self:setSchema(NetworkUtils.events.needModContent.name, NetworkUtils.events.needModContent.schema)
        self:on(NetworkUtils.events.needModContent.name, onNeedModContent)
        -- self:setSchema("duplicatedGuid", { "newGuid" })
        -- self:setSchema("worldFiles", { "relDirPath", "fileName", "fileContent", "fileIndex", "amountOfFiles" })
        -- self:setSchema("worldFilesFinished", { "progress" })
        -- self:setSchema("seed", { "seed" })
        -- self:setSchema("clientInfo", { "name", "guid" })
        -- self:setSchema("needNuid", { "owner", "localEntityId", "x", "y", "rot", "velocity", "filename" })
        -- self:setSchema("newNuid", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "filename" })
        -- self:setSchema("entityAlive", { "owner", "localEntityId", "nuid", "isAlive" })
        -- self:setSchema("entityState", { "owner", "localEntityId", "nuid", "x", "y", "rot", "velocity", "health" })

        CustomProfiler.stop("Client.setCallbackAndSchemas", cpc14)
    end

    local function updateVariables()
        local cpc15    = CustomProfiler.start("Client.updateVariables")
        local entityId = util.getLocalPlayerInfo().entityId
        if entityId then
            local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
            self.health                                                                              = health
            self.transform                                                                           = { x = math.floor(x), y = math.floor(y) }

            if not compNuid then
                self.sendNeedNuid(compOwnerName, compOwnerGuid, entityId)
            end
        end
        CustomProfiler.stop("Client.updateVariables", cpc15)
    end

    ------------------------------------
    -- Public methods:
    ------------------------------------

    --#region Connect and disconnect

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientConnect = sockClient.connect
    --- Connects to a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number port number from 1 to max of 65535 or nil
    --- @param code number connection code 0 = connecting first time, 1 = connected second time with loaded seed
    function self.connect(ip, port, code)
        local cpc16 = CustomProfiler.start("Client.connect")

        if self:isConnecting() or self:isConnected() then
            logger:warn(logger.channels.network, "Client is still connected to %s:%s. Disconnecting!",
                self:getAddress(), self:getPort())
            self:disconnect()
        end

        if not ip then
            local cpc29 = CustomProfiler.start("ModSettingGet")
            ip          = tostring(ModSettingGet("noita-mp.connect_server_ip"))
            CustomProfiler.stop("ModSettingGet", cpc29)
        end

        if not port then
            local cpc30 = CustomProfiler.start("ModSettingGet")
            port        = tonumber(ModSettingGet("noita-mp.connect_server_port"))
            CustomProfiler.stop("ModSettingGet", cpc30)
        end

        port = tonumber(port)

        self.disconnect()
        _G.Client.disconnect() -- stop if any server is already running

        logger:info(logger.channels.network, "Connecting to server on %s:%s", ip, port)
        if not self.host then
            self:establishClient(ip, port)
        end

        GamePrintImportant("Client is connecting..",
            "You are trying to connect to " .. self:getAddress() .. ":" .. self:getPort() .. "!",
            ""
        )

        sockClientConnect(self, code)

        -- FYI: If you want to send data after connected, do it in the "connect" callback function
        CustomProfiler.stop("Client.connect", cpc16)
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientDisconnect = sockClient.disconnect
    function self.disconnect()
        local cpc17 = CustomProfiler.start("Client.disconnect")
        if self.isConnected() then
            sockClientDisconnect(self)
        else
            logger:info(logger.channels.network, "Client isn't connected, no need to disconnect!")
        end
        CustomProfiler.stop("Client.disconnect", cpc17)
    end

    --#endregion

    --#region Additional methods

    local sockClientIsConnected = sockClient.isConnected
    function self.isConnected()
        return sockClientIsConnected(self)
    end

    --local lastFrames = 0
    --local diffFrames = 0
    --local fps30 = 0
    local prevTime         = 0
    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientUpdate = sockClient.update
    --- Updates the Client by checking for network events and handling them.
    function self.update()
        local cpc18 = CustomProfiler.start("Client.update")
        if not self.isConnected() and not self:isConnecting() or self:isDisconnected() then
            return
        end

        --EntityUtils.destroyClientEntities()
        --EntityUtils.processEntityNetworking()
        --EntityUtils.initNetworkVscs()

        EntityUtils.processAndSyncEntityNetworking()

        local nowTime     = GameGetRealWorldTimeSinceStarted() * 1000 -- *1000 to get milliseconds
        local elapsedTime = nowTime - prevTime
        local cpc31       = CustomProfiler.start("ModSettingGet")
        local oneTickInMs = 1000 / tonumber(ModSettingGet("noita-mp.tick_rate"))
        CustomProfiler.stop("ModSettingGet", cpc31)
        if elapsedTime >= oneTickInMs then
            prevTime = nowTime
            --updateVariables()

            --EntityUtils.destroyClientEntities()
            --EntityUtils.syncEntityData()
            --EntityUtils.syncDeadNuids()
        end

        sockClientUpdate(self)
        CustomProfiler.stop("Client.update", cpc18)
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientSend = sockClient.send

    function self:send(event, data)
        local cpc19 = CustomProfiler.start("Client.send")
        if type(data) ~= "table" then
            error("", 3)
        end

        if NetworkUtils.alreadySent(event, data) then
            logger:debug(logger.channels.network, ("Network message for %s for data %s already was acknowledged.")
                :format(event, util.pformat(data)))
            return
        end

        local networkMessageId = sockClientSend(self, event, data)

        if not self.acknowledge then
            self.acknowledge = {}
        end

        if event ~= NetworkUtils.events.acknowledgement.name then
            if not self.acknowledge[networkMessageId] then
                self.acknowledge[networkMessageId] = {}
            end

            self.acknowledge[networkMessageId] = { event  = event, data = data, entityId = data.entityId,
                                                   status = NetworkUtils.events.acknowledgement.sent, sentAt = os.time() }
        end
        CustomProfiler.stop("Client.send", cpc19)
    end

    function self.sendNeedNuid(ownerName, ownerGuid, entityId)
        local cpc20 = CustomProfiler.start("Client.sendNeedNuid")
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end

        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local data                                                                               = {
            NetworkUtils.getNextNetworkMessageId(), { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
            filename, health, EntityUtils.isEntityPolymorphed(entityId)--EntityUtils.isPlayerPolymorphed()
        }

        self:send(NetworkUtils.events.needNuid.name, data)
        CustomProfiler.stop("Client.sendNeedNuid", cpc20)
    end

    function self.sendLostNuid(nuid)
        local cpc21 = CustomProfiler.start("Client.sendLostNuid")
        local data  = { NetworkUtils.getNextNetworkMessageId(), nuid }
        self:send(NetworkUtils.events.lostNuid.name, data)
        CustomProfiler.stop("Client.sendLostNuid", cpc21)
    end

    function self.sendEntityData(entityId)
        local cpc22 = CustomProfiler.start("Client.sendEntityData")
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end

        --local compOwnerName, compOwnerGuid, compNuid     = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local data                                                                               = {
            NetworkUtils.getNextNetworkMessageId(), { compOwnerName, compOwnerGuid }, compNuid, x, y, rotation, velocity, health
        }

        if util.IsEmpty(compNuid) then
            -- this can happen, when entity spawned on client and network is slow
            logger:error(logger.channels.network, "Unable to send entity data, because nuid is empty.")
            self.sendNeedNuid(compOwnerName, compOwnerGuid, entityId)
            return
        end

        if util.getLocalPlayerInfo().guid == compOwnerGuid then
            self:send(NetworkUtils.events.entityData.name, data)
        end
        CustomProfiler.stop("Client.sendEntityData", cpc22)
    end

    function self.sendDeadNuids(deadNuids)
        local cpc23 = CustomProfiler.start("Client.sendDeadNuids")
        local data  = {
            NetworkUtils.getNextNetworkMessageId(), deadNuids
        }
        self:send(NetworkUtils.events.deadNuids.name, data)
        onDeadNuids(deadNuids)
        CustomProfiler.stop("Client.sendDeadNuids", cpc23)
    end

    --- Checks if the current local user is a client
    --- @return boolean iAm true if client
    function self.amIClient()
        --local cpc24 = CustomProfiler.start("Client.amIClient") DO NOT PROFILE, stack overflow error! See CustomProfiler.lua
        if not _G.Server.amIServer() then
            --CustomProfiler.stop("Client.amIClient", cpc24)
            return true
        end
        --CustomProfiler.stop("Client.amIClient", cpc24)
        return false
    end

    --#endregion

    ------------------------------------
    -- Apply some private methods
    ------------------------------------
    setGuid()
    setConfigSettings()
    setCallbackAndSchemas()

    CustomProfiler.stop("Client.new", cpc)
    return self
end

------------------------------------
-- Init this object:
------------------------------------

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.ClientInit = Client
_G.Client     = Client.new(sock.newClient())

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Client
