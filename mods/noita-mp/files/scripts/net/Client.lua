local sock = require("sock")

---@class Client : SockClient Inherit client class from sock.lua#newClient
local Client = setmetatable({
    -- when a class inherits from another class, all additional imports and attributes are defined in :new() !
}, { __index = sock.getClientClass() })
Client.__index = Client


---Sends acknowledgement for a specific network event.
---@private
---@param self Client
---@param networkMessageId number
---@param event string
---@see NetworkUtils.events.acknowledgement.schema
local sendAck = function(self, networkMessageId, event)
    local cpc = self.customProfiler:start("Client.sendAck")
    if not event then
        error("event is nil", 2)
    end
    local data = { networkMessageId, event, self.networkUtils.events.acknowledgement.ack, os.clock() }
    self:send(self.networkUtils.events.acknowledgement.name, data)
    self.logger:debug(self.logger.channels.network, ("Sent ack with data = %s"):format(self.utils.pformat(data)))
    self.customProfiler:stop("Client.sendAck", cpc)
end


---Callback when acknowledgement received.
---@private
---@param self Client
---@param data table data = { "networkMessageId", "event", "status", "ackedAt" }
local onAcknowledgement = function(self, data)
    local cpc = self.customProfiler:start("Client.onAcknowledgement")
    self.logger:debug(self.logger.channels.network, "onAcknowledgement: Acknowledgement received.", self.utils.pformat(data))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onAcknowledgement data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if not data.networkMessageId then
        error(("Unable to get acknowledgement with networkMessageId = %s, data = %s, peer = %s")
            :format(data.networkMessageId, self.utils.pformat(data), self.utils.pformat(self)), 2)
    end

    if self.utils.IsEmpty(data.event) then
        error(("onAcknowledgement data.event is empty: %s"):format(data.event), 2)
    end

    if self.utils.IsEmpty(data.status) then
        error(("onAcknowledgement data.status is empty: %s"):format(data.status), 2)
    end

    if self.utils.IsEmpty(data.ackedAt) then
        error(("onAcknowledgement data.ackedAt is empty: %s"):format(data.ackedAt), 2)
    end

    if not self.clientCacheId then
        self.clientCacheId = self.guidUtils.toNumber(self.guid)
    end

    local cachedData = self.networkCacheUtils.get(self.guid, data.networkMessageId, data.event)
    if self.utils.IsEmpty(cachedData) then
        self.networkCacheUtils.logAll()
        error(("Unable to get cached data, because it is nil '%s'"):format(cachedData), 2)
    end
    if self.utils.IsEmpty(cachedData.dataChecksum) or type(cachedData.dataChecksum) ~= "string" then
        self.networkCacheUtils.logAll()
        error(("Unable to get cachedData.dataChecksum, because it is nil '%s' or checksum is not of type string, type: %s")
            :format(cachedData.dataChecksum, type(cachedData.dataChecksum)), 2)
    end
    -- update previous cached network message
    self.networkCacheUtils.ack(self.guid, data.networkMessageId, data.event,
        data.status, os.clock(), cachedData.sendAt, cachedData.dataChecksum)

    if self.networkCache.size() > self.acknowledgeMaxSize then
        self.networkCache.removeOldest()
    end
    self.customProfiler:stop("Client.onAcknowledgement", cpc)
end

---Callback when connected to server.
---@private
---@param self Client
---@param data table data = { "networkMessageId", "name", "guid", "transform" }
local onConnect = function(self, data)
    local cpc = self.customProfiler:start("Client.onConnect")
    self.logger:debug(self.logger.channels.network, "Connected to server!", self.utils.pformat(data))

    if self.utils.IsEmpty(data) then
        error(("onConnect data is empty: %s"):format(data), 3)
    end

    self:sendMinaInformation()

    self:send(self.networkUtils.events.needModList.name, { self.networkUtils.getNextNetworkMessageId(), {}, {} })

    -- sendAck(self, data.networkMessageId)
    self.customProfiler:stop("Client.onConnect", cpc)
end



---Callback when one of the other clients connected.
---@private
---@param self Client
---@param data table data = { "name", "guid" } @see self.networkUtils.events.connect2.schema
local onConnect2 = function(self, data)
    local cpc = self.customProfiler:start("Client.onConnect2")
    self.logger:debug(self.logger.channels.network, "Another client connected.", self.utils.pformat(data))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onConnect2 data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
    end

    if self.utils.IsEmpty(data.name) then
        error(("onConnect2 data.name is empty: %s"):format(data.name), 3)
    end

    if self.utils.IsEmpty(data.guid) then
        error(("onConnect2 data.guid is empty: %s"):format(data.guid), 3)
    end

    table.insertIfNotExist(self.otherClients, { name = data.name, guid = data.guid, transofrm = data.transform })

    sendAck(self, data.networkMessageId, self.networkUtils.events.connect2.name)
    self.customProfiler:stop("Client.onConnect2", cpc)
