-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local util = require("util")
local fu = require("file_util")
local nxml = require("nxml")

-----------------
-- NuidUtils:
-----------------
--- class for getting the current network unique identifier
NuidUtils = {}

--#region Global private variables

local counter = 0
local xmlParsed = false

--#endregion

--#region Global private functions

local function getNextNuid()
    if _G.whoAmI() ~= _G.Server.iAm then
        error(("Unable to get next nuid, because looks like you aren't a server?! - whoAmI = %s"):format(whoAmI), 2)
    end

    -- Are there any nuids saved in globals, if so get the highest nuid?
    if not xmlParsed then
        local worldStateXmlAbsPath = fu.GetAbsDirPathOfWorldStateXml(saveSlotDirectory)
        if fu.Exists(worldStateXmlAbsPath) then
            local f = io.open(worldStateXmlAbsPath, "r")
            local xml = nxml.parse(f:read("*a"))
            f:close()

            for v in xml:first_of("WorldStateComponent"):first_of("lua_globals"):each_of("E") do
                local nuid = GlobalsUtils.parseXmlValueToNuidAndEntityId(v.attr.key, v.attr.value)
                if nuid ~= nil then
                    nuid = tonumber(nuid)
                    if nuid > counter then
                        counter = nuid
                    end
                end
            end
            logger:info(logger.channels.nuid, "Loaded nuids after loading a savegame. Latest nuid from world_state.xml aka Globals = %s.", counter)
        end
        xmlParsed = true
    end
    counter = counter + 1
    return counter
end

--#endregion

--#region Global public functions

function NuidUtils.getNextNuid()
    return getNextNuid()
end

--#endregion

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NuidUtils = NuidUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NuidUtils
