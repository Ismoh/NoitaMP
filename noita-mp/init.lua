dofile("mods/noita-mp/files/scripts/utils/util.lua")

--[[ 
    Need to add module package to package path, because relative paths are not working
 ]]
package.path = package.path .. ';' .. GetPathOfScript() .. 'files/libs/?.lua;'
package.cpath = package.cpath .. ';' .. GetPathOfScript() .. 'files/libs/?.dll;'
print(package.path)
print(package.cpath)

package.loadlib(GetPathOfScript() .. 'files/libs/lua-enet/enet.dll', 'enet')
print("enet.dll loaded.")

-- local function loadlib(path, name)
--     local sep = string.sub(package.config, 1, 1)
--     local file = path .. sep .. name .. ((sep == '/') and '.so' or '.dll')
--     local func = 'luaopen_' .. name
--     local loader, msg = package.loadlib(file, func)
--     assert(loader, msg)
--     return assert(loader())
-- end

-- local mylib = loadlib([[/path/to]], 'mylib')

dofile("mods/noita-mp/files/scripts/test.lua")

dofile("mods/noita-mp/files/scripts/net/server.lua")
dofile("mods/noita-mp/files/scripts/net/client.lua")