end



---Callback when disconnected from server.
---@private
---@param self Client
---@param data number data(.code) = 0
local onDisconnect = function(self, data)
    local cpc = self.customProfiler:start("Client.onDisconnect")
    self.logger.debug(self.logger.channels.network, "Disconnected from server!", self.utils.pformat(data))

    if self.utils.IsEmpty(data) then
        error(("onDisconnect data is empty: %s"):format(data), 3)
    end

    if self.serverInfo.nuid then
        self.entityUtils.destroyByNuid(self, self.serverInfo.nuid)
    end

    -- TODO remove all NUIDS from entities. I now need a nuid-entityId-cache.
    local nuid, entityId = self.globalsUtils.getNuidEntityPair(self.nuid)
    self.networkVscUtils.addOrUpdateAllVscs(entityId, self.name, self.guid, nil)

    self.nuid         = nil
    self.otherClients = {}
    self.serverInfo   = {}

    -- sendAck(self, data.networkMessageId)
    self.customProfiler:stop("Client.onDisconnect", cpc)
end


---Callback when one of the other clients disconnected.
---@private
---@param self Client
---@param data table data { "name", "guid" } @see self.networkUtils.events.disconnect2.schema
local onDisconnect2 = function(self, data)
    local cpc = self.customProfiler:start("Client.onDisconnect2")
    self.logger.debug(self.logger.channels.network, "onDisconnect2: Another client disconnected.", self.utils.pformat(data))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onDisconnect2 data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
    end

    if self.utils.IsEmpty(data.name) then
        error(("onDisconnect2 data.name is empty: %s"):format(data.name), 3)
    end

    if self.utils.IsEmpty(data.guid) then
        error(("onDisconnect2 data.guid is empty: %s"):format(data.guid), 3)
    end

    for i = 1, #self.otherClients do
        if data.guid == self.otherClients[i].guid then
            table.remove(self.otherClients, i)
            break
        end
    end

    sendAck(self, data.networkMessageId, self.networkUtils.events.disconnect2.name)
    self.customProfiler:stop("Client.onDisconnect2", cpc)
end



---Callback when Server sent his minaInformation to the client
---@private
---@param self Client
---@param data table data @see self.networkUtils.events.minaInformation.schema
local onMinaInformation = function(self, data)
    local cpc = self.customProfiler:start("Client.onMinaInformation")
    self.logger.debug(self.logger.channels.network, "onMinaInformation: Player info received.", self.utils.pformat(data))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onMinaInformation data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils.IsEmpty(data.version) then
        error(("onMinaInformation data.version is empty: %s"):format(data.version), 2)
    end

    if self.utils.IsEmpty(data.name) then
        error(("onMinaInformation data.name is empty: %s"):format(data.name), 2)
    end

    if self.utils.IsEmpty(data.guid) then
        error(("onMinaInformation data.guid is empty: %s"):format(data.guid), 2)
    end

    if self.utils.IsEmpty(data.entityId) or data.entityId == -1 then
        error(("onMinaInformation data.entityId is empty: %s"):format(data.entityId), 2)
    end

    -- if self.utils.IsEmpty(data.nuid) or data.nuid == -1 then
    --     error(("onMinaInformation data.nuid is empty: %s"):format(data.nuid), 2)
    -- end

    if self.utils.IsEmpty(data.transform) then
        error(("onMinaInformation data.transform is empty: %s"):format(data.transform), 2)
    end

    if self.utils.IsEmpty(data.health) then
        error(("onMinaInformation data.health is empty: %s"):format(data.health), 2)
    end


    if data.guid == self.guid then
        self.logger.warn(self.logger.channels.network,
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

    sendAck(self, data.networkMessageId, self.networkUtils.events.minaInformation.name)
    self.customProfiler:stop("Client.onMinaInformation", cpc)
end



---Callback when Server sent a new GUID for a specific client.
---@private
---@param self Client
---@param data table data { "networkMessageId", "oldGuid", "newGuid" }
local onNewGuid = function(self, data)
    local cpc = self.customProfiler:start("Client.onNewGuid")
    self.logger.debug(self.logger.channels.network, ("onNewGuid: New GUID from server received."):format(self.utils.pformat(data)))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onNewGuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils.IsEmpty(data.oldGuid) then
        error(("onNewGuid data.oldGuid is empty: %s"):format(data.oldGuid), 2)
    end

    if self.utils.IsEmpty(data.newGuid) then
        error(("onNewGuid data.newGuid is empty: %s"):format(data.newGuid), 2)
    end

    if data.oldGuid == self.guid then
        local entityId                               = self.minaUtils.getLocalMinaInformation().entityId
        local compOwnerName, compOwnerGuid, compNuid = self.networkVscUtils.getAllVscValuesByEntityId(entityId)

        self.guid                                    = data.newGuid
        self.noitaMpSettings.set("noita-mp.guid", self.guid)
        self.networkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, self.guid, compNuid)
    else
        for i = 1, #self.otherClients do
            if self.otherClients[i].guid == data.oldGuid then
                self.otherClients[i].guid = data.newGuid
            end
        end
    end

    sendAck(self, data.networkMessageId, self.networkUtils.events.newGuid.name)
    self.customProfiler:stop("Client.onNewGuid", cpc)
