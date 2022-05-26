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
end, DOMElement)

function Layout:GetPositionForWidget(gui, data_context, element, width, height)
  local border_size = element:GetBorderSize()
  local x = self.next_element_x + self.style.padding_left
  local y = self.next_element_y + self.style.padding_top
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

  if self.style.direction == LAYOUT_DIRECTION.VERTICAL then
    local something = (horizontal_scalar * self._content_width) - width * horizontal_scalar
    -- "something" is now essentially the distance to the left edge
    something = math.max(element.style.margin_left, something)
    local distance_to_right_edge = self._content_width - (something + width)
    something = something - math.max(0, element.style.margin_right - distance_to_right_edge)
    x = x + something
    y = y + element.style.margin_top + self._content_height * vertical_scalar - (self._content_height * vertical_scalar)
  elseif self.style.direction == LAYOUT_DIRECTION.HORIZONTAL then
    local something = (vertical_scalar * self._content_height) - height * vertical_scalar
    -- "something" is now essentially the distance to the top edge
    something = math.max(element.style.margin_top, something)
    local distance_to_bottom_edge = self._content_height - (something + height)
    something = something - math.max(0, element.style.margin_bottom - distance_to_bottom_edge)
    y = y + something
    x = x + element.style.margin_left + self._content_width * horizontal_scalar - (self._content_width * horizontal_scalar)
  end
  local offset_x, offset_y = element:GetRenderOffset(gui, data_context)
  return x, y, offset_x, offset_y
end

function Layout:GetContentDimensions(gui, data_context)
  if not gui then error("Required parameter #1: GuiObject", 2) end
  if not data_context then error("Required parameter #2: data_context:table", 2) end
  local content_width = 0
  local content_height = 0
  for i, child in ipairs(self.children) do
    if not child.render_if or child.render_if() then
      loop_call(child, data_context, function(child, data_context)
        local child_content_width, child_content_height, child_outer_width, child_outer_height = child:GetDimensions(gui, data_context)
        local child_total_width = child_outer_width + child.style.margin_left + child.style.margin_right
        local child_total_height = child_outer_height + child.style.margin_top + child.style.margin_bottom
        child_total_width = math.max(child_total_width, child.style.width or 0)
        child_total_height = math.max(child_total_height, child.style.height or 0)
        if self.style.direction == "horizontal" then
          content_width = content_width + child_total_width
          content_height = math.max(content_height, child_total_height)
        else
          content_width = math.max(content_width, child_total_width)
          content_height = content_height + child_total_height
        end
      end)
    end
  end

  return content_width, content_height
end

function Layout:Render(gui, new_id, data_context, layout)
  local inner_width, inner_height, outer_width, outer_height = self:GetDimensions(gui, data_context)
  local border_size = self:GetBorderSize()
  local x, y = self.style.margin_left, self.style.margin_top
  local offset_x, offset_y = self:GetRenderOffset(gui, data_context)
  if layout then
    x, y = layout:GetPositionForWidget(gui, data_context, self, outer_width, outer_height)
  end
  local z = self:GetZ()
  -- Cache it so we don't have to calculate it again every time for GetPositionForWidget
  self._content_width = inner_width
  self._content_height = inner_height
  -- Debug rendering
  -- Red = margin
  -- Blue = padding
  -- Green = content
  local function render_debug_rect(x, y, width, height, color)
    if width > 0 and height > 0 then
      GuiZSetForNextWidget(gui, z - 500000)
      local r, g, b
      if type(color) == "string" then
        r, g, b = unpack(({
          red = { 1, 0, 0 },
          green = { 0, 1, 0 },
          blue = { 0, 0, 1 },
        })[color])
      elseif type(color) == "table" then
        r, g, b = unpack(color)
      end
      GuiColorSetForNextWidget(gui, r, g, b, 1)
      GuiImage(gui, 9999, x, y, "data/debug/whitebox.png", 0.5, width / 20, height / 20)
    end
  end

  local function render_debug_margin_and_padding(x, y, style, border_size, inner_width, inner_height, outer_width, outer_height)
    -- Margins
    -- Top
    render_debug_rect(x - style.margin_left, y - style.margin_top, outer_width + style.margin_left + style.margin_right, style.margin_top, "red")
    -- Left
    render_debug_rect(x - style.margin_left, y, style.margin_left, outer_height, "red")
    -- Right
    render_debug_rect(x + outer_width, y, style.margin_right, outer_height, "red")
    -- Bottom
    render_debug_rect(x - style.margin_left, y + outer_height, outer_width + style.margin_left + style.margin_right, style.margin_bottom, "red")

    -- Padding
    -- -- Top
    local render_all = true
    if render_all or math.floor((GameGetFrameNum() / 45) % 4) == 0 then
      render_debug_rect(x + border_size, y + border_size, inner_width + style.padding_left + style.padding_right, style.padding_top, "blue")
    end
    -- -- Left
    if render_all or math.floor((GameGetFrameNum() / 45) % 4) == 1 then
      render_debug_rect(x + border_size, y + border_size + style.padding_top, style.padding_left, inner_height, "blue")
    end
    -- -- Right
    if render_all or math.floor((GameGetFrameNum() / 45) % 4) == 2 then
      render_debug_rect(x + border_size + inner_width + style.padding_left, y + border_size + style.padding_top, style.padding_right, inner_height, "blue")
    end
    -- -- Bottom
    if render_all or math.floor((GameGetFrameNum() / 45) % 4) == 3 then
      render_debug_rect(x + border_size, y + border_size + inner_height + style.padding_top, inner_width + style.padding_left + style.padding_right, style.padding_bottom, "blue")
    end
  end

  self.next_element_x = x + offset_x + border_size
  self.next_element_y = y + offset_y + border_size
  for i, child in ipairs(self.children) do
    if not child.render_if or child.render_if() then
      loop_call(child, data_context, function(child, data_context)
        local child_inner_width, child_inner_height, child_outer_width, child_outer_height = child:GetDimensions(gui, data_context)
        local child_total_width = child_outer_width + child.style.margin_left + child.style.margin_right
        local child_total_height = child_outer_height + child.style.margin_top + child.style.margin_bottom
        local child_border_size = child:GetBorderSize()
        if self.attr.debug then
          local x, y, offset_x, offset_y = self:GetPositionForWidget(gui, data_context, child, child_outer_width, child_outer_height)
          local inner_width = child_outer_width - child.style.padding_left - child.style.padding_right
          local inner_height = child_outer_height - child.style.padding_top - child.style.padding_bottom
          render_debug_margin_and_padding(x, y, child.style, child_border_size, inner_width - child_border_size * 2, inner_height - child_border_size * 2, child_outer_width, child_outer_height)
          -- Content
          if child.style.border then
            x = x + child_border_size
            y = y + child_border_size
          end
          render_debug_rect(x + offset_x + child.style.padding_left, y + offset_y + child.style.padding_top, child_inner_width, child_inner_height, { 1, 0.2 + (i / #self.children) * 0.8, 0 })
        end
        if not child.show_if or child.show_if() then
          child:Render(gui, new_id, data_context, self)
        end
        if self.style.direction == "horizontal" then
          self.next_element_x = self.next_element_x + math.max((child.style.width or 0), child_total_width)
        else
          self.next_element_y = self.next_element_y + math.max((child.style.height or 0), child_total_height)
        end
      end)
    end
  end

  self:RenderBorder(gui, new_id, x, y, z, inner_width, inner_height)

  if self.attr.debug then
    render_debug_margin_and_padding(x, y, self.style, border_size, inner_width, inner_height, outer_width, outer_height)
  end
  return outer_width, outer_height
end

return Layout
