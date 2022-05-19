dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Image = new_class("Image", function(self, xml_element, data_context)
  super(xml_element, data_context)
  self.src = xml_element.attr.src
  self.scaleX = tonumber(xml_element.attr.scaleX) or 1
  self.scaleY = tonumber(xml_element.attr.scaleY) or 1
end, DOMElement)

function Image:GetDimensions(gui)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  local width, height = GuiGetImageDimensions(gui, self.src, 1)
  return width * self.scaleX + self.style.padding_left + self.style.padding_right, height * self.scaleY + self.style.padding_top + self.style.padding_bottom
end

function Image:Render(gui, new_id, data_context, layout)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context", 2) end
  local x, y = self.style.margin_left, self.style.margin_top
  if layout then
    local width, height = self:GetDimensions(gui)
    x, y = layout:GetPositionForWidget(self, width, height)
  end
  local z
  if layout then
    z = layout:GetZ()
  else
    z = self:GetZ()
  end
  GuiZSetForNextWidget(gui, z)
  GuiImage(gui, new_id(), x + self.style.padding_left, y + self.style.padding_top, self.src, 1, self.scaleX, self.scaleY)
end

return Image
