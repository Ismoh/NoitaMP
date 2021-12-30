dofile("data/scripts/lib/utilities.lua")
dofile("mods/noita-mp/files/scripts/util/file_util.lua")

function GetPlayer()
   local player = EntityGetWithTag("player_unit") or nil
   if player ~= nil then
       return player[1]
   end
end


function Sleep(seconds)
    -- https://stackoverflow.com/a/40524323/3493998
    local sec = tonumber(os.clock() + seconds)
    while (os.clock() < sec) do
        -- do a buys wait. Consuming processor time, but I dont care :)
    end
end


function IsEmpty(var)
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