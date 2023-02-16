function split_string(inputstr, sep)
  sep = sep or "%s"
  local t= {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local function split_lines(str)
  local lines = {}
  -- Include linebreaks in the results
  local line = ""
  for i=1, #str do
    local char = str:sub(i, i)
    line = line .. char
    if char == "\n" or i == #str then
      table.insert(lines, line)
      line = ""
    end
  end
  return lines
end

local function get_line_by_pos(str, pos)
  local lines = split_lines(str)
  local line_num = 0
  local line_pos = 1
  if str == "" then
    return str, 0, 0
  end
  for i, line in ipairs(lines) do
    line_num = line_num + 1
    local line_start_pos = line_pos
    local line_end_pos = line_pos + (#line - 1)
    if pos >= line_start_pos and pos <= line_end_pos then
      return line:gsub("\n$", ""), line_num, pos - line_start_pos + 1
    end
    line_pos = line_end_pos + 1
  end
end

local function throw_error(str, msg, pos, error_level)
  error_level = error_level or 0
  -- Add a space at the end if pos is pointing past the end of string, so we can show it
  if pos > #str then
    str = str .. " "
  end
  local line, line_num, pos = get_line_by_pos(str, pos)
  local pos_string = ("%d:%d: "):format(line_num, pos)
  msg = msg .. ": "
  error("\n" .. pos_string .. msg .. line .. "\n" .. (" "):rep(#pos_string + #msg + pos-1) .. "^", error_level + 1)
end

local function shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

local function _ipairs(t)
  if t.__ipairs then
    return t.__ipairs
  else
    return ipairs(t)
  end
end

local function _pairs(t)
  if t.__pairs then
    return t.__pairs
  else
    return pairs(t)
  end
end

-- Thanks to dextercd#7326 on Discord for helping me debug this and coming up with the final working version
local function make_observable(t, key, prev_keys, callback)
  if type(t) ~= "table" or getmetatable(t) then
    return
  end

  local prev_keys = prev_keys or {}
  local _data = {}

  if key then
    table.insert(prev_keys, key)
  end

  for k, v in pairs(t) do
    _data[k] = v
    t[k] = nil
    make_observable(v, k, shallow_copy(prev_keys), callback)
  end

  setmetatable(t, {
    __index = function(self, key)
      if key == "__count" then
        return #_data
      elseif key == "__ipairs" then
        local i = 0
        return function()
          i = i + 1
          if _data[i] then
            return i, _data[i]
          end
        end
      elseif key == "__pairs" then
        local next_key
        return function()
          local key, val = next(_data, next_key)
          next_key = key
          return key, val
        end
      end
      return _data[key]
    end,

    __newindex = function(self, key, value)
      if type(value) == "table" then
        make_observable(value, key, shallow_copy(prev_keys), callback)
      end
      _data[key] = value

      path = table.concat(prev_keys, ".")
      if path ~= '' then
        path = path .. '.'
      end
      path = path .. key

      if callback then
        callback(path)
      end
    end
  })
end

local function get_data_from_binding_chain(ezgui_object, binding_target_chain)
  if ezgui_object.computed and #binding_target_chain == 1 and ezgui_object.computed[binding_target_chain[1]] then
    return ezgui_object.computed[binding_target_chain[1]]()
  end
  local data_context = ezgui_object.data
  for i, current_target in ipairs(binding_target_chain) do
    if tonumber(current_target) then
      current_target = tonumber(current_target)
    end
    data_context = data_context[current_target]
    if data_context == nil then
      error("Bound data variable not found: '" .. tostring(current_target) .."'", 2)
    end
  end
  return data_context
end

-- Get the value from a table like: { type = "value", value = 5 } or { type = "binding", target_chain = ["one"] }
local function get_value_from_chain_or_not(ezgui_object, value)
  if value.type == "binding" then
    return get_data_from_binding_chain(ezgui_object, value.target_chain)
  else
    return value.value
  end
end

local function set_data_on_binding_chain(ezgui_object, binding_target_chain, value)
  local previous_context = ezgui_object.data
  local data_context = ezgui_object.data
  local last_target
  for i, current_target in ipairs(binding_target_chain) do
    if tonumber(current_target) then
      current_target = tonumber(current_target)
    end
    previous_context = data_context
    data_context = data_context[current_target]
    if data_context == nil then
      error("Bound data variable not found: '" .. tostring(current_target) .."'", 2)
    end
    last_target = current_target
  end
  previous_context[last_target] = value
end

local function get_value_from_ezgui_object(ezgui_object, target)
  if type(target) ~= "table" then
    target = { target }
  end
  local computed = ezgui_object.computed[target[1]]
  if computed then
    return computed()
  end
  local current_data = ezgui_object.data
  local target_chain = ""
  for i, current_target in ipairs(target) do
    target_chain = target_chain .. current_target
    if tonumber(current_target) then
      current_target = tonumber(current_target)
    end
    current_data = current_data[current_target]
    if current_data == nil then
      error("Data variable not found: '" .. tostring(target_chain) .."'", 2)
    end
    if next(target, i) then
      target_chain = target_chain .. "."
    end
  end
  return current_data
end

-- Calls the provided function once for each loop iteration, or just once if the element has no loop
-- passing along a data context with loop variables inserted
local function loop_call(dom_element, ezgui_object, func, ...)
  if dom_element.loop then
    if not ezgui_object.data[dom_element.loop.binding_target] then
      error("Binding target not found: " .. dom_element.loop.binding_target)
    end
    for i, v in _ipairs(ezgui_object.data[dom_element.loop.binding_target]) do
      local new_context = setmetatable({}, {
        __index = ezgui_object
      })
      if dom_element.loop.iter_variable then
        new_context.data[dom_element.loop.iter_variable] = i
      end
      if dom_element.loop.bind_variable then
        new_context.data[dom_element.loop.bind_variable] = v
      end
      func(dom_element, new_context, ...)
    end
  else
    func(dom_element, ezgui_object, ...)
  end
end

-- Converts a string like "Hello {{ name }}" into "Hello Peter"
local function inflate_text(tokens, ezgui_object)
  local str = ""
  for i, v in ipairs(tokens) do
    if v.type == "text" then
      str = str .. v.value
    elseif v.type == "binding" then
      str = str .. tostring(get_value_from_ezgui_object(ezgui_object, v.target_chain))
    end
  end
  return str
end

local function concat_table(t)
  local s = ""
  for i, v in ipairs(t) do
    s = s .. ("'%s'"):format(v)
    if next(t, i) then
      s = s .. ", "
    end
  end
  return s
end

return {
  split_lines = split_lines,
  throw_error = throw_error,
  get_line_by_pos = get_line_by_pos,
  get_data_from_binding_chain = get_data_from_binding_chain,
  get_value_from_chain_or_not = get_value_from_chain_or_not,
  set_data_on_binding_chain = set_data_on_binding_chain,
  inflate_text = inflate_text,
  make_observable = make_observable,
  get_value_from_ezgui_object = get_value_from_ezgui_object,
  pairs = _pairs,
  ipairs = _ipairs,
  loop_call = loop_call,
  concat_table = concat_table,
}
