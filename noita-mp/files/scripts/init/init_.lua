-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise pathes, globals and extensions..")

--#region
-- github workflow stuff
local varargs = {}
-- https://stackoverflow.com/a/7630202/3493998
for i = 1, select("#", ...) do
    varargs[#varargs + 1] = select(i, ...)
end
print(("varargs = %s"):format(varargs))
--#endregion

dofile("mods/noita-mp/files/scripts/util/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/util/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
-- if params then
dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")(params)
-- else
--     dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
-- end
