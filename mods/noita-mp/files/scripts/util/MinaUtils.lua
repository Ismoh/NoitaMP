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
---@param name string
function MinaUtils.setLocalMinaName(name)
    localMinaName = name
    NoitaMpSettings.set("noita-mp.nickname", localMinaName)
end

---Getter for local mina name. ~It also loads it from settings file.~
---@return string localMinaName
function MinaUtils.getLocalMinaName()
    if Utils.IsEmpty(localMinaName) then
        localMinaName = NoitaMpSettings.get("noita-mp.nickname", "string")
    end
    return localMinaName
end

---Setter for local mina guid. It also saves it to settings file.
---@param guid string
function MinaUtils.setLocalMinaGuid(guid)
    localMinaGuid = guid
    NoitaMpSettings.set("noita-mp.guid", localMinaGuid)
end

---Getter for local mina guid. ~It also loads it from settings file.~
---@return string localMinaGuid
function MinaUtils.getLocalMinaGuid()
    if Utils.IsEmpty(localMinaGuid) then
        localMinaGuid = NoitaMpSettings.get("noita-mp.guid", "string")
    end
    return localMinaGuid
end

---Getter for local mina entity id. It also takes care of polymorphism!
---@return number|nil localMinaEntityId or nil if not found/dead
function MinaUtils.getLocalMinaEntityId()
    local cpc                   = CustomProfiler.start("MinaUtils.getLocalMinaEntityId")
    local polymorphed, entityId = MinaUtils.isLocalMinaPolymorphed()

    if polymorphed then
        CustomProfiler.stop("MinaUtils.getLocalMinaEntityId", cpc)
        return entityId
    end

    local playerEntityIds = EntityGetWithTag("player_unit")
    for i = 1, #playerEntityIds do
        if NetworkVscUtils.hasNetworkLuaComponents(playerEntityIds[i]) then
            local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(playerEntityIds[i])
            if compOwnerGuid == localMinaGuid then
                CustomProfiler.stop("MinaUtils.getLocalMinaEntityId", cpc)
                return playerEntityIds[i]
            end
        end
    end
    if Utils.IsEmpty(playerEntityIds) then
        Logger.trace(Logger.channels.entity,
            ("There isn't any Mina spawned yet or all died! EntityGetWithTag('player_unit') = {}")
            :format(playerEntityIds))
        return nil
    end
    Logger.debug(Logger.channels.entity,
        ("Unable to get local player entity id. Returning first entity id(%s), which was found.")
        :format(playerEntityIds[1]))
    CustomProfiler.stop("MinaUtils.getLocalMinaEntityId", cpc)
    return playerEntityIds[1]
end

---Getter for local mina nuid. It also takes care of polymorphism!
---@return number nuid if not found/dead
function MinaUtils.getLocalMinaNuid()
    local cpc = CustomProfiler.start("MinaUtils.getLocalMinaNuid")
    local entityId = MinaUtils.getLocalMinaEntityId()
    local ownerName, ownerGuid, nuid = NetworkVscUtils.getAllVscValuesByEntityId(entityId)
    local nuid_, entityId_ = GlobalsUtils.getNuidEntityPair(nuid)
    if Utils.IsEmpty(nuid_) and Utils.IsEmpty(entityId_) then
        return -1
    end
    if nuid ~= nuid_ or entityId ~= entityId_ then
        error(("Something bad happen! Nuid or entityId missmatch: nuid %s ~= nuid_ and/or entityId %s ~= entityId_ %s")
            :format(nuid, nuid_, entityId, entityId_), 2)
    end
    CustomProfiler.stop("MinaUtils.getLocalMinaNuid", cpc)
    return tonumber(nuid) or -1
end

---Getter for local mina information. It also takes care of polymorphism!
--- Deprecated: Use separated getters instead, like getLocalMinaName, getLocalMinaGuid, getLocalMinaEntityId, getLocalMinaNuid!
---@deprecated
---@see MinaInformation
---@return MinaInformation localMinaInformation
function MinaUtils.getLocalMinaInformation()
    local cpc                                = CustomProfiler.start("MinaUtils.getLocalMinaInformation")
    local ownerName                          = MinaUtils.getLocalMinaName()
    local ownerGuid                          = MinaUtils.getLocalMinaGuid()
    local entityId                           = MinaUtils.getLocalMinaEntityId()
    local nuid                               = nil

    local isPolymorphed, polymorphedEntityId = MinaUtils.isLocalMinaPolymorphed()
    if isPolymorphed then
        entityId = polymorphedEntityId
        local who = _G.whoAmI()
        if who == Client.iAm then
            ---@diagnostic disable-next-line: param-type-mismatch
            if not NetworkVscUtils.hasNuidSet(entityId) then
                ---@diagnostic disable-next-line: param-type-mismatch
                Client.sendNeedNuid(ownerName, ownerGuid, entityId)
            end
        elseif who == Server.iAm then
            ---@diagnostic disable-next-line: param-type-mismatch
            if not NetworkVscUtils.hasNuidSet(entityId) then
                nuid = NuidUtils.getNextNuid()
            end
        else
            error(("Unable to identify whether I am Client or Server.. whoAmI() == %s"):format(who), 2)
        end
    end

    local transform = nil
    local health = nil
    if not Utils.IsEmpty(entityId) then
        ---@diagnostic disable-next-line: param-type-mismatch
        local is, nuidComponentId, nuid = NetworkVscUtils.isNetworkEntityByNuidVsc(entityId)
        if not is or Utils.IsEmpty(nuidComponentId) then
            ---@diagnostic disable-next-line: param-type-mismatch
            NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
        end
        ---@diagnostic disable-next-line: param-type-mismatch
        local _name, _guid, _nuid = NetworkVscUtils.getAllVscValuesByEntityId(entityId)
        local _name, _guid, _nuid, _filename, _health, rotation, velocity, x, y = NoitaComponentUtils.getEntityData(entityId)
        health = _health
        ---@class Transform
        ---@field x number
        ---@field y number
        transform = { x = x, y = y }
    end

    CustomProfiler.stop("MinaUtils.getLocalMinaInformation", cpc)
    ---@class MinaInformation
    ---@see Transform
    ---@see Health
    MinaInformation = {
        ---@type string
        name      = ownerName,
        ---@type string
        guid      = ownerGuid,
        ---@type number|nil
        entityId  = entityId,
        ---@type number|nil
        nuid      = nuid,
        ---@type Transform
        transform = transform,
        ---@type Health
        health    = health
    }
    return MinaInformation
