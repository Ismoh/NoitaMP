dofile_once("data/scripts/lib/utilities.lua")
dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local string_buffer = dofile_once("%PATH%string_buffer.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Button = new_class("Button", function(self, xml_element, data_context)
  super(xml_element, data_context)
  self.value = parse_text(xml_element:text())
  self.onClick = parse_function_call_expression(xml_element.attr["@click"])
  self.border_size = 3
end, DOMElement)

Button.default_style = {
  padding_left = 2,
  padding_top = 1,
  padding_right = 2,
  padding_bottom = 1,
}

function Button:GetDimensions(gui, data_context)
  local text = inflate(self.value, data_context)
  local text_width, text_height = GuiGetTextDimensions(gui, text)
  local border_size = self.style.border and self.border_size or 0
  local total_width = border_size * 2 + self.style.padding_left + self.style.padding_right + text_width
  local total_height = border_size * 2  + self.style.padding_top + self.style.padding_bottom + text_height
  return total_width, total_height
end

function Button:Render(gui, new_id, data_context, layout)
  local text = inflate(self.value, data_context)
  local text_width, text_height = GuiGetTextDimensions(gui, text)
  local total_width, total_height = self:GetDimensions(gui, data_context)
  local inner_width = text_width + self.style.padding_left + self.style.padding_right
  local inner_height = text_height + self.style.padding_top + self.style.padding_bottom
  local border_size = self.style.border and self.border_size or 0
  local x, y = layout:GetPositionForWidget(self, total_width, total_height)
  x = x + self.style.margin_left
  y = y + self.style.margin_top
  local z
  if layout then
    z = layout:GetZ()
  else
    z = self:GetZ()
  end
  -- Draw an invisible nine piece which catches mouse clicks, this is to have exact control over the clickable area, which should include padding
  GuiZSetForNextWidget(gui, z - 2)
  GuiImageNinePiece(gui, new_id() + 9999, x + border_size, y + border_size, inner_width, inner_height, 0)
  local clicked, right_clicked, hovered, _x, _y, width, height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)
  if clicked then
    self.onClick.execute(data_context, self)
  end
  if self.attr.debug then
    if hovered then
      GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
    else
      GuiColorSetForNextWidget(gui, 0, 1, 0, 1)
    end
  end
  GuiZSetForNextWidget(gui, z - 2)
  GuiImage(gui, new_id() + 10000, x + border_size, y + border_size, "data/debug/whitebox.png", self.attr.debug and 0.5 or 0, inner_width / 20, inner_height / 20)

  if hovered then
    GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
  else
    GuiColorSetForNextWidget(gui, 1, 1, 1, 1)
  end
  GuiZSetForNextWidget(gui, z - 3)
  GuiText(gui, x + border_size + self.style.padding_left, y + border_size + self.style.padding_top, text)

  if self.style.border then
    GuiZSetForNextWidget(gui, z - 1)
    GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NoLayouting)
    -- Width and height are based on the inside
    GuiImageNinePiece(gui, new_id(), draw_x + border_size, draw_y + border_size, inner_width, inner_height)
  end
end

return Button
