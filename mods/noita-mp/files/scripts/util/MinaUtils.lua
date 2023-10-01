---Util class for fetching information about local and remote minas.
---@class MinaUtils
local MinaUtils     = {}

---Stores local mina name.
---@private
---@type string
local localMinaName = nil

---Stores local mina guid.
---@private
---@type string
local localMinaGuid = nil

---Setter for local mina name. It also saves it to settings file.
---@param name string required
function MinaUtils:setLocalMinaName(name)
    local cpc = self.customProfiler:start("MinaUtils.setLocalMinaName")
    if not name or type(name) ~= "string" then
        error(("MinaUtils:setLocalMinaName(name) requires a string, but got %s"):format(type(name)), 2)
    end
    localMinaName = name
    self.noitaMpSettings:set("noita-mp.nickname", localMinaName)
    self.customProfiler:stop("MinaUtils.setLocalMinaName", cpc)
end

---Getter for local mina name. ~It also loads it from settings file.~
---@return string localMinaName
function MinaUtils:getLocalMinaName()
    local cpc = self.customProfiler:start("MinaUtils.getLocalMinaName")
    if self.utils:IsEmpty(localMinaName) then
        localMinaName = tostring(self.noitaMpSettings:get("noita-mp.nickname", "string"))
    end
    self.customProfiler:stop("MinaUtils.getLocalMinaName", cpc)
    return localMinaName
end

---Setter for local mina guid. It also saves it to settings file.
---@param guid string required
function MinaUtils:setLocalMinaGuid(guid)
    local cpc = self.customProfiler:start("MinaUtils.setLocalMinaGuid")
    if not guid or type(guid) ~= "string" then
        error(("MinaUtils:setLocalMinaGuid(guid) requires a string, but got %s"):format(type(guid)), 2)
    end
    localMinaGuid = guid
    self.noitaMpSettings:set("noita-mp.guid", localMinaGuid)
    self.customProfiler:stop("MinaUtils.setLocalMinaGuid", cpc)
end

---Getter for local mina guid. ~It also loads it from settings file.~
---@return string localMinaGuid
function MinaUtils:getLocalMinaGuid()
    local cpc = self.customProfiler:start("MinaUtils.getLocalMinaGuid")
    if self.utils:IsEmpty(localMinaGuid) then
        localMinaGuid = self.noitaMpSettings:get("noita-mp.guid", "string")
    end
    self.customProfiler:stop("MinaUtils.getLocalMinaGuid", cpc)
    return localMinaGuid
end

---Getter for local mina entity id. It also takes care of polymorphism!
---@return number|nil localMinaEntityId or nil if not found/dead
function MinaUtils:getLocalMinaEntityId()
    local cpc                   = self.customProfiler:start("MinaUtils.getLocalMinaEntityId")
    local polymorphed, entityId = self:isLocalMinaPolymorphed()

    if polymorphed then
        self.customProfiler:stop("MinaUtils.getLocalMinaEntityId", cpc)
        return entityId
    end

    local playerEntityIds = EntityGetWithTag("player_unit")
    for i = 1, #playerEntityIds do
        if self.networkVscUtils:hasNetworkLuaComponents(playerEntityIds[i]) then
            local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(playerEntityIds[i])
            if compOwnerGuid == localMinaGuid then
                self.customProfiler:stop("MinaUtils.getLocalMinaEntityId", cpc)
                return playerEntityIds[i]
            end
        end
    end
    if self.utils.IsEmpty(playerEntityIds) then
        self.logger:trace(self.logger.channels.entity,
            ("There isn't any Mina spawned yet or all died! EntityGetWithTag('player_unit') = {}"):format(playerEntityIds))
        self.customProfiler:stop("MinaUtils.getLocalMinaEntityId", cpc)
        return nil
    end
    self.logger:debug(self.logger.channels.entity,
        ("Unable to get local player entity id. Returning first entity id(%s), which was found."):format(playerEntityIds[1]))
    self.customProfiler:stop("MinaUtils.getLocalMinaEntityId", cpc)
    return playerEntityIds[1]
end

