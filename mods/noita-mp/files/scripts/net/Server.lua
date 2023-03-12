-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------
--- 'Imports'
----------------------------------------
local sock        = require("sock")
local util        = require("util")
local fu          = require("file_util")
local zstandard   = require("zstd")
local messagePack = require("MessagePack")

----------------------------------------------------------------------------------------------------
--- Server
---@type Server
----------------------------------------------------------------------------------------------------
Server            = {}

----------------------------------------
--- Global private variables:
----------------------------------------

----------------------------------------
--- Global private methods:
----------------------------------------

----------------------------------------
--- Access to global private variables
----------------------------------------

----------------------------------------
--- Global public variables:
----------------------------------------

----------------------------------------------------------------------------------------------------
--- Server constructor
----------------------------------------------------------------------------------------------------
--- Creates a new instance of server 'class'
---@param sockServer table sock.lua#newServer
---@return Server Server
function Server.new(sockServer)
    local cpc               = CustomProfiler.start("Server.new")
    local self              = sockServer

    ------------------------------------
    --- Private variables:
    ------------------------------------

    ------------------------------------
    --- Public variables:
    ------------------------------------
    self.iAm                = "SERVER"
    self.name               = tostring(ModSettingGet("noita-mp.name"))
    -- guid might not be set here or will be overwritten at the end of the constructor. @see setGuid
    self.guid               = tostring(ModSettingGet("noita-mp.guid"))
    self.nuid               = nil
    --self.acknowledge        = {} -- sock.lua#Client:send -> self.acknowledge[packetsSent] = { event = event, data = data, entityId = data.entityId, status = NetworkUtils.events.acknowledgement.sent }
    --table.setNoitaMpDefaultMetaMethods(self.acknowledge, "v")
    self.acknowledgeMaxSize = 500
    self.transform          = { x = 0, y = 0 }
    self.health             = { current = 99, max = 100 }
    self.modListCached      = nil


    ------------------------------------
    --- Private methods:
    ------------------------------------

    ------------------------------------------------------------------------------------------------
    --- Set servers settings
    ------------------------------------------------------------------------------------------------
    local function setConfigSettings()
        local cpc0        = CustomProfiler.start("Server.setConfigSettings")
        local serialize   = function(anyValue)
            local cpc1            = CustomProfiler.start("Server.setConfigSettings.serialize")
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
            CustomProfiler.stop("Server.setConfigSettings.serialize", cpc1)
            return compressed
        end

        local deserialize = function(anyValue)
            local cpc2              = CustomProfiler.start("Server.setConfigSettings.deserialize")
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
            CustomProfiler.stop("Server.setConfigSettings.deserialize", cpc2)
            return deserialized
        end

        self:setSerialization(serialize, deserialize)
        CustomProfiler.stop("Server.setConfigSettings", cpc0)
    end

    ------------------------------------------------------------------------------------------------
    --- Set servers guid
    ------------------------------------------------------------------------------------------------
    local function setGuid()
        local cpc01 = CustomProfiler.start("Server.setGuid")
        local guid  = tostring(ModSettingGetNextValue("noita-mp.guid"))

        if guid == "" or GuidUtils.isPatternValid(guid) == false then
            guid = GuidUtils:getGuid()
            ModSettingSetNextValue("noita-mp.guid", guid, false)
            self.guid = guid
            Logger.debug(Logger.channels.network, "Servers guid set to " .. guid)
        else
            Logger.debug(Logger.channels.network, "Servers guid was already set to " .. guid)
        end

        if DebugGetIsDevBuild() then
            guid = guid .. self.iAm
        end
        CustomProfiler.stop("Server.setGuid", cpc01)
    end

    ------------------------------------------------------------------------------------------------
    --- Send acknowledgement
    ------------------------------------------------------------------------------------------------
    local function sendAck(networkMessageId, peer, event)
        local cpc02 = CustomProfiler.start("Server.sendAck")
        if not event then
            error("event is nil", 2)
        end
        local data = { networkMessageId, event, NetworkUtils.events.acknowledgement.ack, os.clock() }
        self:sendToPeer(peer, NetworkUtils.events.acknowledgement.name, data)
        Logger.debug(Logger.channels.network, ("Sent ack with data = %s"):format(util.pformat(data)))
        CustomProfiler.stop("Server.sendAck", cpc02)
    end

    ------------------------------------------------------------------------------------------------
    --- onAcknowledgement
    ------------------------------------------------------------------------------------------------
    local function onAcknowledgement(data, peer)
        local cpc03 = CustomProfiler.start("Server.onAcknowledgement")
        Logger.debug(Logger.channels.network, "onAcknowledgement: Acknowledgement received.", util.pformat(data))

        if util.IsEmpty(data.networkMessageId) then
            error(("onAcknowledgement data.networkMessageId is empty: %s"):format(data.networkMessageId), 2)
        end

        if not data.networkMessageId then
            error(("Unable to get acknowledgement with networkMessageId = %s, data = %s, peer = %s")
                          :format(networkMessageId, data, peer), 2)
        end

        if util.IsEmpty(data.event) then
            error(("onAcknowledgement data.event is empty: %s"):format(data.event), 2)
        end

        if util.IsEmpty(data.status) then
            error(("onAcknowledgement data.status is empty: %s"):format(data.status), 2)
        end

        if util.IsEmpty(data.ackedAt) then
            error(("onAcknowledgement data.ackedAt is empty: %s"):format(data.ackedAt), 2)
        end

        if not peer.clientCacheId then
            peer.clientCacheId = GuidUtils.toNumber(peer.guid)
        end

        local cachedData = NetworkCacheUtils.get(self.guid, data.networkMessageId, data.event)
        if util.IsEmpty(cachedData) or type(cachedData.dataChecksum) ~= "string" or util.IsEmpty(cachedData.dataChecksum) then
            error(("Unable to get cached data, because it is nil '%s' or checksum is not of type string: %s or dataChecksum is empty")
                          :format(cachedData.dataChecksum), 2)
        end
        -- update previous cached network message
        NetworkCacheUtils.ack(self.guid, data.networkMessageId, data.event,
                              data.status, os.clock(), cachedData.sentAt, cachedData.dataChecksum)

        if NetworkCache.size() > self.acknowledgeMaxSize then
            NetworkCache.removeOldest()
        end
        CustomProfiler.stop("Server.onAcknowledgement", cpc03)
    end

    ------------------------------------------------------------------------------------------------
    --- onConnect
    ------------------------------------------------------------------------------------------------
    --- Callback when client connected to server.
    --- @param data number not in use atm
    --- @param peer table
    local function onConnect(data, peer)
        local cpc04 = CustomProfiler.start("Server.onConnect")
        Logger.debug(Logger.channels.network, ("Peer %s connected! data = %s")
                :format(util.pformat(peer), util.pformat(data)))

        if util.IsEmpty(peer) then
            error(("onConnect peer is empty: %s"):format(peer), 3)
        end

        if util.IsEmpty(data) then
            error(("onConnect data is empty: %s"):format(data), 3)
        end

        local localPlayerInfo            = MinaUtils.getLocalMinaInformation()
        local name                       = localPlayerInfo.name
        local guid                       = localPlayerInfo.guid
        local entityId                   = localPlayerInfo.entityId
        local isPolymorphed              = EntityUtils.isEntityPolymorphed(entityId)
        local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)

        if not nuid then
            nuid = NuidUtils.getNextNuid()
            NetworkVscUtils.addOrUpdateAllVscs(entityId, name, guid, nuid)
        end

        if peer.guid == guid then
            local oldGuid = peer.guid
            peer.guid     = GuidUtils:getGuid({ guid })
            self.sendNewGuid(peer, oldGuid, peer.guid)
        end

        self:send(peer, NetworkUtils.events.playerInfo.name,
                  { NetworkUtils.getNextNetworkMessageId(), name, guid, fu.getVersionByFile(), nuid })

        self:send(peer, NetworkUtils.events.seed.name,
                  { NetworkUtils.getNextNetworkMessageId(), StatsGetValue("world_seed") })

        -- Let the other clients know, that a new client connected
        self:sendToAllBut(peer, NetworkUtils.events.connect2.name,
                          { NetworkUtils.getNextNetworkMessageId(), peer.name, peer.guid })

        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        --self.sendNewNuid({ name, guid }, entityId, nuid, x, y, rotation, velocity, filename, health, isPolymorphed)

        CustomProfiler.stop("Server.onConnect", cpc04)
    end

    ------------------------------------------------------------------------------------------------
    --- onDisconnect
    ------------------------------------------------------------------------------------------------
    --- Callback when client disconnected from server.
    --- @param data table
    --- @param peer table
    local function onDisconnect(data, peer)
        local cpc05 = CustomProfiler.start("Server.onDisconnect")
        Logger.debug(Logger.channels.network, "Disconnected from server!", util.pformat(data))

        if util.IsEmpty(peer) then
            error(("onConnect peer is empty: %s"):format(peer), 3)
        end

        if util.IsEmpty(data) then
            error(("onDisconnect data is empty: %s"):format(data), 3)
        end

        Logger.debug(Logger.channels.network, "Disconnected from server!", util.pformat(data))
        -- Let the other clients know, that one client disconnected
        self:sendToAllBut(peer, NetworkUtils.events.disconnect2.name,
                          { NetworkUtils.getNextNetworkMessageId(), peer.name, peer.guid, peer.nuid })
        if peer.nuid then
            EntityUtils.destroyByNuid(peer, peer.nuid)
        end

        -- clear acknowledge cache for disconnected peer
        if not peer.clientCacheId then
            peer.clientCacheId = GuidUtils.toNumber(peer.guid) --error("peer.clientCacheId must not be nil!", 2)
        end
        NetworkCache.clear(peer.clientCacheId)

        -- sendAck(data.networkMessageId, peer)
        CustomProfiler.stop("Server.onDisconnect", cpc05)
    end

    ------------------------------------------------------------------------------------------------
    --- onPlayerInfo
    ------------------------------------------------------------------------------------------------
    --- Callback when Server sent his playerInfo to the client
    --- @param data table data { networkMessageId, name, guid }
    local function onPlayerInfo(data, peer)
        local cpc06 = CustomProfiler.start("Server.onPlayerInfo")
        Logger.debug(Logger.channels.network, "onPlayerInfo: Player info received.", util.pformat(data))

        if util.IsEmpty(peer) then
            error(("onConnect peer is empty: %s"):format(peer), 3)
        end

        if util.IsEmpty(data.networkMessageId) then
            error(("onPlayerInfo data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.name) then
            error(("onPlayerInfo data.name is empty: %s"):format(data.name), 3)
        end

        if util.IsEmpty(data.guid) then
            error(("onPlayerInfo data.guid is empty: %s"):format(data.guid), 3)
        end

        --if util.IsEmpty(data.nuid) then
        --    error(("onPlayerInfo data.nuid is empty: %s"):format(data.nuid), 3)
        --end

        if util.IsEmpty(data.version) then
            error(("onPlayerInfo data.version is empty: %s"):format(data.version), 3)
        end

        if fu.getVersionByFile() ~= tostring(data.version) then
            error(("Version mismatch: NoitaMP version of Client: %s and your version: %s")
                          :format(data.version, fu.getVersionByFile()), 3)
            peer:disconnect()
        end

        -- Make sure guids are unique. It's unlikely that two players have the same guid, but it can happen rarely.
        if self.guid == data.guid or table.contains(GuidUtils:getCachedGuids(), data.guid) then
            Logger.warn(Logger.channels.network, ("onPlayerInfo: guid %s is not unique!"):format(data.guid))
            local newGuid = GuidUtils:getGuid({ data.guid })
            --local dataNewGuid = {
            --    NetworkUtils.getNextNetworkMessageId(), data.guid, newGuid
            --}
            self.sendNewGuid(peer, data.guid, newGuid)--self:sendToAll(NetworkUtils.events.newGuid.name, dataNewGuid)
            data.guid = newGuid
        end

        for i, client in pairs(self.clients) do
            if client == peer then
                self.clients[i].name = data.name
                self.clients[i].guid = data.guid
                self.clients[i].nuid = data.nuid

                GuidUtils:addGuidToCache(data.guid)
            end
        end

        sendAck(data.networkMessageId, peer, NetworkUtils.events.playerInfo.name)
        CustomProfiler.stop("Server.onPlayerInfo", cpc06)
    end

    ------------------------------------------------------------------------------------------------
    --- onNeedNuid
    ------------------------------------------------------------------------------------------------
    local function onNeedNuid(data, peer)
        local cpc07 = CustomProfiler.start("Server.onNeedNuid")
        Logger.debug(Logger.channels.network, ("Peer %s needs a new nuid. data = %s")
                :format(util.pformat(peer), util.pformat(data)))

        if util.IsEmpty(peer) then
            error(("onNeedNuid peer is empty: %s"):format(util.pformat(peer)), 3)
        end

        if util.IsEmpty(data.networkMessageId) then
            error(("onNewNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.owner) then
            error(("onNewNuid data.owner is empty: %s"):format(util.pformat(data.owner)), 3)
        end

        if util.IsEmpty(data.localEntityId) then
            error(("onNewNuid data.localEntityId is empty: %s"):format(data.localEntityId), 3)
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

        local owner         = data.owner
        local localEntityId = data.localEntityId
        local x             = data.x
        local y             = data.y
        local rotation      = data.rotation
        local velocity      = data.velocity
        local filename      = data.filename
        local health        = data.health
        local isPolymorphed = data.isPolymorphed

        local newNuid       = NuidUtils.getNextNuid()
        --self.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename, health, isPolymorphed)
        EntityUtils.spawnEntity(owner, newNuid, x, y, rotation, velocity, filename, localEntityId, health,
                                isPolymorphed)

        sendAck(data.networkMessageId, peer, NetworkUtils.events.needNuid.name)
        CustomProfiler.stop("Server.onNeedNuid", cpc07)
    end

    ------------------------------------------------------------------------------------------------
    --- onLostNuid
    ------------------------------------------------------------------------------------------------
    local function onLostNuid(data, peer)
        local cpc08 = CustomProfiler.start("Server.onLostNuid")
        Logger.debug(Logger.channels.network, ("Peer %s lost a nuid and ask for the entity to spawn. data = %s")
                :format(util.pformat(peer), util.pformat(data)))

        if util.IsEmpty(peer) then
            error(("onLostNuid peer is empty: %s"):format(util.pformat(peer)), 3)
        end

        if util.IsEmpty(data.networkMessageId) then
            error(("onLostNuid data.networkMessageId is empty: %s"):format(data.networkMessageId), 3)
        end

        if util.IsEmpty(data.nuid) then
            error(("onLostNuid data.nuid is empty: %s"):format(util.pformat(data.nuid)), 3)
        end

        local nuid, entityId = GlobalsUtils.getNuidEntityPair(data.nuid)

        if not entityId or not EntityUtils.isEntityAlive(entityId) then
            Logger.debug(Logger.channels.network,
                         ("onLostNuid(%s): Entity %s already dead."):format(data.nuid, entityId))
            CustomProfiler.stop("Server.onLostNuid", cpc08)
            sendAck(data.networkMessageId, peer, NetworkUtils.events.lostNuid.name)
            return
        end

        --local compOwnerName, compOwnerGuid, compNuid     = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
        local compOwnerName, compOwnerGuid, compNuid, filename,
        health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local isPolymorphed              = EntityUtils.isEntityPolymorphed(entityId)

        --self.sendNewNuid({ compOwnerName, compOwnerGuid },
        --                 "unknown", nuid, x, y, rotation, velocity, filename, health, isPolymorphed)

        sendAck(data.networkMessageId, peer, NetworkUtils.events.lostNuid.name)
        CustomProfiler.stop("Server.onLostNuid", cpc08)
    end

    local function onEntityData(data, peer)
        local cpc09 = CustomProfiler.start("Server.onEntityData")
        Logger.debug(Logger.channels.network, ("Received entityData for nuid = %s! data = %s")
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

        local owner                = data.owner
        local nnuid, localEntityId = GlobalsUtils.getNuidEntityPair(data.nuid)
        local nuid                 = data.nuid
        local x                    = data.x
        local y                    = data.y
        local rotation             = data.rotation
        local velocity             = data.velocity
        local health               = data.health

        NoitaComponentUtils.setEntityData(localEntityId, x, y, rotation, velocity, health)

        --self:sendToAllBut(peer, NetworkUtils.events.entityData.name, data)

        --sendAck(data.networkMessageId, peer)
        CustomProfiler.stop("Server.onEntityData", cpc09)
    end

    local function onDeadNuids(data, peer)
        local cpc010    = CustomProfiler.start("Server.onDeadNuids")
        local deadNuids = data.deadNuids or data or {}
        for i = 1, #deadNuids do
            local deadNuid = deadNuids[i]
            if util.IsEmpty(deadNuid) or deadNuid == "nil" then
                error(("onDeadNuids deadNuid is empty: %s"):format(deadNuid), 2)
            else
                if peer then
                    EntityUtils.destroyByNuid(peer, deadNuid)
                end
                GlobalsUtils.removeDeadNuid(deadNuid)
                EntityCache.deleteNuid(deadNuid)
            end
        end
        if peer then
            self:sendToAllBut(peer, NetworkUtils.events.deadNuids.name, data)
        end
        CustomProfiler.stop("Server.onDeadNuids", cpc010)
    end

    --self:sendToAllBut(peer, NetworkUtils.events.playerInfo.name)

    local function setClientInfo(data, peer)
        local cpc011 = CustomProfiler.start("Server.setClientInfo")
        local name   = data.name
        local guid   = data.guid

        if not name then
            error("Unable to get clients name!", 2)
        end

        if not guid then
            error("Unable to get clients guid!", 2)
        end

        -- if not GuidUtils:isUnique(guid) then
        --     guid = GuidUtils:getGuid({ guid })
        --     self:sendToPeer(peer, "duplicatedGuid", { guid })
        -- end

        for i, client in pairs(self.clients) do
            if client == peer then
                self.clients[i].name = name
                self.clients[i].guid = guid
            end
        end
        CustomProfiler.stop("Server.setClientInfo", cpc011)
    end

    local function onNeedModList(data, peer)
        local cpc = CustomProfiler.start("Server.onMeedModList")
        if self.modListCached == nil then
            local modXML  = fu.ReadFile(fu.GetAbsoluteDirectoryPathOfParentSave() .. "\\save00\\mod_config.xml")
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
        peer:send(NetworkUtils.events.needModList.name,
                  { NetworkUtils.getNextNetworkMessageId(), self.modListCached.workshop, self.modListCached.external })

        CustomProfiler.stop("Server.onMeedModList", cpc)
    end

    local function onNeedModContent(data, peer)
        local cpc       = CustomProfiler.start("Server.onMeedModList")
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
                pathToMod = (fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/%s/"):format(mod)

            end
            local archiveName = ("%s_%s_mod_sync"):format(tostring(os.date("!")), mod)
            fu.Create7zipArchive(archiveName, pathToMod, fu.GetAbsoluteDirectoryPathOfNoitaMP())
            table.insert(res, {
                name       = mod,
                workshopID = mod,
                data       = fu.ReadBinaryFile(archiveName)
            })
        end
        peer:send(NetworkUtils.events.needModContent.name, { NetworkUtils.getNextNetworkMessageId(), modsToGet, res })
        CustomProfiler.stop("Server.onMeedModList", cpc)
    end

    -- Called when someone connects to the server
    -- self:on("connect", function(data, peer)
    --     logger:debug(logger.channels.network, "Someone connected to the server:", util.pformat(data))

    --     local local_player_id = MinaUtils.getLocalMinaEntityId()
    --     local x, y, rot, scale_x, scale_y = EntityGetTransform(local_player_id)

    --     EntityUtils.spawnEntity({ peer.name, peer.guid }, NuidUtils.getNextNuid(), x, y, rot,
    --         nil, "mods/noita-mp/data/enemies_gfx/client_player_base.xml", nil)
    -- end
    -- )

    -- self:on(
    --     "clientInfo",
    --     function(data, peer)
    --         logger:debug(logger.channels.network, "on_clientInfo: data =", util.pformat(data))
    --         logger:debug(logger.channels.network, "on_clientInfo: peer =", util.pformat(peer))
    --         setClientInfo(data, peer)
    --     end
    -- )

    -- self:on(
    --     "worldFilesFinished",
    --     function(data, peer)
    --         logger:debug(logger.channels.network, "on_worldFilesFinished: data =", util.pformat(data))
    --         logger:debug(logger.channels.network, "on_worldFilesFinished: peer =", util.pformat(peer))
    --         -- Send restart command
    --         peer:send("restart", { "Restart now!" })
    --     end
    -- )

    -- -- Called when the client disconnects from the server
    -- self:on(
    --     "disconnect",
    --     function(data)
    --         logger:debug(logger.channels.network, "on_disconnect: data =", util.pformat(data))
    --     end
    -- )

    -- -- see lua-enet/enet.c
    -- self:on(
    --     "receive",
    --     function(data, channel, client)
    --         logger:debug(logger.channels.network, "on_receive: data =", util.pformat(data))
    --         logger:debug(logger.channels.network, "on_receive: channel =", util.pformat(channel))
    --         logger:debug(logger.channels.network, "on_receive: client =", util.pformat(client))
    --     end
    -- )

    -- self:on(
    --     "needNuid",
    --     function(data)
    --         logger:debug(logger.channels.network, "%s (%s) needs a new nuid.", data.owner.name, data.owner.guid, util.pformat(data))

    --         local new_nuid = NuidUtils.getNextNuid()
    --         -- tell the clients that there is a new entity, they have to spawn, besides the client, who sent the request
    --         self.sendNewNuid(data.owner, data.localEntityId, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename)
    --         -- spawn the entity on server only
    --         EntityUtils.spawnEntity(data.owner, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename, data.localEntityId) --em:spawnEntity(data.owner, new_nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
    --     end
    -- )

    -- self:on(
    --     "newNuid",
    --     function(data)
    --         logger:debug(logger.channels.network, util.pformat(data))

    --         if self.guid == data.owner.guid then
    --             logger:debug(logger.channels.network,
    --                 "Got a new nuid, but the owner is me and therefore I don't care :). For data content see above!"
    --             )
    --             return -- skip if this entity is my own
    --         end

    --         logger:debug(logger.channels.network, "Got a new nuid and spawning entity. For data content see above!")
    --         em:spawnEntity(data.owner, data.nuid, data.x, data.y, data.rot, data.velocity, data.filename, nil)
    --     end
    -- )

    -- self:on(
    --     "entityAlive",
    --     function(data)
    --         logger:debug(logger.channels.network, util.pformat(data))

    --         self:sendToAll2("entityAlive", data)
    --         em:DespawnEntity(data.owner, data.localEntityId, data.nuid, data.isAlive)
    --     end
    -- )

    -- self:on(
    --     "entityState",
    --     function(data)
    --         logger:debug(logger.channels.network, util.pformat(data))

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
    --         self:sendToAll2("entityState", data)
    --     end
    -- )

    --#endregion

    ------------------------------------------------------------------------------------------------
    --- setCallbackAndSchemas
    ------------------------------------------------------------------------------------------------
    --- Sets callbacks and schemas of the server.
    local function setCallbackAndSchemas()
        local cpc012 = CustomProfiler.start("Server.setCallbackAndSchemas")

        --self:setSchema(NetworkUtils.events.connect, { "code" })
        self:on(NetworkUtils.events.connect.name, onConnect)

        self:setSchema(NetworkUtils.events.connect2.name, NetworkUtils.events.connect2.schema)
        --self:on(NetworkUtils.events.connect2.name, onConnect2)

        --self:setSchema(NetworkUtils.events.disconnect, { "code" })
        self:on(NetworkUtils.events.disconnect.name, onDisconnect)

        self:setSchema(NetworkUtils.events.disconnect2.name, NetworkUtils.events.disconnect2.schema)
        --self:on(NetworkUtils.events.disconnect2.name, onDisconnect2)

        self:setSchema(NetworkUtils.events.acknowledgement.name, NetworkUtils.events.acknowledgement.schema)
        self:on(NetworkUtils.events.acknowledgement.name, onAcknowledgement)

        --self:setSchema(NetworkUtils.events.seed.name, NetworkUtils.events.seed.schema)
        --self:on(NetworkUtils.events.seed.name, onSeed)

        self:setSchema(NetworkUtils.events.playerInfo.name, NetworkUtils.events.playerInfo.schema)
        self:on(NetworkUtils.events.playerInfo.name, onPlayerInfo)

        -- self:setSchema(NetworkUtils.events.newNuid.name, NetworkUtils.events.newNuid.schema)
        -- self:on(NetworkUtils.events.newNuid.name, onNewNuid)

        self:setSchema(NetworkUtils.events.needNuid.name, NetworkUtils.events.needNuid.schema)
        self:on(NetworkUtils.events.needNuid.name, onNeedNuid)

        self:setSchema(NetworkUtils.events.lostNuid.name, NetworkUtils.events.lostNuid.schema)
        self:on(NetworkUtils.events.lostNuid.name, onLostNuid)

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
        CustomProfiler.stop("Server.setCallbackAndSchemas", cpc012)
    end

    local function updateVariables()
        local cpc013   = CustomProfiler.start("Server.updateVariables")
        local entityId = MinaUtils.getLocalMinaInformation().entityId
        if entityId then
            local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
            self.health                                                                              = health
            self.transform                                                                           = { x = math.floor(x), y = math.floor(y) }

            if not compNuid then
                self.nuid = NuidUtils.getNextNuid()
                NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, self.nuid)
                --self.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, self.nuid, x, y, rotation, velocity,
                --                 filename, health, EntityUtils.isEntityPolymorphed(entityId))
            end
        end
        CustomProfiler.stop("Server.updateVariables", cpc013)
    end

    ------------------------------------
    --- Public methods:
    ------------------------------------

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockServerSend = sockServer.sendToPeer
    function self:send(peer, event, data)
        local cpc022 = CustomProfiler.start("Server.send")
        if type(data) ~= "table" then
            error("", 2)
            return false
        end

        if NetworkUtils.alreadySent(peer, event, data) then
            Logger.debug(Logger.channels.network, ("Network message for %s for data %s already was acknowledged.")
                    :format(event, util.pformat(data)))
            CustomProfiler.stop("Server.send", cpc022)
            return false
        end

        local networkMessageId = sockServerSend(self, peer, event, data)

        if event ~= NetworkUtils.events.acknowledgement.name then
            if NetworkUtils.events[event].isCacheable == true then
                NetworkCacheUtils.set(peer.guid, networkMessageId, event,
                                      NetworkUtils.events.acknowledgement.sent, 0, os.clock(), data)
            end
        end
        CustomProfiler.stop("Server.send", cpc022)
        return true
    end

    function self:sendToAll(event, data)
        local cpc023 = CustomProfiler.start("Server.sendToAll")
        local sent   = false
        if util.IsEmpty(self.clients) then
            Logger.trace(Logger.channels.testing,
                         ("Unable to send anything, when there are no clients %s!"):format(util.pformat(self.clients)))
            return sent
        end
        for i = 1, #self.clients do
            Logger.trace(Logger.channels.testing,
                         ("Sending event '%s' with data '%s' to client.name '%s'!"):format(event, util.pformat(data),
                                                                                           self.clients[i].name))
            sent = self:send(self.clients[i], event, data)
        end
        CustomProfiler.stop("Server.sendToAll", cpc023)
        return sent
    end

    function self:sendToAllBut(peer, event, data)
        local cpc024 = CustomProfiler.start("Server.sendToAllBut")
        local sent   = false
        for i = 1, #self.clients do
            if self.clients[i].connectId ~= peer.connectId then
                sent = self:send(self.clients[i], event, data)
            end
        end
        CustomProfiler.stop("Server.sendToAllBut", cpc024)
        return sent
    end


    --#region Start and stop

    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockServerStart = sockServer.start
    --- Starts a server on ip and port. Both can be nil, then ModSettings will be used.
    --- @param ip string localhost or 127.0.0.1 or nil
    --- @param port number? port number from 1 to max of 65535 or nil
    function self.start(ip, port)
        local cpc014 = CustomProfiler.start("Server.start")
        if not ip then
            ip = tostring(ModSettingGet("noita-mp.server_ip"))
        end

        if not port then
            port = tonumber(ModSettingGet("noita-mp.server_port")) or error("noita-mp.server_port wasn't a number")
        end

        self.stop()
        _G.Server.stop() -- stop if any server is already running

        Logger.info(Logger.channels.network, ("Starting server on %s:%s.."):format(ip, port))
        --self = _G.ServerInit.new(sock.newServer(ip, port), false)
        --_G.Server = self
        local success = sockServerStart(self, ip, port)
        if success == true then
            Logger.info(Logger.channels.network, ("Server started on %s:%s"):format(self:getAddress(), self:getPort()))

            setGuid()
            setConfigSettings()
            setCallbackAndSchemas()

            GamePrintImportant("Server started", ("Your server is running on %s:%s. Tell your friends to join!")
                    :format(self:getAddress(), self:getPort()))
        else
            GamePrintImportant("Server didn't start!", "Try again, otherwise restart Noita.")
        end
        CustomProfiler.stop("Server.start", cpc014)
    end

    --- Stops the server.
    function self.stop()
        local cpc015 = CustomProfiler.start("Server.stop")
        if self.isRunning() then
            self:destroy()
        else
            Logger.info(Logger.channels.network, "Server isn't running, there cannot be stopped.")
        end
        CustomProfiler.stop("Server.stop", cpc015)
    end

    --#endregion

    --#region Additional methods

    function self.isRunning()
        --local cpc = CustomProfiler.start("Server.isRunning") DO NOT PROFILE, stack overflow error! See CustomProfiler.lua
        local status, result = pcall(self.getSocketAddress, self)
        if not status then
            --CustomProfiler.stop("Server.isRunning", cpc)
            return false
        end
        --CustomProfiler.stop("Server.isRunning", cpc)
        return true
    end

    --local lastFrames = 0
    --local diffFrames = 0
    --local fps30 = 0
    local prevTime         = 0
    --- Some inheritance: Save parent function (not polluting global 'self' space)
    local sockServerUpdate = sockServer.update
    --- Updates the server by checking for network events and handling them.
    function self.update()
        local cpc016 = CustomProfiler.start("Server.update")
        if not self.isRunning() then
            --if not self.host then
            -- server not established
            CustomProfiler.stop("Server.update", cpc016)
            return
        end

        EntityUtils.processAndSyncEntityNetworking()

        local nowTime     = GameGetRealWorldTimeSinceStarted() * 1000 -- *1000 to get milliseconds
        local elapsedTime = nowTime - prevTime
        local oneTickInMs = 1000 / tonumber(ModSettingGet("noita-mp.tick_rate"))
        if elapsedTime >= oneTickInMs then
            local cpc1 = CustomProfiler.start("Server.update.tick")
            prevTime   = nowTime
            --if since % tonumber(ModSettingGet("noita-mp.tick_rate")) == 0 then
            --updateVariables()

            --EntityUtils.syncEntityData()
            EntityUtils.syncDeadNuids()
            --end
            CustomProfiler.stop("Server.update.tick", cpc1)
        end

        sockServerUpdate(self)
        CustomProfiler.stop("Server.update", cpc016)
    end

    function self.sendNewGuid(peer, oldGuid, newGuid)
        local cpc025 = CustomProfiler.start("Server.sendNewGuid")
        local event  = NetworkUtils.events.newGuid.name
        local data   = { NetworkUtils.getNextNetworkMessageId(), oldGuid, newGuid }
        local sent   = self:send(peer, event, data)
        CustomProfiler.stop("Server.sendNewGuid", cpc025)
        return sent
    end

    --function self.sendNewNuid(owner, localEntityId, newNuid, x, y, rotation, velocity, filename, health, isPolymorphed)
    --    local cpc017 = CustomProfiler.start("Server.sendNewNuid")
    --    local event  = NetworkUtils.events.newNuid.name
    --    local data   = { NetworkUtils.getNextNetworkMessageId(), owner, localEntityId, newNuid, x, y, rotation, velocity, filename, health, isPolymorphed }
    --    local sent   = self:sendToAll(event, data)
    --    CustomProfiler.stop("Server.sendNewNuid", cpc017)
    --    return sent
    --end

    function self.sendNewNuidSerialized(ownerName, ownerGuid, entityId, serializedEntity)
        local cpc026 = CustomProfiler.start("Server.sendNewNuidSerialized")

        if util.IsEmpty(ownerName) then
            error(("ownerName must not be nil or empty %s"):format(ownerName), 2)
        end
        if util.IsEmpty(ownerGuid) then
            error(("ownerGuid must not be nil or empty %s"):format(ownerGuid), 2)
        end
        if util.IsEmpty(entityId) then
            error(("entityId must not be nil or empty %s"):format(entityId), 2)
        end
        if util.IsEmpty(serializedEntity) then
            error(("serializedEntity must not be nil or empty %s"):format(serializedEntity), 2)
        end

        local event = NetworkUtils.events.newNuidSerialized.name
        local data  = { NetworkUtils.getNextNetworkMessageId(), ownerName, ownerGuid, entityId, serializedEntity }
        local sent  = self:sendToAll(event, data)
        CustomProfiler.stop("Server.sendNewNuidSerialized", cpc026)
        return sent
    end

    function self.sendEntityData(entityId)
        local cpc018 = CustomProfiler.start("Server.sendEntityData")
        if not EntityUtils.isEntityAlive(entityId) then
            CustomProfiler.stop("Server.sendEntityData", cpc018)
            return
        end

        --local compOwnerName, compOwnerGuid, compNuid     = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
        local compOwnerName, compOwnerGuid, compNuid, filename, health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        local data                                                                               = {
            NetworkUtils.getNextNetworkMessageId(), { compOwnerName, compOwnerGuid }, compNuid, x, y, rotation, velocity, health
        }

        if util.IsEmpty(compNuid) then
            ---- nuid must not be empty, when Server!
            --logger:error(logger.channels.network, "Unable to send entity data, because nuid is empty.")
            --return
            local newNuid = NuidUtils.getNextNuid()
            NetworkVscUtils.addOrUpdateAllVscs(entityId, compOwnerName, compOwnerGuid, newNuid)
            --self.sendNewNuid({ compOwnerName, compOwnerGuid }, entityId, newNuid, x, y, rotation, velocity, filename,
            --                 health, EntityUtils.isEntityPolymorphed(entityId))
        end

        if MinaUtils.getLocalMinaInformation().guid == compOwnerGuid then
            self:sendToAll(NetworkUtils.events.entityData.name, data)
        end
        CustomProfiler.stop("Server.sendEntityData", cpc018)
    end

    function self.sendDeadNuids(deadNuids)
        local cpc019 = CustomProfiler.start("Server.sendDeadNuids")
        local data   = {
            NetworkUtils.getNextNetworkMessageId(), deadNuids
        }
        self:sendToAll(NetworkUtils.events.deadNuids.name, data)
        -- peer is nil when server, because a callback is executed manually
        onDeadNuids(deadNuids, nil)
        CustomProfiler.stop("Server.sendDeadNuids", cpc019)
    end

    --- Checks if the current local user is the server
    --- @return boolean iAm true if server
    function self.amIServer()
        --local cpc = CustomProfiler.start("Server.amIServer") DO NOT PROFILE, stack overflow error! See CustomProfiler.lua
        -- this can happen when you started and stop a server and then connected to a different server!
        -- if _G.Server.super and _G.Client.super then
        --     error("Something really strange is going on. You are server and client at the same time?", 2)
        -- end

        if self.isRunning() then
            --if _G.Server.host and _G.Server.guid == self.guid then
            --CustomProfiler.stop("Server.amIServer", cpc)
            return true
        end
        --CustomProfiler.stop("Server.amIServer", cpc)
        return false
    end

    function self.kick(name)
        local cpc020 = CustomProfiler.start("Server.kick")
        Logger.debug(Logger.channels.network, "Minä %s was kicked!", name)
        CustomProfiler.stop("Server.kick", cpc020)
    end

    function self.ban(name)
        local cpc021 = CustomProfiler.start("Server.ban")
        Logger.debug(Logger.channels.network, "Minä %s was banned!", name)
        CustomProfiler.stop("Server.ban", cpc021)
    end

    --- Mainly for profiling. Returns then network cache, aka acknowledge.
    --- @return number cacheSize
    function self.getAckCacheSize()
        return NetworkCache.size()
    end

    --#endregion

    -- Apply some private methods

    CustomProfiler.stop("Server.new", cpc)
    return self
end

-- Init this object:

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.ServerInit = Server
_G.Server     = ServerInit.new(sock.newServer())

--local startOnLoad = ModSettingGet("noita-mp.server_start_when_world_loaded")
--if startOnLoad then
--    -- Polymorphism sample
--    _G.Server.start(nil, nil)
--else
--    GamePrintImportant("Server not started",
--                       "Your server wasn't started yet. Check ModSettings to change this or Press M to open multiplayer menu.",
--                       ""
--    )
--end


-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return Server
