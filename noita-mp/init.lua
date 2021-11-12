dofile("mods/noita-mp/files/scripts/util/util.lua")
--[[
    Need to add module package to package path, because relative paths are not working
 ]]
package.path = package.path .. ';' .. GetPathOfScript() .. 'files/libs/?.lua;'
package.cpath = package.cpath .. ';' .. GetPathOfScript() .. 'files/libs/?.dll;'
print(package.path)
print(package.cpath)

local client = dofile_once("mods/noita-mp/files/scripts/net/client.lua")

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
    
end

function OnWorldPreUpdate()
    dofile("mods/noita-mp/files/scripts/net/server.lua")
    client.updateClient()
    dofile("mods/noita-mp/files/scripts/ui.lua")
end