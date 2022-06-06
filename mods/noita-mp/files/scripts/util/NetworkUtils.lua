-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

----------------------------------------------------------------------------------------------------
--- NetworkUtils
----------------------------------------------------------------------------------------------------
NetworkUtils = {}

NetworkUtils.events = {
    connect = { name = "connect", schema = { "code" } },

    --- connect2 is used to let the other clients know, who was connected
    connect2 = { name = "connect2", schema = { "name", "guid" } },

    disconnect = { name = "disconnect", schema = { "code" } },

    --- disconnect2 is used to let the other clients know, who was disconnected
    disconnect2 = { name = "disconnect2", schema = { "name", "guid" } },

    --- seed is used to send the servers seed
    seed = { name = "seed", schema = { "seed" } },

    --- playerInfo is used to send localPlayerInfo name and guid to all peers
    playerInfo = { name = "playerInfo", schema = { "name", "guid" } },

    --- newNuid is used to let clients spawn entities by the servers permission
    newNuid = { name = "newNuid", schema = { "owner", "localEntityId", "newNuid", "x", "y", "rotation", "velocity", "filename" } },

    --- needNuid is used to ask for a nuid from client to servers
    needNuid = { name = "needNuid", schema = { "owner", "localEntityId", "x", "y", "rotation", "velocity", "filename" } }
}

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.NetworkUtils = NetworkUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return NetworkUtils
