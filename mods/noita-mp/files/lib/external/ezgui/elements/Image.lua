dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Image = new_class("Image", function(self, xml_element, data_context)
  super(xml_element, data_context)
  self:ReadAttribute(xml_element, "src", "")
  self:ReadAttribute(xml_element, "scaleX", 1)
  self:ReadAttribute(xml_element, "scaleY", 1)
  if xml_element.attr["@click"] then
    self.onClick = parse_function_call_expression(xml_element.attr["@click"])
  end
end, DOMElement)

function Image:GetContentDimensions(gui, data_context)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  local image_width, image_height = GuiGetImageDimensions(gui, self.attr.src, 1)
  return image_width * self.attr.scaleX, image_height * self.attr.scaleY
end

function Image:Render(gui, new_id, data_context, layout)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context", 2) end
  local x, y = self.style.margin_left, self.style.margin_top
  local offset_x, offset_y = self:GetRenderOffset(gui, data_context)
  local width, height, outer_width, outer_height = self:GetDimensions(gui, data_context)
  local border_size = self:GetBorderSize()
  if layout then
    x, y = layout:GetPositionForWidget(gui, data_context, self, outer_width, outer_height)
  end
  local z = self:GetZ()
  self:RenderBorder(gui, new_id, x, y, z, width, height)
  GuiZSetForNextWidget(gui, z)
  if self.style.color then
    local c = self.style.color
    GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
  end
  GuiImage(gui, new_id(), x + offset_x + self.style.padding_left + border_size, y + offset_y + self.style.padding_top + border_size, self.attr.src, 1, self.attr.scaleX, self.attr.scaleY)

  -- Draw an invisible nine piece which catches mouse clicks, this is to have exact control over the clickable area, which should include padding
  local click_area_width = outer_width - border_size * 2
  local click_area_height = outer_height - border_size * 2
  GuiZSetForNextWidget(gui, z - 2)
  GuiImageNinePiece(gui, new_id(), x + border_size, y + border_size, click_area_width, click_area_height, 0)
  local clicked, right_clicked, hovered, _x, _y, width, height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)
  if clicked then
    self.onClick.execute(data_context, self)
  end
  -- Draw an invisible image while the button is hovered which prevents mouse clicks from firing wands etc
  if hovered then
    GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
    GuiZSetForNextWidget(gui, z - 3)
    GuiImage(gui, new_id(), x + border_size, y + border_size, "data/debug/whitebox.png", 0, click_area_width / 20, click_area_height / 20)
  end
end

return Image
