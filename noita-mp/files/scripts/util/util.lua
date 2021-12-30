--dofile("data/scripts/lib/utilities.lua")

local util = {}

function util.Sleep(seconds)
    -- https://stackoverflow.com/a/40524323/3493998
    local sec = tonumber(os.clock() + seconds)
    while (os.clock() < sec) do
        -- do a buys wait. Consuming processor time, but I dont care :)
    end
end


function util.IsEmpty(var)
    if var == nil then
        return true
    end
    if var == "" then
        return true
    end
    if type(var) == "table" and not next(var) then
        return true
    end
    return false
end

return util