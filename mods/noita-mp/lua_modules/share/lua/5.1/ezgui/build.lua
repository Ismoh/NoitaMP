if not (arg[1] and arg[2]) then
  error("Correct usage: luajit build.lua <in.xml> <settings_out.lua>")
end

local cache = {}
local out = [[
local __dofile_cache = {}

]]
local function stitch_file(path)
  local actual_file_path = path:gsub("^data/", "C:\\Users\\Christian\\AppData\\LocalLow\\Nolla_Games_Noita\\data\\")
  local file = assert(io.open(actual_file_path, "rb"))
  local content = file:read("*a")
  content = content:gsub("%%PATH%%", "")
  file:close()
  out = out .. ([[
------ %s ------
__dofile_cache["%s"] = function()
%s
end
]]):format(path, path, content)
end

local files_to_bundle = {
  "utils.lua",
  "string_buffer.lua",
  "parsing_functions.lua",
  "oop.lua",
  "EZGUI.lua",
  "css.lua",
  "css_props.lua",
  "lib/pretty.lua",
  "lib/nxml.lua",
  "elements/Button.lua",
  "elements/Input.lua",
  "elements/DOMElement.lua",
  "elements/Image.lua",
  "elements/Layout.lua",
  "elements/Slider.lua",
  "elements/Text.lua",
  "data/scripts/lib/utilities.lua",
}

for i, path in ipairs(files_to_bundle) do
  stitch_file(path)
end

local nxml = dofile("lib/nxml.lua")
local f = assert(io.open(arg[1], "rb"))
local gui_xml = f:read("*a")
f:close()
local gui_nxml = nxml.parse_many(gui_xml)

function serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0
  -- local nl = "\n"
  local nl = ""
  local tmp = string.rep(skipnewlines and "" or " ", depth)
  if type(name) == "number" then
    name = "[" .. name .. "]"
  elseif name and name:find("^@") then
    name = "['" .. name .. "']"
  end
  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")
    for k, v in pairs(val) do
      tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end
    if val.text then
      local text, pos = val:text()
      if text ~= "" then
        tmp = tmp .. ("text = function() return [[%s]], %d end,\n"):format(text, pos)
      end
    end
    tmp = tmp .. string.rep(skipnewlines and "" or " ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  elseif name == "text" then
    local text, pos = val()
    tmp = tmp .. ("function() return [[%s]], %d end"):format(text, pos)
  else
    tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end

  return tmp
end

local serialized_gui_xml = serializeTable(gui_nxml, nil, true)

out = out .. "\nlocal content = {\n  xml = " .. serialized_gui_xml .. ",\n  xml_string = [[" .. gui_xml .. "]]\n}\n"

local file = assert(io.open(arg[2], "wb"))
file:write(out .. [[

function dofile(path)
  if not __dofile_cache[path] then
    error("File not cached: " .. path, 2)
  end
  return __dofile_cache[path]()
end
function dofile_once(path)
  if not __dofile_cache[path] then
    error("File not cached: " .. path, 2)
  end
  return __dofile_cache[path]()
end

local render_gui = dofile_once("EZGUI.lua").init()
local data = {
  counter = 1,
  elements = {
    "Bloo", "Blaa", "Blee",
  },
  align_items_horizontal = "center",
  align_items_vertical = "top",
  direction = "vertical",
  margin_left = 0,
  margin_top = 0,
  margin_right = 0,
  margin_bottom = 0,
  padding_left = 0,
  padding_top = 0,
  padding_right = 0,
  button_margin = 0,
  padding_bottom = 0,
  ip = "123.123.123.133",
  port = 80,
  set_align_items_horizontal = function(data, element, alignment)
    data.align_items_horizontal = alignment
  end,
  set_align_items_vertical = function(data, element, alignment)
    data.align_items_vertical = alignment
  end,
  set_direction = function(data, element, direction)
    data.direction = direction
  end,
}

function ModSettingsGuiCount()
  return 1
end

function ModSettingsGui( gui, in_main_menu )
  GuiText(gui, 0, 0, "")
  local clicked, right_clicked, hovered, x, y, width, height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)
  GuiOptionsAdd(gui, GUI_OPTION.Layout_NoLayouting)
  local width, height = render_gui(draw_x, draw_y, content, data, gui)
  GuiOptionsRemove(gui, GUI_OPTION.Layout_NoLayouting)
  GuiText(gui, 0, height, "")
end
]])
file:close()
