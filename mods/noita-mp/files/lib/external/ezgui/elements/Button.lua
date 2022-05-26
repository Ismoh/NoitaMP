dofile_once("data/scripts/lib/utilities.lua")
dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local string_buffer = dofile_once("%PATH%string_buffer.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Button = new_class("Button", function(self, xml_element, data_context)
  super(xml_element, data_context)
  self.value = parse_text(xml_element:text())
  self.onClick = parse_function_call_expression(xml_element.attr["@click"])
end, DOMElement)

Button.default_style = {
  padding_left = 2,
  padding_top = 1,
  padding_right = 2,
  padding_bottom = 1,
  border = true,
}

function Button:GetContentDimensions(gui, data_context)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context:table", 2) end
  local text = inflate(self.value, data_context)
  local text_width, text_height = GuiGetTextDimensions(gui, text)
  return text_width, text_height
end

function Button:Render(gui, new_id, data_context, layout)
  local text = inflate(self.value, data_context)
  local content_width, content_height, outer_width, outer_height = self:GetDimensions(gui, data_context)
  local border_size = self:GetBorderSize()
  local x, y = self.style.margin_left, self.style.margin_top
  if layout then
    x, y = layout:GetPositionForWidget(gui, data_context, self, outer_width, outer_height)
  end
  local z = self:GetZ()
  -- Draw an invisible nine piece which catches mouse clicks, this is to have exact control over the clickable area, which should include padding
  local click_area_width = outer_width - border_size * 2
  local click_area_height = outer_height - border_size * 2
  GuiZSetForNextWidget(gui, z - 2)
  GuiImageNinePiece(gui, new_id(), x + border_size, y + border_size, click_area_width, click_area_height, 0)
  local clicked, right_clicked, hovered, _x, _y, width, height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)

  -- Draw an invisible image while the button is hovered which prevents mouse clicks from firing wands etc
  if hovered then
    GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
    GuiZSetForNextWidget(gui, z - 3)
    GuiImage(gui, new_id(), x + border_size, y + border_size, "data/debug/whitebox.png", self.attr.debug and 0.5 or 0, click_area_width / 20, click_area_height / 20)
  elseif self.attr.debug then
    GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
    GuiZSetForNextWidget(gui, z - 3)
    GuiImage(gui, new_id(), x + border_size, y + border_size, "data/debug/whitebox.png", 0.5, click_area_width / 20, click_area_height / 20)
  end

  if clicked then
    self.onClick.execute(data_context, self)
  end

  self:RenderBorder(gui, new_id, x, y, z, content_width, content_height)

  if hovered then
    GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
  else
    local c = self.style.color or { r = 1, g = 1, b = 1, a = 1 }
    GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
  end

  local offset_x, offset_y = self:GetRenderOffset(gui, data_context)
  GuiZSetForNextWidget(gui, z - 4)
  GuiText(gui, x + offset_x + border_size + self.style.padding_left, y + offset_y + border_size + self.style.padding_top, text)
end

return Button
