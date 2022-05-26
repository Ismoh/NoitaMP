dofile_once("%PATH%oop.lua")
local parsers = dofile_once("%PATH%parsing_functions.lua")
local utils = dofile_once("%PATH%utils.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

-- trim7 from http://lua-users.org/wiki/StringTrim
local function trim(s)
   return s:match("^()%s*$") and '' or s:match("^%s*(.*%S)")
end

local Text = new_class("Text", function(self, xml_element, data_context)
  super(xml_element, data_context)
  local text = trim(xml_element:text())
  self.value = parsers.parse_text(trim(xml_element:text()))
end, DOMElement)

function Text:GetContentDimensions(gui, data_context)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context:table", 2) end
  local text = inflate(self.value, data_context)
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

function Text:Render(gui, new_id, data_context, layout)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context", 2) end
  local text = inflate(self.value, data_context)
  local lines = utils.split_lines(text)
  local width, height, outer_width, outer_height = self:GetDimensions(gui, data_context)
  local border_size = self:GetBorderSize()
  local line_height = (height - self.style.padding_top - self.style.padding_bottom) / #lines
  local x, y = self.style.margin_left, self.style.margin_top
  local offset_x, offset_y = self:GetRenderOffset(gui, data_context)
  if layout then
    x, y = layout:GetPositionForWidget(gui, data_context, self, outer_width, outer_height)
  end
  local z = self:GetZ()
  for i, line in ipairs(lines) do
    line = trim(line)
    GuiZSetForNextWidget(gui, z)
    if self.style.color then
      local c = self.style.color
      GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
    end
    GuiText(gui, x + offset_x + border_size + self.style.padding_left, y + offset_y + border_size + self.style.padding_top + (i-1) * line_height, line)
  end
  self:RenderBorder(gui, new_id, x, y, z, width, height)
end

return Text
