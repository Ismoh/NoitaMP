-- Used to extend default lua implementations
-- https://gist.github.com/HoraceBury/9307117

--- Return true, if the key is contained in the tbl.
---@param tbl table Table to check.
---@param key any Number or String for indexing the table.
---@return boolean true if indexing by key does not return nil
table.contains = function (tbl, key)
    return tbl[key] ~= nil
end

--- Returns true if all the arg parameters are contained in the tbl.
--- @param tbl table The table to check within for the values passed in the following parameters.
--- @param ... any
--- @return boolean true if all the values were in the table.
table.containsAll = function(tbl, ...)
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
