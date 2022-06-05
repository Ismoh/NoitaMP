dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Image = new_class("Image", function(self, xml_element, ezgui_object)
  super(xml_element, ezgui_object)
  self:ReadAttribute(xml_element, "src", "")
  self:ReadAttribute(xml_element, "scaleX", 1)
  self:ReadAttribute(xml_element, "scaleY", 1)
  if xml_element.attr["@click"] then
    self.onClick = parse_function_call_expression(xml_element.attr["@click"])
  end
end, DOMElement)

function Image:GetContentDimensions(gui, ezgui_object)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  local image_width, image_height = GuiGetImageDimensions(gui, self.attr.src, 1)
  return image_width * self.attr.scaleX, image_height * self.attr.scaleY
end

function Image:Render(gui, new_id, x, y, ezgui_object, layout)
  local info = self:PreRender(gui, new_id, x, y, ezgui_object, layout)
  GuiZSetForNextWidget(gui, info.z)
  if self.style.color then
    local c = self.style.color
    GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
  end
  GuiImage(gui, new_id(), info.x + info.offset_x + self.style.padding_left + info.border_size, info.y + info.offset_y + self.style.padding_top + info.border_size, self.attr.src, 1, self.attr.scaleX, self.attr.scaleY)

  if info.clicked and self.onClick then
    self.onClick.execute(ezgui_object, {
      self = ezgui_object.data,
      element = self
    })
  end
  -- Draw an invisible image while the button is hovered which prevents mouse clicks from firing wands etc
  if self.hovered then
    GuiColorSetForNextWidget(gui, 1, 0, 0, 1)
    GuiZSetForNextWidget(gui, info.z - 3)
    -- (NOITA BUG) Image click/mouse block area is always width * width
    local max = math.max(info.click_area_width, info.click_area_height)
    GuiImage(gui, new_id(), info.x + info.border_size, info.y + info.border_size, "data/debug/whitebox.png", 0.0, max / 20, max / 20)
  end
end

return Image
