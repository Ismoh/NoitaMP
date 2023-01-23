---
--- Created by Ismoh-PC.
--- DateTime: 23.01.2023 17:28
---
-- OOP class definition is found here: Closure approach
-- http://lua-users.org/wiki/ObjectOrientationClosureApproach
-- Naming convention is found here:
-- http://lua-users.org/wiki/LuaStyleGuide#:~:text=Lua%20internal%20variable%20naming%20%2D%20The,but%20not%20necessarily%2C%20e.g.%20_G%20.

------------------------------------------------------------------------------------------------------------------------
--- 'Imports'
------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------
--- NetworkUtils
------------------------------------------------------------------------------------------------------------------------
NetworkCacheUtils = {}

function NetworkCacheUtils.getSum(data)
    local sum = ""
    --- start at 2 so the networkMessageId is not included in the checksum
    for i = 2, #data do
        local d = data[i]
        if type(d) == "number" then
            d = tostring(d)
        end
        if type(d) == "boolean" then
            if d == true then
                d = "1"
            else
                d = "0"
            end
        end
        if type(d) == "table" then
            --- if data is a vec2
            if d.x and d.y then
                d = tostring(d.x) .. tostring(d.y)
                --- if data is an entity health table
            else
                if d.current and d.max then
                    d = tostring(d.current) .. tostring(d.max)
                else
                    d = ""
                end
            end
        end
        sum = sum .. d
    end
    return sum
end

--- Manipulates parameters to use Cache-CAPI.
--- @param peerGuid string peer.guid
--- @param networkMessageId number
---
function NetworkCacheUtils.set(peerGuid, networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
    NetworkCache.set(GuidUtils.toNumber(peerGuid), networkMessageId, event, status, ackedAt, sendAt, dataChecksum)
end

--- @return data { ackedAt, dataChecksum, event, messageId, sentAt, status}
function NetworkCacheUtils.get(peerGuid, networkMessageId, event)
    local data = NetworkCache.get(GuidUtils.toNumber(peerGuid), event, networkMessageId)
    return data
end

--- @return data { ackedAt, dataChecksum, event, messageId, sentAt, status}
function NetworkCacheUtils.getByChecksum(peerGuid, checksum)
    local data = NetworkCache.getChecksum(GuidUtils.toNumber(peerGuid), checksum)
    return data
end