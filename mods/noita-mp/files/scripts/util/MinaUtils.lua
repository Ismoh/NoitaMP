-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------
--- MinaUtils
------------------------------------------------------------------------------------------------------------------------
MinaUtils                          = {}

local localMinaName                = nil
local localMinaGuid                = nil

function MinaUtils.setLocalMinaName(name)
    localMinaName = name
    NoitaMpSettings.writeSettings("name", localMinaName)
end

function MinaUtils.getLocalMinaName()
    --if util.IsEmpty(localMinaName) then
    --    MinaUtils.setLocalMinaName(ModSettingGet("noita-mp.name"))
    --end
    return localMinaName
end

function MinaUtils.setLocalMinaGuid(guid)
    localMinaGuid = guid
    NoitaMpSettings.writeSettings("guid", localMinaGuid)
end

function MinaUtils.getLocalMinaGuid()
    --if util.IsEmpty(localMinaGuid) then
    --    MinaUtils.setLocalMinaGuid(ModSettingGet("noita-mp.guid"))
    --end
    return localMinaGuid
end

--- Returns the entity id of the local mina. It also takes care of polymorphism!
--- @return number|nil localMinaEntityId
function MinaUtils.getLocalMinaEntityId()
    local cpc                   = CustomProfiler.start("MinaUtils.getLocalMinaEntityId")
    local polymorphed, entityId = MinaUtils.isLocalMinaPolymorphed()

    if polymorphed then
        ---@cast entityId number
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

--- Returns a table of information about mina:
--- name, guid, entityId and nuid (if nuid is set, can be nil)
function MinaUtils.getLocalMinaInformation()
    local cpc       = CustomProfiler.start("MinaUtils.getLocalMinaInformation")
    local ownerName = MinaUtils.getLocalMinaName()
    local ownerGuid = MinaUtils.getLocalMinaGuid()
    local entityId  = MinaUtils.getLocalMinaEntityId()
    local nuid      = nil

    if MinaUtils.isLocalMinaPolymorphed() then
        local who = _G.whoAmI()
        if who == Client.iAm then
            if not NetworkVscUtils.hasNuidSet(entityId) then
                Client.sendNeedNuid(ownerName, ownerGuid, entityId)
            end
        elseif who == Server.iAm then
            if not NetworkVscUtils.hasNuidSet(entityId) then
                nuid = NuidUtils.getNextNuid()
            end
        else
            error(("Unable to identify whether I am Client or Server.. whoAmI() == %s"):format(who), 2)
        end
    end

    if not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
        NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
    end

    local _, _, nuid = NetworkVscUtils.getAllVscValuesByEntityId(entityId)
    CustomProfiler.stop("MinaUtils.getLocalMinaInformation", cpc)
    return {
        name     = ownerName,
        guid     = ownerGuid,
        entityId = entityId,
        nuid     = nuid
    }
end

--- Checks if local mina is polymorphed. Returns true|false, entityId|nil
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

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.MinaUtils = MinaUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return MinaUtils