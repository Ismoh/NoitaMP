dofile_once("%PATH%/oop.lua")
dofile_once("%PATH%/parsing_functions.lua")
local DOMElement = dofile_once("%PATH%/elements/DOMElement.lua")

local Slider = new_class("Slider", function(self, xml_element, data_context)
  super(xml_element, data_context)
  self.binding_target = xml_element.attr.bind
  self.min = tonumber(xml_element.attr.min) or 0
  self.max = tonumber(xml_element.attr.max) or 100
  self.default = tonumber(xml_element.attr.default) or 0
  self.width = tonumber(xml_element.attr.width) or 100
end, DOMElement)

function Slider:GetDimensions(gui, data_context)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context:table", 2) end
  local slider_width, slider_height = self.width, 8
  local text = tostring(data_context[self.binding_target])
  local text_width, text_height = GuiGetTextDimensions(gui, text)
  local widget_width = slider_width + text_width + 3
  local widget_height = slider_height
  return widget_width + self.style.padding_left + self.style.padding_right, widget_height + self.style.padding_top + self.style.padding_bottom
end

function Slider:Render(gui, new_id, data_context, layout)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context", 2) end
  local total_width, total_height = self:GetDimensions(gui, data_context)
  local text = tostring(data_context[self.binding_target])
  local x, y = self.style.margin_left, self.style.margin_top
  if layout then
    x, y = layout:GetPositionForWidget(self, total_width, total_height)
  end
  local z
  if layout then
    z = layout:GetZ()
  else
    z = self:GetZ()
  end
  GuiZSetForNextWidget(gui, z)
  data_context[self.binding_target] = GuiSlider(gui, new_id(), x - 2 + self.style.padding_left, y + self.style.padding_top, "", data_context[self.binding_target], self.min, self.max, self.default, 1, " ", self.width)
  data_context[self.binding_target] = math.floor(data_context[self.binding_target])
  GuiZSetForNextWidget(gui, z)
  GuiText(gui, x + self.width + 3 + self.style.padding_left, y - 1 + self.style.padding_top, text)
end

return Slider
