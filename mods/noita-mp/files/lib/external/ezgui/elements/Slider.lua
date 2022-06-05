dofile_once("%PATH%oop.lua")
local parser = dofile_once("%PATH%parsing_functions.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")
local utils = dofile_once("%PATH%utils.lua")

local Slider = new_class("Slider", function(self, xml_element, ezgui_object)
  super(xml_element, ezgui_object)
  self.binding_target = { type = "binding", target_chain = parser.read_binding_target(xml_element.attr.bind) }
  self:ReadAttribute(xml_element, "min", 0)
  self:ReadAttribute(xml_element, "max", 100)
  self:ReadAttribute(xml_element, "default", 0)
  self:ReadAttribute(xml_element, "precision", 0, tonumber)
  if xml_element.attr["@change"] then
    self.onChange = parse_function_call_expression(xml_element.attr["@change"])
  end
  self.min_width = 30
end, DOMElement)

Slider.default_style = {
  width = 100
}

local function get_slider_and_text_width(self)
  local char_max_width = 6
  local period_width = 2
  local text_width = #tostring(self.attr.max) * char_max_width
  if self.attr.precision > 0 then
    text_width = text_width + period_width + self.attr.precision * char_max_width
  end
  local slider_width = self.style.width
  return math.max(self.min_width, slider_width), text_width
end

function Slider:GetContentDimensions(gui, ezgui_object)
  local slider_width, text_width = get_slider_and_text_width(self)
  return slider_width + text_width, 8
end

function Slider:Render(gui, new_id, x, y, ezgui_object, layout)
  local info = self:PreRender(gui, new_id, x, y, ezgui_object, layout)
  local value = utils.get_value_from_chain_or_not(ezgui_object, self.binding_target)
  value = tonumber(value) or 0
  GuiZSetForNextWidget(gui, info.z)
  local slider_width, text_width = get_slider_and_text_width(self)
  local old_value = value
  local new_value = GuiSlider(gui, new_id(), info.x + info.offset_x + info.border_size + self.style.padding_left - 2, info.y + info.offset_y + info.border_size + self.style.padding_top, "", value, self.attr.min, self.attr.max, self.attr.default, 1, " ", slider_width)
  if math.abs(new_value - old_value) > 0.001 then
    utils.set_data_on_binding_chain(ezgui_object, self.binding_target.target_chain, new_value)
    if self.onChange then
      self.onChange.execute(ezgui_object, {
        self = ezgui_object.data,
        element = self,
        value = new_value
      })
    end
  end
  GuiZSetForNextWidget(gui, info.z)
  if self.style.color then
    local c = self.style.color
    GuiColorSetForNextWidget(gui, c.r, c.g, c.b, math.max(c.a, 0.001))
  end
  GuiText(gui, info.x + info.offset_x + info.border_size + slider_width + self.style.padding_left + 4, info.y + info.offset_y + info.border_size + self.style.padding_top - 1, ("%." .. self.attr.precision .. "f"):format(value))
end

return Slider
