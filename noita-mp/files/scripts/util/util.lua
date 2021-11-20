dofile("data/scripts/lib/utilities.lua")
dofile("mods/noita-mp/files/scripts/util/file_util.lua")

function GetPlayer()
   local player = EntityGetWithTag("player_unit") or nil
   if player ~= nil then
       return player[1]
   end
end