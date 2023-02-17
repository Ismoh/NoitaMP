dofile_once("%PATH%oop.lua")
local parser = dofile_once("%PATH%parsing_functions.lua")
local utils = dofile_once("%PATH%utils.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Input = new_class("Input", function(self, xml_element, ezgui_object)
  super(xml_element, ezgui_object)
  if not xml_element.attr.bind then
    error("'bind' attribute is required on Input field", 4)
  end
  self.binding_target = { type = "binding", target_chain = parser.read_binding_target(xml_element.attr.bind) }
  self.min_width = 30
  self:ReadAttribute(xml_element, "max_length", 30)
  self:ReadAttribute(xml_element, "allowed_characters", "")
  if xml_element.attr["@change"] then
    self.onChange = parse_function_call_expression(xml_element.attr["@change"])
  end
end, DOMElement)

Input.default_style = {
  width = 100,
}

function Input:GetContentDimensions(gui, ezgui_object)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not ezgui_object then error("Required parameter #2: ezgui_object:table", 2) end
  local border_size = self:GetBorderSize() 
  local inner_width, inner_height = math.max(self.min_width, self.style.width - border_size * 2), 11
  return inner_width, inner_height
end

function Input:Render(gui, new_id, x, y, ezgui_object, layout)
  local info = self:PreRender(gui, new_id, x, y, ezgui_object, layout)
  local value = utils.get_value_from_chain_or_not(ezgui_object, self.binding_target)
  GuiZSetForNextWidget(gui, info.z)
  local new_text = GuiTextInput(gui, new_id(), info.x + info.offset_x + info.border_size + self.style.padding_left, info.y + info.offset_y + info.border_size + self.style.padding_top, value, info.width, self.attr.max_length, self.attr.allowed_characters)
  if new_text ~= value then
    utils.set_data_on_binding_chain(ezgui_object, self.binding_target.target_chain, new_text)
    if self.onChange then
      self.onChange.execute(ezgui_object, {
        self = ezgui_object.data,
        element = self,
        value = new_text
      })
    end
  end
end

return Input
