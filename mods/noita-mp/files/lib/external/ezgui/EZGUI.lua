--[[ 
  EZGUI v0.1.0
]]

local _ModTextFileGetContent = ModTextFileGetContent

return {
  init = function(self_path)
    -- Remove trailing / at the end
    self_path = self_path:gsub("/$", "") 
    local files = {
      ("%s/css_props.lua"):format(self_path),
      ("%s/css.lua"):format(self_path),
      ("%s/oop.lua"):format(self_path),
      ("%s/parsing_functions.lua"):format(self_path),
      ("%s/string_buffer.lua"):format(self_path),
      ("%s/unit_test.lua"):format(self_path),
      ("%s/unit_tests.lua"):format(self_path),
      ("%s/utils.lua"):format(self_path),
      ("%s/elements/Button.lua"):format(self_path),
      ("%s/elements/DOMElement.lua"):format(self_path),
      ("%s/elements/Image.lua"):format(self_path),
      ("%s/elements/Layout.lua"):format(self_path),
      ("%s/elements/Slider.lua"):format(self_path),
      ("%s/elements/Text.lua"):format(self_path),
    }
    for i, filepath in ipairs(files) do
      local content = ModTextFileGetContent(filepath)
      ModTextFileSetContent(filepath, content:gsub("%%PATH%%", self_path))
    end

    local pretty = dofile_once(self_path .. "/lib/pretty.lua")
    local Layout = dofile_once(self_path .. "/elements/Layout.lua")
    local Text = dofile_once(self_path .. "/elements/Text.lua")
    local Button = dofile_once(self_path .. "/elements/Button.lua")
    local Image = dofile_once(self_path .. "/elements/Image.lua")
    local Slider = dofile_once(self_path .. "/elements/Slider.lua")
    local nxml = dofile_once(self_path .. "/lib/nxml.lua")
    local utils = dofile_once(self_path .. "/utils.lua")
    local css = dofile_once(self_path .. "/css.lua")
    local parser = dofile_once(self_path .. "/parsing_functions.lua")

    local DOM_Elements = {
      Layout = Layout,
      Text = Text,
      Button = Button,
      Image = Image,
      Slider = Slider,
    }

    local dom_cache = {}

    local function make_dom_from_xml_file(xml_path, data_context)
      local xml_content = _ModTextFileGetContent(xml_path)
      local xml = nxml.parse_many(xml_content)
    
      local root_layout, style_element
      for i, element in ipairs(xml) do
        if element.name == "Layout" then
          root_layout = element
        elseif element.name == "Style" then
          style_element = element
        end
      end
      
      if not root_layout then
        error("No root 'Layout' found", 2)
      end
    
      local rulesets = {}
      if style_element then
        local text, text_pos = style_element:text()
        text = parser.convert_css_comments_to_spaces(text)
        rulesets = style_element and parse_style_rulesets(text, function(str, msg, pos, lvl)
          utils.throw_error(xml_content, msg, text_pos + pos, 2)
        end)
      end
    
      local function make_dom(element)
        if not DOM_Elements[element.name] then
          error("Unknown element type: '" .. element.name .. "'", 4)
        end
        local dom_element = DOM_Elements[element.name](element, data_context)
        -- TODO: Check if the element can even contain children / valid children types
        for child in element:each_child() do
          local child_dom = make_dom(child)
          dom_element:AddChild(child_dom)
        end
        return dom_element
      end
    
      local dom = make_dom(root_layout)
      local function apply_rules(dom_element)
        css.apply_matching_rules_to_element(dom_element, rulesets)
        for i, child in ipairs(dom_element.children) do
          apply_rules(child)
        end
      end
      apply_rules(dom)
      return dom
    end

    local function create_id_generator()
      local id = 1
      return function()
        id = id + 1
        return id
      end
    end
    local gui = GuiCreate()
    return function(x, y, xml_path, data)
      if not dom_cache[xml_path] then
        dom_cache[xml_path] = make_dom_from_xml_file(xml_path, data)
      end
      GuiStartFrame(gui)
      local new_id = create_id_generator()
      local root_layout = dom_cache[xml_path]
      root_layout.style.margin_left = x
      root_layout.style.margin_top = y
      root_layout:Render(gui, new_id, data)
    end
  end  
}
