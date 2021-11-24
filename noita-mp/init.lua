dofile("mods/noita-mp/files/scripts/util/util.lua")

SetNoitaRootAbsolutePath()

-- Need to add module package to package path, because relative paths are not working
package.path = package.path .. ";"
.. string.gsub(GetRelativePathOfRequiredLibs() .. "/?.lua;", "/", "\\")
.. string.gsub(GetAbsolutePathOfRequiredLibs() .. "/?.lua;", "/", "\\")
print(package.path)

package.cpath = package.cpath .. ";"
.. string.gsub(GetRelativePathOfRequiredLibs() .. "/?.dll;", "/", "\\")
.. string.gsub(GetAbsolutePathOfRequiredLibs() .. "/?.dll;", "/", "\\")
print(package.cpath)


ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")
print("init.lua | loading world seed magic number xml file.")
local world_seed_magic_numbers_path = GetAbsolutePathOfModFolder() .. "/files/tmp/magic_numbers/world_seed.xml"
if Exists(world_seed_magic_numbers_path) then
    GamePrint("init.lua | Loading " .. world_seed_magic_numbers_path)
    ModMagicNumbersFileAdd(world_seed_magic_numbers_path)
else
    GamePrint("init.lua | Unable to load " .. world_seed_magic_numbers_path)
end

local enet = nil
if enet == nil then
    local fileName = "enet.dll"
    print("Trying to load enet c library by file name with '" .. fileName .. "' loading.. Does file exists? " .. tostring(Exists(fileName)))
    enet = package.loadlib(fileName, "luaopen_enet")

    if not enet then
        print(tostring(enet))
        local rel_path = GetRelativePathOfRequiredLibs() .. "/" .. fileName
        rel_path = string.gsub(rel_path, "/", "\\")
        print("Trying to load enet c library by relative path with '" .. rel_path .. "' loading.. Does file exists? " .. tostring(Exists(rel_path)))
        enet = package.loadlib(rel_path, "luaopen_enet")
    end

    if not enet then
        print(tostring(enet))
        local abs_path = GetAbsolutePathOfRequiredLibs() .. "/" .. fileName
        abs_path = string.gsub(abs_path, "/", "\\")
        print("Trying to load enet c library by absolute path with '" .. abs_path .. "' loading.. Does file exists? " .. tostring(Exists(abs_path)))
        enet = package.loadlib(abs_path, "luaopen_enet")
    end

    if not enet then
        print(tostring(enet))
        local abs_path = [[C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\files\libs\enet.dll]]
        print("Trying to load enet c library by absolute path with '" .. abs_path .. "' loading.. Does file exists? " .. tostring(Exists(abs_path)))
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


function OnModPreInit()
    -- the seed is set when first time connecting to a server, otherwise 0
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))

    if not seed and seed > 0 then
        SetWorldSeed(seed)
        _G.Client:connect()
    end
end


function OnWorldInitialized()
    print("init.lua | OnWorldInitialized() | Loading clinet and server stuff..")
    dofile_once("mods/noita-mp/files/scripts/net/server_class.lua") -- run once to init server object
    dofile_once("mods/noita-mp/files/scripts/net/client_class.lua") -- run once to init client object
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