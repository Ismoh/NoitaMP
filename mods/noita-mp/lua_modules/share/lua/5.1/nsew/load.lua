--- Helper module for loading NSEW into your mod.
--
-- This is not a module you would load in using `load = require("nsew.load")`.
-- Instead this file exists to help make Lua's `require` function work with the
-- NSEW modules.
--
-- @module nsew.load

__nsew_path = nil

--- Setup the environment for `require`-ing NSEW modules.
-- The usage example shows how you would use this file for the following Noita
-- mod structure:
--
-- <code><pre>nsew_client/
--├── init.lua
--├── mod.xml
--├── files
--│   └── ...
--├── deps
--│   └── nsew
--│       ├── load.lua
--│       └── < .. all other nsew files .. ></pre></code>
--
-- You can adapt this example for your own mod. :^)
--
-- @tparam string path path to the directory that contains the 'nsew' folder
-- @usage
-- -- nsew_client/init.lua
--
-- -- This tells NSEW where its files are, and configures Lua `package` globals
-- -- so that [`local world = require("nsew.world")`] will work.
-- local nsew_do_load = dofile_once("mods/nsew_client/deps/nsew/load.lua")
-- nsew_do_load("mods/nsew_client/deps")
--
-- local world = require("nsew.world")
-- -- ...
function do_load(path)
    __nsew_path = path .. "/nsew/"
    package.path = package.path .. ";" .. path .. "/?.lua"
end

return do_load
