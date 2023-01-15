local pprint = {}
if require then
    pprint = require("pprint")
else
    pprint.pformat = function(...)
        print(...)
    end
    pprint.defaults = {}
end

local util = {}

--- Wait for n seconds.
---@param s number seconds to wait
function util.Sleep(s)
    if type(s) ~= "number" then
        error("Unable to wait if parameter 'seconds' isn't a number: " .. type(s))
    end
    -- http://lua-users.org/wiki/SleepFunction
    local ntime = os.clock() + s
    repeat
    until os.clock() > ntime
end

function util.IsEmpty(var)
    -- if you change this also change NetworkVscUtils.lua
    -- if you change this also change table_extensions.lua
    if var == nil then
        return true
    end
    if var == "" then
        return true
    end
    if type(var) == "table" and not next(var) then
        return true
    end
    return false
end

-- function util.serialise(data)
--     return bitser.dumps(data)
-- end

-- --- Deserialise data
-- ---@param data any
-- ---@return any
-- function util.deserialise(data)
--     return bitser.loads(data)
-- end

--https://noita.wiki.gg/wiki/Modding:_Utilities#Easier_entity_debugging
function util.str(var)
    if type(var) == "table" then
        local s = "{ "
        for k, v in pairs(var) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. util.str(v) .. ","
        end
        return s .. "} "
    end
    return tostring(var)
end

--https://noita.wiki.gg/wiki/Modding:_Utilities#Easier_entity_debugging
function util.debug_entity(e)
    local parent   = EntityGetParent(e)
    local children = EntityGetAllChildren(e)
    local comps    = EntityGetAllComponents(e)

    local msg      = "--- ENTITY DATA ---\n"
    msg            = msg .. ("Parent: [" .. parent .. "] name = " .. (EntityGetName(parent) or "") .. "\n")

    msg            = msg .. (" Entity: [" .. util.str(e) .. "] name = " .. (EntityGetName(e) or "") .. "\n")
    msg            = msg .. ("  Tags: " .. (EntityGetTags(e) or "") .. "\n")
    if (comps ~= nil) then
        for _, comp in ipairs(comps) do
            local comp_type = ComponentGetTypeName(comp) or ""
            msg             = msg .. ("  Comp: [" .. comp .. "] type = " .. comp_type)
            if comp_type == "VariableStorageComponent" then
                msg = msg .. (" - " .. (ComponentGetValue2(comp, "name") or "") .. " = " .. (ComponentGetValue2(comp,
                                                                                                                "value_string") or ""))
            end
            msg = msg .. "\n"
        end
    end

    if children == nil then
        return
    end

    for _, child in ipairs(children) do
        local comps = EntityGetAllComponents(child)
        msg         = msg .. ("  Child: [" .. child .. "] name = " .. EntityGetName(child) .. "\n")
        for _, comp in ipairs(comps) do
            local comp_type = ComponentGetTypeName(comp) or ""
            msg = msg .. ("   Comp: [" .. comp .. "] type = " .. comp_type)
            if comp_type == "VariableStorageComponent" then
                msg = msg .. (" - " .. (ComponentGetValue2(comp, "name") or "") .. " = " .. (ComponentGetValue2(comp,
                                                                                                                "value_string") or ""))
            end
            msg = msg .. "\n"
        end
    end
    msg = msg .. ("--- END ENTITY DATA ---" .. "\n")

    logger:debug(nil, msg)
end

function util.pformat(var)
    return pprint.pformat(var, pprint.defaults)
end

--- Gets the local player information.
--- Including polymorphed entity id. When polymorphed, entityId will be the new one and not minäs anymore.
--- @return PlayerInfo playerInfo
function util.getLocalPlayerInfo()
    local cpc = CustomProfiler.start("util.getLocalPlayerInfo")
    local ownerName = tostring(ModSettingGet("noita-mp.name"))
    local ownerGuid = tostring(ModSettingGet("noita-mp.guid"))
    local entityId  = EntityUtils.getLocalPlayerEntityId()
    local nuid = nil

    if EntityUtils.isPlayerPolymorphed() then
        if _G.whoAmI() == Client.iAm then
            if not NetworkVscUtils.hasNuidSet(entityId) then
                Client.sendNeedNuid(ownerName, ownerGuid, entityId)
            end
        elseif _G.whoAmI() == Server.iAm then
            if not NetworkVscUtils.hasNuidSet(entityId) then
                nuid = NuidUtils.getNextNuid()
            end
        else
            error("Unable to identify whether I am Client or Server..", 3)
        end
    end

    if not NetworkVscUtils.isNetworkEntityByNuidVsc(entityId) then
        NetworkVscUtils.addOrUpdateAllVscs(entityId, ownerName, ownerGuid, nuid)
    end

    local _, _, nuid = NetworkVscUtils.getAllVcsValuesByEntityId(entityId)
    CustomProfiler.stop("util.getLocalPlayerInfo", cpc)
    return {
        name     = tostring(ModSettingGet("noita-mp.name")),
        guid     = tostring(ModSettingGet("noita-mp.guid")),
        entityId = entityId,
        nuid     = nuid
    }
end

--- Reloads the whole world with a specific seed. No need to restart the game and use magic numbers.
---@param seed number max = 4294967295
function util.reloadMap(seed)
    SetWorldSeed(seed)
    BiomeMapLoad_KeepPlayer("mods/noita-mp/files/scripts/DefaultBiomeMap.lua", "data/biome/_pixel_scenes.xml")
end

function util.copyToClipboard(copy)
    local command = nil
    if _G.is_windows then
        command = ('echo "%s" | clip'):format(copy)
    else
        command = ('echo "%s" | xclip -sel clip'):format(copy)
    end
    os.execute(command)
end

return util
