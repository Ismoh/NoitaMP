------------------------------------------------------------------------------------------------------------------------
--- Created by Ismoh.
--- DateTime: 08.10.2022 20:01
------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------
--- CoroutineUtils:
------------------------------------------------------------------------------------------------------------------------
CoroutineUtils = {}

--- Custom iterator for entities using coroutine.
--- @param entities table indexed table of entities: entities[1]...entities[n]
--- @return function iterator as a coroutine
--function CoroutineUtils.iterator(entities)
--    return coroutine.wrap(function()
--        for i = 1, #entities do
--            coroutine.yield(entities[i])
--        end
--    end)
--end
function CoroutineUtils.iterator(entities)
    if not co or coroutine.status(co) == 'dead' then
        co = coroutine.create(function()
            for i = 1, #entities do
                local entityId = entities[i]
                if EntityUtils.cachedEntityIds[entityId] ~= EntityUtils.entityStatus.processed and
                        EntityUtils.cachedEntityIds[entityId] ~= EntityUtils.entityStatus.destroyed then
                    EntityUtils.cachedEntityIds[entityId] = EntityUtils.entityStatus.new
                    coroutine.yield(entityId)
                end
            end
        end)
    end
    local iterator = function()
        local status, result = coroutine.resume(co)
        if status then
            return result, co
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