end


---Callback when Server sent his seed to the client
---@private
---@param self Client
---@param data table data { networkMessageId, seed }
local onSeed = function(self, data)
    local cpc = self.customProfiler:start("Client.onSeed")
    self.logger.debug(self.logger.channels.network, "onSeed: Seed from server received.", self.utils.pformat(data))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onSeed data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
    end

    if self.utils.IsEmpty(data.seed) then
        error(("onSeed data.seed is empty: %s"):format(data.seed), 3)
    end

    local serversSeed = tonumber(data.seed)
    self.logger.info(self.logger.channels.network,
        ("Client received servers seed (%s) and stored it. Reloading map with that seed!")
        :format(serversSeed))

    local localSeed = tonumber(StatsGetValue("world_seed"))
    if localSeed ~= serversSeed then
        if not DebugGetIsDevBuild() then
            self.utils.ReloadMap(serversSeed)
        end
    end

    local entityId = self.minaUtils.getLocalMinaEntityId()
    local name = self.minaUtils.getLocalMinaName()
    local guid = self.minaUtils.getLocalMinaGuid()
    if not self.networkVscUtils.hasNetworkLuaComponents(entityId) then
        self.networkVscUtils.addOrUpdateAllVscs(entityId, name, guid, nil)
    end
    if not self.networkVscUtils.hasNuidSet(entityId) then
        self.sendNeedNuid(name, guid, entityId)
    end

    sendAck(self, data.networkMessageId, self.networkUtils.events.seed.name)
    self.customProfiler:stop("Client.onSeed", cpc)
end


-- ---Callback when Server sent a new nuid to the client
-- ---@private
-- ---@param self Client
-- ---@param data table data { networkMessageId, owner { name, guid }, localEntityId, newNuid, x, y, rotation, velocity { x, y }, filename }
-- local onNewNuid = function(self, data)
--     local cpc = self.customProfiler:start("Client.onNewNuid")
--     self.logger.debug(self.logger.channels.network, ("Received a new nuid! data = %s"):format(self.utils.pformat(data)))

--     if self.utils.IsEmpty(data.networkMessageId) then
--         error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
--     end

--     if self.utils.IsEmpty(data.owner) then
--         error(("onNewNuid data.owner is empty: %s"):format(self.utils.pformat(data.owner)), 3)
--     end

--     if self.utils.IsEmpty(data.localEntityId) then
--         error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
--     end

--     if self.utils.IsEmpty(data.newNuid) then
--         error(("onNewNuid data.newNuid is empty: %s"):format(data.newNuid), 3)
--     end

--     if self.utils.IsEmpty(data.x) then
--         error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
--     end

--     if self.utils.IsEmpty(data.y) then
--         error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
--     end

--     if self.utils.IsEmpty(data.rotation) then
--         error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
--     end

--     if self.utils.IsEmpty(data.velocity) then
--         error(("onNewNuid data.velocity is empty: %s"):format(self.utils.pformat(data.velocity)), 3)
--     end

--     if self.utils.IsEmpty(data.filename) then
--         error(("onNewNuid data.filename is empty: %s"):format(data.filename), 3)
--     end

--     if self.utils.IsEmpty(data.health) then
--         error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
--     end

--     if self.utils.IsEmpty(data.isPolymorphed) then
--         error(("onNewNuid data.isPolymorphed is empty: %s"):format(data.isPolymorphed), 3)
--     end

--     local owner         = data.owner
--     local localEntityId = data.localEntityId
--     local newNuid       = data.newNuid
--     local x             = data.x
--     local y             = data.y
--     local rotation      = data.rotation
--     local velocity      = data.velocity
--     local filename      = data.filename
--     local health        = data.health
--     local isPolymorphed = data.isPolymorphed

--     if owner.guid == self.minaUtils.getLocalMinaInformation().guid then
--         if localEntityId == self.minaUtils.getLocalMinaInformation().entityId then
--             self.nuid = newNuid
--         end
--     end

--     self.entityUtils.spawnEntity(owner, newNuid, x, y, rotation, velocity, filename, localEntityId, health,
--         isPolymorphed)

--     sendAck(self, data.networkMessageId, self.networkUtils.events.newNuid.name)
--     self.customProfiler:stop("Client.onNewNuid", cpc)
-- end

