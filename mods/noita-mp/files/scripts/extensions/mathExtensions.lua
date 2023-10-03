-- Used to extend default lua implementations of math

-- http://lua-users.org/wiki/SimpleRound

---Returns the sign of a number.
---@param v number
---@return integer
function math.sign(v)
    if type(v) ~= "number" then
        error("Unable to get sign of non-number: " .. type(v))
    end
    return (v >= 0 and 1) or -1
end

--- This way, you can round on any bracket:
--- math.round(119.68, 6.4) -- 121.6 (= 19 * 6.4)
--- It works for "number of decimals" too, with a rather visual representation:
--- math.round(119.68, 0.01) -- 119.68
--- math.round(119.68, 0.1) -- 119.7
--- math.round(119.68) -- 120
--- math.round(119.68, 100) -- 100
--- math.round(119.68, 1000) -- 0
---@param v number|nil
---@param bracket number|nil
---@return number
function math.round(v, bracket)
    if not v then
        error("Unable to round nil")
    end
    if type(v) ~= "number" then
        error("Unable to round non-number: " .. type(v))
    end
    bracket = bracket or 1
    return math.floor(v / bracket + math.sign(v) * 0.5) * bracket
end
