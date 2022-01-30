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
if destination_path then
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")(destination_path)
else
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
end