---Getter for local mina nuid. It also takes care of polymorphism!
---@return number nuid if not found/dead
function MinaUtils:getLocalMinaNuid()
    local cpc = self.customProfiler:start("MinaUtils.getLocalMinaNuid")
    local entityId = self:getLocalMinaEntityId()
    local ownerName, ownerGuid, nuid = self.networkVscUtils.getAllVscValuesByEntityId(entityId)
    local nuid_, entityId_ = self.globalsUtils:getNuidEntityPair(nuid)
    if self.utils.IsEmpty(nuid_) and self.utils.IsEmpty(entityId_) then
        self.customProfiler:stop("MinaUtils.getLocalMinaNuid", cpc)
        return -1
    end
    if nuid ~= nuid_ or entityId ~= entityId_ then
        error(("Something bad happen! Nuid or entityId missmatch: nuid %s ~= nuid_ and/or entityId %s ~= entityId_ %s")
            :format(nuid, nuid_, entityId, entityId_), 2)
    end
    self.customProfiler:stop("MinaUtils.getLocalMinaNuid", cpc)
    return tonumber(nuid) or -1
end

---Checks if local mina is polymorphed. Returns true, entityId | false, nil
---@return boolean isPolymorphed, number|nil entityId
function MinaUtils:isLocalMinaPolymorphed()
    local cpc                  = self.customProfiler:start("MinaUtils.isLocalMinaPolymorphed")
    local polymorphedEntityIds = EntityGetWithTag("polymorphed") or {}

    for e = 1, #polymorphedEntityIds do
        if EntityGetIsAlive(polymorphedEntityIds[e]) then
            local componentIds = EntityGetComponentIncludingDisabled(polymorphedEntityIds[e],
                "GameStatsComponent") or {}
            for c = 1, #componentIds do
                local isPlayer = ComponentGetValue2(componentIds[c], "is_player")
                if isPlayer then
                    local compOwnerName, compOwnerGuid, compNuid = self.networkVscUtils:getAllVscValuesByEntityId(polymorphedEntityIds[e])
                    if compOwnerGuid == localMinaGuid then
                        self.customProfiler:stop("MinaUtils.isLocalMinaPolymorphed", cpc)
                        return true, polymorphedEntityIds[e]
                    else
                        self.logger:warn(self.logger.channels.entity,
                            ("Found polymorphed Mina, but isn't local one! %s, %s, %s"):format(compOwnerName, compOwnerGuid, compNuid))
                    end
                end
            end
        end
    end
    self.customProfiler:stop("MinaUtils.isLocalMinaPolymorphed", cpc)
    return false, nil
end

