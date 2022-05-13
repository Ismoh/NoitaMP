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
local function get_data_from_binding_chain(data_context, binding_target_chain)
  local pos = 1
  for i, current_target in ipairs(binding_target_chain) do
    data_context = data_context[current_target]
    if not data_context then
      local str = table.concat(binding_target_chain, ".")
      throw_error(str, "Unknown identifier '" .. current_target .. "'", pos)
    end
    pos = pos + #current_target + 1
  end
  return data_context
end

return {
  throw_error = throw_error,
  get_line_by_pos = get_line_by_pos,
  get_data_from_binding_chain = get_data_from_binding_chain
}
