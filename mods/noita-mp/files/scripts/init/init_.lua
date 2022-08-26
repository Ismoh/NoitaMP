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
else
    logger:warn(nil,
                "Utils didnt load in init_.lua, because it looks like the mod wasn't run in game, but maybe on Github.")
end
