dofile_once("%PATH%oop.lua")
local parser = dofile_once("%PATH%parsing_functions.lua")
local css_props = dofile_once("%PATH%css_props.lua")
local pretty = dofile_once("%PATH%lib/pretty.lua")
local utils = dofile_once("%PATH%utils.lua")
local string_buffer = dofile_once("%PATH%string_buffer.lua")

ALIGN_ITEMS_HORIZONTAL = {
  LEFT = "left", CENTER = "center", RIGHT = "right"
}
ALIGN_ITEMS_VERTICAL = {
  TOP = "top", CENTER = "center", BOTTOM = "bottom"
}
LAYOUT_DIRECTION = {
  VERTICAL = "vertical", HORIZONTAL = "horizontal"
}

function create_enum_validator(valid_values)
  return function(name, value)
    local is_valid = false
    for i, v in ipairs(valid_values or {}) do
      if v == value then
        is_valid = true
        break
      end
    end
    if not is_valid then
      error(("'%s' must be one of the following: [%s]"):format(name, table.concat(valid_values, ", ")), 6)
    end
  end
end

local DOMElement = new_class("DOMElement", function(self, xml_element, ezgui_object)
  self.name = xml_element.name
  self.class = xml_element.attr.class or ""
  self.ezgui_object = ezgui_object
  local style = {}
  local style_raw = {}
  self.style = setmetatable({
    _set = function(key, value)
      style[key] = value
    end,
    _set_raw = function(key, value)
      style_raw[key] = value
    end,
  }, {
    __index = function(t, key)
      if not css_props[key] then
        error(("Unknown property: '%s'"):format(tostring(key)), 2)
      end
      if style[key] then
        return utils.get_value_from_chain_or_not(ezgui_object, style[key])
      else
        -- Style was not set, check if it's to be inherited
        if css_props[key].inherit then
          return (self.parent and self.parent.style[key]) or css_props[key].default
        else
          -- Get default
          local default = self.default_style[key] -- or css_props[key].default
          local superclass = self.__superclass
          while default == nil and superclass do
            default = superclass.default_style[key]
            superclass = superclass.__superclass
          end
          -- If we still haven't found a default defined on the class hierarchy chain's default_styles,
          -- use css props default
          if not default then
            default = css_props[key].default
          end
          return default
        end
      end
    end,
    __newindex = function(t, key, value_string)
      if not css_props[key] then
        error(("Unknown property: '%s'"):format(tostring(key)), 2)
      end
      -- TODO: Lazy hack... rework later,
      -- some css properties should not be applied to certain elements that don't support them
      if not (self.name == "Input" and key:sub(1, 7) == "padding") then
        css_props[key].apply(self.style, value_string)
      end
    end
  })
  local attr = {}
  self.attr = setmetatable({}, {
    __index = function(t, key)
      if not attr[key] then
        return
      end
      return utils.get_value_from_chain_or_not(ezgui_object, attr[key])
    end,
    __newindex = function(t, key, value)
      -- Let us set it once in the constructor but not afterwards
      if not attr[key] then
        attr[key] = value
      else
        error("Please use data binding instead of modifying the attributes directly.", 2)
      end
    end
  })

  self.z = 0
  self.children = {}
  if xml_element.attr.forEach then
    self.loop = parser.parse_loop(string_buffer(xml_element.attr.forEach))
  end
  self:ReadAttribute(xml_element, "debug", false, function(val)
    if val == "true" then
      return true
    elseif val == "false" then
      return false
    end
  end)
  local function read_func(prop, attr)
    local attr = xml_element.attr[attr]
    if attr then
      if attr:match("%(") then
        local func = parse_function_call_expression(attr)
        self[prop] = function()
          return func.execute(ezgui_object, self)
        end
      else
        self[prop] = function()
          local a = {
            type = "binding",
            target_chain = parser.read_binding_target(attr),
          }
          return utils.get_value_from_chain_or_not(ezgui_object, a)
        end
      end
    end
  end
  read_func("render_if", "if")
  read_func("show_if", "show")
end)

DOMElement.default_style = {
  padding_left = 0,
  padding_top = 0,
  padding_right = 0,
  padding_bottom = 0,
  margin_left = 0,
  margin_top = 0,
  margin_right = 0,
  margin_bottom = 0,
  border = false,
  border_size = 3,
}

function DOMElement:QuerySelector(selector_string)
  local selector = parser.parse_style_selector(selector_string)
  local css = dofile_once("%PATH%css.lua")
  local function find_matching_self_or_child(element)
    local s = element
    if css.does_selector_match(s, selector) then
      pretty.table3(selector)
      return s
    else
      for i, child in ipairs(s.children) do
        local matching_element = find_matching_self_or_child(child)
        if matching_element then
          return matching_element
        end
      end
    end
  end
  return find_matching_self_or_child(self)
end

