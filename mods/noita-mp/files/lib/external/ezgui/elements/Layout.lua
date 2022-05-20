dofile_once("data/scripts/lib/utilities.lua")
dofile_once("%PATH%oop.lua")
dofile_once("%PATH%parsing_functions.lua")
local string_buffer = dofile_once("%PATH%string_buffer.lua")
local DOMElement = dofile_once("%PATH%elements/DOMElement.lua")

local Layout = new_class("Layout", function(self, xml_element, data_context)
  super(xml_element, data_context)
  -- Scrolling is unsupported due to the Noita GUI API not supporting nested ScrollContainers,
  -- which means they're unusable in the mod settings menu, since the mod settings menu in itself already renders its
  -- content in a ScrollContainer
  self.next_element_x = 0
  self.next_element_y = 0
  self.z_stack = 10
  self.border_size = 3
end, DOMElement)

function Layout:GetPositionForWidget(element, width, height)
  local border_size = self.style.border and self.border_size or 0
  local x = self.next_element_x + self.style.padding_left + border_size
  local y = self.next_element_y + self.style.padding_top + border_size
  local horizontal_scalar = ({
    [ALIGN_ITEMS_HORIZONTAL.LEFT] = 0,
    [ALIGN_ITEMS_HORIZONTAL.CENTER] = 0.5,
    [ALIGN_ITEMS_HORIZONTAL.RIGHT] = 1,
  })[self.style.align_items_horizontal or ALIGN_ITEMS_HORIZONTAL.LEFT]
  local vertical_scalar = ({
    [ALIGN_ITEMS_VERTICAL.TOP] = 0,
    [ALIGN_ITEMS_VERTICAL.CENTER] = 0.5,
    [ALIGN_ITEMS_VERTICAL.BOTTOM] = 1,
  })[self.style.align_items_vertical or ALIGN_ITEMS_VERTICAL.TOP]

  local inner_width_without_padding = self._inner_width - (self.style.padding_left + self.style.padding_right)
  local inner_height_without_padding = self._inner_height - (self.style.padding_top + self.style.padding_bottom)
  if self.style.direction == LAYOUT_DIRECTION.VERTICAL then
    local something = (horizontal_scalar * inner_width_without_padding) - width * horizontal_scalar
    -- "something" is now essentially the distance to the left edge
    something = math.max(element.style.margin_left, something)
    local distance_to_right_edge = inner_width_without_padding - (something + width)
    something = something - math.max(0, element.style.margin_right - distance_to_right_edge)
    x = x + something
    y = y + element.style.margin_top + inner_height_without_padding * vertical_scalar - (self._content_height * vertical_scalar)
  elseif self.style.direction == LAYOUT_DIRECTION.HORIZONTAL then
    local something = (vertical_scalar * inner_height_without_padding) - height * vertical_scalar
    -- "something" is now essentially the distance to the top edge
    something = math.max(element.style.margin_top, something)
    local distance_to_bottom_edge = inner_height_without_padding - (something + height)
    something = something - math.max(0, element.style.margin_bottom - distance_to_bottom_edge)
    y = y + something
    x = x + element.style.margin_left + inner_width_without_padding * horizontal_scalar - (self._content_width * horizontal_scalar)
  end

  return x, y
end

function Layout:_GetInnerAndOuterDimensions(gui, data_context)
  local inner_width = 0
  local inner_height = 0
  for i, child in ipairs(self.children) do
    loop_call(child, data_context, function(child, data_context)
      local child_width, child_height = child:GetDimensions(gui, data_context)
      local child_total_width = child_width + child.style.margin_left + child.style.margin_right
      local child_total_height = child_height + child.style.margin_top + child.style.margin_bottom
      child_total_width = math.max(child_total_width, child.style.width or 0)
      child_total_height = math.max(child_total_height, child.style.height or 0)
      if self.style.direction == "horizontal" then
        inner_width = inner_width + child_total_width
        inner_height = math.max(inner_height, child_total_height)
      else
        inner_width = math.max(inner_width, child_total_width)
        inner_height = inner_height + child_total_height
      end
    end)
  end
  local content_width = inner_width
  local content_height = inner_height
  inner_width = inner_width + self.style.padding_left + self.style.padding_right
  inner_height = inner_height + self.style.padding_top + self.style.padding_bottom
  if self.style.width then
    inner_width = math.max(inner_width, self.style.width)
  end
  if self.style.height then
    inner_height = math.max(inner_height, self.style.height)
  end
  local border_size = self.style.border and self.border_size or 0
  local outer_width = inner_width + border_size * 2
  local outer_height = inner_height + border_size * 2
  self._inner_width = inner_width
  self._inner_height = inner_height
  self._content_width = content_width
  self._content_height = content_height
  return inner_width, inner_height, outer_width, outer_height, content_width, content_height
