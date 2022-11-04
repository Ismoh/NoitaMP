------------------------------------------------------------------------------------------------------------------------
--- Created by Ismoh.
--- DateTime: 08.10.2022 20:01
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
--- CoroutineUtils: -- TODO: REMOVE THIS FILE
------------------------------------------------------------------------------------------------------------------------
CoroutineUtils = {}
CoroutineUtils.co = nil

local prevEntities = {}
--- Custom iterator for entities using coroutine.
--- @param entities table indexed table of entities: entities[1]...entities[n]
--- @return number entityId
function CoroutineUtils.iterator(entities)
    --if #entities ~= #prevEntities then
    --    coroutine.s
    --end
    if not CoroutineUtils.co or coroutine.status(CoroutineUtils.co) == 'dead' then
        CoroutineUtils.co = coroutine.create(function()
            if not prevEntities then
                prevEntities = entities
            end
            for i = 1, #entities do
                local entityId = entities[i]
                if EntityUtils.isEntityAlive(entityId) then
                    coroutine.yield(entityId)
                end
            end
        end)
    end
    local iterator = function()
        local status, result = coroutine.resume(CoroutineUtils.co)
        if status then
            return result, CoroutineUtils.co
        else
            logger:error(logger.channels.entity, result)
        end
    end
    return iterator
end

-- Because of stack overflow errors when loading lua files,
-- I decided to put Utils 'classes' into globals
_G.CoroutineUtils = CoroutineUtils

-- But still return for Noita Components,
-- which does not have access to _G,
-- because of own context/vm
return CoroutineUtils