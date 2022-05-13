-- function ModTextFileGetContent()
--   return [[
--  <Layout width="100" align_items_horizontal="right">
--   <Text margin_right="10">Boo</Text>
--   <Text margin_right="10">Boo</Text>
-- </Layout>
-- <Style>
-- Text.text_class,
-- Button.button_class,
-- .another_class,
-- Layout {
--   padding_top: .9;
-- padding_left: "5";
-- padding_right: 5;
-- padding_bottom: [one.two.three];
-- }

-- Text.text_class,
-- Button.button_class,
-- .another_class,
-- Layout {
--   padding_top: .9;
-- padding_left: "5";
-- padding_right: 5;
-- padding_bottom: [one.two.three];
-- }
-- </Style>
-- ]]
-- end


local pretty = dofile_once("%PATH%/lib/pretty.lua")
local expect = dofile_once("%PATH%/unit_test.lua")
local parser = dofile_once("%PATH%/parsing_functions.lua")
local parsed_loop = parser.parse_loop("shid in yooo")
expect(parsed_loop.bind_variable).to_be("shid")
expect(parsed_loop.binding_target).to_be("yooo")

local f = parse_function_call_expression("func(1, 'two', three)")
expect(f.type).to_be("function")
expect(f.name).to_be("func")
expect(type(f.execute)).to_be("function")
expect(#f.args).to_be(3)
expect(f.args[1].type).to_be("number")
expect(f.args[1].value).to_be(1)
expect(f.args[2].type).to_be("string")
expect(f.args[2].value).to_be("two")
expect(f.args[3].type).to_be("variable")
expect(f.args[3].value).to_be("three")

-- local f = parser.parse_identifier_group("  s (hello, 2  )")
local f = parse_text("  (hello, 2  ) {{ shid }}")

-- TODO: Make tests for failures, so it throws the correct errors with correct line numbers etc

-- local str = [[  _!.Hello {hoochie}} mama  "]]
-- local result = parse_text(str)
-- expect(#result).to_be(1)
-- expect(result[1].type).to_be("text")
-- expect(result[1].value).to_be(str)

-- local result = parse_text("  Hello {{   hoochie}} mama  ")
-- expect(#result).to_be(3)
-- expect(result[1].type).to_be("text")
-- expect(result[1].value).to_be("  Hello ")
-- expect(result[2].type).to_be("binding")
-- expect(result[2].target_chain[1]).to_be("hoochie")
-- expect(result[3].type).to_be("text")
-- expect(result[3].value).to_be(" mama  ")
-- expect(inflate(parse_text("  Hello {{   hoochie.boochie}} mama  "), { hoochie = { boochie = " yes :) " }})).to_be("  Hello  yes :)  mama  ")

--[[ 

assert(does_selector_match({ name = "Text", classes = { "one", "two" }}, { class_name = "two", element_name = "Text" }) == true)
assert(does_selector_match({ name = "Text", classes = { "one", "two" }}, { class_name = "two" }) == true)
assert(does_selector_match({ name = "Text", classes = { "one", "two" }}, { element_name = "Text" }) == true)
assert(does_selector_match({ name = "Text", classes = { "one", "two" }}, { element_name = "Button" }) == false)
assert(does_selector_match({ name = "Text", classes = { "one", "two" }}, { class_name = "three" }) == false)
assert(does_selector_match({ name = "Text" }, { class_name = "one" }) == false)
assert(does_selector_match({ name = "Text" }, { class_name = "one", element_name = "Text" }) == false)
assert(does_selector_match({ name = "Text" }, { element_name = "Button" }) == false)


--]]


local parser = dofile_once("%PATH%/parsing_functions.lua")
local pretty = dofile_once("%PATH%/lib/pretty.lua")
local css = dofile_once("%PATH%/css.lua")
local nxml = dofile_once("%PATH%/lib/nxml.lua")
local select = parser.parse_style_selector

local s = select(" Layout > .cla > Button ")
expect(s.name).to_be("Button")
expect(s.class).to_be(nil)
expect(s.child_of.name).to_be(nil)
expect(s.descendant_of).to_be(nil)
expect(s.child_of.class).to_be("cla")
expect(s.child_of.descendant_of).to_be(nil)
expect(s.child_of.child_of.name).to_be("Layout")
expect(s.child_of.child_of.class).to_be(nil)

local s = select(" Layout .cla Button ")
expect(s.name).to_be("Button")
expect(s.class).to_be(nil)
expect(s.descendant_of.name).to_be(nil)
expect(s.child_of).to_be(nil)
expect(s.descendant_of.class).to_be("cla")
expect(s.descendant_of.child_of).to_be(nil)
expect(s.descendant_of.descendant_of.name).to_be("Layout")
expect(s.descendant_of.descendant_of.class).to_be(nil)

-- returns the innermost child
local function make_element(xml)
  local xml = nxml.parse(xml)
  local innermost_child = xml
  local function convert(el)
    for child in el:each_child() do
      child.parent = el
      innermost_child = child
      convert(child)
    end
    el.class = el.attr.class
    el.children = nil
    el.attr = nil
  end
  convert(xml)
  return innermost_child
end

-- Test our make_element2 function
assert(is_table_equal(make_element([[
<HTML class="html_class">
  <DIV class="div_class">
    <P class="p_class" />
  </DIV>
</HTML>]]), {
  class = "p_class",
  parent = {
      class = "div_class",
      parent = {
          class = "html_class",
          name = "HTML",
      },
      name = "DIV",
  },
  name = "P",
}))

-- These function tests is the selector matches for the innermost element
expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]),select("  Layout Text  "))).to_be(true)

expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]),select("  .class Text  "))).to_be(false)

expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]), select(" Layout .class Text  "))).to_be(false)

expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]), select(" Layout Button Text  "))).to_be(false)

expect(css.does_selector_match(make_element([[
<Button>
  <Text class="class" />
</Button>
]]), select(" Layout Button Text  "))).to_be(true)

expect(css.does_selector_match(make_element([[
<Layout>
  <Button>
    <Text class="class" />
  </Button>
</Layout>
]]), select(" Layout Button Text  "))).to_be(true)

expect(css.does_selector_match(make_element([[
<Layout>
  <Button>
    <Text class="class" />
  </Button>
</Layout>
]]), select(" Layout Text Text  "))).to_be(false)

expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]), select(" Button Layout Text  "))).to_be(true)

expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]), select("  Layout > Text  "))).to_be(true)

expect(css.does_selector_match(make_element([[
<Layout>
  <Text class="class" />
</Layout>
]]), select("  Layout > Text  "))).to_be(true)

expect(css.calculate_selector_specificity(select("  Layout "))).to_be(1)
expect(css.calculate_selector_specificity(select("  Layout > Text  "))).to_be(2)
expect(css.calculate_selector_specificity(select("  Layout Text  "))).to_be(2)
expect(css.calculate_selector_specificity(select("  Layout.class Text  "))).to_be(12)
expect(css.calculate_selector_specificity(select("  Layout Text.class  "))).to_be(12)
expect(css.calculate_selector_specificity(select("  Layout.class Text.class  "))).to_be(22)
expect(css.calculate_selector_specificity(select("  Button Layout.class Text.class  "))).to_be(23)
expect(css.calculate_selector_specificity(select("  Button.class Layout.class Text.class  "))).to_be(33)
expect(css.calculate_selector_specificity(select("  Button.class Layout Text.class  "))).to_be(23)
expect(css.calculate_selector_specificity(select("  Button.class .class Text.class  "))).to_be(32)

local string_buffer = dofile_once("%PATH%/string_buffer.lua")

local function is_number(str)
  local buffer = string_buffer(str)
  return peek_number(buffer)
end

assert(is_number("1") == true)
assert(is_number("+1") == true)
assert(is_number("122") == true)
assert(is_number("+122") == true)
assert(is_number("0") == true)
assert(is_number("+0") == true)
assert(is_number("a") == false)
assert(is_number("+a") == false)
assert(is_number("+3") == true)
assert(is_number("-3") == true)
assert(is_number("0.10") == true)
assert(is_number("+0.10") == true)
assert(is_number("0054.100") == true)
assert(is_number("+0054.100") == true)
assert(is_number("54.22100") == true)
assert(is_number("+54.22100") == true)
assert(is_number("54.") == true)
assert(is_number("+54.") == true)
assert(is_number(".") == false)
assert(is_number("+.") == false)
assert(is_number(".45434") == true)
assert(is_number("+.45434") == true)
assert(is_number(".-234") == false)
assert(is_number("+.-234") == false)

expect(parser.read_number_literal("1")).to_be(1)
expect(parser.read_number_literal("+1")).to_be(1)
expect(parser.read_number_literal("122")).to_be(122)
expect(parser.read_number_literal("+122")).to_be(122)
expect(parser.read_number_literal("0")).to_be(0)
expect(parser.read_number_literal("+0")).to_be(0)
expect(parser.read_number_literal("+3")).to_be(3)
expect(parser.read_number_literal("-3")).to_be(-3)
expect(parser.read_number_literal("0.10")).to_be(0.1)
expect(parser.read_number_literal("+0.10")).to_be(0.1)
expect(parser.read_number_literal("0054.100")).to_be(54.1)
expect(parser.read_number_literal("+0054.100")).to_be(54.1)
expect(parser.read_number_literal("54.22100")).to_be(54.221)
expect(parser.read_number_literal("+54.22100")).to_be(54.221)
expect(parser.read_number_literal("-54.22100")).to_be(-54.221)
expect(parser.read_number_literal("54.")).to_be(54)
expect(parser.read_number_literal("+54.")).to_be(54)
expect(parser.read_number_literal(".45434")).to_be(0.45434)
expect(parser.read_number_literal("+.45434")).to_be(0.45434)

local tokens = parser.parse_tokens("5 Yooo 5.123 3 -123.2 +.23 -.25 Hello - 10 boop -43.12")
assert(is_table_equal(tokens, {
  { type = "number", value = 5, },
  { type = "identifier", value = "Yooo", },
  { type = "number", value = 5.123, },
  { type = "number", value = 3, },
  { type = "number", value = -123.2, },
  { type = "number", value = 0.23, },
  { type = "number", value = -0.25, },
  { type = "identifier", value = "Hello", },
}))
