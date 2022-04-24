-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

-----------------
-- GlobalsUtils:
-----------------
--- class for GlobalsSetValue and GlobalsGetValue
GlobalsUtils = {}

--#region Global public variables

--- key for nuid
GlobalsUtils.nuidKey = "nuid = "
GlobalsUtils.nuidKeyFormat = "nuid = %s"
GlobalsUtils.nuidValueFormat = "nuid=%s -> entity_id=%s"

--#endregion

--#region Access to global private variables

function GlobalsUtils.getNuidNumberOfKeyString(keyString)
    if type(keyString) ~= "string" then
        logger:error("keyString(%s) is not type of string!", keyString)
    end

    local nuid = nil
    local found = string.find(keyString, GlobalsUtils.nuidKey, 1, true)
    if found ~= nil then
        nuid = tonumber(string.sub(keyString, GlobalsUtils.nuidKey:len()))
    else
        logger:error("Unable to get nuid number of key string (%s).", keyString)
    end
    return nuid
end

--#endregion

return GlobalsUtils