---Returns all minas.
---@param client Client Either client or
---@param server Server server object is required!
---@return table
function MinaUtils:getAllMinas(client, server)
    local cpc = self.customProfiler:start("MinaUtils.getAllMinas")
    if not client or not server then
        error("MinaUtils:getAllMinas(client, server) requires a client or server object!", 2)
    end

    local minas = {}
    if client then
        for i = 1, #client.otherClients or 1 do
            local mina = {}
            mina.name = client.otherClients[i].name
            mina.guid = client.otherClients[i].guid
            mina.nuid = client.otherClients[i].nuid

            if self.utils:IsEmpty(mina.nuid) then
                local playerEntityIds = EntityGetWithTag("player_unit")
                for i = 1, #playerEntityIds do
                    if self.networkVscUtils:hasNetworkLuaComponents(playerEntityIds[i]) then
                        local compOwnerName, compOwnerGuid, compNuid = self.networkVscUtils:getAllVscValuesByEntityId(playerEntityIds[i])
                        if compOwnerGuid == mina.guid then
                            mina.nuid = compNuid
                            break
                        end
                    end
                end
            end
            minas[i] = mina
        end
    elseif server then
        for i = 1, #server:getClients() do
            local mina = {}
            mina.name = server:getClients()[i].name
            mina.guid = server:getClients()[i].guid
            mina.nuid = server:getClients()[i].nuid

            if self.utils:IsEmpty(mina.nuid) then
                local playerEntityIds = EntityGetWithTag("player_unit")
                for i = 1, #playerEntityIds do
                    if self.networkVscUtils:hasNetworkLuaComponents(playerEntityIds[i]) then
                        local compOwnerName, compOwnerGuid, compNuid = self.networkVscUtils:getAllVscValuesByEntityId(playerEntityIds[i])
                        if compOwnerGuid == mina.guid then
                            mina.nuid = compNuid
                            break
                        end
                    end
                end
            end
            minas[i] = mina
        end
    else
        self.logger:warn("MinaUtils:getAllMinas(client, server) client and server are nil!", 2)
    end

    local localMina = {}
    localMina.name = self:getLocalMinaName()
    localMina.guid = self:getLocalMinaGuid()
    localMina.nuid = self:getLocalMinaNuid()
    minas[#minas + 1] = localMina

    self.customProfiler:stop("MinaUtils.getAllMinas", cpc)
    return minas
end

-- TODO: Rework this by adding and updating entityId to Server.entityId and Client.entityId! Dont forget polymorphism!
---Checks if the entityId is a remote minae.
---@param client Client Either client or
---@param server Server server object is required!
---@param entityId number required
---@return boolean true if entityId is a remote minae, otherwise false
function MinaUtils:isRemoteMinae(client, server, entityId)
    local cpc = self.customProfiler:start("EntityUtils.isRemoteMinae")
    if not EntityGetIsAlive(entityId) then
        self.customProfiler:stop("EntityUtils.isRemoteMinae", cpc)
        return false
    end
    if client then
        local serverNuid, serverEntityId = self.globalsUtils:getNuidEntityPair(client.serverInfo.nuid)
        if entityId == serverEntityId then
            self.customProfiler:stop("EntityUtils.isRemoteMinae", cpc)
            return true
        end
        for i = 1, #client.otherClients do
            local otherClient                = client.otherClients[i]
            local clientsNuid                = otherClient.nuid
            local nuidRemote, entityIdRemote = self.globalsUtils:getNuidEntityPair(clientsNuid)
            if not self.utils:IsEmpty(entityIdRemote) and entityIdRemote == entityId then
                self.customProfiler:stop("EntityUtils.isRemoteMinae", cpc)
                return true
            end
        end
    elseif server then
        local clients = server:getClients()
        for i = 1, #clients do
            local otherClient                = clients[i]
            local clientsNuid                = otherClient.nuid
            local nuidRemote, entityIdRemote = self.globalsUtils:getNuidEntityPair(clientsNuid)
            if not self.utils:IsEmpty(entityIdRemote) and entityIdRemote == entityId then
                self.customProfiler:stop("EntityUtils.isRemoteMinae", cpc)
                return true
            end
        end
    end
    self.customProfiler:stop("EntityUtils.isRemoteMinae", cpc)
    return false
end

---Constructor for MinaUtils.
---@param minaUtils MinaUtils|nil optional
---@param customProfiler CustomProfiler required
---@param globalsUtils GlobalsUtils required
---@param logger Logger required
---@param networkVscUtils NetworkVscUtils required
---@param noitaMpSettings NoitaMpSettings required
---@param utils Utils required
---@return MinaUtils
function MinaUtils:new(minaUtils, customProfiler, globalsUtils, logger, networkVscUtils, noitaMpSettings, utils)
    ---@class MinaUtils
    minaUtils = setmetatable(minaUtils or self, MinaUtils)

    if not customProfiler then
        error("MinaUtils:new() requires a CustomProfiler object!", 2)
    end
    local cpc = customProfiler:start("MinaUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not minaUtils.customProfiler then
        ---@type CustomProfiler
        minaUtils.customProfiler = customProfiler
    end

    if not minaUtils.globalsUtils then
        ---@type GlobalsUtils
        minaUtils.globalsUtils = globalsUtils or
            error("MinaUtils:new() requires a GlobalsUtils object!", 2)
    end

    if not minaUtils.logger then
        ---@type Logger
        minaUtils.logger = logger or
            error("MinaUtils:new() requires a Logger object!", 2)
    end

    if not minaUtils.networkVscUtils then
        ---@type NetworkVscUtils
        minaUtils.networkVscUtils = networkVscUtils or
            error("MinaUtils:new() requires a NetworkVscUtils object!", 2)
    end

    if not minaUtils.noitaMpSettings then
        ---@type NoitaMpSettings
        minaUtils.noitaMpSettings = noitaMpSettings or
            error("MinaUtils:new() requires a NoitaMpSettings object!", 2)
    end

    if not minaUtils.utils then
        ---@type Utils
        minaUtils.utils = utils or
            error("MinaUtils:new() requires a Utils object!", 2)
    end

    --[[ Attributes ]]


    customProfiler:stop("MinaUtils:new", cpc)
    return minaUtils
end

return MinaUtils