end

---Checks if local mina is polymorphed. Returns true, entityId | false, nil
---@return boolean isPolymorphed, number|nil entityId
function MinaUtils.isLocalMinaPolymorphed()
    local cpc                  = CustomProfiler.start("MinaUtils.isLocalMinaPolymorphed")
    local polymorphedEntityIds = EntityGetWithTag("polymorphed") or {}

    for e = 1, #polymorphedEntityIds do
        if EntityGetIsAlive(polymorphedEntityIds[e]) then
            local componentIds = EntityGetComponentIncludingDisabled(polymorphedEntityIds[e],
                "GameStatsComponent") or {}
            for c = 1, #componentIds do
                local isPlayer = ComponentGetValue2(componentIds[c], "is_player")
                if isPlayer then
                    local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(polymorphedEntityIds[e])
                    if compOwnerGuid == localMinaGuid then
                        CustomProfiler.stop("MinaUtils.isLocalMinaPolymorphed", cpc)
                        return true, polymorphedEntityIds[e]
                    else
                        Logger.warn(Logger.channels.entity, ("Found polymorphed Mina, but isn't local one! %s, %s, %s")
                            :format(compOwnerName, compOwnerGuid, compNuid))
                    end
                end
            end
        end
    end
    CustomProfiler.stop("MinaUtils.isLocalMinaPolymorphed", cpc)
    return false, nil
end

function MinaUtils.getAllMinas()
    local cpc = CustomProfiler.start("MinaUtils.getAllMinas")
    local minas = {}
    if whoAmI() == Client.iAm then
        for i = 1, #Client.otherClients or 1 do
            local mina = {}
            mina.name = Client.otherClients[i].name
            mina.guid = Client.otherClients[i].guid
            mina.nuid = Client.otherClients[i].nuid

            if Utils.IsEmpty(mina.nuid) then
                local playerEntityIds = EntityGetWithTag("player_unit")
                for i = 1, #playerEntityIds do
                    if NetworkVscUtils.hasNetworkLuaComponents(playerEntityIds[i]) then
                        local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(playerEntityIds[i])
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
        for i = 1, #Server:getClients() do
            local mina = {}
            mina.name = Server:getClients()[i].name
            mina.guid = Server:getClients()[i].guid
            mina.nuid = Server:getClients()[i].nuid

            if Utils.IsEmpty(mina.nuid) then
                local playerEntityIds = EntityGetWithTag("player_unit")
                for i = 1, #playerEntityIds do
                    if NetworkVscUtils.hasNetworkLuaComponents(playerEntityIds[i]) then
                        local compOwnerName, compOwnerGuid, compNuid = NetworkVscUtils.getAllVscValuesByEntityId(playerEntityIds[i])
                        if compOwnerGuid == mina.guid then
                            mina.nuid = compNuid
                            break
                        end
                    end
                end
            end
            minas[i] = mina
        end
    end

    local localMina = {}
    localMina.name = MinaUtils.getLocalMinaName()
    localMina.guid = MinaUtils.getLocalMinaGuid()
    localMina.nuid = MinaUtils.getLocalMinaNuid()
    minas[#minas + 1] = localMina

    CustomProfiler.stop("MinaUtils.getAllMinas", cpc)
    return minas
end

-- TODO: Rework this by adding and updating entityId to Server.entityId and Client.entityId! Dont forget polymorphism!
--- isRemoteMinae
---Checks if the entityId is a remote minae.
---@param entityId number
---@return boolean true if entityId is a remote minae, otherwise false
function MinaUtils:isRemoteMinae(entityId)
    local cpc = self.customProfiler:start("EntityUtils.isRemoteMinae")
    if not EntityGetIsAlive(entityId) then
        CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
        return false
    end
    local who = whoAmI()
    if who == Server.iAm then
        local clients = Server:getClients()
        for i = 1, #clients do
            local client                     = clients[i]
            local clientsNuid                = client.nuid
            local nuidRemote, entityIdRemote = GlobalsUtils.getNuidEntityPair(clientsNuid)
            if not Utils.IsEmpty(entityIdRemote) and entityIdRemote == entityId then
                CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
                return true
            end
        end
    elseif who == Client.iAm then
        local serverNuid, serverEntityId = GlobalsUtils.getNuidEntityPair(Client.serverInfo.nuid)
        if entityId == serverEntityId then
            CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
            return true
        end
        for i = 1, #Client.otherClients do
            local client                     = Client.otherClients[i]
            local clientsNuid                = client.nuid
            local nuidRemote, entityIdRemote = GlobalsUtils.getNuidEntityPair(clientsNuid)
            if not Utils.IsEmpty(entityIdRemote) and entityIdRemote == entityId then
                CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
                return true
            end
        end
    end
    CustomProfiler.stop("EntityUtils.isRemoteMinae", cpc)
    return false
end

---Globally accessible MinaUtils in _G.MinaUtils.
---@alias _G.MinaUtils MinaUtils
return MinaUtils