function DOMElement:GetDimensions(gui, ezgui_object)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not ezgui_object then error("Required parameter #2: ezgui_object:table", 2) end
  local content_width, content_height = self:GetContentDimensions(gui, ezgui_object)
  local border_size = self:GetBorderSize()
  local outer_width = content_width + self.style.padding_left + self.style.padding_right + border_size * 2
  local outer_height = content_height + self.style.padding_top + self.style.padding_bottom + border_size * 2
  return content_width, content_height, math.max((self.style.width or 0), outer_width), math.max((self.style.height or 0), outer_height)
end

-- Just a shortcut for self.style.border and self.style.border_size or 0
function DOMElement:GetBorderSize()
  return self.style.border and self.style.border_size or 0
end

function DOMElement:GetRenderOffset(gui, ezgui_object)
  local content_width, content_height = self:GetContentDimensions(gui, ezgui_object)
  local border_size = self:GetBorderSize()
  content_width = content_width + self.style.padding_left + self.style.padding_right + border_size * 2
  content_height = content_height + self.style.padding_top + self.style.padding_bottom + border_size * 2
  local space_to_move_x = math.max(self.style.width or 0, content_width) - content_width
  local space_to_move_y = math.max(self.style.height or 0, content_height) - content_height
  local x_translate_scale = ({ left=0, center=0.5, right=1 })[self.style.align_self_horizontal]
  local y_translate_scale = ({ top=0, center=0.5, bottom=1 })[self.style.align_self_vertical]
  return x_translate_scale * space_to_move_x, y_translate_scale * space_to_move_y
end

function DOMElement:PreRender(gui, new_id, x, y, ezgui_object, layout)
  local width, height, outer_width, outer_height = self:GetDimensions(gui, ezgui_object)
  local border_size = self:GetBorderSize()
  local offset_x, offset_y = self:GetRenderOffset(gui, ezgui_object)
  if layout then
    x, y = layout:GetPositionForWidget(gui, ezgui_object, self, outer_width, outer_height)
  end
  local z = self:GetZ()
  -- Draw an invisible nine piece which catches mouse clicks, this is to have exact control over the clickable area, which should include padding
  local click_area_width = outer_width - border_size * 2
  local click_area_height = outer_height - border_size * 2
  GuiZSetForNextWidget(gui, z - 1)
  GuiImageNinePiece(gui, new_id(), x + border_size, y + border_size, click_area_width, click_area_height, 0)
  local clicked, right_clicked, hovered, _x, _y, _width, _height, draw_x, draw_y, draw_width, draw_height = GuiGetPreviousWidgetInfo(gui)
  self.hovered = hovered
  self:RenderBorder(gui, new_id, x, y, z, width, height)
  return {
    x = x,
    y = y,
    z = z,
    width = width,
    height = height,
    outer_width = outer_width,
    outer_height = outer_height,
    border_size = border_size,
    offset_x = offset_x,
    offset_y = offset_y,
    click_area_width = click_area_width,
    click_area_height = click_area_height,
    clicked = clicked,
    right_clicked = right_clicked
  }
end

function DOMElement:RenderBorder(gui, new_id, x, y, z, inner_width, inner_height)
  if self.style.border then
    GuiZSetForNextWidget(gui, z + 1)
    -- Width and height of GuiImageNinePiece are based on the inside, border gets drawn outside of the area (not 100% sure)
    local border_size = self:GetBorderSize()
    local width_with_padding = inner_width + self.style.padding_left + self.style.padding_right
    local height_with_padding = inner_height + self.style.padding_top + self.style.padding_bottom
    width_with_padding = math.max((self.style.width or 0) - border_size * 2, width_with_padding)
    height_with_padding = math.max((self.style.height or 0) - border_size * 2, height_with_padding)
    GuiImageNinePiece(gui, new_id(), x + border_size, y + border_size, width_with_padding, height_with_padding)
  end
end

function DOMElement:AddChild(child)
  child.parent = self
  table.insert(self.children, child)
end

function DOMElement:GetZ()
  local parent = self.parent
  local z = 0
  while parent do
    z = z - 100
    parent = parent.parent
  end
  return z
end

function DOMElement:ReadAttribute(xml_element, name, value_default, converter, validator)
  local out
  local value
  local used_default = false
  if xml_element.attr[":" .. name] ~= nil then
    value = utils.get_value_from_ezgui_object(self.ezgui_object, parser.read_binding_target(xml_element.attr[":" .. name])) -- TODO: What does this do again?
    out = {
      type = "binding",
      target_chain = parser.read_binding_target(xml_element.attr[":" .. name])
    }
  elseif xml_element.attr[name] ~= nil then
    value = xml_element.attr[name]
    if type(converter) == "function" then
      value = converter(value)
    end
    out = {
      type = "value",
      value = value
    }
  else
    used_default = true
    value = value_default
    out = {
      type = "value",
      value = value_default
    }
  end
  if type(validator) == "function" then
    validator(name, value)
  end
  self.attr[name] = out
end

return DOMElement
