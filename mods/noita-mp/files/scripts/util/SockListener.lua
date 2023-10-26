local Listener    = {}
local Listener_mt = { __index = Listener }

-- Adds a callback to a trigger
-- Returns: the callback function
function Listener:addCallback(event, callback)
    if not self.triggers[event] then
        self.triggers[event] = {}
    else
        print("sock.lua | addCallback | There is already a callback set for event " .. event .. ". This callback won't be added. Returning nil!")
        return nil
    end

    table.insert(self.triggers[event], callback)

    return callback
end

-- Removes a callback on a given trigger
-- Returns a boolean indicating if the callback was removed
function Listener:removeCallback(callback)
    for _, triggers in pairs(self.triggers) do
        for i, trigger in pairs(triggers) do
            if trigger == callback then
                table.remove(triggers, i)
                return true
            end
        end
    end
    return false
end

-- Accepts: event (string), schema (table)
-- Returns: nothing
function Listener:setSchema(event, schema)
    self.schemas[event] = schema
end

-- Activates all callbacks for a trigger
-- Returns a boolean indicating if any callbacks were triggered
function Listener:trigger(event, data, client)
    if self.triggers[event] then
        for _, trigger in pairs(self.triggers[event]) do
            -- Event has a pre-existing schema defined
            if self.schemas[event] then
                data = require("NetworkUtils"):zipTable(data, self.schemas[event], event)
            end
            trigger(data, client)
        end
        return true
    else
        return false
    end
end

function Listener:newListener()
    local listener = setmetatable({
        triggers = {},
        schemas  = {},
    }, Listener_mt)

    return listener
end

return Listener
