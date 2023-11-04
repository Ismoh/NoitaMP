--- Used to extend default lua implementations of table

---@class tablelib
local table = _G.table

---@see table.isEmpty
local next  = _G.next

---Extension or expansion of the default lua table for checking if a table is empty.
---@param tbl table
---@return boolean true if table is empty.
function table.isEmpty(tbl)
    if not tbl then
        return true
    end
    if type(tbl) ~= "table" then
        error("Unable to check if a non-table is empty.")
    end
    return next(tbl) == nil
end

---Return true, if the key is contained in the tbl. NOTE: Doesn't check for duplicates inside the table.
---@param tbl table
---@param key any Number(index) or String(name matching) for indexing the table.
---@return boolean true if indexing by key does not return nil
---@return number index also returns the index of the found key
function table.contains(tbl, key)
    if table.isEmpty(tbl) then
        return false, -1
    end
    if not key then
        error("Unable to check if a key is contained in a table, when key is nil.", 2)
        return false, -1
    end
    if type(key) == "number" then
        if key <= 0 then
            return false, -1
        end
    end
    if type(key) == "string" then
        if key == "" then
            return false, -1
        end
        for k, v in pairs(tbl) do
            if type(v) == "string" then
                if string.contains(key, v) then
                    return true, k
                end
            end
        end
    end
    for k, v in pairs(tbl) do
        if v == key then
            return true, k
        end
    end
    return false, -1
end

-- https://gist.github.com/HoraceBury/9307117#file-tablelib-lua-L293-L313
---Returns true if all the arg parameters are contained in the tbl.
---@param tbl table
---@param ... any
---@return boolean true if all the values were in the table.
function table.containsAll(tbl, ...)
    local arg   = { ... }
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
--function table.removeByKey(tbl, key)
-- local element = table[key]
-- table[key] = nil
-- return element
--end

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

---Adds all values of tbl2 into tbl, but not duplicates.
---@param tbl1 table
---@param tbl2 table
function table.insertAllButNotDuplicates(tbl1, tbl2)
    if not tbl1 then
        tbl1 = {}
    end

    if type(tbl1) ~= "table" then
        error("Unable to insert values of one to another table, when tbl1 isn't a table.")
    end

    if not tbl2 then
        tbl2 = {}
    end

    if type(tbl2) ~= "table" then
        error("Unable to insert values of one to another table, when tbl2 isn't a table.")
    end

    --for i, v in ipairs(tbl2) do
    --    if not table.contains(tbl1, v) then
    --        table.insert(tbl1, v)
    --    end
    --end

    for i = 1, #tbl2 do
        local v = tbl2[i]
        if not table.contains(tbl1, v) then
            table.insert(tbl1, v)
        end
    end
end

function table.size(tbl)
    if not next(tbl) then
        return 0
    end

    -- https://stackoverflow.com/a/64882015/3493998
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

---We need a simple and 'fast' way to convert a lua table into a string.
---@param tbl table { "Name", 2, 234, "string" }
---@param logger Logger required
---@param utils Utils required
---@return string Example: tbl becomes "Name,2,234,string"
function table.join(tbl, logger, utils)
    if not tbl or type(tbl) ~= "table" then
        error("'tbl' must not be nil and type of table!", 2)
    end

    logger:trace(logger.channels.testing, ("tbl = %s"):format(utils:pformat(tbl)))
    local status, err = pcall(table.concat, tbl, ",")
    local str         = nil
    if status == true then
        str = err
        logger:trace(logger.channels.testing, ("table.concat(tbl, ',') = %s"):format(str))
    else
        logger:warn(logger.channels.testing, ("table.concat(tbl, ',') = %s"):format(err))
    end
    logger:trace(logger.channels.testing, ("str = %s"):format(str))
    if not str or str == "" then
        for key, value in orderedPairs(tbl) do
            logger:trace(logger.channels.testing, ("value = %s"):format(utils:pformat(value)))
            if type(value) == "table" then
                logger:trace(logger.channels.testing, ("value = %s is table!"):format(utils:pformat(tbl)))
                value = value:join()
            end
            if not str or str == "" then
                str = ("%s"):format(value)
            else
                str = ("%s,%s"):format(str, value)
            end
            logger:trace(logger.channels.testing, ("str = %s"):format(str))
        end
    end
    str = str:gsub("%s", "")
    logger:trace(logger.channels.testing, ("contentToString end str = '%s'"):format(str))
    return str
end