end

function Layout:GetDimensions(gui, data_context)
  local inner_width, inner_height, outer_width, outer_height = self:_GetInnerAndOuterDimensions(gui, data_context)
  return outer_width, outer_height
end

function Layout:Render(gui, new_id, data_context, layout)
  local inner_width, inner_height, outer_width, outer_height = self:_GetInnerAndOuterDimensions(gui, data_context)
  local x, y = self.style.margin_left, self.style.margin_top
  if layout then
    x, y = layout:GetPositionForWidget(self, outer_width, outer_height)
  end
  local z
  if layout then
    z = layout:GetZ() - 1
  else
    z = self:GetZ()
  end
  -- Debug rendering
  -- Red = margin
  -- Blue = padding
  -- Green = content
  local function render_debug_rect(x, y, width, height, color)
    if width > 0 and height > 0 then
      GuiZSetForNextWidget(gui, z - 50)
      local r, g, b = unpack(({
        red = { 1, 0, 0 },
        green = { 0, 1, 0 },
        blue = { 0, 0, 1 },
      })[color])
      GuiColorSetForNextWidget(gui, r, g, b, 1)
      GuiImage(gui, 9999, x, y, "data/debug/whitebox.png", 0.5, width / 20, height / 20)
    end
  end
  self.next_element_x = x
  self.next_element_y = y
  for i, child in ipairs(self.children) do
    loop_call(child, data_context, function(child, data_context)
      local child_width, child_height = child:GetDimensions(gui, data_context)
      local child_total_width = child_width + child.style.margin_left + child.style.margin_right
      local child_total_height = child_height + child.style.margin_top + child.style.margin_bottom
      child_total_width = math.max(child_total_width, child.style.width or 0)
      child_total_height = math.max(child_total_height, child.style.height or 0)
      if self.attr.debug then
        -- Content
        local x, y = self:GetPositionForWidget(child, child_width, child_height)
        render_debug_rect(x, y, child_width, child_height, "green")
      end
      child:Render(gui, new_id, data_context, self)
      if self.style.direction == "horizontal" then
        self.next_element_x = self.next_element_x + child_total_width
      else
        self.next_element_y = self.next_element_y + child_total_height
      end
    end)
  end
  if self.style.background then
    if self.style.border then
      GuiZSetForNextWidget(gui, z + 1)
      GuiImageNinePiece(gui, new_id(), x + self.border_size, y + self.border_size, inner_width, inner_height)
    end
  end
  if self.attr.debug then
    -- Margins
    -- Top
    render_debug_rect(x - self.style.margin_left, y - self.style.margin_top, outer_width + self.style.margin_left + self.style.margin_right, self.style.margin_top, "red")
    -- Left
    render_debug_rect(x - self.style.margin_left, y, self.style.margin_left, outer_height, "red")
    -- Right
    render_debug_rect(x + outer_width, y, self.style.margin_right, outer_height, "red")
    -- Bottom
    render_debug_rect(x - self.style.margin_left, y + outer_height, outer_width + self.style.margin_left + self.style.margin_right, self.style.margin_bottom, "red")

    -- Padding
    -- -- Top
    render_debug_rect(x + self.border_size, y + self.border_size, inner_width, self.style.padding_top, "blue")
    -- -- Left
    render_debug_rect(x + self.border_size, y + self.border_size + self.style.padding_top, self.style.padding_left, inner_height - self.style.padding_top - self.style.padding_bottom, "blue")
    -- -- Right
    render_debug_rect(x + self.border_size + inner_width - self.style.padding_right, y + self.border_size + self.style.padding_top, self.style.padding_right, inner_height - self.style.padding_top - self.style.padding_bottom, "blue")
    -- -- Bottom
    render_debug_rect(x + self.border_size, y + self.border_size + inner_height - self.style.padding_bottom, inner_width, self.style.padding_bottom, "blue")
  end
  return outer_width, outer_height
end

return Layout
