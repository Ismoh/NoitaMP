local pretty = {}
pretty.table = function(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end
 
    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"
 
    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end
 
        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then
               
                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end
 
                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""
               
                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end
 
                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end
 
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end
 
            cur_index = cur_index + 1
        end
 
        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end
    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)
   
    print(output_str)
end

function pretty.table2(tbl, indent)
    if not indent then indent = 0 end
    local toprint = "{\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
      toprint = toprint .. string.rep(" ", indent)
      if (type(k) == "number") then
        toprint = toprint .. "[" .. k .. "] = "
      elseif (type(k) == "string") then
        toprint = toprint  .. k ..  " = "   
      end
      if (type(v) == "number") then
        toprint = toprint .. v .. ",\n"
      elseif (type(v) == "string") then
        toprint = toprint .. "\"" .. v .. "\",\n"
      elseif (type(v) == "table") then
        toprint = toprint .. pretty.table2(v, indent + 2) .. ",\n"
      else
        toprint = toprint .. "\"" .. tostring(v) .. "\",\n"
      end
    end
    toprint = toprint .. string.rep(" ", indent-4) .. "}"
    return toprint
end

function pretty.table3(tbl, indent, do_print)
    if do_print == nil then
        do_print = true
    end
    if not indent then indent = 0 end
    local toprint = "{\n"
    indent = indent + 2
    for k, v in pairs(tbl) do
      toprint = toprint .. string.rep(" ", indent)
      if (type(k) == "number") then
        -- toprint = toprint .. "[" .. k .. "] = "
        -- toprint = toprint .. "[" .. k .. "] = "
      elseif (type(k) == "string") then
        toprint = toprint  .. k ..  " = "
      end
      if (type(v) == "number") then
        toprint = toprint .. v .. ",\n"
      elseif (type(v) == "string") then
        toprint = toprint .. "\"" .. v .. "\",\n"
      elseif (type(v) == "table") then
        toprint = toprint .. pretty.table3(v, indent + 2, false) .. ",\n"
      else
        toprint = toprint .. "\"" .. tostring(v) .. "\",\n"
      end
    end
    toprint = toprint .. string.rep(" ", indent-4) .. "}"
    if do_print then
        print(toprint)
    else
        return toprint
    end
end

return pretty