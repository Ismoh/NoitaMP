-- Init lua scripts to set necessary defaults, like lua paths, logger init and extensions
print("Initialise paths, globals and extensions..")

-- assert(loadfile("mods/noita-mp/tests/_initializeUnitTests.lua"))("--verbose", "--error", "--failure")


--#region
-- github workflow stuff
local varargs          = { ... }
local destination_path = nil
if varargs and #varargs > 0 then
    if require then
        print("ERROR: Do not add any arguments when running this script in-game!")
    else
        print("'varargs' of init_.lua, see below:")
        print(unpack(varargs))

        --destination_path = varargs[1]
        --print("destination_path = " .. tostring(destination_path))
        --if varargs[2] then
        --    print("WARNING: varargs[2] is set and should only be used locally to fix unit testing paths!")
        --    local workDir = varargs[2]
        --    print("Current working directory: " .. workDir)
        --    local dofile     = _G.dofile
        --    _G.dofile        = function(path)
        --        print("Trying to load file: " .. path)
        --        print("Trying to load file with DOFILE: " .. workDir .. "/" .. path)
        --        return dofile(workDir .. "/" .. path)
        --    end
        --end
    end
else
    print("no 'varargs' set.")
end

--#endregion

dofile("mods/noita-mp/files/scripts/extensions/table_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/string_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/mathExtensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/ffi_extensions.lua")
dofile("mods/noita-mp/files/scripts/extensions/globalExtensions.lua")

local init_package_loading = dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
--if destination_path then
--    print("Running init_package_loading.lua with destination_path = " .. tostring(destination_path))
--    init_package_loading(destination_path)
--else
--    print("Running init_package_loading.lua without any destination_path")
--    init_package_loading()
--end

dofile("mods/noita-mp/files/scripts/init/init_logger.lua")

-- We simply want to load all dependencies, when inGame and in init.lua-Context,
-- but we don't when in NoitaComponents or in unit testing!
if require and not isTestLuaContext then
    -- Load utils
    require 'noitamp_cache'
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

    _G.whoAmI         = function()
        if _G.Server:amIServer() then
            return _G.Server.iAm
        end
        if _G.Client:amIClient() then
            return _G.Client.iAm
        end
        return nil
    end

    local fu          = require("file_util")
    _G.NoitaMPVersion = fu.getVersionByFile()

    require("CustomProfiler")
else
    print("WARNING: Utils didnt load in init_.lua, because it looks like the mod wasn't run in-game, but maybe on GitHub.")
end
