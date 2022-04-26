-- Used to extend default lua implementations of table

--- Return true, if the key is contained in the tbl. NOTE: Doesn't check for duplicates inside the table.
--- @param tbl table Table to check.
--- @param key any Number(index) or String(name matching) for indexing the table.
--- @return boolean true if indexing by key does not return nil
--- @return integer index also returns the index of the found key
table.contains = function(tbl, key)
    -- for index, value in ipairs(tbl) do
    --     if value == key then
    --         return true, index
    --     end
    -- end
    for i = 1, #tbl do -- better performance? Yes reduced load from 111 to 80. still only 10fps
        local v = tbl[i]
        if v == key then
            return true, i
        end
    end
    return false, -1
end

-- https://gist.github.com/HoraceBury/9307117#file-tablelib-lua-L293-L313
--- Returns true if all the arg parameters are contained in the tbl.
--- @param tbl table The table to check within for the values passed in the following parameters.
--- @param ... any
--- @return boolean true if all the values were in the table.
table.containsAll = function(tbl, ...)
    local arg = { ... }
    local count = 0
    for i = 1, #tbl do
        for c = 1, #arg do
            if (tbl[i] == arg[c]) then
                count = count + 1
            end
        end
    end
    return count >= #arg
end

-- https://stackoverflow.com/questions/1758991/how-to-remove-a-lua-table-entry-by-its-key
function table.removeByKey(tbl, key)
    -- local element = table[key]
    -- table[key] = nil
    -- return element
end

function table.removeByValue(tbl, value)
    local index = table.indexOf(tbl, value)
    if index ~= nil then
        table.remove(tbl, index)
    end
    return tbl
end

--- Removes all values in tbl1 by the values of tbl2
--- @param tbl1 table
--- @param tbl2 table
--- @return table tbl1 returns tbl1 with remove values containing in tbl2
function table.removeByTable(tbl1, tbl2)
    for i = 1, #tbl2 do
        local v = tbl2[i]
        if table.contains(tbl1, v) then
            table.removeByValue(tbl1, v)
        end
    end
    return tbl1
end

-- https://stackoverflow.com/a/52922737/3493998
function table.indexOf(tbl, value)
    for i = 1, #tbl do
        local v = tbl[i]
        if (v == value) then
            return i
        end
    end
    return nil
end

--- Adds a value to a table, if this value doesn't exist in the table
--- @param tbl table
--- @param value any
function table.insertIfNotExist(tbl, value)
    if not table.contains(tbl, value) then
        table.insert(tbl, value)
    end
end

--- Adds all values of tbl2 into tbl1.
--- @param tbl1 table
--- @param tbl2 table
function table.insertAll(tbl1, tbl2)
    for i, v in ipairs(tbl2) do
        table.insert(tbl1, v)
    end
end
