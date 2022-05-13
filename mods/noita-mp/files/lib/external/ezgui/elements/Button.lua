dofile_once("data/scripts/lib/utilities.lua")
dofile_once("%PATH%/oop.lua")
dofile_once("%PATH%/parsing_functions.lua")
local string_buffer = dofile_once("%PATH%/string_buffer.lua")
local DOMElement = dofile_once("%PATH%/elements/DOMElement.lua")

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
  local total_width = self.border_size * 2 + self.style.padding_left + self.style.padding_right + text_width
  local total_height = self.border_size * 2  + self.style.padding_top + self.style.padding_bottom + text_height
  return total_width, total_height
end

function Button:Render(gui, new_id, data_context, layout)
  local text = inflate(self.value, data_context)
  local text_width, text_height = GuiGetTextDimensions(gui, text)
  local total_width, total_height = self:GetDimensions(gui, data_context)
  local x, y = layout:GetPositionForWidget(self, total_width, total_height)
  x = x + self.style.margin_left
  y = y + self.style.margin_top
  local z
  if layout then
    z = layout:GetZ()
  else
    z = self:GetZ()
  end
  GuiZSetForNextWidget(gui, z - 2)
  if GuiButton(gui, new_id(), x + self.border_size + self.style.padding_left, y + self.border_size + self.style.padding_top, text) then
    self.onClick.execute(data_context, self)
  end
  -- TODO: Use EZMouse draggable to make the entire button area clickable (including padding)
  -- and show custom hover effect

  -- GuiText(gui, x + border_width + padding, y + border_width + padding, text)
  -- local clicked, right_clicked, hovered, _x, _y, width, height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)
  -- if clicked then
  --   self.onClick.execute(data_context)
  -- end

  local clicked, right_clicked, hovered, _x, _y, width, height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)
  local np_w, np_h = text_width + self.style.padding_left + self.style.padding_right, text_height + self.style.padding_top + self.style.padding_bottom
  GuiZSetForNextWidget(gui, z - 1)
  GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NoLayouting)
  -- Width and height are based on the inside
  GuiImageNinePiece(gui, new_id(), draw_x - self.style.padding_left, draw_y - self.style.padding_top, text_width + self.style.padding_left + self.style.padding_right, text_height + self.style.padding_top + self.style.padding_bottom)
  -- !! ATTENTION !! There is a bug with layouting (in ScrollContainer only?), where it takes the X scale into account when expanding the layout vertically instead of the Y scale
  -- This is for making sure the ScrollLayout expands downwards with padding
  -- Draw an invisible image with a specific size to force the layout to use it's size, since the NinePiece by itself doesn't work with layouts somehow
  GuiImage(gui, new_id(), x, y, "data/debug/empty.png", 0.001, total_height, total_height)
end

return Button
