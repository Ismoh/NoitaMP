local pprint = {}
if require then
    pprint = require("pprint")
else
    pprint.pformat = function(...)
        print(...)
    end
    pprint.defaults = {}
end

--- @class Utils
local Utils = {}

--- Wait for n seconds.
---@param s number seconds to wait
function Utils.Sleep(s)
    if type(s) ~= "number" then
        error("Unable to wait if parameter 'seconds' isn't a number: " .. type(s))
    end
    -- http://lua-users.org/wiki/SleepFunction
    local ntime = os.clock() + s
    repeat
    until os.clock() > ntime
end

function Utils.IsEmpty(var)
    -- if you change this also change NetworkVscUtils.lua
    -- if you change this also change tableExtensions.lua
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

--https://noita.wiki.gg/wiki/Modding:_Utilities#Easier_entity_debugging
function Utils.Str(var)
    if type(var) == "table" then
        local s = "{ "
        for k, v in pairs(var) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. Utils.Str(v) .. ","
        end
        return s .. "} "
    end
    return tostring(var)
end

--https://noita.wiki.gg/wiki/Modding:_Utilities#Easier_entity_debugging
function Utils.DebugEntity(e)
    local parent   = EntityGetParent(e)
    local children = EntityGetAllChildren(e)
    local comps    = EntityGetAllComponents(e)

    local msg      = "--- ENTITY DATA ---\n"
    msg            = msg .. ("Parent: [" .. parent .. "] name = " .. (EntityGetName(parent) or "") .. "\n")

    msg            = msg .. (" Entity: [" .. Utils.Str(e) .. "] name = " .. (EntityGetName(e) or "") .. "\n")
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

    Logger.debug(Logger.channels.testing, msg)
end

function Utils.pformat(var)
    return pprint.pformat(var, pprint.defaults)
end

--- Reloads the whole world with a specific seed. No need to restart the game and use magic numbers.
---@param seed number max = 4294967295
function Utils.ReloadMap(seed)
    SetWorldSeed(seed)
    BiomeMapLoad_KeepPlayer("mods/noita-mp/files/scripts/DefaultBiomeMap.lua", "data/biome/_pixel_scenes.xml")
end

function Utils.CopyToClipboard(copy)
    local command = nil
    if _G.is_windows then
        command = ('echo "%s" | clip'):format(copy)
    else
        command = ('echo "%s" | xclip -sel clip'):format(copy)
    end
    os.execute(command)
end

function Utils.openUrl(url)
    local command = nil
    if _G.is_windows then
        command = ("rundll32 url.dll,FileProtocolHandler %s"):format(url) -- command = ('explorer "%s"'):format(url)
    else
        command = ('open "%s"'):format(url)
    end
    os.execute(command)
end

return Utils
