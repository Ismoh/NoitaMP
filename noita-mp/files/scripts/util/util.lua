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


-- https://stackoverflow.com/a/61541952
function TableToString(table)
    local index = 1
    local holder = "{"
    while true do

      if table == nil then
         holder = holder .. "nil"
         break
      end

       if type(table[index]) == "function" then
          index = index + 1
       elseif type(table[index]) == "table" then
          holder = holder..TableToString(table[index])
       elseif type(table[index]) == "number" then
          holder = holder..tostring(table[index])
       elseif type(table[index]) == "string" then
          holder = holder.."\""..table[index].."\""
       elseif table[index] == nil then
          holder = holder.."nil"
       elseif type(table[index]) == "boolean" then
          holder = (table[index] and "true" or "false")
       end
       if index + 1 > #table then
         break
       end
       holder = holder..","
       index = index + 1
    end
    return holder.."}"
 end

 function GetPlayer()
   local player = EntityGetWithTag("player_unit") or nil
   if player ~= nil then
       return player[1]
   end
end