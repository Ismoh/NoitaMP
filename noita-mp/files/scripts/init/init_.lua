-- Noita independent init file for setting global object, requirements and fixing lua paths
dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
dofile("mods/noita-mp/files/scripts/util/table_extensions.lua")

-- use require instead of dofile, because of different paths. Set package parh in the first line
-- or move/copy noita-mp to ./mods/ on github
