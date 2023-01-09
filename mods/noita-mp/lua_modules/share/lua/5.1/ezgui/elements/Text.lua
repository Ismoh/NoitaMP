dofile_once("%PATH%oop.lua")
local parsers = dofile_once("%PATH%parsing_functions.lua")
local utils = dofile_once("%PATH%utils.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

-- trim7 from http://lua-users.org/wiki/StringTrim
local function trim(s)
   return s:match("^()%s*$") and '' or s:match("^%s*(.*%S)")
end

local Text = new_class("Text", function(self, xml_element, ezgui_object)
  super(xml_element, ezgui_object)
  local text = trim(xml_element:text())
  self.value = parsers.parse_text(trim(xml_element:text()))
end, DOMElement)

function Text:GetContentDimensions(gui, ezgui_object)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not ezgui_object then error("Required parameter #2: ezgui_object:table", 2) end
  local text = utils.inflate_text(self.value, ezgui_object)
  -- split text into lines
  local lines = utils.split_lines(text)
  local content_width, content_height = 0, 0
  for i, line in ipairs(lines) do
    line = trim(line)
    local w, h = GuiGetTextDimensions(gui, line)
    content_width = math.max(content_width, w)
    content_height = content_height + h
  end
  return content_width, content_height
end

function Text:Render(gui, new_id, x, y, ezgui_object, layout)
  local info = self:PreRender(gui, new_id, x, y, ezgui_object, layout)
  local text = utils.inflate_text(self.value, ezgui_object)
  local lines = utils.split_lines(text)
  local line_height = (info.height - self.style.padding_top - self.style.padding_bottom) / #lines
  for i, line in ipairs(lines) do
    line = trim(line)
    GuiZSetForNextWidget(gui, info.z)
    if self.style.color then
      local c = self.style.color
      GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
    end
    GuiText(gui, info.x + info.offset_x + info.border_size + self.style.padding_left, info.y + info.offset_y + info.border_size + self.style.padding_top + (i-1) * line_height, line)
  end
end

return Text
