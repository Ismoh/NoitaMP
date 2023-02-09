---@diagnostic disable: undefined-global, redundant-parameter, need-check-nil
-- Used to extend default lua implementations of table

--- Return true, if the key is contained in the tbl. NOTE: Doesn't check for duplicates inside the table.
--- @param tbl table Table to check.
--- @param key any Number(index) or String(name matching) for indexing the table.
--- @return boolean true if indexing by key does not return nil
--- @return number index also returns the index of the found key
table.contains    = function(tbl, key)
    for i = 1, #tbl do
        -- better performance? Yes reduced load from 111 to 80. still only 10fps
        local v = tbl[i]
        if v == key then
            return true, i
        end
        --if type(v) == "string" and string.contains(v, key) then
        --    return true, i
        --end
        if type(v) == "string" and type(key) == "string" and v:lower() == key:lower() then
            return true, i
        end
    end
    for index, value in ipairs(tbl) do
        if value == key then
            return true, index
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

--- DEPRECATED use table.insertAllButNotDuplicates(tbl1, tbl2)
--- Adds all values of tbl2 into tbl1.
--- @param tbl1 table
--- @param tbl2 table
function table.insertAll(tbl1, tbl2)
    if not tbl1 then
        tbl1 = {}
    end
    if not tbl2 then
        tbl2 = {}
    end
    for i, v in ipairs(tbl2) do
        table.insert(tbl1, v)
    end
end

--- Adds all values of tbl2 into tbl1, but not duplicates.
--- @param tbl1 table
--- @param tbl2 table
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

function table.size(T)
    if not T then
        return 0
    end

    -- https://stackoverflow.com/a/64882015/3493998
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

--- Sets metamethods for the table, which are default metamethods for NoitaMP.
--- __mode = "kv" is set, so the table can be used as a weak table on key and value.
--- __index = decreases __len by 1, so the table can be used as a stack.
--- __newindex = increases __len by 1, so the table can be used as a stack.
--- __len isn't available in lua 5.1, so init it.
--- @param tbl table table to set the metamethods
--- @param mode? string k or v or kv
function table.setNoitaMpDefaultMetaMethods(tbl, mode)
    mode = mode or "kv"
    if type(tbl) ~= "table" then
        error("Unable to set default metamethods for a non-table.")
    end
    if type(mode) ~= "string" then
        error("Unable to set default metamethods for a non-string mode.")
    end

    --tbl.size = 0 -- __len isn't available in lua 5.1, workaround.

    local mt = {
        __mode = mode, -- Make it a weak table with "k" or "v" or "kv"
        --    __index    = function(self, k)
        --        if not rawget(self, k) then
        --            -- value = rawget(self, k)
        --            self.size = self.size - 1 -- dirty workaround to get __len in lua5.1
        --        end
        --        return rawget(self, k)
        --    end,
        --    __newindex = function(self, k, v)
        --        self.size = self.size + 1 -- dirty workaround to get __len in lua5.1
        --        rawset(self, k, v)
        --    end,
        --    __tostring = function(self)
        --        local str = ""
        --        for i = 1, self.size do
        --            str = str .. tostring(self[i]) .. ", "
        --        end
        --        return str
        --    end,
        --    __len      = function(self)
        --        return self.size
        --    end
    }
    setmetatable(tbl, mt)
end

function table.contentToString(tbl)
    if not tbl or type(tbl) ~= "table" then
        error("'tbl' must not be nil and type of table!", 2)
    end
    Logger.trace(Logger.channels.testing, ("tbl = %s"):format(tbl))
    local status, err = pcall(table.concat, tbl, ",")
    local str         = nil
    if status == true then
        str = err
    else
        Logger.warn(Logger.channels.testing, ("table.concat(tbl, ',') = %s"):format(err))
    end
    Logger.trace(Logger.channels.testing, ("str = %s"):format(str))
    if not str or str == "" then
        -- I don't like pairs, but in this case, I don't have a better idea yet
        -- TODO: Gustavo: the risky thing about that is that pairs() iteration order is not guaranteed, so you might have different sums for the same table
        for key, value in pairs(tbl) do
            Logger.trace(Logger.channels.testing, ("value = %s"):format(value))
            if type(value) == "table" then
                Logger.trace(Logger.channels.testing, ("value = %s is table!"):format(tbl))
                value = table.contentToString(value)
            end
            if not str or str == "" then
                str = ("%s"):format(value)
            else
                str = ("%s,%s"):format(str, value)
            end
            Logger.trace(Logger.channels.testing, ("str = %s"):format(str))
        end
    end
    str = str:gsub("%s", "")
    Logger.trace(Logger.channels.testing, ("contentToString end str = '%s'"):format(str))
    return str