---Callback when Server sent a new nuid to the client.
---@param self Client
---@param data table data { networkMessageId, ownerName, ownerGuid, entityId, serializedEntityString, nuid, x, y, initialSerializedEntityString }
local onNewNuid = function(self, data)
    local cpc = self.customProfiler:start("Client.onNewNuid")
    self.logger.debug(self.logger.channels.network,
        ("Received a new nuid onNewNuid! data = %s"):format(self.utils.pformat(data)))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils.IsEmpty(data.ownerName) then
        error(("onNewNuid data.ownerName is empty: %s"):format(self.utils.pformat(data.ownerName)), 2)
    end

    if self.utils.IsEmpty(data.ownerGuid) then
        error(("onNewNuid data.ownerGuid is empty: %s"):format(self.utils.pformat(data.ownerGuid)), 2)
    end

    if self.utils.IsEmpty(data.entityId) then
        error(("onNewNuid data.entityId is empty: %s"):format(data.entityId), 2)
    end

    if self.utils.IsEmpty(data.serializedEntityString) then
        error(("onNewNuid data.serializedEntityString is empty: %s"):format(data.serializedEntityString), 2)
    end

    if self.utils.IsEmpty(data.nuid) then
        error(("onNewNuid data.nuid is empty: %s"):format(data.nuid), 2)
    end

    if self.utils.IsEmpty(data.x) then
        error(("onNewNuid data.x is empty: %s"):format(data.x), 2)
    end

    if self.utils.IsEmpty(data.y) then
        error(("onNewNuid data.y is empty: %s"):format(data.y), 2)
    end

    if self.utils.IsEmpty(data.initialSerializedEntityString) then
        error(("onNewNuid data.initialSerializedEntityString is empty: %s"):format(data.initialSerializedEntityString), 2)
    end

    -- FOR TESTING ONLY, DO NOT MERGE
    --print(self.utils.pformat(data))
    --os.exit()

    --if ownerGuid == self.minaUtils.getLocalMinaInformation().guid then
    --    if entityId == self.minaUtils.getLocalMinaInformation().entityId then
    --        self.nuid = newNuid
    --    end
    --end

    local nuid, entityId = self.globalsUtils.getNuidEntityPair(data.nuid)

    if self.utils.IsEmpty(entityId) then
        local closestEntityId = EntityGetClosest(data.x, data.y)
        local initialSerializedEntityString = self.noitaComponentUtils.getInitialSerializedEntityString(closestEntityId)
        if initialSerializedEntityString == data.initialSerializedEntityString then
            entityId = closestEntityId
        else
            entityId = EntityCreateNew(data.nuid)
        end
    else
        if self.entityCache.contains(entityId) then
            local cachedEntity = self.entityCache.get(entityId)
        end
    end


    entityId = self.noitaPatcherUtils.deserializeEntity(entityId, data.serializedEntityString, data.x, data.y) --EntitySerialisationUtils.deserializeEntireRootEntity(data.serializedEntity, data.nuid)

    -- include exclude list of entityIds which shouldn't be spawned
    -- if filename:contains("player.xml") then
    --     filename = "mods/noita-mp/data/enemies_gfx/client_player_base.xml"
    -- end

    -- local entityId = EntityLoad(filename, x, y)
    -- if not EntityGetIsAlive(entityId) then
    --     return
    -- end

    local compIds = EntityGetAllComponents(entityId) or {}
    for i = 1, #compIds do
        local compId   = compIds[i]
        local compType = ComponentGetTypeName(compId)
        if table.contains(self.entityUtils.remove.byComponentsName, compType) or
            table.contains(EntitySerialisationUtils.ignore.byComponentsType) then
            EntityRemoveComponent(entityId, compId)
        end
    end

    sendAck(self, data.networkMessageId, self.networkUtils.events.newNuid.name)
    self.customProfiler:stop("Client.onNewNuid", cpc)
end

---Callback when entity data received.
---@private
---@param self Client
---@param data table data { networkMessageId, owner { name, guid }, localEntityId, nuid, x, y, rotation, velocity { x, y }, health }
local onEntityData = function(self, data)
    local cpc = self.customProfiler:start("Client.onEntityData")
    self.logger.debug(self.logger.channels.network, ("Received entityData for nuid = %s! data = %s")
        :format(data.nuid, self.utils.pformat(data)))

    if self.utils.IsEmpty(data.networkMessageId) then
        error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
    end

    if self.utils.IsEmpty(data.owner) then
        error(("onNewNuid data.owner is empty: %s"):format(self.utils.pformat(data.owner)), 3)
    end

    --if self.utils.IsEmpty(data.localEntityId) then
    --    error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
    --end

    if self.utils.IsEmpty(data.nuid) then
        error(("onNewNuid data.nuid is empty: %s"):format(data.nuid), 3)
    end

    if self.utils.IsEmpty(data.x) then
        error(("onNewNuid data.x is empty: %s"):format(data.x), 3)
    end

    if self.utils.IsEmpty(data.y) then
        error(("onNewNuid data.y is empty: %s"):format(data.y), 3)
    end

    if self.utils.IsEmpty(data.rotation) then
        error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 3)
    end

    if self.utils.IsEmpty(data.velocity) then
        error(("onNewNuid data.velocity is empty: %s"):format(self.utils.pformat(data.velocity)), 3)
    end

    if self.utils.IsEmpty(data.health) then
        error(("onNewNuid data.health is empty: %s"):format(data.health), 3)
    end

    local owner                = data.owner
    local gNuid, localEntityId = self.globalsUtils.getNuidEntityPair(data.nuid)
    local nuid                 = data.nuid
    local x                    = data.x
    local y                    = data.y
    local rotation             = data.rotation
    local velocity             = data.velocity
    local health               = data.health

    if self.nuid ~= nuid then
        self.noitaComponentUtils.setEntityData(localEntityId, x, y, rotation, velocity, health)
    else
        self.logger.warn(self.logger.channels.network, ("Received entityData for self.nuid = %s! data = %s")
            :format(data.nuid, self.utils.pformat(data)))
    end

    -- sendAck(self, data.networkMessageId) do not send ACK for position data, network will explode
    self.customProfiler:stop("Client.onEntityData", cpc)
