-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise pathes, globals and extensions..")

--#region
-- github workflow stuff
local varargs          = { ... }
local destination_path = nil
if varargs and #varargs > 0 then
    print("'varargs' of init_.lua, see below:")
    print(unpack(varargs))

    destination_path = varargs[1]
    print("destination_path = " .. tostring(destination_path))
else
    print("no 'varargs' set.")
end

--#endregion

dofile("mods/noita-mp/files/scripts/extensions/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/ffi_extensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")

local init_package_loading = dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
if destination_path then
    print("Running init_package_loading.lua with destination_path = " .. tostring(destination_path))
    init_package_loading(destination_path)
else
    print("Running init_package_loading.lua without any destination_path")
    init_package_loading()
end

dofile("mods/noita-mp/files/scripts/extensions/globalsExtensions.lua")

-- On Github we do not want to load the utils.
-- Do a simple check by nil check:
if ModSettingGet then
    -- Load utils
    require("EntityUtils")
    require("GlobalsUtils")
    require("NetworkVscUtils")
    require("NetworkUtils")
    require("NoitaComponentUtils")
    require("NuidUtils")
    require("guid")
    require("Server")
    require("Client")
    local fu    = require("file_util")
    _G.profiler = require("profiler")
    -- profiler.attachPrintFunction(print, true)
    profiler.start()

    if false then -- if ModSettingGet("noita-mp.toggle_profiler") then
        local allLuaScriptFilenames = fu.getAllModSpecificLuaScriptFilenames()

        local directory             = fu.GetAbsolutePathOfNoitaRootDirectory().. _G.path_separator .. "noita-mp_profiler_reports" -- fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "profilerReports" .. _G.path_separator
        if fu.Exists(directory) == false then
            fu.MkDir(directory)
        end

        for k, v in pairs(_G.package.loaded._G) do
            if table.contains(allLuaScriptFilenames, k) and k ~= "profiler" then
                if type(v) == "table" then
                    for kt, vt in pairs(v) do
                        if type(vt) == "function" then
                            local func                  = vt
                            _G.package.loaded._G[k][kt] = function(...)
                                -- local args = { ... }
                                profiler.start()
                                local r = {func(...)} -- local result = func(unpack(args))
                                profiler.stop()
                                profiler.report(("%s%s%s.%s"):format(directory, _G.path_separator, k, kt))
                                return (table.unpack or unpack)(r) -- return result
                            end
                            logger:info(nil, ("Profiler enabled for %s.%s"):format(k, kt))
                        end
                    end
                elseif type(v) == "function" then
                    local func              = v
                    _G.package.loaded._G[k] = function(...)
                        -- local args = { ... }
                        profiler.start()
                        local r = {func(...)} -- local result = func(unpack(args))
                        profiler.stop()
                        profiler.report(("%s%s%s"):format(directory, _G.path_separator, k))
                        return (table.unpack or unpack)(r) -- return result
                    end
                    logger:info(nil, ("Profiler enabled for %s.%s"):format(k, v))
                end
            end
        end
    end
else
    logger:warn(nil,
                "Utils didnt load in init_.lua, because it looks like the mod wasn't run in game, but maybe on Github.")
end

