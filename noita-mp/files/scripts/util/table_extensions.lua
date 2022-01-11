-- Used to extend default lua implementations

--- Return true, if the key is contained in the tbl. NOTE: Doesn't check for duplicates inside the table.
--- @param tbl table Table to check.
--- @param key any Number(index) or String(name matching) for indexing the table.
--- @return boolean true if indexing by key does not return nil
table.contains = function(tbl, key)
    for index, value in ipairs(tbl) do
        if value == key then
            return true
        end
    end
    return false
end

-- https://gist.github.com/HoraceBury/9307117
--- Returns true if all the arg parameters are contained in the tbl.
--- @param tbl table The table to check within for the values passed in the following parameters.
--- @param ... any
--- @return boolean true if all the values were in the table.
table.containsAll = function(tbl, ...)
    local arg = {...}
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
