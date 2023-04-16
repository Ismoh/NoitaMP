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
if require then
    dofile("mods/noita-mp/files/scripts/extensions/ffiExtensions.lua")
end
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")
if require then
    dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
end
dofile("mods/noita-mp/files/scripts/init/init_logger.lua")



if not _G.Utils then
    if not require then
        _G.Utils = dofile_once("mods/noita-mp/files/scripts/util/Utils.lua")
    else
        ---Globally accessible Utils in _G.Utils.
        ---@alias _G.Utils Utils
        _G.Utils = require("Utils")
    end
end
if not _G.MinaUtils then
    if not require then
        _G.MinaUtils = dofile_once("mods/noita-mp/files/scripts/util/MinaUtils.lua")
    else
        ---Globally accessible MinaUtils in _G.MinaUtils.
        ---@alias _G.MinaUtils MinaUtils
        _G.MinaUtils = require("MinaUtils")
    end
end

if not _G.EntityCache then
    if not require then
    else
        require("luaExtensions")
    end
end

if not _G.NetworkCacheUtils then
    if not require then
        _G.NetworkCacheUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkCacheUtils.lua")
    else
        ---Globally accessible NetworkCacheUtils in _G.NetworkCacheUtils.
        ---@alias _G.NetworkCacheUtils NetworkCacheUtils
        _G.NetworkCacheUtils = require("NetworkCacheUtils")
    end
end

if not _G.EntitySerialisationUtils then
    if not require then
        _G.EntitySerialisationUtils = dofile_once("mods/noita-mp/files/scripts/util/EntitySerialisationUtils.lua")
    else
        ---Globally accessible EntitySerialisationUtils in _G.EntitySerialisationUtils.
        ---@alias _G.EntitySerialisationUtils EntitySerialisationUtils
        _G.EntitySerialisationUtils = require("EntitySerialisationUtils")
    end
end

if not _G.EntityCacheUtils then
    if not require then
        _G.EntityCacheUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityCacheUtils.lua")
    else
        ---Globally accessible EntityCacheUtils in _G.EntityCacheUtils.
        ---@alias _G.EntityCacheUtils EntityCacheUtils
        _G.EntityCacheUtils = require("EntityCacheUtils")
    end
end

if not _G.EntityUtils then
    if not require then
        _G.EntityUtils = dofile_once("mods/noita-mp/files/scripts/util/EntityUtils.lua")
    else
        ---Globally accessible EntityUtils in _G.EntityUtils.
        ---@alias _G.EntityUtils EntityUtils
        _G.EntityUtils = require("EntityUtils")
    end
end

if not _G.GlobalsUtils then
    if not require then
        _G.GlobalsUtils = dofile_once("mods/noita-mp/files/scripts/util/GlobalsUtils.lua")
    else
        ---Globally accessible GlobalsUtils in _G.GlobalsUtils.
        ---@alias _G.GlobalsUtils GlobalsUtils
        _G.GlobalsUtils = require("GlobalsUtils")
    end
end

if not _G.NetworkVscUtils then
    if not require then
        _G.NetworkVscUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkVscUtils.lua")
    else
        ---Globally accessible NetworkVscUtils in _G.NetworkVscUtils.
        ---@alias _G.NetworkVscUtils NetworkVscUtils
        _G.NetworkVscUtils = require("NetworkVscUtils")
    end
end

if not _G.NetworkUtils then
    if not require then
        _G.NetworkUtils = dofile_once("mods/noita-mp/files/scripts/util/NetworkUtils.lua")
    else
        ---Globally accessible NetworkUtils in _G.NetworkUtils.
        ---@alias _G.NetworkUtils NetworkUtils
        _G.NetworkUtils = require("NetworkUtils")
    end
end

if not _G.NoitaComponentUtils then
    if not require then
        _G.NoitaComponentUtils = dofile_once("mods/noita-mp/files/scripts/util/NoitaComponentUtils.lua")
    else
        ---Globally accessible NoitaComponentUtils in _G.NoitaComponentUtils.
        ---@alias _G.NoitaComponentUtils NoitaComponentUtils
        _G.NoitaComponentUtils = require("NoitaComponentUtils")
    end
end

if not _G.NuidUtils then
    if not require then
        _G.NuidUtils = dofile_once("mods/noita-mp/files/scripts/util/NuidUtils.lua")
    else
        ---Globally accessible NuidUtils in _G.NuidUtils.
        ---@alias _G.NuidUtils NuidUtils
        _G.NuidUtils = require("NuidUtils")
    end
end

if not _G.GuidUtils then
    if not require then
        _G.GuidUtils = dofile_once("mods/noita-mp/files/scripts/util/GuidUtils.lua")
    else
        ---Globally accessible GuidUtils in _G.GuidUtils.
        ---@alias _G.GuidUtils GuidUtils
        _G.GuidUtils = require("GuidUtils")
    end
end

if not _G.NoitaMpSettings then
    if not require then
        _G.NoitaMpSettings = dofile_once("mods/noita-mp/files/scripts/util/NoitaMpSettings.lua")
    else
        ---Globally accessible NoitaMpSettings in _G.NoitaMpSettings.
        ---@alias _G.NoitaMpSettings NoitaMpSettings
        _G.NoitaMpSettings = require("NoitaMpSettings")
    end
end

if not _G.CustomProfiler then
    if not require then
        _G.CustomProfiler = dofile_once("mods/noita-mp/files/scripts/util/CustomProfiler.lua")
    else
        ---Globally accessible CustomProfiler in _G.CustomProfiler.
        ---@alias _G.CustomProfiler CustomProfiler
        _G.CustomProfiler = require("CustomProfiler")
    end
end

if not _G.Server then
    if not require then
        _G.Server = dofile_once("mods/noita-mp/files/scripts/server/Server.lua")
    else
        ---Globally accessible Server in _G.Server.
        ---@alias _G.Server Server
        _G.Server = require("Server")
    end
end

if not _G.Client then
    if not require then
        _G.Client = dofile_once("mods/noita-mp/files/scripts/client/Client.lua")
    else
        ---Globally accessible Client in _G.Client.
        ---@alias _G.Client Client
        _G.Client = require("Client")
    end
end

if require then
    _G.whoAmI = function()
        if Server:amIServer() then
            return Server.iAm
        end
        if Client:amIClient() then
            return Client.iAm
        end
        return "UNKNOWN"
    end
end
