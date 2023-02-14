-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise paths, globals and extensions..")
local varargs = { ... }

if varargs and #varargs > 0 then
    if require then
        print("ERROR: Do not add any arguments when running this script in-game!")
    else
        print("'varargs' of init_.lua, see below:")
        print(unpack(varargs))
    end
else
    print("no 'varargs' set.")
end

dofile("mods/noita-mp/files/scripts/extensions/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/ffi_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")

dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")

-- We simply want to load all dependencies, when inGame and in init.lua-Context,
-- and when in NoitaComponents or in unit testing!Ø
require("MinaUtils")
require("noitamp_cache")
require("NetworkCacheUtils")
require("EntityUtils")
require("GlobalsUtils")
require("NetworkVscUtils")
require("NetworkUtils")
require("NoitaComponentUtils")
require("NuidUtils")
require("GuidUtils")
require("Server")
require("Client")
require("CustomProfiler")

_G.whoAmI = function()
    if Server:amIServer() then
        return Server.iAm
    end
    if Client:amIClient() then
        return Client.iAm
    end
    return "UNKNOWN"
end