-- Fix package.path and package.cpath once
dofile_once("mods/noita-mp/files/lib/external/init_package_loading.lua")
dofile_once("mods/noita-mp/files/util/table_extensions.lua")


dofile("mods/noita-mp/files/scripts/util/util.lua")
local fu = require("file_util")
local Guid = require("guid")

fu.SetAbsolutePathOfNoitaRootDirectory()

-- Need to add module package to package path, because relative paths are not working
package.path = package.path .. ";"
.. string.gsub(fu.GetRelativeDirectoryPathOfRequiredLibs() .. "/?.lua;", "/", "\\")
.. string.gsub(fu.GetAbsoluteDirectoryPathOfRequiredLibs() .. "/?.lua;", "/", "\\")
print(package.path)

package.cpath = package.cpath .. ";"
.. string.gsub(fu.GetRelativeDirectoryPathOfRequiredLibs() .. "/?.dll;", "/", "\\")
.. string.gsub(fu.GetAbsoluteDirectoryPathOfRequiredLibs() .. "/?.dll;", "/", "\\")
print(package.cpath)


ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")
print("init.lua | loading world seed magic number xml file.")
local world_seed_magic_numbers_path = fu.GetAbsoluteDirectoryPathOfMods() .. "/files/tmp/magic_numbers/world_seed.xml"
if fu.Exists(world_seed_magic_numbers_path) then
    GamePrint("init.lua | Loading " .. world_seed_magic_numbers_path)
    ModMagicNumbersFileAdd(world_seed_magic_numbers_path)
else
    GamePrint("init.lua | Unable to load " .. world_seed_magic_numbers_path)
end

local enet = nil
if enet == nil then
    local fileName = "enet.dll"
    print("Trying to load enet c library by file name with '" .. fileName .. "' loading.. Does file exists? " .. tostring(fu.Exists(fileName)))
    enet = package.loadlib(fileName, "luaopen_enet")

    if not enet then
        print(tostring(enet))
        local rel_path = fu.GetRelativeDirectoryPathOfRequiredLibs() .. "/" .. fileName
        rel_path = string.gsub(rel_path, "/", "\\")
        print("Trying to load enet c library by relative path with '" .. rel_path .. "' loading.. Does file exists? " .. tostring(fu.Exists(rel_path)))
        enet = package.loadlib(rel_path, "luaopen_enet")
    end

    if not enet then
        print(tostring(enet))
        local abs_path = fu.GetAbsoluteDirectoryPathOfRequiredLibs() .. "/" .. fileName
        abs_path = string.gsub(abs_path, "/", "\\")
        print("Trying to load enet c library by absolute path with '" .. abs_path .. "' loading.. Does file exists? " .. tostring(fu.Exists(abs_path)))
        enet = package.loadlib(abs_path, "luaopen_enet")
    end

    if not enet then
        print(tostring(enet))
        local abs_path = [[C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\files\libs\enet.dll]]
        print("Trying to load enet c library by absolute path with '" .. abs_path .. "' loading.. Does file exists? " .. tostring(fu.Exists(abs_path)))
        enet = package.loadlib(abs_path, "luaopen_enet")
    end

    if enet then
        print("enet c library '" .. fileName .. "' was loaded by function load.")
        enet()
    else
        print(tostring(enet))
        print("enet c library '" .. fileName .. "' was loaded by require load.")
        require(fileName)
    end
end

fu.Find7zipExecutable()

function OnModPreInit()
    -- the seed is set when first time connecting to a server, otherwise 0
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))

    if not seed and seed > 0 then
        SetWorldSeed(seed)
        _G.Client:connect()
    end
end


function OnWorldInitialized()
    print("init.lua | OnWorldInitialized()")

    local make_zip = ModSettingGet("noita-mp.server_start_7zip_savegame")
    print("init.lua | make_zip = " .. tostring(make_zip))
    if make_zip then
        local archive_name = "server_save06_" .. os.date("%Y-%m-%d_%H-%M-%S")
        local destination = fu.GetAbsoluteDirectoryPathOfMods() .. _G.path_separator .. "_"
        local archive_content = fu.Create7zipArchive(archive_name .. "_from_server",
                                                    fu.GetAbsoluteDirectoryPathOfSave06(),
                                                    destination)
        local msg = ("init.lua | Server savegame [%s] was zipped with 7z to location [%s]."):format(archive_name, destination)
        print(msg)
        GamePrint(msg)
        ModSettingSetNextValue("noita-mp.server_start_7zip_savegame", false, false)
        ModSettingSet("noita-mp.server_start_when_world_loaded", true) -- automatically start the server again
    end

    print("init.lua | Initialise client and server stuff..")
    dofile_once("mods/noita-mp/files/scripts/net/server_class.lua") -- run once to init server object
    dofile_once("mods/noita-mp/files/scripts/net/client_class.lua") -- run once to init client object

    Guid.getGuid()
end


function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
    -- if Server.super then
    --     GamePrintImportant( "Server started", "Your server is running on "
    --     .. Server.super:getAddress() .. ":" .. Server.super:getPort() .. ". Tell your friends to join!")
    -- else
    --     GamePrintImportant( "Server not started", "Your server wasn't started yet. Check ModSettings to change this or Press M to open multiplayer menu.")
    -- end
end


function OnWorldPreUpdate()
    if _G.Server then
        _G.Server:update()
    end

    if _G.Client then
        _G.Client:update()
    end

    dofile("mods/noita-mp/files/scripts/ui.lua")
end