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
    print("Checking external enet c library 'enet.dll' loading..")
    enet = assert(package.loadlib(GetPathOfScript() .. "files/libs/enet.dll", "luaopen_enet"))
    enet()
    print("enet c library 'enet.dll' was loaded.")
end

local client = dofile_once("mods/noita-mp/files/scripts/net/client.lua")

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
    -- --debug_print_table(package.loaded)
    -- --debug_print_table(package.loaded, 1, "enet")
    -- print("printing debug_print_table(package.loaded[\"enet\"], 2)")
    -- debug_print_table(package.loaded["enet"], 2)

    -- print("printing assert(package.loadlib(GetPathOfScript() .. \"files/libs/enet.dll\", \"enet_initialize\"))")
    -- assert(package.loadlib(GetPathOfScript() .. "files/libs/enet.dll", "enet_initialize"))

    -- print("printing local test = assert(package.loadlib(GetPathOfScript() .. \"files/libs/enet.dll\", \"host_create\"))")
    -- local test = assert(package.loadlib(GetPathOfScript() .. "files/libs/enet.dll", "host_create"))

    -- print("printing assert(package.loadlib(GetPathOfScript() .. \"files/libs/enet.dll\", \"linked_version\"))")
    -- assert(package.loadlib(GetPathOfScript() .. "files/libs/enet.dll", "linked_version"))
end

function OnWorldPreUpdate()
    dofile("mods/noita-mp/files/scripts/net/server.lua")
    client.updateClient()
    dofile("mods/noita-mp/files/scripts/ui.lua")
end