end

------------------------------------------------------------------------------------------------------------------------
--[[ deepcopy.lua

    Deep-copy function for Lua - v0.2
    ==============================
      - Does not overflow the stack.
      - Maintains cyclic-references
      - Copies metatables
      - Maintains common upvalues between copied functions (for Lua 5.2 only)

    TODO
    ----
      - Document usage (properly) and provide examples
      - Implement handling of LuaJIT FFI ctypes
      - Provide option to only set metatables, not copy (as if they were
        immutable)
      - Find a way to replicate `debug.upvalueid` and `debug.upvaluejoin` in
        Lua 5.1
      - Copy function environments in Lua 5.1 and LuaJIT
        (Lua 5.2's _ENV is actually a good idea!)
      - Handle C functions

    Usage
    -----
        copy = table.deecopy(orig)
        copy = table.deecopy(orig, params, customcopyfunc_list)

    `params` is a table of parameters to inform the copy functions how to
    copy the data. The default ones available are:
      - `value_ignore` (`table`/`nil`): any keys in this table will not be
        copied (value should be `true`). (default: `nil`)
      - `value_translate` (`table`/`nil`): any keys in this table will result
        in the associated value, rather than a copy. (default: `nil`)
        (Note: this can be useful for global tables: {[math] = math, ..})
      - `metatable_immutable` (`boolean`): assume metatables are immutable and
        do not copy them (only set). (default: `false`)
      - `function_immutable` (`boolean`): do not copy function values; instead
        use the original value. (default: `false`)
      - `function_env` (`table`/`nil`): Set the enviroment of functions to
        this value (via fourth arg of `loadstring`). (default: `nil`)
        this value. (default: `nil`)
      - `function_upvalue_isolate` (`boolean`): do not join common upvalues of
        copied functions (only applicable for Lua 5.2 and LuaJIT). (default:
        `false`)
      - `function_upvalue_dontcopy` (`boolean`): do not copy upvalue values
        (does not stop joining). (default: `false`)

    `customcopyfunc_list` is a table of typenames to copy functions.
    For example, a simple solution for userdata:
    { ["userdata"] = function(stack, orig, copy, state, arg1, arg2)
        if state == nil then
            copy = orig
            local orig_uservalue = debug.getuservalue(orig)
            if orig_uservalue ~= nil then
                stack:recurse(orig_uservalue)
                return copy, 'uservalue'
            end
            return copy, true
        elseif state == 'uservalue' then
            local copy_uservalue = arg2
            if copy_uservalue ~= nil then
                debug.setuservalue(copy, copy_uservalue)
            end
            return copy, true
        end
    end }
    Any parameters passed to the `params` are available in `stack`.
    You can use custom paramter names, but keep in mind that numeric keys and
    string keys prefixed with a single underscore are reserved.

    License
    -------
    Copyright (C) 2012 Declan White

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
]]
do
    local type                              = rawtype or type
    local rawget                            = rawget
    local rawset                            = rawset
    local next                              = rawnext or next
    local getmetatable                      = debug and debug.getmetatable or getmetatable
    local setmetatable                      = debug and debug.setmetatable or setmetatable
    local debug_getupvalue                  = debug and debug.getupvalue or nil
    local debug_setupvalue                  = debug and debug.setupvalue or nil
    local debug_upvalueid                   = debug and debug.upvalueid or nil
    local debug_upvaluejoin                 = debug and debug.upvaluejoin or nil
    local unpack                            = unpack
    local table                             = table
    table.deepcopy_copyfunc_list            = {
        --["type"] = function(stack, orig, copy, state, temp1, temp2, temp..., tempN)
        --
        --    -- When complete:
        --    state = true
        --
        --    -- Store temporary variables between iterations using these:
        --    -- (Note: you MUST NOT call these AFTER recurse)
        --    stack:_push(tempN+1, tempN+2, tempN+..., tempN+M)
        --    stack:_pop(K)
        --    -- K is the number to pop.
        --    -- If you wanted to pop two from the last state and push four new ones:
        --    stack:_pop(2)
        --    stack:_push('t', 'e', 's', 't')
        --
        --    -- To copy a child value:
        --    -- (Note: any calls to push or pop MUST be BEFORE a call to this)
        --    state:recurse(childvalue_orig)
        --    -- This will leave two temp variables on the stack for the next iteration
        --    -- .., childvalue_orig, childvalue_copy
        --    -- which are available via the varargs (temp...)
        --    -- (Note: the copy may be nil if it was not copied (because caller
        --    -- specified it not to be)).
        --    -- You can only call this once per iteration.
        --
        --    -- Return like this:
        --    -- (Temp variables are not part of the return list due to optimisation.)
        --    return copy, state
        --
        --end,
        _plainolddata     = function(stack, orig, copy, state)
            return orig, true
        end,
        ["table"]         = function(stack, orig, copy, state, arg1, arg2, arg3, arg4)
            local orig_prevkey, grabkey = nil, false
            if state == nil then
                -- 'init'
                -- Initial state, check for metatable, or get first key
                -- orig, copy:nil, state
                copy = stack[orig]
                if copy ~= nil then
                    -- Check if already copied
                    return copy, true
                else
                    copy            = {} -- Would be nice if you could preallocate sizes!
                    stack[orig]     = copy
                    local orig_meta = getmetatable(orig)
                    if orig_meta ~= nil then
                        -- This table has a metatable, copy it
                        if not stack.metatable_immutable then
                            stack:_recurse(orig_meta)
                            return copy, 'metatable'
                        else
                            setmetatable(copy, orig_meta)
                        end
                    end
                end
                -- No metatable, go straight to copying key-value pairs
                orig_prevkey = nil -- grab first key
                grabkey      = true --goto grabkey
            elseif state == 'metatable' then
                -- Metatable has been copied, set it and get first key
                -- orig, copy:{}, state, metaorig, metacopy
                local copy_meta = arg2--select(2, ...)
                stack:_pop(2)

                if copy_meta ~= nil then
                    setmetatable(copy, copy_meta)
                end

                -- Now start copying key-value pairs
                orig_prevkey = nil -- grab first key
                grabkey      = true --goto grabkey
            elseif state == 'key' then
                -- Key has been copied, now copy value
                -- orig, copy:{}, state, keyorig, keycopy
                local orig_key = arg1--select(1, ...)
                local copy_key = arg2--select(2, ...)

                if copy_key ~= nil then
                    -- leave keyorig and keycopy on the stack
                    local orig_value = rawget(orig, orig_key)
                    stack:_recurse(orig_value)
                    return copy, 'value'
                else
                    -- key not copied? move onto next
                    stack:_pop(2) -- pop keyorig, keycopy
                    orig_prevkey = orig_key
                    grabkey      = true--goto grabkey
                end
            elseif state == 'value' then
                -- Value has been copied, set it and get next key
                -- orig, copy:{}, state, keyorig, keycopy, valueorig, valuecopy
                local orig_key   = arg1--select(1, ...)
                local copy_key   = arg2--select(2, ...)
                --local orig_value = arg3--select(3, ...)
                local copy_value = arg4--select(4, ...)
                stack:_pop(4)

                if copy_value ~= nil then
                    rawset(copy, copy_key, copy_value)
                end

                -- Grab next key to copy
                orig_prevkey = orig_key
                grabkey      = true --goto grabkey
            end
            --return
            --::grabkey::
            if grabkey then
                local orig_key, orig_value = next(orig, orig_prevkey)
                if orig_key ~= nil then
                    stack:_recurse(orig_key) -- Copy key
                    return copy, 'key'
                else
                    return copy, true -- Key is nil, copying of table is complete
                end
            end
            return
        end,
        ["function"]      = function(stack, orig, copy, state, arg1, arg2, arg3)
            local grabupvalue, grabupvalue_idx = false, nil
            if state == nil then
                -- .., orig, copy, state
                copy = stack[orig]
                if copy ~= nil then
                    return copy, true
                elseif stack.function_immutable then
                    copy = orig
                    return copy, true
                else
                    copy        = loadstring(string.dump(orig), nil, nil, stack.function_env)
                    stack[orig] = copy

                    if debug_getupvalue ~= nil and debug_setupvalue ~= nil then
                        grabupvalue     = true
                        grabupvalue_idx = 1
                    else
                        -- No way to get/set upvalues!
                        return copy, true
                    end
                end
            elseif this_state == 'upvalue' then
                -- .., orig, copy, state, uvidx, uvvalueorig, uvvaluecopy
                local orig_upvalue_idx   = arg1
                --local orig_upvalue_value = arg2
                local copy_upvalue_value = arg3
                stack:_pop(3)

                debug_setupvalue(copy, orig_upvalue_idx, copy_upvalue_value)

                grabupvalue_idx = orig_upvalue_idx + 1
                stack:_push(grabupvalue_idx)
                grabupvalue = true
            end
            if grabupvalue then
                -- .., orig, copy, retto, state, uvidx
                local upvalue_idx_curr = grabupvalue_idx
                for upvalue_idx = upvalue_idx_curr, math.huge do
                    local upvalue_name, upvalue_value_orig = debug_getupvalue(orig, upvalue_idx)
                    if upvalue_name ~= nil then
                        local upvalue_handled = false
                        if not stack.function_upvalue_isolate and debug_upvalueid ~= nil and debug_upvaluejoin ~= nil then
                            local upvalue_uid = debug.upvalueid(orig, upvalue_idx)
                            -- Attempting to store an upvalueid of a function as a child of root is UB!
                            local other_orig  = stack[upvalue_uid]
                            if other_orig ~= nil then
                                for other_upvalue_idx = 1, math.huge do
                                    if upvalue_uid == debug_upvalueid(other_orig, other_upvalue_idx) then
                                        local other_copy = stack[other_orig]
                                        debug_upvaluejoin(
                                                copy, upvalue_idx,
                                                other_copy, other_upvalue_idx
                                        )
                                        break
                                    end
                                end
                                upvalue_handled = true
                            else
                                stack[upvalue_uid] = orig
                            end
                        end
                        if not stack.function_upvalue_dontcopy and not upvalue_handled and upvalue_value_orig ~= nil then
                            stack:_recurse(upvalue_value_orig)
                            return copy, 'upvalue'
                        end
                    else
                        stack:_pop(1) -- pop uvidx
                        return copy, true
                    end
                end
            end
        end,
        ["userdata"]      = nil,
        ["lightuserdata"] = nil,
        ["thread"]        = nil,
    }
    table.deepcopy_copyfunc_list["number"]  = table.deepcopy_copyfunc_list._plainolddata
    table.deepcopy_copyfunc_list["string"]  = table.deepcopy_copyfunc_list._plainolddata
    table.deepcopy_copyfunc_list["boolean"] = table.deepcopy_copyfunc_list._plainolddata
    -- `nil` should never be encounted... but just in case:
    table.deepcopy_copyfunc_list["nil"]     = table.deepcopy_copyfunc_list._plainolddata

    do
        local ORIG, COPY, RETTO, STATE, SIZE = 0, 1, 2, 3, 4
        function table.deepcopy_push(...)
            local arg_list_len = select('#', ...)
            local stack_offset = stack._top + 1
            for arg_i = 1, arg_list_len do
                stack[stack_offset + arg_i] = select(arg_i, ...)
            end
            stack._top = stack_top + arg_list_len
        end
        function table.deepcopy_pop(stack, count)
            stack._top = stack._top - count
        end
        function table.deepcopy_recurse(stack, orig)
            local retto              = stack._ptr
            local stack_top          = stack._top
            local stack_ptr          = stack_top + 1
            stack._top               = stack_top + SIZE
            stack._ptr               = stack_ptr
            stack[stack_ptr + ORIG]  = orig
            stack[stack_ptr + COPY]  = nil
            stack[stack_ptr + RETTO] = retto
            stack[stack_ptr + STATE] = nil
        end
        function table.deepcopy(root, params, customcopyfunc_list)
            local stack         = params or {}
            --orig,copy,retto,state,[temp...,] partorig,partcopy,partretoo,partstate
            stack[1 + ORIG]     = root
            stack[1 + COPY]     = nil
            stack[1 + RETTO]    = nil
            stack[1 + STATE]    = nil
            stack._ptr          = 1
            stack._top          = 4
            stack._push         = table.deepcopy_push
            stack._pop          = table.deepcopy_pop
            stack._recurse      = table.deepcopy_recurse
            --[[local stack_dbg do -- debug
                stack_dbg = stack
                stack = setmetatable({}, {
                    __index = stack_dbg,
                    __newindex = function(t, k, v)
                        stack_dbg[k] = v
                        if tonumber(k) then
                            local stack = stack_dbg
                            local line_stack, line_label, line_stptr = "", "", ""
                            for stack_i = 1, math.max(stack._top, stack._ptr) do
                                local s_stack = (
                                        (type(stack[stack_i]) == 'table' or type(stack[stack_i]) == 'function')
                                            and string.gsub(tostring(stack[stack_i]), "^.-(%x%x%x%x%x%x%x%x)$", "<%1>")
                                    or  tostring(stack[stack_i])
                                ), type(stack[stack_i])
                                local s_label = ""--dbg_label_dict[stack_i] or "?!?"
                                local s_stptr = (stack_i == stack._ptr and "*" or "")..(stack_i == k and "^" or "")
                                local maxlen = math.max(#s_stack, #s_label, #s_stptr)+1
                                line_stack = line_stack..s_stack..string.rep(" ", maxlen-#s_stack)
                                --line_label = line_label..s_label..string.rep(" ", maxlen-#s_label)
                                line_stptr = line_stptr..s_stptr..string.rep(" ", maxlen-#s_stptr)
                            end
                            io.stdout:write(
                                          line_stack
                                --..  "\n"..line_label
                                ..  "\n"..line_stptr
                                ..  ""
                            )
                            io.read()
                        elseif false then
                            io.stdout:write(("stack.%s = %s"):format(
                                k,
                                (
                                        (type(v) == 'table' or type(v) == 'function')
                                            and string.gsub(tostring(v), "^.-(%x%x%x%x%x%x%x%x)$", "<%1>")
                                    or  tostring(v)
                                )
                            ))
                            io.read()
                        end
                    end,
                })
            end]]
            local copyfunc_list = table.deepcopy_copyfunc_list
            repeat
                local stack_ptr = stack._ptr
                local this_orig = stack[stack_ptr + ORIG]
                local this_copy, this_state
                stack[0]        = stack[0]
                if stack.value_ignore and stack.value_ignore[this_orig] then
                    this_copy  = nil
                    this_state = true --goto valuefound
                else
                    if stack.value_translate then
                        this_copy = stack.value_translate[this_orig]
                        if this_copy ~= nil then
                            this_state = true --goto valuefound
                        end
                    end
                    if not this_state then
                        local this_orig_type  = type(this_orig)
                        local copyfunc        = (
                                customcopyfunc_list and customcopyfunc_list[this_orig_type]
                                        or copyfunc_list[this_orig_type]
                                        or error(("cannot copy type %q"):format(this_orig_type), 2)
                        )
                        this_copy, this_state = copyfunc(
                                stack,
                                this_orig,
                                stack[stack_ptr + COPY],
                                unpack(stack--[[_dbg]], stack_ptr + STATE, stack._top)
                        )
                    end
                end
                stack[stack_ptr + COPY] = this_copy
                --::valuefound::
                if this_state == true then
                    local retto = stack[stack_ptr + RETTO]
                    stack._top  = stack_ptr + 1 -- pop retto, state, temp...
                    -- Leave orig and copy on stack for parent object
                    stack_ptr   = retto -- return to parent's stack frame
                    stack._ptr  = stack_ptr
                else
                    stack[stack_ptr + STATE] = this_state
                end
            until stack_ptr == nil
            return stack[1 + COPY]
        end
    end
end
------------------------------------------------------------------------------------------------------------------------

return table