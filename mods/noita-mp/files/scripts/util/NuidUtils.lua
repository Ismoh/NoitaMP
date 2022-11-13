-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

local util      = require("util")
local fu        = require("file_util")
local nxml      = require("nxml")

-----------------
-- NuidUtils:
-----------------
--- class for getting the current network unique identifier
NuidUtils       = {}

--#region Global private variables

local counter   = 0
local xmlParsed = false

--#endregion

--#region Global private functions

local function getNextNuid()
    local cpc = CustomProfiler.start("NuidUtils.getNextNuid")
    if _G.whoAmI() ~= _G.Server.iAm then
        error(("Unable to get next nuid, because looks like you aren't a server?! - whoAmI = %s"):format(whoAmI), 2)
    end

    -- Are there any nuids saved in globals, if so get the highest nuid?
    if not xmlParsed then
        local worldStateXmlAbsPath = fu.GetAbsDirPathOfWorldStateXml(_G.saveSlotMeta.dir)
        if fu.Exists(worldStateXmlAbsPath) then
            local f   = io.open(worldStateXmlAbsPath, "r")
            local xml = nxml.parse(f:read("*a"))
            f:close()

            for v in xml:first_of("WorldStateComponent"):first_of("lua_globals"):each_of("E") do
                if string.contains(v.attr.key, "nuid") then
                    local nuid = GlobalsUtils.parseXmlValueToNuidAndEntityId(v.attr.key, v.attr.value)
                    if nuid ~= nil then
                        nuid = tonumber(nuid)
                        if nuid > counter then
                            counter = nuid
                        end
                    end
                end
            end
            logger:info(logger.channels.nuid,
                        "Loaded nuids after loading a savegame. Latest nuid from world_state.xml aka Globals = %s.",
                        counter)
        end
        xmlParsed = true
    end
    counter = counter + 1
    CustomProfiler.stop("NuidUtils.getNextNuid", cpc)
    return counter
end

--#endregion

--#region Global public functions

function NuidUtils.getNextNuid()
    return getNextNuid()
end

--- If an entity died, the associated nuid-entityId-set will be updated with entityId multiplied by -1.
--- If this happens, KillEntityMsg has to be send by network.
function NuidUtils.getEntityIdsByKillIndicator()
    local deadNuids            = GlobalsUtils.getDeadNuids()
    local worldStateXmlAbsPath = fu.GetAbsDirPathOfWorldStateXml(_G.saveSlotMeta.dir)
    if fu.Exists(worldStateXmlAbsPath) then
        local f   = io.open(worldStateXmlAbsPath, "r")
        local xml = nxml.parse(f:read("*a"))
        f:close()

        for v in xml:first_of("WorldStateComponent"):first_of("lua_globals"):each_of("E") do
            if string.contains(v.attr.key, "nuid") then
                local nuid, entityId = GlobalsUtils.parseXmlValueToNuidAndEntityId(v.attr.key, v.attr.value)
                if math.sign(tonumber(entityId)) == -1 then
                    table.insertIfNotExist(deadNuids, nuid)
                end
            end
        end
    end

    -- Remove all dead nuids from client or server acknowledge cache
    local clientOrServer = NetworkUtils.getClientOrServer()
    for i = 1, #deadNuids do
        local deadNuid            = deadNuids[i]
        local deadNuid_, entityId = GlobalsUtils.getNuidEntityPair(deadNuid)
        entityId                  = math.abs(entityId) -- Remove the kill indicator: -1 -> 1
        for j = 1, #clientOrServer.acknowledge do -- TODO FIX ME!
            local ack = clientOrServer.acknowledge[j]
            if ack and ack.data.localEntityId == entityId then
                table.setNoitaMpDefaultMetaMethods(clientOrServer.acknowledge[j], "v")
                clientOrServer.acknowledge[j] = nil
            end
        end
    end
    return deadNuids
end

--#endregion

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NuidUtils = NuidUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NuidUtils
