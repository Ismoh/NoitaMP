---ClientInit class for creating a new extended instance of SockClient.
---@see SockClient
---@class ClientInit
local ClientInit  = {}

--- 'Imports'
local sock        = require("sock")
local zstandard   = require("zstd")
local messagePack = require("MessagePack")


---@param sockClient SockClient
---@return SockClient self
function ClientInit.new(sockClient)
    local cpc               = CustomProfiler.start("ClientInit.new")
    ---@class SockClient
    local self              = sockClient
    self.iAm                = "CLIENT"
    self.name               = NoitaMpSettings.get("noita-mp.nickname", "string")
    -- guid might not be set here or will be overwritten at the end of the constructor. @see setGuid
    self.guid               = NoitaMpSettings.get("noita-mp.guid", "string")
    self.nuid               = nil
    self.acknowledgeMaxSize = 500
    self.transform          = { x = 0, y = 0 }
    self.health             = { current = 99, max = 100 }
    self.serverInfo         = {}
    self.otherClients       = {}
    self.missingMods        = nil
    self.requiredMods       = nil
    self.syncedMods         = false

    --- Set clients settings
    local function setConfigSettings()
        local cpc1        = CustomProfiler.start("ClientInit.setConfigSettings")
        local serialize   = function(anyValue)
            local cpc2            = CustomProfiler.start("ClientInit.setConfigSettings.serialize")
            --logger:debug(logger.channels.network, ("Serializing value: %s"):format(anyValue))
            local serialized      = messagePack.pack(anyValue)
            local zstd            = zstandard:new()
            --logger:debug(logger.channels.network, "Uncompressed size:", string.len(serialized))
            local compressed, err = zstd:compress(serialized)
            if err then
                error("Error while compressing: " .. err, 2)
            end
            --logger:debug(logger.channels.network, "Compressed size:", string.len(compressed))
            --logger:debug(logger.channels.network, ("Serialized and compressed value: %s"):format(compressed))
            zstd:free()
            CustomProfiler.stop("ClientInit.setConfigSettings.serialize", cpc2)
            return compressed
        end

        local deserialize = function(anyValue)
            local cpc3              = CustomProfiler.start("ClientInit.setConfigSettings.deserialize")
            --logger:debug(logger.channels.network, ("Serialized and compressed value: %s"):format(anyValue))
            local zstd              = zstandard:new()
            --logger:debug(logger.channels.network, "Compressed size:", string.len(anyValue))
            local decompressed, err = zstd:decompress(anyValue)
            if err then
                error("Error while decompressing: " .. err, 2)
            end
            --logger:debug(logger.channels.network, "Uncompressed size:", string.len(decompressed))
            local deserialized = messagePack.unpack(decompressed)
            Logger.debug(Logger.channels.network, ("Deserialized and uncompressed value: %s"):format(deserialized))
            zstd:free()
            CustomProfiler.stop("ClientInit.setConfigSettings.deserialize", cpc3)
            return deserialized
        end

        self:setSerialization(serialize, deserialize)
        self:setTimeout(320, 50000, 100000)
        CustomProfiler.stop("ClientInit.setConfigSettings", cpc1)
    end


    --- Set clients guid
    local function setGuid()
        local cpc1 = CustomProfiler.start("ClientInit.setGuid")
        local guid = NoitaMpSettings.get("noita-mp.guid", "string")

        if guid == "" or GuidUtils.isPatternValid(guid) == false then
            guid = GuidUtils:getGuid()
            NoitaMpSettings.set("noita-mp.guid", guid)
            self.guid = guid
            Logger.debug(Logger.channels.network, "Clients guid set to " .. guid)
        else
            Logger.debug(Logger.channels.network, "Clients guid was already set to " .. guid)
        end

        if DebugGetIsDevBuild() then
            guid = guid .. self.iAm
        end
        CustomProfiler.stop("ClientInit.setGuid", cpc1)
    end


    --- Send acknowledgement
    local function sendAck(networkMessageId, event)
        local cpc2 = CustomProfiler.start("ClientInit.sendAck")
        if not event then
            error("event is nil", 2)
        end
        local data = { networkMessageId, event, NetworkUtils.events.acknowledgement.ack, os.clock() }
        self:send(NetworkUtils.events.acknowledgement.name, data)
        Logger.debug(Logger.channels.network, ("Sent ack with data = %s"):format(Utils.pformat(data)))
        CustomProfiler.stop("ClientInit.sendAck", cpc2)
    end


    --- onAcknowledgement
    local function onAcknowledgement(data)
        local cpc3 = CustomProfiler.start("ClientInit.onAcknowledgement")
        Logger.debug(Logger.channels.network, "onAcknowledgement: Acknowledgement received.", Utils.pformat(data))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onAcknowledgement data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
        end

        if not data.networkMessageId then
            error(("Unable to get acknowledgement with networkMessageId = %s, data = %s, peer = %s")
                :format(networkMessageId, Utils.pformat(data), Utils.pformat(self)), 2)
        end

        if Utils.IsEmpty(data.event) then
            error(("onAcknowledgement data.event is empty: %s"):format(data.event), 2)
        end

        if Utils.IsEmpty(data.status) then
            error(("onAcknowledgement data.status is empty: %s"):format(data.status), 2)
        end

        if Utils.IsEmpty(data.ackedAt) then
            error(("onAcknowledgement data.ackedAt is empty: %s"):format(data.ackedAt), 2)
        end

        if not self.clientCacheId then
            self.clientCacheId = GuidUtils.toNumber(peer.guid)
        end

        local cachedData = NetworkCacheUtils.get(self.guid, data.networkMessageId, data.event)
        if Utils.IsEmpty(cachedData) then
            NetworkCacheUtils.logAll()
            error(("Unable to get cached data, because it is nil '%s'"):format(cachedData), 2)
        end
        if Utils.IsEmpty(cachedData.dataChecksum) or type(cachedData.dataChecksum) ~= "string" then
            NetworkCacheUtils.logAll()
            error(("Unable to get cachedData.dataChecksum, because it is nil '%s' or checksum is not of type string, type: %s")
                :format(cachedData.dataChecksum, type(cachedData.dataChecksum)), 2)
        end
        -- update previous cached network message
        NetworkCacheUtils.ack(self.guid, data.networkMessageId, data.event,
            data.status, os.clock(), cachedData.sendAt, cachedData.dataChecksum)

        if NetworkCache.size() > self.acknowledgeMaxSize then
            NetworkCache.removeOldest()
        end
        CustomProfiler.stop("ClientInit.onAcknowledgement", cpc3)
    end


    --- onConnect
    --- Callback when connected to server.
    --- @param data number not in use atm
    local function onConnect(data)
        local cpc4 = CustomProfiler.start("ClientInit.onConnect")
        Logger.debug(Logger.channels.network, "Connected to server!", Utils.pformat(data))

        if Utils.IsEmpty(data) then
            error(("onConnect data is empty: %s"):format(data), 3)
        end

        self.sendMinaInformation()

        self:send(NetworkUtils.events.needModList.name, { NetworkUtils.getNextNetworkMessageId(), {}, {} })

        -- sendAck(data.networkMessageId)
        CustomProfiler.stop("ClientInit.onConnect", cpc4)
    end


    --- onConnect2
    --- Callback when one of the other clients connected.
    --- @param data table data = { "name", "guid" } @see NetworkUtils.events.connect2.schema
    local function onConnect2(data)
        local cpc5 = CustomProfiler.start("ClientInit.onConnect2")
        Logger.debug(Logger.channels.network, "Another client connected.", Utils.pformat(data))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onConnect2 data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if Utils.IsEmpty(data.name) then
            error(("onConnect2 data.name is empty: %s"):format(data.name), 3)
        end

        if Utils.IsEmpty(data.guid) then
            error(("onConnect2 data.guid is empty: %s"):format(data.guid), 3)
        end

        table.insertIfNotExist(self.otherClients, { name = data.name, guid = data.guid, transofrm = data.transform })

        sendAck(data.networkMessageId, NetworkUtils.events.connect2.name)
        CustomProfiler.stop("ClientInit.onConnect2", cpc5)
    end


    --- onDisconnect
    --- Callback when disconnected from server.
    --- @param data number data(.code) = 0
    local function onDisconnect(data)
        local cpc6 = CustomProfiler.start("ClientInit.onDisconnect")
        Logger.debug(Logger.channels.network, "Disconnected from server!", Utils.pformat(data))

        if Utils.IsEmpty(data) then
            error(("onDisconnect data is empty: %s"):format(data), 3)
        end

        if self.serverInfo.nuid then
            EntityUtils.destroyByNuid(self, self.serverInfo.nuid)
        end

        -- TODO remove all NUIDS from entities. I now need a nuid-entityId-cache.
        local nuid, entityId = GlobalsUtils.getNuidEntityPair(self.nuid)
        NetworkVscUtils.addOrUpdateAllVscs(entityId, self.name, self.guid, nil)

        self.nuid         = nil
        self.otherClients = {}
        self.serverInfo   = {}

        -- sendAck(data.networkMessageId)
        CustomProfiler.stop("ClientInit.onDisconnect", cpc6)
    end


    --- onDisconnect2
    --- Callback when one of the other clients disconnected.
    --- @param data table data { "name", "guid" } @see NetworkUtils.events.disconnect2.schema
    local function onDisconnect2(data)
        local cpc7 = CustomProfiler.start("ClientInit.onDisconnect2")
        Logger.debug(Logger.channels.network, "onDisconnect2: Another client disconnected.", Utils.pformat(data))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onDisconnect2 data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if Utils.IsEmpty(data.name) then
            error(("onDisconnect2 data.name is empty: %s"):format(data.name), 3)
        end

        if Utils.IsEmpty(data.guid) then
            error(("onDisconnect2 data.guid is empty: %s"):format(data.guid), 3)
        end

        for i = 1, #self.otherClients do
            if data.guid == self.otherClients[i].guid then
                table.remove(self.otherClients, i)
                break
            end
        end

        sendAck(data.networkMessageId, NetworkUtils.events.disconnect2.name)
        CustomProfiler.stop("ClientInit.onDisconnect2", cpc7)
    end


    --- onMinaInformation
    --- Callback when Server sent his minaInformation to the client
    --- @param data table data @see NetworkUtils.events.minaInformation.schema
    local function onMinaInformation(data)
        local cpc8 = CustomProfiler.start("ClientInit.onMinaInformation")
        Logger.debug(Logger.channels.network, "onMinaInformation: Player info received.", Utils.pformat(data))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onMinaInformation data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
        end

        if Utils.IsEmpty(data.version) then
            error(("onMinaInformation data.version is empty: %s"):format(data.version), 2)
        end

        if Utils.IsEmpty(data.name) then
            error(("onMinaInformation data.name is empty: %s"):format(data.name), 2)
        end

        if Utils.IsEmpty(data.guid) then
            error(("onMinaInformation data.guid is empty: %s"):format(data.guid), 2)
        end

        if Utils.IsEmpty(data.entityId) or data.entityId == -1 then
            error(("onMinaInformation data.entityId is empty: %s"):format(data.entityId), 2)
        end

        -- if Utils.IsEmpty(data.nuid) or data.nuid == -1 then
        --     error(("onMinaInformation data.nuid is empty: %s"):format(data.nuid), 2)
        -- end

        if Utils.IsEmpty(data.transform) then
            error(("onMinaInformation data.transform is empty: %s"):format(data.transform), 2)
        end

        if Utils.IsEmpty(data.health) then
            error(("onMinaInformation data.health is empty: %s"):format(data.health), 2)
        end


        if data.guid == self.guid then
            Logger.warn(Logger.channels.network,
                ("onMinaInformation: Clients GUID %s isn't unique! Server will fix this!"):format(self.guid))
        end

        if FileUtils.GetVersionByFile() ~= tostring(data.version) then
            error(("Version mismatch: NoitaMP version of Server: %s and your version: %s")
                :format(data.version, FileUtils.GetVersionByFile()), 3)
            self.disconnect()
        end

        self.serverInfo.version = data.version
        self.serverInfo.name = data.name
        self.serverInfo.guid = data.guid
        self.serverInfo.entityId = data.entityId
        self.serverInfo.nuid = data.nuid
        self.serverInfo.transform = data.transform
        self.serverInfo.health = data.health

        sendAck(data.networkMessageId, NetworkUtils.events.minaInformation.name)
        CustomProfiler.stop("ClientInit.onMinaInformation", cpc8)
    end


    --- onNewGuid
    --- Callback when Server sent a new GUID for a specific client.
    --- @param data table data { "networkMessageId", "oldGuid", "newGuid" }
    local function onNewGuid(data)
        local cpc9 = CustomProfiler.start("ClientInit.onNewGuid")
        Logger.debug(Logger.channels.network, ("onNewGuid: New GUID from server received."):format(Utils.pformat(data)))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onNewGuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
        end

        if Utils.IsEmpty(data.oldGuid) then
            error(("onNewGuid data.oldGuid is empty: %s"):format(data.oldGuid), 2)
        end

        if Utils.IsEmpty(data.newGuid) then
            error(("onNewGuid data.newGuid is empty: %s"):format(data.newGuid), 2)
        end

        if data.oldGuid == self.guid then
            local entityId                               = MinaUtils.getLocalMinaInformation().entityId
            local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(entityId)

            self.guid                                    = data.newGuid
            NoitaMpSettings.set("noita-mp.guid", self.guid)
            NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, self.guid, compNuid)
        else
            for i = 1, #self.otherClients do
                if self.otherClients[i].guid == data.oldGuid then
                    self.otherClients[i].guid = data.newGuid
                end
            end
        end

        sendAck(data.networkMessageId, NetworkUtils.events.newGuid.name)
        CustomProfiler.stop("ClientInit.onNewGuid", cpc9)
    end


    --- onSeed
    --- Callback when Server sent his seed to the client
    --- @param data table data { networkMessageId, seed }
    local function onSeed(data)
        local cpc10 = CustomProfiler.start("ClientInit.onSeed")
        Logger.debug(Logger.channels.network, "onSeed: Seed from server received.", Utils.pformat(data))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onSeed data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if Utils.IsEmpty(data.seed) then
            error(("onSeed data.seed is empty: %s"):format(data.seed), 3)
        end

        local serversSeed = tonumber(data.seed)
        Logger.info(Logger.channels.network,
            ("Client received servers seed (%s) and stored it. Reloading map with that seed!")
            :format(serversSeed))

        local localSeed = tonumber(StatsGetValue("world_seed"))
        if localSeed ~= serversSeed then
            if not DebugGetIsDevBuild() then
                Utils.ReloadMap(serversSeed)
            end
        end

        local entityId = MinaUtils.getLocalMinaEntityId()
        local name = MinaUtils.getLocalMinaName()
        local guid = MinaUtils.getLocalMinaGuid()
        if not NetworkVscUtils.hasNetworkLuaComponents(entityId) then
            NetworkVscUtils.addOrUpdateAllVscs(entityId, name, guid, nil)
        end
        if not NetworkVscUtils.hasNuidSet(entityId) then
            self.sendNeedNuid(name, guid, entityId)
        end

        sendAck(data.networkMessageId, NetworkUtils.events.seed.name)
        CustomProfiler.stop("ClientInit.onSeed", cpc10)
    end


    --- onNewNuid
    --- Callback when Server sent a new nuid to the client
    --- @param data table data { networkMessageId, owner { name, guid }, localEntityId, newNuid, x, y, rotation,
    --- velocity { x, y }, filename }
    local function onNewNuid(data)
        local cpc11 = CustomProfiler.start("ClientInit.onNewNuid")
        Logger.debug(Logger.channels.network, ("Received a new nuid! data = %s"):format(Utils.pformat(data)))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if Utils.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(Utils.pformat(data.owner)), 3)
        end

        if Utils.IsEmpty(data.localEntityId) then
            error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
        end

        if Utils.IsEmpty(data.newNuid) then
            error(("onNewNuid data.newNuid is empty: %s"):format(data.newNuid), 3)
        end

        if Utils.IsEmpty(data.x) then
            error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
        end

        if Utils.IsEmpty(data.y) then
            error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
        end

        if Utils.IsEmpty(data.rotation) then
            error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
        end

        if Utils.IsEmpty(data.velocity) then
            error(("onNewNuid data.velocity is empty: %s"):format(Utils.pformat(data.velocity)), 3)
        end

        if Utils.IsEmpty(data.filename) then
            error(("onNewNuid data.filename is empty: %s"):format(data.filename), 3)
        end

        if Utils.IsEmpty(data.health) then
            error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
        end

        if Utils.IsEmpty(data.isPolymorphed) then
            error(("onNewNuid data.isPolymorphed is empty: %s"):format(data.isPolymorphed), 3)
        end

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

        if owner.guid == MinaUtils.getLocalMinaInformation().guid then
            if localEntityId == MinaUtils.getLocalMinaInformation().entityId then
                self.nuid = newNuid
            end
        end

        EntityUtils.spawnEntity(owner, newNuid, x, y, rotation, velocity, filename, localEntityId, health,
            isPolymorphed)

        sendAck(data.networkMessageId, NetworkUtils.events.newNuid.name)
        CustomProfiler.stop("ClientInit.onNewNuid", cpc11)
    end

    local function onNewNuidSerialized(data)
        local cpc32 = CustomProfiler.start("ClientInit.onNewNuidSerialized")
        Logger.debug(Logger.channels.network,
            ("Received a new nuid onNewNuidSerialized! data = %s"):format(Utils.pformat(data)))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onNewNuidSerialized data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
        end

        if Utils.IsEmpty(data.ownerName) then
            error(("onNewNuidSerialized data.ownerName is empty: %s"):format(Utils.pformat(data.ownerName)), 2)
        end

        if Utils.IsEmpty(data.ownerGuid) then
            error(("onNewNuidSerialized data.ownerGuid is empty: %s"):format(Utils.pformat(data.ownerGuid)), 2)
        end

        if Utils.IsEmpty(data.entityId) then
            error(("onNewNuidSerialized data.entityId is empty: %s"):format(data.entityId), 2)
        end

        if Utils.IsEmpty(data.serializedEntityString) then
            error(("onNewNuidSerialized data.serializedEntityString is empty: %s"):format(data.serializedEntityString), 2)
        end

        if Utils.IsEmpty(data.nuid) then
            error(("onNewNuidSerialized data.nuid is empty: %s"):format(data.nuid), 2)
        end

        if Utils.IsEmpty(data.x) then
            error(("onNewNuidSerialized data.x is empty: %s"):format(data.x), 2)
        end

        if Utils.IsEmpty(data.y) then
            error(("onNewNuidSerialized data.y is empty: %s"):format(data.y), 2)
        end

        if Utils.IsEmpty(data.initialSerializedEntityString) then
            error(("onNewNuidSerialized data.initialSerializedEntityString is empty: %s"):format(data.initialSerializedEntityString), 2)
        end

        -- FOR TESTING ONLY, DO NOT MERGE
        --print(Utils.pformat(data))
        --os.exit()

        if data.ownerGuid == MinaUtils.getLocalMinaGuid() then
            if data.entityId == MinaUtils.getLocalMinaEntityId() then
                self.nuid = data.nuid
                NetworkVscUtils.addOrUpdateAllVscs(data.entityId, data.ownerName, data.ownerGuid, data.nuid)
            end
        end

        local nuid, entityId = GlobalsUtils.getNuidEntityPair(data.nuid)

        if Utils.IsEmpty(entityId) then
            local closestEntityId = EntityGetClosest(data.x, data.y)
            local initialSerializedEntityString = NoitaComponentUtils.getInitialSerializedEntityString(closestEntityId)
            if initialSerializedEntityString == data.initialSerializedEntityString then
                entityId = closestEntityId
            else
                entityId = EntityCreateNew(data.nuid)
            end
        else
            if EntityCache.contains(entityId) then
                local cachedEntity = EntityCache.get(entityId)
            end
        end


        entityId = NoitaPatcherUtils.deserializeEntity(entityId, data.serializedEntityString, data.x, data.y) --EntitySerialisationUtils.deserializeEntireRootEntity(data.serializedEntity, data.nuid)

        -- include exclude list of entityIds which shouldn't be spawned
        -- if filename:contains("player.xml") then
        --     filename = "mods/noita-mp/data/enemies_gfx/client_player_base.xml"
        -- end

        -- local entityId = EntityLoad(filename, x, y)
        -- if not EntityUtils.isEntityAlive(entityId) then
        --     return
        -- end

        local compIds = EntityGetAllComponents(entityId) or {}
        for i = 1, #compIds do
            local compId   = compIds[i]
            local compType = ComponentGetTypeName(compId)
            if table.contains(EntityUtils.remove.byComponentsName, compType) or
                table.contains(EntitySerialisationUtils.ignore.byComponentsType) then
                EntityRemoveComponent(entityId, compId)
            end
        end

        sendAck(data.networkMessageId, NetworkUtils.events.newNuidSerialized.name)
        CustomProfiler.stop("ClientInit.onNewNuidSerialized", cpc32)
    end

    local function onEntityData(data)
        local cpc12 = CustomProfiler.start("ClientInit.onEntityData")
        Logger.debug(Logger.channels.network, ("Received entityData for nuid = %s! data = %s")
            :format(data.nuid, Utils.pformat(data)))

        if Utils.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if Utils.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(Utils.pformat(data.owner)), 3)
        end

        --if Utils.IsEmpty(data.localEntityId) then
        --    error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
        --end

        if Utils.IsEmpty(data.nuid) then
            error(("onNewNuid data.nuid is empty: %s"):format(data.nuid), 3)
        end

        if Utils.IsEmpty(data.x) then
            error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
        end

        if Utils.IsEmpty(data.y) then
            error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
        end

        if Utils.IsEmpty(data.rotation) then
            error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
        end

        if Utils.IsEmpty(data.velocity) then
            error(("onNewNuid data.velocity is empty: %s"):format(Utils.pformat(data.velocity)), 3)
        end

        if Utils.IsEmpty(data.health) then
            error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
        end

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
            Logger.warn(Logger.channels.network, ("Received entityData for self.nuid = %s! data = %s")
                :format(data.nuid, Utils.pformat(data)))
        end

        -- sendAck(data.networkMessageId) do not send ACK for position data, network will explode
        CustomProfiler.stop("ClientInit.onEntityData", cpc12)
    end

    local function onDeadNuids(data)
        local cpc13     = CustomProfiler.start("ClientInit.onDeadNuids")
        local deadNuids = data.deadNuids or data or {}
        for i = 1, #deadNuids do
            local deadNuid = deadNuids[i]
            if Utils.IsEmpty(deadNuid) or deadNuid == "nil" then
                error(("onDeadNuids deadNuid is empty: %s"):format(deadNuid), 2)
            else
                EntityUtils.destroyByNuid(self, deadNuid)
                GlobalsUtils.removeDeadNuid(deadNuid)
                EntityCache.deleteNuid(deadNuid)
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
        local conflicts   = {}
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
            Logger.info("Mod conflicts detected: Missing " .. table.concat(conflicts, ", "))
        end
        CustomProfiler.stop("ClientInit.onNeedModList", cpc)
    end

    local function onNeedModContent(data)
        local cpc = CustomProfiler.start("ClientInit.onNeedModContent")
        for _, v in ipairs(data.items) do
            local modName = v.name
            local modID   = v.workshopID
            local modData = v.data
            if modID == "0" then
                if not FileUtils.IsDirectory((FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName)) then
                    local fileName = ("%s_%s_mod_sync.7z"):format(tostring(os.date("!")), modName)
                    FileUtils.WriteBinaryFile(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. "/" .. fileName, modData)
                    FileUtils.Extract7zipArchive(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP(), fileName,
                        (FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName))
                end
            else
                if not FileUtils.IsDirectory(("C:/Program Files (x86)/Steam/steamapps/workshop/content/881100/%s/"):format(modID)) then
                    if not FileUtils.IsDirectory((FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName)) then
                        local fileName = ("%s_%s_mod_sync.7z"):format(tostring(os.date("!")), modName)
                        FileUtils.WriteBinaryFile(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. "/" .. fileName, modData)
                        FileUtils.Extract7zipArchive(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP(), fileName,
                            (FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(modName))
                    end
                end
            end
        end
        CustomProfiler.stop("ClientInit.onNeedModContent", cpc)
    end

    local function onSendPlayerAreaData(data)
        local cpc = CustomProfiler.start("Client.onSendPlayerAreaData")
        WorldUtils.LoadEncodedArea(data.data)
        CustomProfiler.stop("Client.onSendPlayerAreaData", cpc)
    end

    -- self:on(
    --     "entityAlive",
    --     function(data)
    --         logger:debug(Utils.pformat(data))

    --         em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
    --     end
    -- )

    -- self:on(
    --     "entityState",
    --     function(data)
    --         logger:debug(Utils.pformat(data))

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


    --- setCallbackAndSchemas
    --- Sets callbacks and schemas of the client.
    local function setCallbackAndSchemas()
        local cpc14 = CustomProfiler.start("ClientInit.setCallbackAndSchemas")
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

        self:setSchema(NetworkUtils.events.minaInformation.name, NetworkUtils.events.minaInformation.schema)
        self:on(NetworkUtils.events.minaInformation.name, onMinaInformation)

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

        self:setSchema(NetworkUtils.events.newNuidSerialized.name, NetworkUtils.events.newNuidSerialized.schema)
        self:on(NetworkUtils.events.newNuidSerialized.name, onNewNuidSerialized)

        self:setSchema(NetworkUtils.events.sendPlayerAreaData.name, NetworkUtils.events.sendPlayerAreaData.schema)
        self:on(NetworkUtils.events.sendPlayerAreaData.name, onSendPlayerAreaData)

        CustomProfiler.stop("ClientInit.setCallbackAndSchemas", cpc14)
    end

    local function updateVariables()
        local cpc15    = CustomProfiler.start("Client.updateVariables")
        local entityId = MinaUtils.getLocalMinaInformation().entityId
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

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientConnect = sockClient.connect
    --- Connects to a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number? port number from 1 to max of 65535 or nil
    --- @param code number connection code 0 = connecting first time, 1 = connected second time with loaded seed
    function self.connect(ip, port, code)
        local cpc16 = CustomProfiler.start("ClientInit.connect")

        if self:isConnecting() or self:isConnected() then
            Logger.warn(Logger.channels.network, ("Client is still connected to %s:%s. Disconnecting!")
                :format(self:getAddress(), self:getPort()))
            self:disconnect()
        end

        if not ip then
            local cpc29 = CustomProfiler.start("ModSettingGet")
            ip          = tostring(ModSettingGet("noita-mp.connect_server_ip"))
            CustomProfiler.stop("ModSettingGet", cpc29)
        end

        if not port then
            local cpc30 = CustomProfiler.start("ModSettingGet")
            port        = tonumber(ModSettingGet("noita-mp.connect_server_port")) or error("noita-mp.connect_server_port wasn't a number")
            CustomProfiler.stop("ModSettingGet", cpc30)
        end

        port = tonumber(port) or error("noita-mp.connect_server_port wasn't a number")

        Logger.info(Logger.channels.network, ("Trying to connect to server on %s:%s"):format(ip, port))
        if not self.host then
            self:establishClient(ip, port)
        end

        GamePrintImportant("ClientInit is trying to connect to server..",
            "You are trying to connect to " .. self:getAddress() .. ":" .. self:getPort() .. "!",
            ""
        )

        sockClientConnect(self, code)

        -- FYI: If you want to send data after connected, do it in the "connect" callback function
        CustomProfiler.stop("ClientInit.connect", cpc16)
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientDisconnect = sockClient.disconnect
    function self.disconnect()
        local cpc17 = CustomProfiler.start("ClientInit.disconnect")
        if self.isConnected() then
            sockClientDisconnect(self)
        else
            Logger.info(Logger.channels.network, "Client isn't connected, no need to disconnect!")
        end
        CustomProfiler.stop("ClientInit.disconnect", cpc17)
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
    function self.update(startFrameTime)
        local cpc18 = CustomProfiler.start("ClientInit.update")
        if not self.isConnected() and not self:isConnecting() or self:isDisconnected() then
            CustomProfiler.stop("ClientInit.update", cpc18)
            return
        end

        if MinaUtils.getLocalMinaNuid() <= 0 then
            self.sendNeedNuid(MinaUtils.getLocalMinaName(), MinaUtils.getLocalMinaGuid(), MinaUtils.getLocalMinaEntityId())
        end
        self.sendMinaInformation()

        --EntityUtils.destroyClientEntities()
        --EntityUtils.processEntityNetworking()
        --EntityUtils.initNetworkVscs()

        EntityUtils.processAndSyncEntityNetworking(startFrameTime)

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
            EntityUtils.syncDeadNuids()
        end

        sockClientUpdate(self)
        CustomProfiler.stop("ClientInit.update", cpc18)
    end

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockClientSend = sockClient.send
    function self:send(event, data)
        local cpc19 = CustomProfiler.start("ClientInit.send")
        if type(data) ~= "table" then
            error(("Data is not type of table: %s"):format(data), 2)
            return false
        end

        if NetworkUtils.alreadySent(self, event, data) then
            Logger.debug(Logger.channels.network, ("Network message for %s for data %s already was acknowledged.")
                :format(event, Utils.pformat(data)))
            CustomProfiler.stop("ClientInit.send", cpc19)
            return false
        end

        local networkMessageId = sockClientSend(self, event, data)

        if event ~= NetworkUtils.events.acknowledgement.name then
            if NetworkUtils.events[event].isCacheable == true then
                NetworkCacheUtils.set(self.guid, networkMessageId, event,
                    NetworkUtils.events.acknowledgement.sent, 0, os.clock(), data)
            end
        end
        CustomProfiler.stop("ClientInit.send", cpc19)
        return true
    end

    ---Sends a message to the server that the client needs a nuid.
    ---@param ownerName string
    ---@param ownerGuid string
    ---@param entityId number
    function self.sendNeedNuid(ownerName, ownerGuid, entityId)
        local cpc20 = CustomProfiler.start("ClientInit.sendNeedNuid")

        if not ownerName then
            error("ownerName is nil")
        end
        if not ownerGuid then
            error("ownerGuid is nil")
        end
        if not entityId then
            error("entityId is nil")
        end

        if not EntityUtils.isEntityAlive(entityId) then
            return
        end

        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local data                                                                               = {
            NetworkUtils.getNextNetworkMessageId(), { ownerName, ownerGuid }, entityId, x, y, rotation, velocity,
            filename, health, EntityUtils.isEntityPolymorphed(entityId), NoitaComponentUtils.getInitialSerializedEntityString(entityId)
        }

        if isTestLuaContext then
            print(("Sending need nuid for entity %s with data %s"):format(entityId, Utils.pformat(data)))
        end

        self:send(NetworkUtils.events.needNuid.name, data)
        CustomProfiler.stop("ClientInit.sendNeedNuid", cpc20)
    end

    function self.sendLostNuid(nuid)
        local cpc21 = CustomProfiler.start("ClientInit.sendLostNuid")
        local data  = { NetworkUtils.getNextNetworkMessageId(), nuid }
        local sent  = self:send(NetworkUtils.events.lostNuid.name, data)
        CustomProfiler.stop("ClientInit.sendLostNuid", cpc21)
        return sent
    end

    function self.sendEntityData(entityId)
        local cpc22 = CustomProfiler.start("ClientInit.sendEntityData")
        if not EntityUtils.isEntityAlive(entityId) then
            return
        end

        --local compOwnerName, compOwnerGuid, compNuid     = NetworkVscUtils.getAllVscValuesByEntityId(entityId)
        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local data                                                                               = {
            NetworkUtils.getNextNetworkMessageId(), { compOwnerName, compOwnerGuid }, compNuid, x, y, rotation, velocity, health
        }

        if Utils.IsEmpty(compNuid) then
            -- this can happen, when entity spawned on client and network is slow
            Logger.debug(Logger.channels.network, "Unable to send entity data, because nuid is empty.")
            self.sendNeedNuid(compOwnerName, compOwnerGuid, entityId)
            return
        end

        if MinaUtils.getLocalMinaInformation().guid == compOwnerGuid then
            self:send(NetworkUtils.events.entityData.name, data)
        end
        CustomProfiler.stop("ClientInit.sendEntityData", cpc22)
    end

    function self.sendDeadNuids(deadNuids)
        local cpc23 = CustomProfiler.start("ClientInit.sendDeadNuids")
        local data  = {
            NetworkUtils.getNextNetworkMessageId(), deadNuids
        }
        local sent  = self:send(NetworkUtils.events.deadNuids.name, data)
        onDeadNuids(deadNuids)
        CustomProfiler.stop("ClientInit.sendDeadNuids", cpc23)
        return sent
    end

    function self.sendMinaInformation()
        local cpc24     = CustomProfiler.start("ClientInit.sendMinaInformation")
        local minaInfo  = MinaUtils.getLocalMinaInformation()
        local name      = minaInfo.name
        local guid      = minaInfo.guid
        local entityId  = minaInfo.entityId or -1
        local nuid      = minaInfo.nuid or -1
        local transform = minaInfo.transform
        local health    = minaInfo.health
        local data      = {
            NetworkUtils.getNextNetworkMessageId(), FileUtils.GetVersionByFile(), name, guid, entityId, nuid, transform, health
        }
        local sent      = self:send(NetworkUtils.events.minaInformation.name, data)
        CustomProfiler.stop("ClientInit.sendMinaInformation", cpc24)
        return sent
    end

    --- Checks if the current local user is a client
    --- @return boolean iAm true if client
    function self.amIClient()
        --local cpc24 = CustomProfiler.start("ClientInit.amIClient") DO NOT PROFILE, stack overflow error! See CustomProfiler.lua
        if not _G.Server.amIServer() then
            --CustomProfiler.stop("ClientInit.amIClient", cpc24)
            return true
        end
        --CustomProfiler.stop("ClientInit.amIClient", cpc24)
        return false
    end

    --- Mainly for profiling. Returns then network cache, aka acknowledge.
    --- @return number cacheSize
    function self.getAckCacheSize()
        return NetworkCache.size()
    end

    --#endregion


    -- Apply some private methods

    setGuid()
    setConfigSettings()
    setCallbackAndSchemas()

    CustomProfiler.stop("ClientInit.new", cpc)
    return self
end

---Globally accessible ClientInit in _G.ClientInit.
---@alias _G.ClientInit ClientInit
_G.ClientInit = ClientInit

---Globally accessible SockClient in _G.SockClient.
---@see SockClient
---@alias _G.SockClient SockClient
_G.Client = ClientInit.new(sock.newClient())

return Client
