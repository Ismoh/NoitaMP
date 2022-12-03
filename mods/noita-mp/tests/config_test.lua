function table.pack(...)
    return { n = select("#", ...), ... }
end
function vararg(...)
    local args = table.pack(...)
    for i = 1, args.n do
        -- do something with args[i], careful, it might be nil!
        print(("vararg %s = %s"):format(i, args[i]))
    end
    return args
end

local vArgs = vararg(...)
if vArgs[6] then
    print(("Found 6th arg to fix paths: "):format(vArgs[6]))
    local dofileDefault = _G.dofile
    local dofile = function(path)
        local fixedPath = vArgs[4] .. "/" .. path
        print(("dofile: %s -> %s"):format(path, fixedPath))
        return dofileDefault(fixedPath)
    end
    _G.dofile = dofile
end

local init_ = loadfile(vArgs[4] .. "/mods/noita-mp/files/scripts/init/init_.lua")
init_(vArgs[4] .. "/")
local init_package_loading = dofile("mods/noita-mp/files/scripts/init/init_package_loading.lua")
init_package_loading(vArgs[4] .. "/")

local lu   = require("luaunit")

TestConfig = {}

function TestConfig:setUp()
    print("\n setUp")
end

function TestConfig:tearDown()
    print("tearDown\n")
end

os.exit(lu.LuaUnit.run())
