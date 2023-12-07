-- Needed for inheritance in lua. Load the Superclass into the metatable.__index to make those functions available.
local SockServer = require("SockServer")

---@class Server : SockServer Inherit server class from sock.lua#newServer
local Server = setmetatable({}, { __index = SockServer })
Server.__index = Server

---Sends acknowledgement for a specific network event.
---@private
---@param self Server
---@param networkMessageId number
---@param peer Client|Server
---@param event string @see self.networkself.utils:events
---@param nuid number|nil optional, some events don't have a nuid
local sendAck = function(self, networkMessageId, peer, event, nuid)
    if not event then
        error("event is nil", 2)
    end
    local data = { networkMessageId, event, self.networkUtils.events.acknowledgement.ack, os.clock(), nuid }
    self:sendToPeer(peer, self.networkUtils.events.acknowledgement.name, data)
    --self.logger:debug(self.logger.channels.network, ("Sent ack with data = %s"):format(self.utils:pformat(data)))
end


---Callback when acknowledgement received.
---@private
---@param self Server
---@param data table data = { "networkMessageId", "event", "status", "ackedAt" }
---@param peer Client|Server
local onAcknowledgement = function(self, data, peer)
    --self.logger:debug(self.logger.channels.network, "onAcknowledgement: Acknowledgement received.", self.utils:pformat(data))

    if self.utils:isEmpty(data.networkMessageId) then
        error(("onAcknowledgement data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if not data.networkMessageId then
        error(("Unable to get acknowledgement with networkMessageId = %s, data = %s, peer = %s")
            :format(data.networkMessageId, data, peer), 2)
    end

    if self.utils:isEmpty(data.event) then
        error(("onAcknowledgement data.event is empty: %s"):format(data.event), 2)
    end

    if self.utils:isEmpty(data.status) then
        error(("onAcknowledgement data.status is empty: %s"):format(data.status), 2)
    end

    if self.utils:isEmpty(data.ackedAt) then
        error(("onAcknowledgement data.ackedAt is empty: %s"):format(data.ackedAt), 2)
    end

    if not peer.clientCacheId then
        peer.clientCacheId = self.guidUtils:toNumber(peer.guid)
    end

    local cachedData = self.networkCacheUtils:get(self.guid, data.networkMessageId, data.event)
    if self.utils:isEmpty(cachedData) then
        self.networkCacheUtils:logAll()
        error(("Unable to get cached data, because it is nil '%s'"):format(cachedData), 2)
    end
    if self.utils:isEmpty(cachedData.dataChecksum) or type(cachedData.dataChecksum) ~= "string" then
        self.networkCacheUtils:logAll()
        error(("Unable to get cachedData.dataChecksum, because it is nil '%s' or checksum is not of type string, type: %s")
            :format(cachedData.dataChecksum, type(cachedData.dataChecksum)), 2)
    end
    -- update previous cached network message
    self.networkCacheUtils:ack(self.guid, data.networkMessageId, data.event,
        data.status, os.clock(), cachedData.sendAt, cachedData.dataChecksum)

    if self.networkCache:size() > self.acknowledgeMaxSize then
        self.networkCache:removeOldest()
    end

    if not self.utils:isEmpty(data.nuid) then
        -- data.nuid can be nil now and then, because it's not set in all events
        local nuid_, entityId = self.globalsUtils:getNuidEntityPair(data.nuid)
        if not self.utils:isEmpty(entityId) then
            self.noitaComponentUtils:setNetworkSpriteIndicatorStatus(entityId, "acked")
        end
    end
end


---Callback when client connected to server.
---@private
---@param self Server
---@param data table data = { "networkMessageId", "name", "guid", "transform" }
---@param peer Client|Server
local onConnect = function(self, data, peer)
    if self.utils:isEmpty(peer) then
        error(("onConnect peer is empty: %s"):format(peer), 2)
    end

    if self.utils:isEmpty(data) then
        error(("onConnect data is empty: %s"):format(data), 2)
    end

    --self.logger:debug(self.logger.channels.network, ("Peer %s connected! data = %s")
    --    :format(self.utils:pformat(peer), self.utils:pformat(data)))

    local localNuid = self.minaUtils:getLocalMinaNuid()
    local entityId = self.minaUtils:getLocalMinaEntityId()
    if self.utils:isEmpty(entityId) or entityId <= 0 then
        error(("onConnect entityId is empty: %s"):format(entityId), 2)
    end

    if self.utils:isEmpty(localNuid) or localNuid <= 0 then
        local hasNuid, nuid = self.networkVscUtils:hasNuidSet(entityId)
        if not hasNuid or self.utils:isEmpty(nuid) then
            nuid = self.nuidUtils:getNextNuid()
            self.networkVscUtils:addOrUpdateAllVscs(entityId, self.minaUtils:getLocalMinaName(), self.minaUtils:getLocalMinaGuid(), nuid, nil, nil)
        end
    end

    self:sendMinaInformation()

    self:send(peer, self.networkUtils.events.seed.name,
        { self.networkUtils:getNextNetworkMessageId(), StatsGetValue("world_seed") })

    -- Let the other clients know, that a new client connected
    self:sendToAllBut(peer, self.networkUtils.events.connect2.name,
        { self.networkUtils:getNextNetworkMessageId(), peer.name, peer.guid })

    -- Send local minä to the new client
    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = self.noitaComponentUtils:getEntityData(entityId)
    local serializedEntityString = self.noitaPatcherUtils:serializeEntity(entityId)
    self:sendNewNuid(compOwnerName, compOwnerGuid, entityId, serializedEntityString, compNuid, x, y,
        self.noitaComponentUtils:getInitialSerializedEntityString(entityId))
    -- self.sendNewNuid({ name, guid }, entityId, nuid, x, y, rotation, velocity, filename, health, isPolymorphed)
end


---Callback when client disconnected from server.
---@private
---@param self Server
---@param data number data(.code) = 0
---@param peer Client|Server
local onDisconnect = function(self, data, peer)
    --self.logger:debug(self.logger.channels.network, "Disconnected from server!", self.utils:pformat(data))

    if self.utils:isEmpty(peer) then
        error(("onConnect peer is empty: %s"):format(peer), 3)
    end

    if self.utils:isEmpty(data) then
        error(("onDisconnect data is empty: %s"):format(data), 3)
    end

    --self.logger:debug(self.logger.channels.network, "Disconnected from server!", self.utils:pformat(data))
    -- Let the other clients know, that one client disconnected
    self:sendToAllBut(peer, self.networkUtils.events.disconnect2.name,
        { self.networkUtils:getNextNetworkMessageId(), peer.name, peer.guid, peer.nuid })
    if peer.nuid then
        self.entityUtils:destroyByNuid(peer, peer.nuid)
    end

    -- clear acknowledge cache for disconnected peer
    if not peer.clientCacheId then
        peer.clientCacheId = self.guidUtils:toNumber(peer.guid) --error("peer.clientCacheId must not be nil!", 2)
    end
    self.networkCache:clear(peer.clientCacheId)

    -- sendAck(data.networkMessageId, peer)
end


---Callback when Server sent his minaInformation to the client
---@private
---@param self Server
---@param data table data @see self.networkUtils.events.minaInformation.schema
local onMinaInformation = function(self, data, peer)
    --self.logger:debug(self.logger.channels.network, "onMinaInformation: Player info received.", self.utils:pformat(data))

    if self.utils:isEmpty(peer) then
        error(("onConnect peer is empty: %s"):format(peer), 2)
    end

    if self.utils:isEmpty(data.networkMessageId) then
        error(("onMinaInformation data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils:isEmpty(data.version) then
        error(("onMinaInformation data.version is empty: %s"):format(data.version), 2)
    end

    if self.utils:isEmpty(data.name) then
        error(("onMinaInformation data.name is empty: %s"):format(data.name), 2)
    end

    if self.utils:isEmpty(data.guid) then
        error(("onMinaInformation data.guid is empty: %s"):format(data.guid), 2)
    end

    if self.utils:isEmpty(data.entityId) or data.entityId == -1 then
        error(("onMinaInformation data.entityId is empty: %s"):format(data.entityId), 2)
    end

    -- if self.utils:isEmpty(data.nuid) or data.nuid == -1 then
    --     error(("onMinaInformation data.nuid is empty: %s"):format(data.nuid), 2)
    -- end

    if self.utils:isEmpty(data.transform) then
        error(("onMinaInformation data.transform is empty: %s"):format(data.transform), 2)
    end

    if self.utils:isEmpty(data.health) then
        error(("onMinaInformation data.health is empty: %s"):format(data.health), 2)
    end


    if self.fileUtils:GetVersionByFile() ~= tostring(data.version) then
        error(("Version mismatch: NoitaMP version of Client: %s and your version: %s")
            :format(data.version, self.fileUtils:GetVersionByFile()), 3)
        peer:disconnect()
    end

    -- Make sure guids are unique. It's unlikely that two players have the same guid, but it can happen rarely.
    if self.guid == data.guid --[[or table.contains(self.guidUtils:getCachedGuids(), data.guid)]] then
        self.logger:warn(self.logger.channels.network, ("onMinaInformation: guid %s is not unique!"):format(data.guid))
        local newGuid = self.guidUtils:generateNewGuid({ data.guid })
        self:sendNewGuid(peer, data.guid, newGuid)
        data.guid = newGuid
    end

    -- Update peer as well, otherwise it's out of sync
    peer.version = data.version
    peer.name = data.name
    peer.guid = data.guid
    peer.entityId = data.entityId
    peer.nuid = data.nuid
    peer.transform = data.transform
    peer.heath = data.health

    for i, client in pairs(self:getClients()) do
        if client.connectId == peer.connectId then
            self.clients[i].version = data.version
            self.clients[i].name = data.name
            self.clients[i].guid = data.guid
            self.clients[i].entityId = data.entityId
            self.clients[i].nuid = data.nuid
            self.clients[i].transform = data.transform
            self.clients[i].health = data.health

            self.guidUtils:addGuidToCache(data.guid)
        end
    end

    sendAck(self, data.networkMessageId, peer, self.networkUtils.events.minaInformation.name, data.nuid)
end


---Callback when Client needs a new nuid.
---@param self Server
---@param data table @see self.networkUtils.events.needNuid.schema
---@param peer Client|Server
local onNeedNuid = function(self, data, peer)
    --self.logger:debug(self.logger.channels.network, ("Peer %s needs a new nuid. data = %s")
    --    :format(self.utils:pformat(peer), self.utils:pformat(data)))

    if self.utils:isEmpty(peer) then
        error(("onNeedNuid peer is empty: %s"):format(self.utils:pformat(peer)), 2)
    end

    if self.utils:isEmpty(data.networkMessageId) then
        error(("onNeedNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils:isEmpty(data.ownerName) then
        error(("onNeedNuid data.ownerName is empty: %s"):format(data.ownerName), 2)
    end

    if self.utils:isEmpty(data.ownerGuid) then
        error(("onNeedNuid data.ownerGuid is empty: %s"):format(data.ownerGuid), 2)
    end

    if self.utils:isEmpty(data.localEntityId) then
        error(("onNeedNuid data.localEntityId is empty: %s"):format(data.localEntityId), 2)
    end

    if self.utils:isEmpty(data.x) then
        error(("onNeedNuid data.x is empty: %s"):format(data.x), 2)
    end

    if self.utils:isEmpty(data.y) then
        error(("onNeedNuid data.y is empty: %s"):format(data.y), 2)
    end

    if self.utils:isEmpty(data.initSerializedB64Str) then
        error(("onNeedNuid data.initSerializedB64Str is empty: %s"):format(data.initSerializedB64Str), 2)
    end

    local initSerializedB64Str   = nil
    local serializedEntityString = nil
    local closestServerEntityId  = EntityGetClosest(data.x, data.y)
    local nuid                   = nil

    if not self.utils:isEmpty(closestServerEntityId) then
        initSerializedB64Str = self.noitaComponentUtils:getInitialSerializedEntityString(closestServerEntityId)
        if initSerializedB64Str == data.initSerializedB64Str then -- entity on server and client are the same
            if not self.networkVscUtils:hasNuidSet(closestServerEntityId) then
                local ownerName, ownerGuid, nuid = self.noitaComponentUtils:getEntityData(closestServerEntityId)
                if self.utils:isEmpty(nuid) or nuid < 0 then
                    nuid = self.nuidUtils:getNextNuid()
                    self.networkVscUtils:addOrUpdateAllVscs(closestServerEntityId, ownerName, ownerGuid, nuid)
                end
            end
            serializedEntityString = self.noitaPatcherUtils:serializeEntity(closestServerEntityId)
        else -- create new entity on server
            nuid                 = self.nuidUtils:getNextNuid()
            -- local serverEntityId          = self.entityUtils:spawnEntity(owner, nuid, x, y, rotation,
            --     velocity, filename, localEntityId, health, isPolymorphed)
            local serverEntityId = EntityCreateNew(tostring(data.nuid))
            serverEntityId       = self.noitaPatcherUtils:deserializeEntity(
                serverEntityId, data.initSerializedB64Str, data.x, data.y)
            initSerializedB64Str = data.initSerializedB64Str
            self.noitaComponentUtils:setInitialSerializedEntityString(serverEntityId, initSerializedB64Str)
            serializedEntityString = initSerializedB64Str
        end
    end

    self:sendNewNuid(data.ownerName, data.ownerGuid, data.localEntityId,
        serializedEntityString, nuid, data.x, data.y, initSerializedB64Str)

    sendAck(self, data.networkMessageId, peer, self.networkUtils.events.needNuid.name, nuid)
end


---Callback when Client has a nuid, but no entity.
---@param self Server
---@param data table @see self.networkUtils.events.lostNuid.schema
---@param peer Client|Server
local onLostNuid = function(self, data, peer)
    --self.logger:debug(self.logger.channels.network, ("Peer %s lost a nuid and ask for the entity to spawn. data = %s")
    --    :format(self.utils:pformat(peer), self.utils:pformat(data)))

    if self.utils:isEmpty(peer) then
        error(("onLostNuid peer is empty: %s"):format(self.utils:pformat(peer)), 2)
    end

    if self.utils:isEmpty(data.networkMessageId) then
        error(("onLostNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils:isEmpty(data.nuid) then
        error(("onLostNuid data.nuid is empty: %s"):format(data.nuid), 2)
    end

    local nuid, entityId = self.globalsUtils:getNuidEntityPair(data.nuid)

    if not entityId or not EntityGetIsAlive(entityId) then
        self.logger:warn(self.logger.channels.network, ("onLostNuid(%s): Entity %s already dead."):format(nuid, entityId))
        if not self.utils:isEmpty(nuid) then
            self:sendDeadNuids({ nuid })
        end
        sendAck(self, data.networkMessageId, peer, self.networkUtils.events.lostNuid.name, nuid)
        return
    end

    --local compOwnerName, compOwnerGuid, compNuid     = self.networkVscUtils:getAllVscValuesByEntityId(entityId)
    local compOwnerName, compOwnerGuid, compNuid, filename,
    health, rotation, velocity, x, y = self.noitaComponentUtils:getEntityData(entityId)
    local isPolymorphed              = self.entityUtils:isEntityPolymorphed(entityId)

    --self.sendNewNuid({ compOwnerName, compOwnerGuid },
    --                 "unknown", nuid, x, y, rotation, velocity, filename, health, isPolymorphed)
    local serializedEntityString     = self.noitaPatcherUtils:serializeEntity(entityId)
    self:sendNewNuid(compOwnerName, compOwnerGuid, entityId, serializedEntityString, compNuid, x, y,
        self.noitaComponentUtils:getInitialSerializedEntityString(entityId))

    sendAck(self, data.networkMessageId, peer, self.networkUtils.events.lostNuid.name, data.nuid)
end

---Callback when entity data received.
---@private
---@param self Server
---@param data table data { networkMessageId, owner { name, guid }, localEntityId, nuid, x, y, rotation, velocity { x, y }, health }
---@param peer Client|Server
local onEntityData = function(self, data, peer)
    --self.logger:debug(self.logger.channels.network, ("Received entityData for nuid = %s! data = %s")
    --    :format(data.nuid, self.utils:pformat(data)))

    if self.utils:isEmpty(data.networkMessageId) then
        error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
    end

    if self.utils:isEmpty(data.owner) then
        error(("onNewNuid data.owner is empty: %s"):format(self.utils:pformat(data.owner)), 2)
    end

    --if self.utils:isEmpty(data.localEntityId) then
    --    error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 2)
    --end

    if self.utils:isEmpty(data.nuid) then
        error(("onNewNuid data.nuid is empty: %s"):format(data.nuid), 2)
    end

    if self.utils:isEmpty(data.x) then
        error(("onNewNuid data.x is empty: %s"):format(data.x), 2)
    end

    if self.utils:isEmpty(data.y) then
        error(("onNewNuid data.y is empty: %s"):format(data.y), 2)
    end

    if self.utils:isEmpty(data.rotation) then
        error(("onNewNuid data.rotation is empty: %s"):format(data.rotation), 2)
    end

    if self.utils:isEmpty(data.velocity) then
        error(("onNewNuid data.velocity is empty: %s"):format(self.utils:pformat(data.velocity)), 2)
    end

    if self.utils:isEmpty(data.health) then
        error(("onNewNuid data.health is empty: %s"):format(data.health), 2)
    end

    local owner                = data.owner
    local nnuid, localEntityId = self.globalsUtils:getNuidEntityPair(data.nuid)
    local nuid                 = data.nuid
    local x                    = data.x
    local y                    = data.y
    local rotation             = data.rotation
    local velocity             = data.velocity
    local health               = data.health

    self.noitaComponentUtils:setEntityData(localEntityId, x, y, rotation, velocity, health)

    --self:sendToAllBut(peer, self.networkUtils.:events.entityData.name, data)

    --sendAck(data.networkMessageId, peer, data.nuid)
end

---Callback when dead nuids received.
---@param self Server
---@param data table data { networkMessageId, deadNuids }
---@param peer Client|Server
local onDeadNuids = function(self, data, peer)
    local deadNuids = data.deadNuids or data or {}
    for i = 1, #deadNuids do
        local deadNuid = deadNuids[i]
        if self.utils:isEmpty(deadNuid) or deadNuid == "nil" then
            error(("onDeadNuids deadNuid is empty: %s"):format(deadNuid), 2)
        else
            if peer then
                self.entityUtils:destroyByNuid(peer, deadNuid)
            end
            self.globalsUtils:removeDeadNuid(deadNuid)
            self.entityCache:deleteNuid(deadNuid)
        end
    end
    if peer then
        self:sendToAllBut(peer, self.networkUtils.events.deadNuids.name, data)
        sendAck(self, data.networkMessageId, peer, self.networkUtils.events.deadNuids.name)
    end
end


---Callback when mod list is requested.
---@param self Server
---@param data table data { networkMessageId, workshop, external }
---@param peer Client|Server
local onNeedModList = function(self, data, peer)
    if self.modListCached == nil then
        local modXML  = self.fileUtils:ReadFile(self.fileUtils:GetAbsoluteDirectoryPathOfParentSave() .. "\\save00\\mod_config.xml")
        local modList = {
            workshop = {},
            external = {}
        }
        modXML:gsub('<Mod([a-zA-Z_-"]+)>', function(item)
            if item:find('enabled="1"') ~= nil then
                local workshopID
                local name
                item:gsub('workshop_item_id="([0-9]+)"', function(wID)
                    workshopID = wID
                end)
                item:gsub('name="([a-zA-Z0-9_-]+)"', function(mID)
                    name = mID
                end)
                if workshopID == nil or name == nil then
                    error("onNeedModList: Failed to parse mod_config.xml", 2)
                end
                table.insert((workshopID ~= "0" and modList.workshop or modList.external), {
                    workshopID = workshopID,
                    name       = name
                })
            end
        end)
        self.modListCached = modList
    end
    peer:send(peer, self.networkUtils.events.needModList.name,
        { self.networkUtils:getNextNetworkMessageId(), self.modListCached.workshop, self.modListCached.external })
end

---Callback when mod content is requested.
---@param self Server
---@param data table data { networkMessageId, items }
---@param peer Client|Server
local onNeedModContent = function(self, data, peer)
    local modsToGet = data.get
    local res       = {}
    for i, mod in ipairs(modsToGet) do
        local modId = "0"
        for _ = 1, #self.modListCached.workshop do
            if self.modListCached.workshop[_].name == mod then
                modId = self.modListCached.workshop[_].workshopID
            end
        end
        local pathToMod
        if modId ~= "0" then
            pathToMod = ("C:/Program Files (x86)/Steam/steamapps/workshop/content/881100/%s/"):format(modId)
        else
            pathToMod = (self.fileUtils:GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(mod)
        end
        local archiveName = ("%s_%s_mod_sync"):format(tostring(os.date("!")), mod)
        self.fileUtils:Create7zipArchive(archiveName, pathToMod, self.fileUtils:GetAbsoluteDirectoryPathOfNoitaMP())
        table.insert(res, {
            name       = mod,
            workshopID = mod,
            data       = self.fileUtils:ReadBinaryFile(archiveName)
        })
    end
    peer:send(peer, self.networkUtils.events.needModContent.name, { self.networkUtils:getNextNetworkMessageId(), modsToGet, res })
end


---Sets callbacks and schemas of the client.
---@private
---@param self Server
local setCallbackAndSchemas = function(self)
    --self:setSchema(self.networkUtils.:events.connect, { "code" })
    self:on(self.networkUtils.events.connect.name, onConnect)

    self:setSchema(self.networkUtils.events.connect2.name, self.networkUtils.events.connect2.schema)
    --self:on(self.networkUtils.:events.connect2.name, onConnect2)

    --self:setSchema(self.networkUtils.:events.disconnect, { "code" })
    self:on(self.networkUtils.events.disconnect.name, onDisconnect)

    self:setSchema(self.networkUtils.events.disconnect2.name, self.networkUtils.events.disconnect2.schema)
    --self:on(self.networkUtils.:events.disconnect2.name, onDisconnect2)

    self:setSchema(self.networkUtils.events.acknowledgement.name, self.networkUtils.events.acknowledgement.schema)
    self:on(self.networkUtils.events.acknowledgement.name, onAcknowledgement)

    --self:setSchema(self.networkUtils.:events.seed.name, self.networkUtils.:events.seed.schema)
    --self:on(self.networkUtils.:events.seed.name, onSeed)

    self:setSchema(self.networkUtils.events.minaInformation.name, self.networkUtils.events.minaInformation.schema)
    self:on(self.networkUtils.events.minaInformation.name, onMinaInformation)

    -- self:setSchema(self.networkUtils.:events.newNuid.name, self.networkUtils.:events.newNuid.schema)
    -- self:on(self.networkUtils.:events.newNuid.name, onNewNuid)

    self:setSchema(self.networkUtils.events.needNuid.name, self.networkUtils.events.needNuid.schema)
    self:on(self.networkUtils.events.needNuid.name, onNeedNuid)

    self:setSchema(self.networkUtils.events.lostNuid.name, self.networkUtils.events.lostNuid.schema)
    self:on(self.networkUtils.events.lostNuid.name, onLostNuid)

    -- self:setSchema(self.networkUtils.:events.entityData.name, self.networkUtils.:events.entityData.schema)
    -- self:on(self.networkUtils.:events.entityData.name, onEntityData)

    self:setSchema(self.networkUtils.events.deadNuids.name, self.networkUtils.events.deadNuids.schema)
    self:on(self.networkUtils.events.deadNuids.name, onDeadNuids)

    self:setSchema(self.networkUtils.events.needModList.name, self.networkUtils.events.needModList.schema)
    self:on(self.networkUtils.events.needModList.name, onNeedModList)

    self:setSchema(self.networkUtils.events.needModContent.name, self.networkUtils.events.needModContent.schema)
    self:on(self.networkUtils.events.needModContent.name, onNeedModContent)
end


---Sends a message a one peer.
---@param peer Client|Server required
---@param event string required
---@param data table required
---@return boolean true if message was sent, false if not
function Server:send(peer, event, data)
    if type(data) ~= "table" then
        error("Data type must be table!", 2)
    end

    if self.networkUtils:alreadySent(peer, event, data) then
        --self.logger:debug(self.logger.channels.network, ("Network message for %s for data %s already was acknowledged.")
        --    :format(event, self.utils:pformat(data)))
        return false
    end

    local networkMessageId = self:sendToPeer(peer, event, data)

    if event ~= self.networkUtils.events.acknowledgement.name then
        if self.networkUtils.events[event].isCacheable == true then
            self.networkCacheUtils:set(peer.guid, networkMessageId, event,
                self.networkUtils.events.acknowledgement.sent, 0, os.clock(), data)
        end
    end
    return true
end

---Sends a message to all peers.
---@param event string required
---@param data table required
---@return boolean true if message was sent, false if not
function Server:sendToAll(event, data)
    if not self.clients then
        error("self.clients must not be nil!", 2)
    end

    local sent = false
    for i = 1, #self.clients do
        sent = self:send(self.clients[i], event, data)
    end
    return sent
end

---Sends a message to all peers excluded one peer defined as the peer param.
---@param peer Client|Server required
---@param event string required
---@param data table required
---@return boolean true if message was sent, false if not
function Server:sendToAllBut(peer, event, data)
    if not self.clients then
        error("self.clients must not be nil!", 2)
    end

    local sent = false
    for i = 1, #self.clients do
        if self.clients[i].connectId ~= peer.connectId then
            sent = self:send(self.clients[i], event, data)
        end
    end
    return sent
end

---Starts a server on ip and port. Both can be nil, then ModSettings will be used.
---@param ip string|nil localhost or 127.0.0.1 or nil
---@param port number|nil port number from 1 to max of 65535 or nil
function Server:preStart(ip, port)
    if not ip then
        ip = self:getAddress()
    end

    if not port then
        port = self:getPort()
    end

    self:stop()

    self.logger:info(self.logger.channels.network, ("Starting server on %s:%s.."):format(ip, port))

    local success = self:start(ip, port, self.fileUtils, self.logger)
    if success == true then
        self.logger:info(self.logger.channels.network, ("Server started on %s:%s"):format(self:getAddress(), self:getPort()))

        self.guidUtils:setGuid(nil, self, self.guid)
        self:setSerialization(self.networkUtils.serialize, self.networkUtils.deserialize)
        setCallbackAndSchemas(self)

        GamePrintImportant("Server started", ("Your server is running on %s:%s. Tell your friends to join!")
            :format(self:getAddress(), self:getPort()))
    else
        GamePrintImportant("Server didn't start!", "Try again, otherwise restart Noita.")
    end
end

---Stops the server.
function Server:stop()
    if self:isRunning() then
        self:destroy()
    else
        self.logger:info(self.logger.channels.network, "Server isn't running, there cannot be stopped.")
    end
end

---Returns true if server is running, false if not.
---@return boolean true if server is running, false if not
function Server:isRunning() -- TODO: remove this before merge
    local status, result = pcall(self.getSocketAddress, self)
    if not status then
        return false
    end
    if DebugGetIsDevBuild() and lldebugger then -- TODO: remove this before merge
        lldebugger.start(true)                  -- TODO: remove this before merge
    end
    return true
end

local prevTime = 0
---Updates the server by checking for network events and handling them.
---@param startFrameTime number required
---@see SockServer.update
function Server:preUpdate(startFrameTime)
    if not self:isRunning() then
        --if not self.host then server not established
        return
    end

    if self.utils:isEmpty(self.minaUtils:getLocalMinaNuid()) then
        local entityId = self.minaUtils:getLocalMinaEntityId()
        local hasNuid, nuid = self.networkVscUtils:hasNuidSet(entityId)
        if not hasNuid or self.utils:isEmpty(nuid) then
            nuid = self.nuidUtils:getNextNuid()
            self.networkVscUtils:addOrUpdateAllVscs(entityId, self.minaUtils:getLocalMinaName(), self.minaUtils:getLocalMinaGuid(), nuid, nil, nil)
        end
    end
    self:sendMinaInformation()

    self.entityUtils:syncEntities(startFrameTime, self, nil)

    local nowTime     = GameGetRealWorldTimeSinceStarted() * 1000 -- *1000 to get milliseconds
    local elapsedTime = nowTime - prevTime
    local oneTickInMs = 1000 / tonumber(ModSettingGet("noita-mp.tick_rate"))
    if elapsedTime >= oneTickInMs then
        prevTime   = nowTime
        --if since % tonumber(ModSettingGet("noita-mp.tick_rate")) == 0 then
        --updateVariables()

        --self.entityUtils:syncEntityData()
        self.entityUtils:syncDeadNuids(self, nil)
        --end
    end

    self:update()
end

---Sends a message to the client, when there is a guid clash.
---@param peer Client|Server
---@param oldGuid string
---@param newGuid string
---@return boolean true if message was sent, false if not
function Server:sendNewGuid(peer, oldGuid, newGuid)
    local event = self.networkUtils.events.newGuid.name
    local data  = { self.networkUtils:getNextNetworkMessageId(), oldGuid, newGuid }
    local sent  = self:send(peer, event, data)
    return sent
end

---Sends a new nuid to all clients. This also creates/updates the entities on clients.
---@param ownerName string required
---@param ownerGuid string required
---@param entityId number required
---@param currentSerializedB64Str string required
---@param nuid number required
---@param x number required
---@param y number required
---@param initSerializedB64Str string required
---@return boolean true if message was sent, false if not
function Server:sendNewNuid(ownerName, ownerGuid, entityId, currentSerializedB64Str, nuid, x, y, initSerializedB64Str)
    if self.utils:isEmpty(ownerName) then
        error(("ownerName must not be nil or empty %s"):format(ownerName), 2)
    end
    if self.utils:isEmpty(ownerGuid) then
        error(("ownerGuid must not be nil or empty %s"):format(ownerGuid), 2)
    end
    if self.utils:isEmpty(entityId) then
        error(("entityId must not be nil or empty %s"):format(entityId), 2)
    end
    if self.utils:isEmpty(currentSerializedB64Str) or type(currentSerializedB64Str) ~= "string" then
        error(("currentSerializedB64Str must not be nil or empty %s or is not of type 'string'."):format(currentSerializedB64Str), 2)
    end
    if self.utils:isEmpty(nuid) then
        error(("nuid must not be nil or empty %s"):format(nuid), 2)
    end
    if self.utils:isEmpty(x) then
        error(("x must not be nil or empty %s"):format(x), 2)
    end
    if self.utils:isEmpty(y) then
        error(("y must not be nil or empty %s"):format(y), 2)
    end
    if self.utils:isEmpty(initSerializedB64Str) or type(initSerializedB64Str) ~= "string" then
        error(("initSerializedB64Str must not be nil or empty %s or is not of type 'string'."):format(initSerializedB64Str), 2)
    end

    local event = self.networkUtils.events.newNuid.name
    local data  = { self.networkUtils:getNextNetworkMessageId(), ownerName, ownerGuid, entityId, x, y, initSerializedB64Str, currentSerializedB64Str,
        nuid }
    local sent  = self:sendToAll(event, data)

    -- FOR TESTING ONLY, DO NOT MERGE
    --print(self.utils:pformat(data))
    --os.exit()

    if sent == true then
        self.noitaComponentUtils:setNetworkSpriteIndicatorStatus(entityId, "sent")
    end
    return sent
end

---Sends entity data to all clients.
---@param entityId number required
function Server:sendEntityData(entityId)
    if not EntityGetIsAlive(entityId) then
        return
    end

    --local compOwnerName, compOwnerGuid, compNuid     = self.networkVscUtils:getAllVscValuesByEntityId(entityId)
    local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = self.noitaComponentUtils:getEntityData(entityId)
    local data                                                                               = {
        self.networkUtils:getNextNetworkMessageId(), { compOwnerName, compOwnerGuid }, compNuid, x, y, rotation, velocity, health
    }

    if self.utils:isEmpty(compNuid) then
        -- nuid must not be empty, when Server!
        --logger:error(logger.channels.network, "Unable to send entity data, because nuid is empty.")
        --return
        local newNuid = self.nuidUtils:getNextNuid()
        self.networkVscUtils:addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, newNuid)
        --self.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, newNuid, x, y, rotation, velocity, filename,
        --                 health, self.entityUtils:isEntityPolymorphed(entityId))
        self:sendNewNuid(compOwnerName, compOwnerGuid, entityId, self.entityUtils:serializeEntity(entityId), newNuid, x, y,
            self.noitaComponentUtils:getInitialSerializedEntityString(entityId))
    end

    if self.minaUtils:getLocalMinaGuid() == compOwnerGuid then
        self:sendToAll(self.networkUtils.events.entityData.name, data)
    end
end

---Sends dead nuids to all clients.
---@param deadNuids table required
function Server:sendDeadNuids(deadNuids)
    local data = {
        self.networkUtils:getNextNetworkMessageId(), deadNuids
    }
    self:sendToAll(self.networkUtils.events.deadNuids.name, data)
    -- peer is nil when server, because a callback is executed manually
    onDeadNuids(self, deadNuids, nil)
end

---Sends mina information to all clients.
---@return boolean
function Server:sendMinaInformation()
    local name                                                             = self.minaUtils:getLocalMinaName()
    local guid                                                             = self.minaUtils:getLocalMinaGuid()
    local entityId                                                         = self.minaUtils:getLocalMinaEntityId()
    local nuid                                                             = self.minaUtils:getLocalMinaNuid()
    local _name, _guid, _nuid, _filename, health, rotation, velocity, x, y = self.noitaComponentUtils:getEntityData(entityId) -- TODO: rework this
    local data                                                             = {
        self.networkUtils:getNextNetworkMessageId(), self.fileUtils:GetVersionByFile(), name, guid, entityId, nuid, { x = x, y = y }, health
    }
    local sent                                                             = self:sendToAll(self.networkUtils.events.minaInformation.name, data)
    return sent
end

---Checks if the current local user is a server.
---@return boolean true if server, false if not
---@see Client.amIClient
function Server:amIServer()
    return self:isRunning()
end

---Kicks a player by name.
---@param name string required
function Server:kick(name)
    self.logger:debug(self.logger.channels.network, ("Mina %s was kicked!"):format(name))
end

---Bans a player by name.
---@param name string required
function Server:ban(name)
    self.logger:debug(self.logger.channels.network, ("Mina %s was banned!"):format(name))
end

---Mainly for profiling. Returns then network cache, aka acknowledge.
---@return number cacheSize
function Server:getAckCacheSize()
    return self.networkCache:size()
end

---Server constructor. Inherits from SockServer sock.newServer.
---@param address string|nil optional
---@param port number|nil optional
---@param maxPeers number|nil optional
---@param maxChannels number|nil optional
---@param inBandwidth number|nil optional
---@param outBandwidth number|nil optional
---@param np noitapatcher required
---@return Server
function Server.new(address, port, maxPeers, maxChannels, inBandwidth, outBandwidth, np)
    ---@class Server : SockClient
    local serverObject = setmetatable(
            require("SockServer").new(address, port, maxPeers, maxChannels, inBandwidth, outBandwidth)
            , Server) or
        error("Unable to create new sock server!", 2)

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not serverObject.noitaMpSettings then
        ---@type NoitaMpSettings
        serverObject.noitaMpSettings = require("NoitaMpSettings")
            :new(nil, nil, nil, nil, nil, nil, nil, nil, nil)
    end

    if not serverObject.customProfiler then
        ---@type CustomProfiler
        serverObject.customProfiler = serverObject.noitaMpSettings.customProfiler or
            require("CustomProfiler")
            :new(nil, nil, serverObject.noitaMpSettings, nil, nil, nil, nil)
    end

    if not serverObject.logger or type(serverObject.logger) ~= "Logger" then
        ---@type Logger
        serverObject.logger = serverObject.noitaMpSettings.logger or
            require("Logger")
            :new(nil, serverObject.noitaMpSettings) or
            error("serverObject.logger must not be nil!", 2)
    end

    if not serverObject.utils then
        ---@type Utils
        serverObject.utils = serverObject.noitaMpSettings.utils or
            error("serverObject.noitaMpSettings.utils must not be nil!", 2)
    end

    if not serverObject.globalsUtils then
        ---@type GlobalsUtils
        ---@see GlobalsUtils
        serverObject.globalsUtils = require("GlobalsUtils")
            :new(nil, serverObject.customProfiler, serverObject.logger, nil, serverObject.utils) or
            error("Unable to create GlobalsUtils!", 2)
    end

    if not serverObject.networkVscUtils then
        ---@type NetworkVscUtils
        serverObject.networkVscUtils = require("NetworkVscUtils")
            :new(nil, serverObject.customProfiler, serverObject.logger, serverObject,
                serverObject.globalsUtils, serverObject.utils)
    end

    if not serverObject.minaUtils then
        ---@type MinaUtils
        serverObject.minaUtils = require("MinaUtils")
            :new(nil, serverObject.customProfiler, serverObject.globalsUtils, serverObject.logger,
                serverObject.networkVscUtils, serverObject.noitaMpSettings, serverObject.noitaMpSettings.utils) or
            error("Unable to create MinaUtils!", 2)
    end

    if not serverObject.fileUtils then
        ---@type FileUtils
        ---@see FileUtils
        serverObject.fileUtils = require("FileUtils")
            :new(nil, serverObject.customProfiler, serverObject.logger, serverObject.noitaMpSettings,
                nil, serverObject.utils)
        serverObject.customProfiler.fileUtils = serverObject.fileUtils
    end

    if not serverObject.nuidUtils then
        ---@type NuidUtils
        serverObject.nuidUtils = require("NuidUtils")
            :new(nil, {}, serverObject.customProfiler, serverObject.fileUtils, serverObject.globalsUtils,
                serverObject.logger, nil)
    end

    if not serverObject.guidUtils then
        ---@type GuidUtils
        ---@see GuidUtils
        serverObject.guidUtils = require("GuidUtils")
            :new(nil, serverObject.customProfiler, serverObject.fileUtils, serverObject.logger,
                nil, nil, serverObject.utils)
    end

    if not serverObject.networkCache then
        ---@type NetworkCache
        serverObject.networkCache = require("NetworkCache")
            :new(serverObject.customProfiler, serverObject.logger, serverObject.utils)
    end

    if not serverObject.networkCacheUtils then
        ---@type NetworkCacheUtils
        serverObject.networkCacheUtils = require("NetworkCacheUtils")
            :new(serverObject.customProfiler, serverObject.guidUtils, serverObject.logger, nil, serverObject.networkCache,
                nil, serverObject.utils)
    end

    if not serverObject.networkUtils then
        ---@type NetworkUtils
        serverObject.networkUtils = serverObject.networkCacheUtils.networkUtils or
            require("NetworkUtils")
            :new(serverObject.customProfiler, serverObject.guidUtils, serverObject.logger,
                serverObject.networkCacheUtils, serverObject.utils)
    end

    if not serverObject.noitaPatcherUtils then
        serverObject.noitaPatcherUtils = require("NoitaPatcherUtils")
            :new(serverObject.customProfiler, np)
    end

    if not serverObject.noitaComponentUtils then
        ---@type NoitaComponentUtils
        serverObject.noitaComponentUtils = require("NoitaComponentUtils")
            :new(nil, serverObject.customProfiler, serverObject.globalsUtils, serverObject.logger,
                serverObject.networkVscUtils, serverObject.utils, serverObject.noitaPatcherUtils)
    end

    if not serverObject.entityCache then
        ---@type EntityCache
        serverObject.entityCache = require("EntityCache")
            :new(nil, serverObject.customProfiler, nil, serverObject.noitaMpSettings.utils)
    end

    if not serverObject.entityCacheUtils then
        ---@type EntityCacheUtils
        ---@see EntityCacheUtils
        serverObject.entityCacheUtils = require("EntityCacheUtils")
            :new(nil, serverObject.customProfiler, serverObject.entityCache, serverObject.noitaMpSettings.utils)
    end

    if not serverObject.entityUtils then
        serverObject.entityUtils = require("EntityUtils")
            :new({}, serverObject.customProfiler, serverObject.entityCacheUtils, serverObject.entityCache,
                serverObject.globalsUtils, serverObject.noitaMpSettings.logger, serverObject.minaUtils,
                serverObject.networkUtils, serverObject.networkVscUtils, serverObject.noitaComponentUtils,
                serverObject.noitaMpSettings, serverObject.nuidUtils, serverObject, serverObject.noitaMpSettings.utils, np) or
            error("Unable to create EntityUtils!", 2)

        serverObject.entityCache.entityUtils = serverObject.entityUtils
    end

    -- [[ Attributes ]]

    serverObject.acknowledgeMaxSize = 1024
    serverObject.guid               = nil
    serverObject.health             = { current = 99, max = 100 }
    serverObject.iAm                = "SERVER"
    serverObject.modListCached      = nil
    serverObject.name               = nil
    serverObject.nuid               = nil
    serverObject.transform          = { x = 0, y = 0 }

    -- Functions for initialization

    serverObject:setSerialization(serverObject.networkUtils.serialize, serverObject.networkUtils.deserialize)

    serverObject.name = tostring(serverObject.noitaMpSettings:get("noita-mp.nickname", "string"))
    serverObject.guid = tostring(serverObject.noitaMpSettings:get("noita-mp.guid", "string"))
    serverObject.guidUtils:setGuid(nil, serverObject, serverObject.guid)

    print("Server loaded, instantiated and inherited!")
    return serverObject
end

return Server
