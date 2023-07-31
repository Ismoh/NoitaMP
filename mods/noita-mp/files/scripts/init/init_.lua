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

dofile("mods/noita-mp/files/scripts/extensions/tableExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/stringExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/ffiExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")
dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")
(dofile("mods/noita-mp/lua_modules/share/lua/5.1/nsew/load.lua"))("mods/noita-mp/lua_modules/share/lua/5.1/nsew")
require("MinaUtils")
require("luaExtensions")
require("NetworkCacheUtils")
require("EntitySerialisationUtils")
require("EntityCacheUtils")
require("WorldUtils")
require("EntityUtils")
require("GlobalsUtils")
require("NetworkVscUtils")
require("NetworkUtils")
require("NoitaComponentUtils")
require("NuidUtils")
require("GuidUtils")
require("NoitaMpSettings")
require("CustomProfiler")
require("Server")
require("Client")

_G.whoAmI = function()
    if Server:amIServer() then
        return Server.iAm
    end
    if Client:amIClient() then
        return Client.iAm
    end
    return "UNKNOWN"
end
