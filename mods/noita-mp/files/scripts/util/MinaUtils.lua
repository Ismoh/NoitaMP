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
    --if util.IsEmpty(localMinaName) then
    --    MinaUtils.setLocalMinaName(ModSettingGet("noita-mp.name"))
    --end
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
    --if util.IsEmpty(localMinaGuid) then
    --    MinaUtils.setLocalMinaGuid(ModSettingGet("noita-mp.guid"))
    --end
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
    if nuid ~= nuid_ or entityId ~= entityId_ then
        error(("Something bad happen! Nuid or entityId missmatch: nuid %s ~= nuid_ and/or entityId %s ~= entityId_ %s")
            :format(nuid, nuid_, entityId, entityId_), 2)
    end
    CustomProfiler.stop("MinaUtils.getLocalMinaNuid", cpc)
    return tonumber(nuid) or -1
end

---Getter for local mina information. It also takes care of polymorphism!
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
        if EntityUtils.isEntityAlive(polymorphedEntityIds[e]) then
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

----Globally accessible MinaUtils in _G.MinaUtils.
----@alias _G.MinaUtils MinaUtils
--_G.MinaUtils = MinaUtils

return MinaUtils
