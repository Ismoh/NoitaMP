local bitser = require("bitser")

local util = {}

function util.Sleep(s)
    if type(s) ~= "number" then
        error("Unable to wait if parameter 'seconds' isn't a number: " .. type(s))
    end
    -- http://lua-users.org/wiki/SleepFunction
    local ntime = os.clock() + s
    repeat
    until os.clock() > ntime
end

function util.IsEmpty(var)
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

--- Extends @var to the @length with @char. Example 1: "test", 6, " " = "test  " | Example 2: "verylongstring", 5, " " = "veryl"
---@param var string any string you want to extend or cut
---@param length number
---@param char any
---@return string
function util.ExtendAndCutStringToLength(var, length, char)
    if type(var) ~= "string" then
        error("var is not a string.", 2)
    end
    if type(length) ~= "number" then
        error("length is not a number.", 2)
    end
    if type(char) ~= "string" or string.len(char) > 1 then
        error("char is not a character. string.len(char) > 1 = " .. string.len(char), 2)
    end

    local new_var = ""
    local len = string.len(var)
    for i = 1, length, 1 do
        local char_of_var = var:sub(i, i)
        if char_of_var ~= "" then
            new_var = new_var .. char_of_var
        else
            new_var = new_var .. char
        end
    end
    return new_var
end

function util.serialise(data)
    return bitser.dumps(data)
end

--- Deserialise data
---@param data any
---@return any
function util.deserialise(data)
    return bitser.loads(data)
end

--https://noita.fandom.com/wiki/Modding:_Utilities#Easier_entity_debugging
function util.str(var)
    if type(var) == "table" then
        local s = "{ "
        for k, v in pairs(var) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. util.str(v) .. ","
        end
        return s .. "} "
    end
    return tostring(var)
end

--https://noita.fandom.com/wiki/Modding:_Utilities#Easier_entity_debugging
function util.debug_entity(e)
    local parent = EntityGetParent(e)
    local children = EntityGetAllChildren(e)
    local comps = EntityGetAllComponents(e)

    print("--- ENTITY DATA ---")
    print("Parent: [" .. parent .. "] " .. (EntityGetName(parent) or "nil"))

    print(" Entity: [" .. util.str(e) .. "] " .. (EntityGetName(e) or "nil"))
    print("  Tags: " .. (EntityGetTags(e) or "nil"))
    if (comps ~= nil) then
        for _, comp in ipairs(comps) do
            print("  Comp: [" .. comp .. "] " .. (ComponentGetTypeName(comp) or "nil"))
        end
    end

    if children == nil then
        return
    end

    for _, child in ipairs(children) do
        local comps = EntityGetAllComponents(child)
        print("  Child: [" .. child .. "] " .. EntityGetName(child))
        for _, comp in ipairs(comps) do
            print("   Comp: [" .. comp .. "] " .. (ComponentGetTypeName(comp) or "nil"))
        end
    end
    print("--- END ENTITY DATA ---")
end

return util
