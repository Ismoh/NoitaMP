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
    if not name or type(name) ~= "string" then
        error(("MinaUtils:setLocalMinaName(name) requires a string, but got %s"):format(type(name)), 2)
    end
    localMinaName = name
    self.noitaMpSettings:set("noita-mp.nickname", localMinaName)
end

---Getter for local mina name. ~It also loads it from settings file.~
---@return string localMinaName
function MinaUtils:getLocalMinaName()
    if self.utils:isEmpty(localMinaName) then
        localMinaName = tostring(self.noitaMpSettings:get("noita-mp.nickname", "string"))
        if self.utils:isEmpty(localMinaName) then
            localMinaName = "Press CTRL+ALT+S for setting a nickname!"
        end
    end
    return localMinaName
end

---Setter for local mina guid. It also saves it to settings file.
---@param guid string required
function MinaUtils:setLocalMinaGuid(guid)
    if not guid or type(guid) ~= "string" then
        error(("MinaUtils:setLocalMinaGuid(guid) requires a string, but got %s"):format(type(guid)), 2)
    end
    localMinaGuid = guid
    self.noitaMpSettings:set("noita-mp.guid", localMinaGuid)
end

---Getter for local mina guid. ~It also loads it from settings file.~
---@return string localMinaGuid
function MinaUtils:getLocalMinaGuid()
    if self.utils:isEmpty(localMinaGuid) then
        localMinaGuid = self.noitaMpSettings:get("noita-mp.guid", "string")
    end
    return localMinaGuid
end

---Getter for local mina entity id. It also takes care of polymorphism!
---@return number|nil localMinaEntityId or nil if not found/dead
function MinaUtils:getLocalMinaEntityId()
    local polymorphed, entityId = self:isLocalMinaPolymorphed()

    if polymorphed then
        return entityId
    end

    local playerEntityIds = EntityGetWithTag("player_unit")
    for i = 1, #playerEntityIds do
        if self.networkVscUtils:hasNetworkLuaComponents(playerEntityIds[i]) then
            local compOwnerName, compOwnerGuid, compNuid = self.networkVscUtils:getAllVscValuesByEntityId(playerEntityIds[i])
            if compOwnerGuid == localMinaGuid then
                return playerEntityIds[i]
            end
        end
    end
    if self.utils:isEmpty(playerEntityIds) then
        self.logger:trace(self.logger.channels.entity,
            ("There isn't any Mina spawned yet or all died! EntityGetWithTag('player_unit') = {}"):format(playerEntityIds))
        return nil
    end
    self.logger:debug(self.logger.channels.entity,
        ("Unable to get local player entity id. Returning first entity id(%s), which was found."):format(playerEntityIds[1]))
    return playerEntityIds[1] or nil
end

---Getter for local mina nuid. It also takes care of polymorphism!
---@return number nuid if not found/dead
function MinaUtils:getLocalMinaNuid()
    local entityId = self:getLocalMinaEntityId()
    local ownerName, ownerGuid, nuid = self.networkVscUtils:getAllVscValuesByEntityId(entityId)
    local nuid_, entityId_ = self.globalsUtils:getNuidEntityPair(nuid)
    if self.utils:isEmpty(nuid_) and self.utils:isEmpty(entityId_) then
        return -1
    end
    if nuid ~= nuid_ or entityId ~= entityId_ then
        error(("Something bad happen! Nuid or entityId missmatch: nuid %s ~= nuid_ and/or entityId %s ~= entityId_ %s")
            :format(nuid, nuid_, entityId, entityId_), 2)
    end
    return tonumber(nuid) or -1
end

---Checks if local mina is polymorphed. Returns true, entityId | false, nil
---@return boolean isPolymorphed, number|nil entityId
function MinaUtils:isLocalMinaPolymorphed()
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
                        return true, polymorphedEntityIds[e]
                    else
                        self.logger:warn(self.logger.channels.entity,
                            ("Found polymorphed Mina, but isn't local one! %s, %s, %s"):format(compOwnerName, compOwnerGuid, compNuid))
                    end
                end
            end
        end
    end
    return false, nil
end

---Returns all minas.
---@param client Client Either client or
---@param server Server server object is required!
---@return table
function MinaUtils:getAllMinas(client, server)
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

            if self.utils:isEmpty(mina.nuid) then
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

            if self.utils:isEmpty(mina.nuid) then
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

    return minas
end

-- TODO: Rework this by adding and updating entityId to Server.entityId and Client.entityId! Dont forget polymorphism!
---Checks if the entityId is a remote minae.
---@param client Client Either client or
---@param server Server server object is required!
---@param entityId number required
---@return boolean true if entityId is a remote minae, otherwise false
function MinaUtils:isRemoteMinae(client, server, entityId)
    if not EntityGetIsAlive(entityId) then
        return false
    end
    if client then
        local serverNuid, serverEntityId = self.globalsUtils:getNuidEntityPair(client.serverInfo.nuid)
        if entityId == serverEntityId then
            return true
        end
        for i = 1, #client.otherClients do
            local otherClient                = client.otherClients[i]
            local clientsNuid                = otherClient.nuid
            local nuidRemote, entityIdRemote = self.globalsUtils:getNuidEntityPair(clientsNuid)
            if not self.utils:isEmpty(entityIdRemote) and entityIdRemote == entityId then
                return true
            end
        end
    elseif server then
        local clients = server:getClients()
        for i = 1, #clients do
            local otherClient                = clients[i]
            local clientsNuid                = otherClient.nuid
            local nuidRemote, entityIdRemote = self.globalsUtils:getNuidEntityPair(clientsNuid)
            if not self.utils:isEmpty(entityIdRemote) and entityIdRemote == entityId then
                return true
            end
        end
    end
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

    return minaUtils
end

return MinaUtils