end

---Callback when dead nuids received.
---@param self Client
---@param data table data { networkMessageId, deadNuids }
local onDeadNuids = function(self, data)
    local cpc       = self.customProfiler:start("Client.onDeadNuids")
    local deadNuids = data.deadNuids or data or {}
    for i = 1, #deadNuids do
        local deadNuid = deadNuids[i]
        if self.utils.IsEmpty(deadNuid) or deadNuid == "nil" then
            error(("onDeadNuids deadNuid is empty: %s"):format(deadNuid), 2)
        else
            self.entityUtils.destroyByNuid(self, deadNuid)
            self.globalsUtils.removeDeadNuid(deadNuid)
            self.entityCache.deleteNuid(deadNuid)
        end
    end
    sendAck(self, data.networkMessageId, self.networkUtils.events.deadNuids.name)
    self.customProfiler:stop("Client.onDeadNuids", cpc)
end

---Callback when mod list is requested.
---@param self Client
---@param data table data { networkMessageId, workshop, external }
local onNeedModList = function(self, data)
    local cpc        = self.customProfiler:start("Client.onNeedModList")
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
        self.logger.info("Mod conflicts detected: Missing " .. table.concat(conflicts, ", "))
    end
    self.customProfiler:stop("Client.onNeedModList", cpc)
end

---Callback when mod content is requested.
---@param self Client
---@param data table data { networkMessageId, items }
local onNeedModContent = function(self, data)
    local cpc = self.customProfiler:start("Client.onNeedModContent")
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
    self.customProfiler:stop("Client.onNeedModContent", cpc)
end


---Sets callbacks and schemas of the client.
---@private
---@param self Client
local setCallbackAndSchemas = function(self)
    local cpc = self.customProfiler:start("Client.setCallbackAndSchemas")
    --self:setSchema(self.networkUtils.events.connect, { "code" })
    self:on(self.networkUtils.events.connect.name, onConnect)

    self:setSchema(self.networkUtils.events.connect2.name, self.networkUtils.events.connect2.schema)
    self:on(self.networkUtils.events.connect2.name, onConnect2)

    --self:setSchema(self.networkUtils.events.disconnect, { "code" })
    self:on(self.networkUtils.events.disconnect.name, onDisconnect)

    self:setSchema(self.networkUtils.events.disconnect2.name, self.networkUtils.events.disconnect2.schema)
    self:on(self.networkUtils.events.disconnect2.name, onDisconnect2)

    self:setSchema(self.networkUtils.events.acknowledgement.name, self.networkUtils.events.acknowledgement.schema)
    self:on(self.networkUtils.events.acknowledgement.name, onAcknowledgement)

    self:setSchema(self.networkUtils.events.seed.name, self.networkUtils.events.seed.schema)
    self:on(self.networkUtils.events.seed.name, onSeed)

    self:setSchema(self.networkUtils.events.minaInformation.name, self.networkUtils.events.minaInformation.schema)
    self:on(self.networkUtils.events.minaInformation.name, onMinaInformation)

    self:setSchema(self.networkUtils.events.newGuid.name, self.networkUtils.events.newGuid.schema)
    self:on(self.networkUtils.events.newGuid.name, onNewGuid)

    self:setSchema(self.networkUtils.events.newNuid.name, self.networkUtils.events.newNuid.schema)
    self:on(self.networkUtils.events.newNuid.name, onNewNuid)

    -- self:setSchema(self.networkUtils.events.entityData.name, self.networkUtils.events.entityData.schema)
    -- self:on(self.networkUtils.events.entityData.name, onEntityData)

    self:setSchema(self.networkUtils.events.deadNuids.name, self.networkUtils.events.deadNuids.schema)
    self:on(self.networkUtils.events.deadNuids.name, onDeadNuids)

    self:setSchema(self.networkUtils.events.needModList.name, self.networkUtils.events.needModList.schema)
    self:on(self.networkUtils.events.needModList.name, onNeedModList)

    self:setSchema(self.networkUtils.events.needModContent.name, self.networkUtils.events.needModContent.schema)
    self:on(self.networkUtils.events.needModContent.name, onNeedModContent)

    self.customProfiler:stop("Client.setCallbackAndSchemas", cpc)
