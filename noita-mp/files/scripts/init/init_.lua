-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise pathes, globals and extensions..")

--#region
-- github workflow stuff
local destination_path = select(1, ...)
--#endregion

dofile("mods/noita-mp/files/scripts/util/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/util/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
-- if destination_path then
dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")(destination_path)
--else
--     dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
--end
