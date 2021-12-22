-- https://subscription.packtpub.com/book/game-development/9781849515504/1/ch01lvl1sec10/preparing-a-basic-file-structure-for-the-game-engine

-- A list of paths to lua script modules
local paths = {
    "{root}/noita-mp/files/{module}",
    "{root}/noita-mp/files/lib/{module}",
    "{root}/noita-mp/files/lib/external/{module}",
    "{root}/noita-mp/files/lib/external/platform-specific/{platform}/{module}"
}

-- A list of paths to binary Lua modules
local module_paths = {
    "?.{extension}",
    "?/init.{extension}",
    "?/core.{extension}"
}

-- List of supported OS paired with binary file extension name
local extensions = {
    Windows = "dll",
    Linux = "so",
    Mac = "dylib"
}

--[[ NoitaMP additions ]]
local default_path = package.path
package.path = package.path .. "./noita-mp/files/lib/external/?.lua;"
--[[ NoitaMP additions ]]

-- os_name is a supplemental module for
-- OS and CPU architecture detection
local os_name = require("os_name")

--[[ NoitaMP additions ]]
package.path = default_path
--[[ NoitaMP additions ]]

-- A dot character represent current working directory
local root_dir = "."
local current_platform, current_architecture = os_name.getOS()

local cpaths, lpaths = {}, {}
local current_clib_extension = extensions[current_platform]

if current_clib_extension then
    -- now you can process each defined path for module.
    for _, path in ipairs(paths) do
        local path =
            path:gsub(
            "{(%w+)}",
            {
                root = root_dir,
                platform = current_platform
            }
        )
        -- skip empty path entries
        if #path > 0 then
            -- make a substitution for each module file path.
            for _, raw_module_path in ipairs(module_paths) do
                local module_path =
                    path:gsub(
                    "{(%w+)}",
                    {
                        module = raw_module_path
                    }
                )
                -- add path for binary module
                cpaths[#cpaths + 1] =
                    module_path:gsub(
                    "{(%w+)}",
                    {
                        extension = current_clib_extension
                    }
                )
                -- add paths for platform independent lua and luac modules
                lpaths[#lpaths + 1] =
                    module_path:gsub(
                    "{(%w+)}",
                    {
                        extension = "lua"
                    }
                )
                lpaths[#lpaths + 1] =
                    module_path:gsub(
                    "{(%w+)}",
                    {
                        extension = "luac"
                    }
                )
            end
        end
    end
    -- build module path list delimited with semicolon.
    --package.path = table.concat(lpaths, ";")
    --package.cpath = table.concat(cpaths, ";")
    --[[ NoitaMP additions ]]
    package.path = package.path .. table.concat(lpaths, ";")
    package.cpath = package.cpath .. table.concat(cpaths, ";")

    _G.os_name = current_platform
    _G.os_arch = current_architecture

    if _G.os_name == "Windows" then
        _G.is_windows = true
        os.execute('set LUA_PATH="' .. package.path ..'"')
        os.execute('set LUA_CPATH="' .. package.cpath ..'"')
    end
    if _G.os_name == "Linux" then
        _G.is_linux = true
        os.execute('export LUA_PATH="' .. package.path ..'"')
        os.execute('export LUA_CPATH="' .. package.cpath ..'"')
    end

    print("modules_handler.lua | Detected OS " .. _G.os_name .. " " .. _G.os_arch .. " .")
    print("modules_handler.lua | package.path and LUA_PATH set to " .. package.path .. " .")
    print("modules_handler.lua | package.cpath and LUA_CPATH set to " .. package.cpath .. " .")
    --[[ NoitaMP additions ]]
end
