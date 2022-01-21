--#region github specific stuff
local params = {...}
--#endregion

-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise pathes, globals and extensions..")
dofile("mods/noita-mp/files/scripts/util/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/util/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")(params)