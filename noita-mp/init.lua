dofile("mods/noita-mp/files/scripts/util/util.lua")
--[[
    Need to add module package to package path, because relative paths are not working
 ]]
package.path = package.path .. ';' .. GetPathOfScript() .. 'files/libs/?.lua;'
package.cpath = package.cpath .. ';' .. GetPathOfScript() .. 'files/libs/?.dll;'
print(package.path)
print(package.cpath)

ModMagicNumbersFileAdd("mods/noita-mp/files/data/magic_numbers.xml")

local enet = nil
if enet == nil then
    local fileName = "files/libs/enet1317_lua-enet-master21-10-2015_lua5-1_32bit.dll"
    print("Checking external enet c library '" .. fileName .. "' loading..")
    enet = assert(package.loadlib(GetPathOfScript() .. fileName, "luaopen_enet"))
    enet()
    print("enet c library '" .. fileName .. "' was loaded.")
end

function OnModPreInit()
    local seed = tonumber(ModSettingGet("noita-mp.connect_server_seed"))

    -- if (seed == nil) then
    --     seed = 0
    --     ModSettingSet( "noita_together.seed", seed )
    -- end

    if (seed > 0) then
        SetWorldSeed(seed)
        _G.Client:connect()
    end
end

function OnWorldInitialized()
    print("init.lua | OnWorldInitialized()")
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