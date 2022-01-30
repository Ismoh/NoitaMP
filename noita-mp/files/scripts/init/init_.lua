-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise pathes, globals and extensions..")

--#region
-- github workflow stuff
local params = ...
print(("params = %s"):format(params))
--#endregion

dofile("mods/noita-mp/files/scripts/util/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/util/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
-- if params then
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")(params)
-- else
--     dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
-- end
