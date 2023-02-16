local utils = dofile_once("%PATH%utils.lua")
local string_buffer = dofile_once("%PATH%string_buffer.lua")

local dom_element_names = {
  "Layout", "Text", "Input", "Button", "Image", "Slider", "*"
}

local function _throw_error(str, msg, pos, level)
  utils.throw_error(str, msg, pos, level)
end

local function peek_text(buffer)
  return not buffer:look_ahead("{{")
end

local function peek_identifier_beginning(buffer)
  return buffer:peek() and (buffer:peek():match("[a-zA-Z_]") ~= nil)
end

local function peek_assignment_operator(buffer)
  return buffer:peek() and (buffer:peek():match(":") ~= nil)
end

local function peek_identifier(buffer)
  return buffer:peek() and (buffer:peek():match("[a-zA-Z0-9_]") ~= nil)
end

local function peek_whitespace(buffer)
  return buffer:peek() and (buffer:peek():match("[ \n\r\t]") ~= nil)
end

local function peek_css_line_comment(buffer)
  return buffer:look_ahead("//")
end

function peek_number(buffer)
  local ch = buffer:peek()
  if ch then
    -- This could probably be done a million times better...
    local sub_buffer = string_buffer(buffer:peek(0, 30))
    local sign = sub_buffer:peek()
    if sign:match("^[%+%-]?") ~= "" then
      sub_buffer:skip()
    end
    local s = sub_buffer:read_while(function(buffer)
      return buffer:peek() and buffer:peek():match("[0-9]")
    end)
    local period = sub_buffer:peek() and sub_buffer:peek():match("%.")
    if period then
      sub_buffer:skip()
      local s2 = sub_buffer:read_while(function(buffer)
        return buffer:peek() and buffer:peek():match("[0-9]")
      end)
      return (s ~= nil) or (s2 ~= nil)
    else
      return s ~= nil
    end
  end
  return false
end

local function peek_string_literal_start(buffer)
  return buffer:peek() and (buffer:peek():match("[\"']") ~= nil)
end

local function peek_style_binding_start(buffer)
  return buffer:peek() and (buffer:peek():match("%[") ~= nil)
end

local function peek_style_binding_end(buffer)
  return buffer:peek() and (buffer:peek():match("]") ~= nil)
end

local function peek_style_declaration_block_start(buffer)
  return buffer:peek() and (buffer:peek():match("{") ~= nil)
end

local function peek_style_declaration_block_end(buffer)
  return buffer:peek() and (buffer:peek():match("}") ~= nil)
end

local function peek_binding_target(buffer)
  return peek_identifier(buffer)
end

local function peek_dom_element_name(buffer)
  for i, dom_element_name in ipairs(dom_element_names) do
    if buffer:look_ahead(dom_element_name) then
      return true
    end
  end
  return false
end

local function skip_whitespace(buffer)
  buffer:skip_while(peek_whitespace)
end

-- func is a read_ function, returns the value if read was successful,
-- otherwise nil and on fail resets the position of the buffer to where it started to read
local function try_read(func, input)
  local buffer = type(input) == "string" and string_buffer(input) or input
  local pos = buffer:pos()
  local return_value = func(buffer, function() end)
  if return_value == nil then
    buffer:set_pos(pos)
  end
  return return_value
end

