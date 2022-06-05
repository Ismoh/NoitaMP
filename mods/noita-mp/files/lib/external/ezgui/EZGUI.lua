-- v0.2.0-29-gb81808a

local _ModTextFileGetContent = ModTextFileGetContent

local function verify_ezgui_object(ezgui_object)
  ezgui_object.data = ezgui_object.data or {}
  ezgui_object.watch = ezgui_object.watch or {}
  ezgui_object.computed = ezgui_object.computed or {}
  ezgui_object.methods = ezgui_object.methods or {}
  for i, v in pairs(ezgui_object.data) do
    if type(v) == "function" then
      return "Please move your functions into 'ezgui_object.methods'"
    end
  end
end

return {
  init = function(self_path)
    if self_path then
      -- Remove trailing / at the end and add it again to allow both versions
      self_path = self_path:gsub("/$", "") .. "/"
      local files = {
        ("%scss_props.lua"):format(self_path),
        ("%scss.lua"):format(self_path),
        ("%soop.lua"):format(self_path),
        ("%sparsing_functions.lua"):format(self_path),
        ("%sstring_buffer.lua"):format(self_path),
        ("%sutils.lua"):format(self_path),
        ("%selements/DOMElement.lua"):format(self_path),
        ("%selements/Layout.lua"):format(self_path),
        ("%selements/Text.lua"):format(self_path),
        ("%selements/Input.lua"):format(self_path),
        ("%selements/Button.lua"):format(self_path),
        ("%selements/Image.lua"):format(self_path),
        ("%selements/Slider.lua"):format(self_path),
      }
      for i, filepath in ipairs(files) do
        local content = ModTextFileGetContent(filepath)
        local s = content:gsub("%%PATH%%", self_path)
        ModTextFileSetContent(filepath, s)
      end
    end

    self_path = self_path and self_path or ""

    local pretty = dofile_once(self_path .. "lib/pretty.lua")
    local Layout = dofile_once(self_path .. "elements/Layout.lua")
    local Text = dofile_once(self_path .. "elements/Text.lua")
    local Input = dofile_once(self_path .. "elements/Input.lua")
    local Button = dofile_once(self_path .. "elements/Button.lua")
    local Image = dofile_once(self_path .. "elements/Image.lua")
    local Slider = dofile_once(self_path .. "elements/Slider.lua")
    local nxml = dofile_once(self_path .. "lib/nxml.lua")
    local utils = dofile_once(self_path .. "utils.lua")
    local css = dofile_once(self_path .. "css.lua")
    local parser = dofile_once(self_path .. "parsing_functions.lua")

    local DOM_Elements = {
      Layout = Layout,
      Text = Text,
      Button = Button,
      Image = Image,
      Slider = Slider,
      Input = Input,
    }

    local dom_cache = {}

    local function make_dom_from_nxml_table(xml, xml_content, ezgui_object)
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
        local dom_element = DOM_Elements[element.name](element, ezgui_object)
        -- TODO: Check if the element can even contain children / valid children types
        for i, child in ipairs(element.children) do
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

    local function make_dom_from_xml_file(xml_path, ezgui_object)
      local xml_content = _ModTextFileGetContent(xml_path)
      local xml = nxml.parse_many(xml_content)
      return make_dom_from_nxml_table(xml, xml_content, ezgui_object)
    end

    local function create_id_generator()
      local id = 1
      return function()
        id = id + 1
        return id
      end
    end
    local _gui = GuiCreate()
    local frame_started
    local observing = {}
    local error_msg
    return function(x, y, content, ezgui_object, gui)
      if error_msg then
        return
      end
      local frame_num = GameGetFrameNum()
      if not gui and frame_started ~= frame_num then
        frame_started = frame_num
        GuiStartFrame(_gui)
      end
      if not observing[ezgui_object] then
        error_msg = verify_ezgui_object(ezgui_object)
        if error_msg then
          error(error_msg, 2)
        end
        local env = setmetatable({
          self = setmetatable({}, {
            __index = function(t, k)
              return utils.get_value_from_ezgui_object(ezgui_object, { k })
            end
          })
        }, {
          __index = _G,
          __newindex = _G
        })
        for k, func in pairs(ezgui_object.watch) do
          setfenv(func, env)
        end
        for k, func in pairs(ezgui_object.computed) do
          setfenv(func, env)
        end
        utils.make_observable(ezgui_object.data, nil, nil, function(path)
          if ezgui_object.watch[path] then
            local v = utils.get_data_from_binding_chain(ezgui_object, split_string(path, "."))
            ezgui_object.watch[path](v)
          end
        end)
        observing[ezgui_object] = true
      end
      gui = gui or _gui
      if not dom_cache[content] then
        if type(content) == "string" then
          dom_cache[content] = make_dom_from_xml_file(content, ezgui_object)
        else
          dom_cache[content] = make_dom_from_nxml_table(content.xml, content.xml_string, ezgui_object)
        end
      end
      local new_id = create_id_generator()
      local root_layout = dom_cache[content]
      GuiIdPushString(gui, "EZGUI_" .. tostring(content))
      local width, height = root_layout:Render(gui, new_id, x, y, ezgui_object)
      GuiIdPop(gui)
      return width, height
    end
  end
}
