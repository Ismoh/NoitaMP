local pretty = dofile_once("%PATH%lib/pretty.lua")
local props = dofile_once("%PATH%css_props.lua")
local utils = dofile_once("%PATH%utils.lua")

local function calculate_selector_specificity(selector)
  -- Start at 0, add 100 for each ID value, add 10 for each class value (or pseudo-class or attribute selector), add 1 for each element selector or pseudo-element.
  local specificity = 0
  local function add(s)
    specificity = specificity + (s.id and 100 or 0)
    specificity = specificity + (s.class and 10 or 0)
    specificity = specificity + (s.name and 1 or 0)
    if s.child_of then
      add(s.child_of)
    elseif s.descendant_of then
      add(s.descendant_of)
    end
  end
  add(selector)
  return specificity
end

local function does_selector_match(element, selector)
  local function does_simple_selector_match(element, selector)
    if selector.name and (selector.name ~= "*") and (element.name ~= selector.name) then
      return false
    end
    if selector.class then
      local has_class = false
      local classes = split_string(element.class or "")
      for i, class in ipairs(classes) do
        has_class = has_class or class == selector.class
      end
      return has_class
    end
    return true
  end
  local function find_matching_ancestor(element, selector)
    local el = element.parent
    while el do
      if does_simple_selector_match(el, selector) then
        return el
      end
      el = el.parent
    end
  end
  local function matches(element, selector)
    if not element then
      return false
    end
    if not does_simple_selector_match(element, selector) then
      return false
    end
    if selector.child_of then
      return matches(element.parent, selector.child_of)
    elseif selector.descendant_of then
      local matching_ancestor = find_matching_ancestor(element, selector.descendant_of)
      return matching_ancestor ~= nil
    end
    return true
  end
  return matches(element, selector)
end

local function apply_matching_rules_to_element(element, rulesets)
  local style = {}
  -- First collect all the matching rules, overwriting them with the ones with higher specificity
  -- and at the end pass the final values on to the style table of the element
  for i, ruleset in ipairs(rulesets) do
    for i, selector in ipairs(ruleset.selectors) do
      if does_selector_match(element, selector) then
        for i, declaration in ipairs(ruleset.declarations) do
          local specificity = calculate_selector_specificity(selector)
          if not style[declaration.property] or (style[declaration.property] and style[declaration.property].specificity < specificity) then
            style[declaration.property] = { specificity = specificity, value_string = declaration.value, selector = selector }
          end
        end
      end
    end
  end
  element.style_source = element.style_source or {}
  for k, v in pairs(style) do
    element.style[k] = v.value_string
    element.style_source[k] = v.selector
  end
end

return {
  apply_matching_rules_to_element = apply_matching_rules_to_element,
  does_selector_match = does_selector_match,
  calculate_selector_specificity = calculate_selector_specificity
}