-- Whitespace has to already be stripped from the beginning
local function read_identifier(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  if peek_identifier_beginning(buffer) then
    return buffer:read_while(peek_identifier)
  else
    error_callback(buffer.str, "Expected identifier", buffer:pos(), 2)
  end
end

-- Reads strings in the form of the following and returns a table with all found matches:
-- one
-- one.two.three
local function read_binding_target(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  -- Read periods/points
  local target_chain = {}
  while true do
    local target
    if buffer:peek() and buffer:peek():match("%d") then
      target = buffer:read_while(function(buffer)
        return buffer:peek() and buffer:peek():match("%d")
      end)
    end
    if not target then
      target = read_identifier(buffer, function(str, msg, pos, lvl)
        error_callback(str, msg, pos, lvl)
      end)
    end
    if target then
      table.insert(target_chain, target)
    end
    if buffer:look_ahead(".") then
      buffer:skip(1)
    else
      break
    end
  end
  return target_chain
end

local function read_number_literal(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  local str = ""
  if buffer:look_ahead("-") or buffer:look_ahead("+") then
    str = buffer:read()
  end
  str = str .. (buffer:read_while(function(buffer)
    return buffer:peek() and (buffer:peek():match("[0-9]") ~= nil)
  end) or "")
  if buffer:look_ahead(".") then
    str = str .. buffer:read()
    str = str .. (buffer:read_while(function(buffer)
      return buffer:peek() and (buffer:peek():match("[0-9]") ~= nil)
    end) or "")
  end
  str = tonumber(str)
  if not str then
    error_callback(buffer.str, "Number expected", buffer:pos(), 2)
  end
  return str
end

local function read_string_literal(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  local str = ""
  local quote = buffer:peek()
  if not peek_string_literal_start(buffer) then
    error_callback(buffer.str, "String literal must start with a quote", buffer:pos(), 2)
    return
  end
  local quote_pos = buffer:pos()
  buffer:skip()
  str = str .. buffer:read_while(function(buffer)
    return buffer:peek() ~= quote
  end)
  if buffer:peek() ~= quote then
    error_callback(buffer.str, "No matching quote found", quote_pos, 2)
    return
  end
  buffer:skip()
  return str
end

-- Reads a binding for styles in the form of:
-- property = [binding_target.sub_prop]
local function read_style_binding(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  if not peek_style_binding_start(buffer) then
    -- This shouldn't ever get called, since the caller should check first if there's even a string literal start
    error_callback(buffer.str, "Style bindings must start with '['", buffer:pos(), 2)
    return
  end
  local opening_pos = buffer:pos()
  buffer:skip()
  local binding_end = buffer:find("]")
  if not binding_end then
    error_callback(buffer.str, "No matching end brackets found", opening_pos, 2)
    return
  end
  skip_whitespace(buffer)
  local binding_target_chain = read_binding_target(buffer)
  skip_whitespace(buffer)
  if not peek_style_binding_end(buffer) then
    error_callback(buffer.str, "Expected closing bracket ']'", buffer:pos(), 2)
    return
  end
  buffer:skip()
  return binding_target_chain
end

local function read_element_name(input)
  local buffer = type(input) == "string" and string_buffer(input) or input
  local pos = buffer:pos()
  local dom_element_name = buffer:read_while(function(buffer)
    return buffer:peek() and (buffer:peek():match("[a-zA-Z%*]") ~= nil)
  end)
  for i, name in ipairs(dom_element_names) do
    if dom_element_name == name then
      return dom_element_name
    end
  end
  utils.throw_error(buffer.str, "Expected element name", pos, 2)
end

local function read_assignment_operator(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  skip_whitespace(buffer)
  if not peek_assignment_operator(buffer) then
    error_callback(buffer.str, "Expected ':'", buffer:pos(), 2)
  end
  buffer:read()
end

local function peek_boolean_literal(buffer)
  if (buffer:look_ahead("true")  and not buffer:peek(4)) or
     (buffer:look_ahead("false") and not buffer:peek(5)) then
    return true
  end
  return false
end

local function read_boolean_literal(buffer)
  if buffer:look_ahead("true") then
    buffer:skip(4)
    return true
  elseif buffer:look_ahead("false") then
    buffer:skip(5)
    return false
  end
end

local function read_text(buffer)
  return buffer:read_while(peek_text)
end

local function read_hex_color(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  skip_whitespace(buffer)
  local str = buffer:peek(0, 9)
  if not buffer:look_ahead("#") then
    error_callback(buffer.str, "Expected '#'", buffer:pos(), 2)
    return
  end
  buffer:skip()
  local color = {}
  for i=1, 4 do
    local pos = buffer:pos()
    local s = buffer:peek(0, 2)
    local num = tonumber(s or "", 16)
    if not num and i <= 3 then
      error_callback(buffer.str, "Expected hex pair", pos, 2)
      return
    end
    if num then
      table.insert(color, num / 255)
      buffer:skip(2)
    end
  end
  return { r = color[1], g = color[2], b = color[3], a = color[4] or 1 }
end

local function parse_loop(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  skip_whitespace(buffer)
  local iter_variable = "i"
  local bind_variable = read_identifier(buffer)
  if not bind_variable then
    error_callback(buffer.str, "No bind variable defined for for loop binding: for=\""..buffer.str.."\"", 1, 2)
  end
  if not buffer:look_ahead(" in ") then
    error_callback(buffer.str, "Invalid bind variable or missing 'in' in for loop binding: for=\""..buffer.str.."\"", 1, 2)
  end
  buffer:skip(4)
  skip_whitespace(buffer)
  local binding_target = read_identifier(buffer)
  if not binding_target then
    error_callback(buffer.str, "No binding target defined for for loop binding: for=\""..buffer.str.."\"", 1, 2)
  end
  skip_whitespace(buffer)
  if not buffer:is_done() then
    error_callback(buffer.str, "For loop end expected in for loop binding: for=\""..buffer.str.."\"", 1, 2)
  end
  return {
    iter_variable = iter_variable,
    bind_variable = bind_variable,
    binding_target = binding_target,
  }
end

-- TODO: Needs refactoring of the error throwing so all paths correctly use error_callback etc
function parse_function_call_expression(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  skip_whitespace(buffer)
  local function_name = read_identifier(buffer, error_callback)
  skip_whitespace(buffer)
  if not buffer:look_ahead("(") then
    error_callback(buffer.str, "Invalid function syntax, expected '('", buffer:pos(), 2)
  end
  buffer:skip()
  local args = {}
  repeat
    skip_whitespace(buffer)
    -- Read the next token until , or )
    local next_token = buffer:read_while(function(buffer)
      return not buffer:peek():match("[,)]")
    end)
    local arg
    if next_token then
      local token_buffer = string_buffer(next_token)
      if token_buffer:peek():match("[\"']") then
        arg = {
          type = "string",
          value = read_string_literal(token_buffer)
        }
      elseif peek_boolean_literal(token_buffer) then
        arg = {
          type = "boolean",
          value = read_boolean_literal(token_buffer)
        }
      elseif tonumber(token_buffer:peek()) ~= nil then
        arg = {
          type = "number",
          value = read_number_literal(token_buffer)
        }
      elseif token_buffer then
        skip_whitespace(buffer)
        arg = {
          type = "variable",
          value = read_identifier(token_buffer)
        }
      end
      if arg then
        table.insert(args, arg)
      end
    end
    if buffer:look_ahead(",") then
      buffer:skip()
      skip_whitespace(buffer)
    end
  until arg == nil
  if not buffer:look_ahead(")") then
    error_callback(buffer.str, "Invalid function syntax, expected ')'", buffer:pos(), 2)
  end
  buffer:skip()
  return {
    type = "function",
    name = function_name,
    args = args,
    execute = function(ezgui_object, environment_variables)
      if not ezgui_object.methods[function_name] then
        error("Function not found in ezgui_object.methods: " .. function_name, 3)
      end
      environment_variables.self = setmetatable({}, {
        __index = function(t, k)
          return utils.get_value_from_ezgui_object(ezgui_object, { k })
        end,
        __newindex = function(t, k, v)
          return utils.set_data_on_binding_chain(ezgui_object, { k }, v)
        end,
      })
      local _args = {}
      -- Collect and package arguments
      for i, arg in ipairs(args) do
        if arg.type == "variable" then
          if not ezgui_object.data[arg.value] then
            error("Variable not found in data context: " .. arg.value, 3)
          end
          arg.value = ezgui_object.data[arg.value]
        end
        table.insert(_args, arg.value)
      end
      return setfenv(ezgui_object.methods[function_name], setmetatable(environment_variables, {
        __index = _G,
        __newindex = _G
      }))(unpack(_args))
    end
  }
end

-- Parses a group like "(one, two)" and consumes the characters from the buffer,
-- the new cursor position will be one character after the closing ")"
local function parse_identifier_group(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  skip_whitespace(buffer)
  if not buffer:look_ahead("(") then
    error_callback(buffer.str, "Expected identifier group opening '('", buffer:pos(), 3)
  end
  -- Skip opening parantheses
  buffer:skip()
  local function read_next_identifier()
    if not buffer:look_ahead(")") then
      return buffer:read_while(peek_identifier)
    end
  end
  local identifiers = {}
  skip_whitespace(buffer)
  local identifier = read_next_identifier()
  while identifier do
    table.insert(identifiers, identifier)
    -- TODO: test (, what) nil for first etc
    skip_whitespace(buffer)
    if buffer:look_ahead(",") then
      buffer:skip()
    else
      break
    end
    local pos = buffer:pos()
    skip_whitespace(buffer)
    identifier = read_next_identifier()
    if not identifier then
      error_callback(buffer.str, "Identifier expected", pos, 3)
    end
  end
  skip_whitespace(buffer)
  if not buffer:look_ahead(")") then
    error_callback(buffer.str, "End of group expected", buffer:pos(), 3)
  end
  -- Skip closing parantheses
  buffer:skip()
  return identifiers
end

function parse_text(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  local out = {}
  while not buffer:is_done() do
    if buffer:look_ahead("{{") then
      buffer:skip(2)
      skip_whitespace(buffer)
      local binding_target_chain = read_binding_target(buffer)
      skip_whitespace(buffer)
      if not buffer:look_ahead("}}") then
        error_callback(buffer.str, "Binding ending expected", buffer:pos(), 3)
      end
      buffer:skip(2)
      table.insert(out, { type = "binding", target_chain = binding_target_chain })
    else
      local str = read_text(buffer)
      if str then
        table.insert(out, { type = "text", value = str })
      else
        break
      end
    end
  end
  return out
end

-- Parses everything between and including {}
local function parse_style_declaration_block(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  local out = {}
  if not peek_style_declaration_block_start(buffer) then
    error_callback(buffer.str, "(parse_style_declaration_block) Expected '{'", buffer:pos(), 2)
  end
  buffer:skip()
  while not buffer:is_done() do
    skip_whitespace(buffer)
    if peek_style_declaration_block_end(buffer) then
      break
    end
    -- Notice how we pass on the entire buffer
    local property = read_identifier(buffer, error_callback)
    skip_whitespace(buffer)
    read_assignment_operator(buffer, error_callback)
    skip_whitespace(buffer)
    -- Read everything up until ; or }
    -- and store the raw string as the value of the property
    -- only later when actually setting the style property should we do the parsing?
    -- but then we can't throw an error with line number etc...?
    local pos = buffer:pos()
    local property_value_string = buffer:read_while(function(buffer)
      return buffer:peek() and buffer:peek():match("[^;}]")
    end)
    table.insert(out, { property = property, property_string_pos = pos, value = property_value_string })
    local pos = buffer:pos()
    -- 1. We are at the end of the string -- ERROR expected }
    -- 2. Next char is ; -- repeat the loop
    -- 3. Next char is } -- break
    if buffer:is_done() then
      error_callback(buffer.str, "(parse_style_declaration_block) Expected '}'", buffer:pos(), 2)
    end
    if buffer:look_ahead(";") then
      buffer:skip()
    end
    if buffer:look_ahead("}") then
      break
    end
  end
  return out
end


function parse_style_selector(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  local function read_next_simple_selector()
    local s = {}
    skip_whitespace(buffer)
    if peek_dom_element_name(buffer) then
      s.name = read_element_name(buffer)
    end
    if buffer:look_ahead(".") then
      -- Read classname
      buffer:skip()
      s.class = read_identifier(buffer, function(str, msg, pos, lvl)
        error_callback(str, msg, pos, lvl)
      end)
    end
    skip_whitespace(buffer)
    if buffer:look_ahead(">") then
      s.is_parent = true
      buffer:skip()
    end
    if not s.is_parent then
      skip_whitespace(buffer)
      if not buffer:is_done() then
        s.is_ancestor = true
      end
    end
    if not (s.name or s.class) then
      return nil
    end
    return s
  end
  local prev_selector
  while not buffer:is_done() do
    skip_whitespace(buffer)
    local pos_element_name = buffer:pos()
    local selector = read_next_simple_selector()
    if not selector then
      error_callback(buffer.str, "(parse_style_selector) Invalid selector", pos_element_name, 2)
    end
    if prev_selector then
      if prev_selector.is_parent then
        selector.child_of = prev_selector
        prev_selector.is_parent = nil
      end
      if prev_selector.is_ancestor then
        selector.descendant_of = prev_selector
        prev_selector.is_ancestor = nil
      end
    end
    prev_selector = selector
    if not (selector.is_parent or selector.is_ancestor) then
      break
    end
  end
  if not prev_selector then
    error_callback(buffer.str, "(parse_style_selector) Selector expected", buffer:pos(), 2)
  end
  return prev_selector
end

-- Read in a CSS-like comma separated list of selectors
-- Format: DOMElementType.classname, where DOMElementType and classname can be optional
-- or: .classname
-- example:
-- Button.large_padding, Text.otherclass
function parse_style_selector_list(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  local selectors = {}
  while not buffer:is_done() do
    local pos_selector_start = buffer:pos()
    local selector_string = buffer:read_while(function(buffer)
      return (not buffer:is_done()) and buffer:peek():match("[^,{]")
    end)
    if not selector_string then
      utils.throw_error(buffer.str, "Expected selector", pos_selector_start, 2)
    end
    local selector = parse_style_selector(selector_string, function(str, msg, pos, lvl)
      error_callback(buffer.str, msg, pos_selector_start + pos - 1, lvl)
    end)
    selector.string = selector_string:gsub("\r", ""):gsub("\n", "")
    table.insert(selectors, selector)
    local pos_selector_end = buffer:pos()
    if buffer:look_ahead(",") then
      buffer:skip()
    else
      skip_whitespace(buffer)
      if not buffer:is_done() then
        utils.throw_error(buffer.str, "Unexpected symbol", pos_selector_end, 2)
      end
      break
    end
  end
  return selectors
end

-- This is basically the top function to parse a whole <Style> block
function parse_style_rulesets(input, error_callback)
  local buffer = type(input) == "string" and string_buffer(input) or input
  error_callback = error_callback or _throw_error
  local rulesets = {}
  while not buffer:is_done() do
    local pre_pos = buffer:pos()
    local selector_list_string = buffer:read_while(function(buffer)
      return not peek_style_declaration_block_start(buffer)
    end)
    local selectors = parse_style_selector_list(selector_list_string, function(str, msg, pos, lvl)
      error_callback(buffer.str, msg, pre_pos + pos - 1, lvl)
    end)
    pre_pos = buffer:pos()
    local style_declaration_block_string = buffer:read_while(function(buffer)
      return not peek_style_declaration_block_end(buffer)
    end)
    if not peek_style_declaration_block_end(buffer) then
      error_callback(buffer.str, "(parse_style_rulesets) Expected '}'", buffer:pos() - 1, 2)
    end
    style_declaration_block_string = style_declaration_block_string .. buffer:read()
    local declarations = parse_style_declaration_block(style_declaration_block_string, function(str, msg, pos, lvl)
      error_callback(buffer.str, msg, pre_pos + pos - 1, lvl)
    end)
    table.insert(rulesets, {
      selectors = selectors,
      declarations = declarations
    })
    skip_whitespace(buffer)
  end
  return rulesets
end

local function convert_css_comments_to_spaces(str)
  local buffer = string_buffer(str)
  local out = ""
  while not buffer:is_done() do
    out = out .. buffer:read_while(function(buffer) return not peek_css_line_comment(buffer) end)
    -- Convert all comments into spaces because otherwise text position gets lost
    buffer:skip_while(function(buffer)
      local continue = buffer:peek() ~= "\n"
      if continue then
        out = out .. " "
      end
      return continue
    end)
    out = out .. "\n"
    buffer:skip()
  end
  return out
end

-- Returns a table of tokens that it manages to read from a buffer
local function parse_tokens(input)
  local buffer = type(input) == "string" and string_buffer(input) or input
  local tokens = {}
  local funcs = {
    { type = "color", func = read_hex_color },
    { type = "boolean", func = read_boolean_literal },
    { type = "number", func = read_number_literal },
    { type = "binding", func = read_style_binding },
    { type = "identifier", func = read_identifier },
  }
  while not buffer:is_done() do
    skip_whitespace(buffer)
    local value
    -- Read until the next whitespace
    local str = buffer:read_while(function(buffer)
      return buffer:peek() and buffer:peek():match("[^%s]")
    end)
    for i, parser in ipairs(funcs) do
      local read_value = try_read(parser.func, str)
      if read_value ~= nil then
        value = { type = parser.type }
        if parser.type == "binding" then
          value.target_chain = read_value
        else
          value.value = read_value
        end
        break
      end
    end
    if value == nil then
      break
    end
    table.insert(tokens, value)
  end
  return tokens
end

_G.parse_style_declaration_block = parse_style_declaration_block

return {
  parse_text = parse_text,
  read_number_literal = read_number_literal,
  read_string_literal = read_string_literal,
  read_identifier = read_identifier,
  parse_loop = parse_loop,
  skip_whitespace = skip_whitespace,
  parse_tokens = parse_tokens,
  try_read = try_read,
  parse_identifier_group = parse_identifier_group,
  parse_style_declaration_block = parse_style_declaration_block,
  parse_style_rulesets = parse_style_rulesets,
  parse_style_selector = parse_style_selector,
  read_binding_target = read_binding_target,
  convert_css_comments_to_spaces = convert_css_comments_to_spaces,
  peek_style_binding_start = peek_style_binding_start,
  read_hex_color = read_hex_color,
}