end

---Connects to a server on ip and port. Both can be nil, then ModSettings will be used. Inherit from sock.connect.
---@param ip string|nil localhost or 127.0.0.1 or nil
---@param port number|nil port number from 1 to max of 65535 or nil
---@param code number|nil connection code 0 = connecting first time, 1 = connected second time with loaded seed
---@see sock.connect
function Client:connect(ip, port, code)
    local cpc = self.customProfiler:start("Client.connect")

    if self:isConnecting() or self:isConnected() then
        self.logger:warn(self.logger.channels.network, ("Client is still connected to %s:%s. Disconnecting!")
            :format(self:getAddress(), self:getPort()))
        self:disconnect()
    end

    if not ip then
        local cpc29 = self.customProfiler:start("ModSettingGet")
        ip          = tostring(ModSettingGet("noita-mp.connect_server_ip"))
        self.customProfiler:stop("ModSettingGet", cpc29)
    end

    if not port then
        local cpc30 = self.customProfiler:start("ModSettingGet")
        port        = tonumber(ModSettingGet("noita-mp.connect_server_port")) or error("noita-mp.connect_server_port wasn't a number")
        self.customProfiler:stop("ModSettingGet", cpc30)
    end

    port = tonumber(port) or error("noita-mp.connect_server_port wasn't a number")

    self.logger:info(self.logger.channels.network, ("Trying to connect to server on %s:%s"):format(ip, port))
    if not self.host then
        self:establishClient(ip, port)
    end

    GamePrintImportant("Client is trying to connect to server..",
        "You are trying to connect to " .. self:getAddress() .. ":" .. self:getPort() .. "!",
        ""
    )

    -- Inheritance: https://ozzypig.com/2018/05/10/object-oriented-programming-in-lua-part-5-inheritance
    self.sock.connect(self, code) --sockClientConnect(self, code)

    -- FYI: If you want to send data after connected, do it in the "connect" callback function
    self.customProfiler:stop("Client.connect", cpc16)
end

---Disconnects from the server. Inherit from sock.disconnect.
---@see sock.disconnect
function Client:disconnect()
    local cpc = self.customProfiler:start("Client.disconnect")
    if self.isConnected() then
        -- Inheritance: https://ozzypig.com/2018/05/10/object-oriented-programming-in-lua-part-5-inheritance
        self.sock.disconnect(self) --sockClientDisconnect(self)
    else
        self.logger.info(self.logger.channels.network, "Client isn't connected, no need to disconnect!")
    end
    self.customProfiler:stop("Client.disconnect", cpc)
end

---Returns true if the client is connected to the server. Inherit from sock.isConnected.
---@return boolean
function Client:isConnected()
    -- Inheritance: https://ozzypig.com/2018/05/10/object-oriented-programming-in-lua-part-5-inheritance
    return self.sock.isConnected(self)
end

local prevTime = 0
---Updates the Client by checking for network events and handling them. Inherit from sock.update.
---@param startFrameTime number required
---@see sock.update
function Client:update(startFrameTime)
    local cpc = self.customProfiler:start("Client.update")
    if not self.isConnected() and not self:isConnecting() or self:isDisconnected() then
        self.customProfiler:stop("Client.update", cpc)
        return
    end

    self.sendMinaInformation()

    --self.entityUtils.destroyClientEntities()
    --self.entityUtils.processEntityNetworking()
    --self.entityUtils.initNetworkVscs()

    self.entityUtils.syncEntities(startFrameTime)

    local nowTime     = GameGetRealWorldTimeSinceStarted() * 1000 -- *1000 to get milliseconds
    local elapsedTime = nowTime - prevTime
    local cpc31       = self.customProfiler:start("ModSettingGet")
    local oneTickInMs = 1000 / tonumber(ModSettingGet("noita-mp.tick_rate"))
    self.customProfiler:stop("ModSettingGet", cpc31)
    if elapsedTime >= oneTickInMs then
        prevTime = nowTime
        --updateVariables()

        --self.entityUtils.destroyClientEntities()
        --self.entityUtils.syncEntityData()
        self.entityUtils.syncDeadNuids()
    end

    -- Inheritance: https://ozzypig.com/2018/05/10/object-oriented-programming-in-lua-part-5-inheritance
    self.sock.update(self) --sockClientUpdate(self)
    self.customProfiler:stop("Client.update", cpc)
end

