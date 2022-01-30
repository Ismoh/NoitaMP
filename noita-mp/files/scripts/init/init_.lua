-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise pathes, globals and extensions..")

--#region
-- github workflow stuff
local varargs = {...}
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

dofile("mods/noita-mp/files/scripts/util/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/util/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
local init_package_loading = dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
if destination_path then
    print("Running init_package_loading.lua with destination_path = " .. tostring(destination_path))
    init_package_loading(destination_path)
else
    print("Running init_package_loading.lua without any destination_path")
    init_package_loading()
end
