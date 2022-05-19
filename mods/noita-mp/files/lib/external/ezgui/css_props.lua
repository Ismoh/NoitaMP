local pretty = dofile_once("%PATH%lib/pretty.lua")
local parser = dofile_once("%PATH%parsing_functions.lua")

local function make_value(val)
  return {
    type = "value",
    value = val
  }
end

local function store_raw_value(style, key, val)
  style._set_raw(key, val)
end

local function validate_tokens(tokens, ...)
  local to_match = {...}
  if #tokens ~= #to_match then
    return false
  end
  for i, token_type in ipairs(to_match) do
    if tokens[i].type ~= "binding" and tokens[i].type ~= token_type then
      return false
    end
  end
  return true
end

local props = {}

-- The apply function reads the raw string value of the property and converts it to matching values,
-- it can also set other properties in case of shortcuts like 'padding'.
-- Should get called anytime the setter of style[key] runs?...
-- gets set Gets called when setting the value in apply_matching_rules_to_element
local function define_property(name, inherit, default, apply)
  props[name] = {
    inherit = inherit,
    default = default,
    apply = function(style, value)
      value = tostring(value)
      store_raw_value(style, name, value)
      apply(style, name, value)
    end
  }
end

-- style._set is like rawset, bypassing the setter style.__newindex, except we can't use rawset because
-- we don't wanna set values ON the style table itself, but the private local style, which gets handled by style._set

define_property("padding", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set("padding_top", tokens[1])
    style._set("padding_bottom", tokens[1])
    style._set("padding_left", tokens[1])
    style._set("padding_right", tokens[1])
  elseif validate_tokens(tokens, "number", "number") then
    style._set("padding_top", tokens[1])
    style._set("padding_bottom", tokens[1])
    style._set("padding_left", tokens[2])
    style._set("padding_right", tokens[2])
  elseif validate_tokens(tokens, "number", "number", "number") then
    style._set("padding_top", tokens[1])
    style._set("padding_right", tokens[2])
    style._set("padding_bottom", tokens[3])
  elseif validate_tokens(tokens, "number", "number", "number", "number") then
    style._set("padding_top", tokens[1])
    style._set("padding_right", tokens[2])
    style._set("padding_bottom", tokens[3])
    style._set("padding_left", tokens[4])
  end
end)

define_property("padding_left", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  -- pretty.table3(tokens)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("padding_top", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("padding_right", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("padding_bottom", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("margin", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set("margin_top", tokens[1])
    style._set("margin_bottom", tokens[1])
    style._set("margin_left", tokens[1])
    style._set("margin_right", tokens[1])
  elseif validate_tokens(tokens, "number", "number") then
    style._set("margin_top", tokens[1])
    style._set("margin_bottom", tokens[1])
    style._set("margin_left", tokens[2])
    style._set("margin_right", tokens[2])
  elseif validate_tokens(tokens, "number", "number", "number") then
    style._set("margin_top", tokens[1])
    style._set("margin_right", tokens[2])
    style._set("margin_bottom", tokens[3])
  elseif validate_tokens(tokens, "number", "number", "number", "number") then
    style._set("margin_top", tokens[1])
    style._set("margin_right", tokens[2])
    style._set("margin_bottom", tokens[3])
    style._set("margin_left", tokens[4])
  end
end)

define_property("margin_left", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("margin_top", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("margin_right", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("margin_bottom", false, 0, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

-- define_property("color", true, "#FFFFFF", function(style, name, str)
--   local tokens = parser.parse_tokens(str)
--   -- TODO: Parse color
--   if validate_tokens(tokens, "color") then
--     style[name] = make_value(tokens[1].value)
--   end
-- end)

define_property("direction", false, "vertical", function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "identifier") then
    style._set(name, tokens[1])
  end
end)

define_property("align_items_horizontal", false, "left", function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "identifier") then
    style._set(name, tokens[1])
  end
end)

define_property("align_items_vertical", false, "top", function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "identifier") then
    style._set(name, tokens[1])
  end
end)

define_property("border", false, false, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "boolean") then
    style._set(name, tokens[1])
  end
end)

define_property("width", false, nil, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("height", false, nil, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "number") then
    style._set(name, tokens[1])
  end
end)

define_property("background", false, true, function(style, name, str)
  local tokens = parser.parse_tokens(str)
  if validate_tokens(tokens, "boolean") then
    style._set(name, tokens[1])
  end
end)

return props
