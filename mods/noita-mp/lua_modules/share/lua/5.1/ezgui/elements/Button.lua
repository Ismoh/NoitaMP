dofile_once("data/scripts/lib/utilities.lua")
dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local utils = dofile_once("%PATH%utils.lua")
local string_buffer = dofile_once("%PATH%string_buffer.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Button = new_class("Button", function(self, xml_element, ezgui_object)
  super(xml_element, ezgui_object)
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

function Button:GetContentDimensions(gui, ezgui_object)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not ezgui_object then error("Required parameter #2: ezgui_object:table", 2) end
  local text = utils.inflate_text(self.value, ezgui_object)
  local text_width, text_height = GuiGetTextDimensions(gui, text)
  return text_width, text_height
end

function Button:Render(gui, new_id, x, y, ezgui_object, layout)
  local info = self:PreRender(gui, new_id, x, y, ezgui_object, layout)
  local text = utils.inflate_text(self.value, ezgui_object)

  -- Draw an invisible image while the button is hovered which prevents mouse clicks from firing wands etc
  if self.hovered then
    GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
    GuiZSetForNextWidget(gui, info.z - 3)
    -- (NOITA BUG) Image click/mouse block area is always width * width
    local max = math.max(info.click_area_width, info.click_area_height)
    GuiImage(gui, new_id(), info.x + info.border_size, info.y + info.border_size, "data/debug/whitebox.png", 0, max / 20, max / 20)
  end

  if info.clicked then
    self.onClick.execute(ezgui_object, {
      self = ezgui_object.data,
      element = self
    })
  end

  if self.hovered then
    GuiColorSetForNextWidget(gui, 1, 1, 0, 1)
  else
    local c = self.style.color or { r = 1, g = 1, b = 1, a = 1 }
    GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
  end

  GuiZSetForNextWidget(gui, info.z - 4)
  GuiText(gui, info.x + info.offset_x + info.border_size + self.style.padding_left, info.y + info.offset_y + info.border_size + self.style.padding_top, text)
end

return Button