---Sends a message to the server. Inherit from sock.send.
---@param event string required
---@param data table required
---@return boolean true if message was sent, false if not
---@see sock.send
function Client:send(event, data)
    local cpc = self.customProfiler:start("Client.send")
    if type(data) ~= "table" then
        error(("Data is not type of table: %s"):format(data), 2)
        return false
    end

    if self.networkUtils.alreadySent(self, event, data) then
        self.logger.debug(self.logger.channels.network, ("Network message for %s for data %s already was acknowledged.")
            :format(event, self.utils.pformat(data)))
        self.customProfiler:stop("Client.send", cpc)
        return false
    end

    -- Inheritance: https://ozzypig.com/2018/05/10/object-oriented-programming-in-lua-part-5-inheritance
    local networkMessageId = self.sock.send(self, event, data) --sockClientSend(self, event, data)

    if event ~= self.networkUtils.events.acknowledgement.name then
        if self.networkUtils.events[event].isCacheable == true then
            self.networkCacheUtils.set(self.guid, networkMessageId, event,
                self.networkUtils.events.acknowledgement.sent, 0, os.clock(), data)
        end
    end
    self.customProfiler:stop("Client.send", cpc)
    return true
end

---Sends a message to the server that the client needs a nuid.
---@param ownerName string
---@param ownerGuid string
---@param entityId number
function Client:sendNeedNuid(ownerName, ownerGuid, entityId)
    local cpc = self.customProfiler:start("Client.sendNeedNuid")

    if not ownerName then
        error("ownerName is nil")
    end
    if not ownerGuid then
        error("ownerGuid is nil")
    end
    if not entityId then
        error("entityId is nil")
    end

    if not EntityGetIsAlive(entityId) then
        return
    end

    local x, y                         = EntityGetTransform(entityId)
    local initialBase64String, md5Hash = self.noitaPatcherUtils.serializeEntity(entityId)
    local data                         = {
        self.networkUtils.getNextNetworkMessageId(), ownerName, ownerGuid, entityId, x, y,
        self.noitaComponentUtils.getInitialSerializedEntityString(entityId), initialBase64String
    }

    if isTestLuaContext then
        print(("Sending need nuid for entity %s with data %s"):format(entityId, self.utils.pformat(data)))
    end

    self:send(self.networkUtils.events.needNuid.name, data)
    self.customProfiler:stop("Client.sendNeedNuid", cpc)
end

---Sends a message that the client has a nuid, but no linked entity.
---@param nuid number required
---@return boolean true if message was sent, false if not
function Client:sendLostNuid(nuid)
    local cpc  = self.customProfiler:start("Client.sendLostNuid")
    local data = { self.networkUtils.getNextNetworkMessageId(), nuid }
    local sent = self:send(self.networkUtils.events.lostNuid.name, data)
    self.customProfiler:stop("Client.sendLostNuid", cpc)
    return sent
end

---Sends entity data to the server.
---@param entityId number required
function Client:sendEntityData(entityId)
    local cpc = self.customProfiler:start("Client.sendEntityData")
    if not EntityGetIsAlive(entityId) then
        return
    end

    --local compOwnerName, compOwnerGuid, compNuid     = self.networkVscUtils.getAllVscValuesByEntityId(entityId)
    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = self.noitaComponentUtils.getEntityData(entityId)
    local data                                                                               = {
        self.networkUtils.getNextNetworkMessageId(), { compOwnerName, compOwnerGuid }, compNuid, x, y, rotation, velocity, health
    }

    if self.utils.IsEmpty(compNuid) then
        -- this can happen, when entity spawned on client and network is slow
        self.logger.debug(self.logger.channels.network, "Unable to send entity data, because nuid is empty.")
        self.sendNeedNuid(compOwnerName, compOwnerGuid, entityId)
        return
    end

    if self.minaUtils.getLocalMinaInformation().guid == compOwnerGuid then
        self:send(self.networkUtils.events.entityData.name, data)
    end
    self.customProfiler:stop("Client.sendEntityData", cpc)
end

---Sends dead nuids to the server.
---@param deadNuids table required
---@return boolean true if message was sent, false if not
function Client:sendDeadNuids(deadNuids)
    local cpc  = self.customProfiler:start("Client.sendDeadNuids")
    local data = {
        self.networkUtils.getNextNetworkMessageId(), deadNuids
    }
    local sent = self:send(self.networkUtils.events.deadNuids.name, data)
    onDeadNuids(deadNuids)
    self.customProfiler:stop("Client.sendDeadNuids", cpc)
    return sent
end

---Sends mina information to the server.
---@return boolean
function Client:sendMinaInformation()
    local cpc       = self.customProfiler:start("Client.sendMinaInformation")
    local minaInfo  = self.minaUtils.getLocalMinaInformation()
    local name      = minaInfo.name
    local guid      = minaInfo.guid
    local entityId  = minaInfo.entityId or -1
    local nuid      = minaInfo.nuid or -1
    local transform = minaInfo.transform
    local health    = minaInfo.health
    local data      = {
        self.networkUtils.getNextNetworkMessageId(), FileUtils.GetVersionByFile(), name, guid, entityId, nuid, transform, health
    }
    local sent      = self:send(self.networkUtils.events.minaInformation.name, data)
    self.customProfiler:stop("Client.sendMinaInformation", cpc)
    return sent
