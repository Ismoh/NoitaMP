dofile("data/scripts/lib/utilities.lua")

function GetPathOfScript() -- Returns the relative path of the script, which executes this function
    local str = debug.getinfo(2, "S").source:sub(1)
    print("str = " .. str)

    local match1 = str:match("(.*/)")
    print("path get match1 = " .. match1)

    local match_windows = str:match("(.*[/\\])")
    print("path get match windows = " .. match_windows)

    return match1 or match_windows
end


 function GetPlayer()
   local player = EntityGetWithTag("player_unit") or nil
   if player ~= nil then
       return player[1]
   end
end