end

---Checks if the current local user is a client.
---@return boolean true if client, false if not
---@see Server.amIServer
function Client:amIClient()
    --local cpc24 = self.customProfiler:start("Client.amIClient") DO NOT PROFILE, stack overflow error! See self.customProfiler.lua
    if not self.server.amIServer() then
        --self.customProfiler:stop("Client.amIClient", cpc24)
        return true
    end
    --self.customProfiler:stop("Client.amIClient", cpc24)
    return false
end

---Mainly for profiling. Returns then network cache, aka acknowledge.
---@return number cacheSize
function Client:getAckCacheSize()
    return self.networkCache.size()
end

---Client constructor. Inherits from SockClient sock.Client.
---@param clientObject Client|nil
---@param serverOrAddress string|nil
---@param port number|nil
---@param maxChannels number|nil
---@param server Server required
---@return Client
function Client:new(clientObject, serverOrAddress, port, maxChannels, server)
    ---@class Client : SockClient
    clientObject =
        setmetatable(clientObject or sock.newClient(serverOrAddress, port, maxChannels), Client) or
        error("Unable to create new sock client!", 2)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not clientObject.noitaMpSettings then
        clientObject.noitaMpSettings = server.noitaMpSettings or error("Client:new requires a server object!", 2)
    end
    if not clientObject.customProfiler then
        clientObject.customProfiler = clientObject.noitaMpSettings.customProfiler or error("Client:new requires a server object!", 2)
    end
    local cpc = clientObject.customProfiler:start("Client:new")

    if not clientObject.globalUtils then
        clientObject.globalUtils = server.globalUtils or require("GlobalUtils")
    end
    if not clientObject.networkCache then
        clientObject.networkCache = server.networkCache or error("Client:new requires a server object!", 2)
    end
    if not clientObject.networkCacheUtils then
        clientObject.networkCacheUtils = server.networkCacheUtils or error("Client:new requires a server object!", 2)
    end
    if not clientObject.entityUtils then
        clientObject.entityUtils = server.entityUtils or error("Client:new requires a server object!", 2)
    end
    if not clientObject.guidUtils then
        clientObject.guidUtils = server.guidUtils or error("Client:new requires a server object!", 2)
    end
    -- clientObject.logger is sock.logger by default. Has to be repalced with NoitaMP logger.
    if not clientObject.logger or clientObject.logger ~= clientObject.noitaMpSettings.logger then
        clientObject.logger = clientObject.noitaMpSettings.logger or error("Client:new requires a server object!", 2)
    end
    if not clientObject.messagePack then
        clientObject.messagePack = server.messagePack or require("MessagePack")
    end
    if not clientObject.minaUtils then
        clientObject.minaUtils = server.minaUtils or require("MinaUtils")
    end
    if not clientObject.networkUtils then
        clientObject.networkUtils = server.networkUtils or require("NetworkUtils")
    end
    if not clientObject.noitaPatcherUtils then
        clientObject.noitaPatcherUtils = server.noitaPatcherUtils or require("NoitaPatcherUtils")
    end
    if not clientObject.server then
        clientObject.server = server or error("Client:new requires a server object!", 2)
    end
    if not clientObject.sock then
        clientObject.sock = server.sock or require("sock")
    end
    if not clientObject.zstandard then
        clientObject.zstandard = server.zstandard or require("zstd")
    end
    if not clientObject.utils then
        clientObject.utils = server.utils or error("Client:new requires a server object!", 2)
    end

    --[[ Attributes ]]

    clientObject.acknowledgeMaxSize = 500
    clientObject.guid               = nil
    clientObject.health             = { current = 99, max = 100 }
    clientObject.iAm                = "CLIENT"
    clientObject.missingMods        = nil
    clientObject.name               = nil
    clientObject.nuid               = nil
    clientObject.otherClients       = {}
    clientObject.requiredMods       = nil
    clientObject.serverInfo         = {}
    clientObject.syncedMods         = false
    clientObject.transform          = { x = 0, y = 0 }

    -- Functions for initialization

    clientObject:setSerialization(clientObject.networkUtils.serialize, clientObject.networkUtils.deserialize)
    clientObject:setTimeout(320, 50000, 100000)
    setCallbackAndSchemas(clientObject)

    clientObject.name = tostring(clientObject.noitaMpSettings:get("noita-mp.nickname", "string"))
    clientObject.guid = tostring(clientObject.noitaMpSettings:get("noita-mp.guid", "string"))
    clientObject.guidUtils:setGuid(clientObject, nil, clientObject.guid)

    clientObject.customProfiler:stop("Client:new", cpc)
    return clientObject
end

return Client
