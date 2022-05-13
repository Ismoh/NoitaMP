# EZGUI
### An xml & lua GUI framework for Noita, which lets you define your GUIs similarly like you would a web app with Vue.js
## Example:
You make an XML file that contains your GUI definition, just like single file components in Vue.js.
A root Layout element is mandatory.
```xml
<Layout>
  <Button @click="a_method('with a string arg')">Click me!</Button>
  <Text forEach="element in collection">{{ element }}</Text>
</Layout>
<Style>
Layout {
  direction: vertical;
  padding: 2;
}
Layout > Button {
  margin: [button_margin]; // Can also databind to CSS properties!
}
</Style>
```
Then in your init.lua you can render this GUI:
```lua
-- Dofiling EZGUI.lua returns a table with an init function that you need to call and pass in the path to the library, which in turn will return a render function you can call to render a GUI
local render_gui = dofile_once("mods/your_mod_id/lib/EZGUI/EZGUI.lua").init("mods/your_mod_id/lib/EZGUI")
-- This is the data context table, here lives your data that you can bind to
local data = {
  collection = { "Bloo", "Blaa", "Blee" },
  button_margin = 5,
  -- Methods defined here can be used in @click, arg1 is the data_context itself, arg2 the element that was clicked, arg3 the first custom arg
  a_method = function(data, element, arg1)
    print(arg1)
  end,
}

function OnWorldPreUpdate()
  -- render_gui(x, y, path_to_xml, data_context)
  render_gui(10, 50, "mods/EZGUI_example/gui.xml", data)
end
```
Currently only works in `init.lua`, since it needs access to `ModTextFileGetContent` to read the XML file.
I've also managed to make it work in the `settings.lua` by bundling up all the necessary files into the `settings.lua`, since `dofile`ing mod files does not work there, at least not in the main menu, because at that point the mod files are not yet loaded.

# Currently existing Elements:
## Layout
**The** element to handle layouting, can either layout child elements horizontally or vertically.
Also responsible for rendering a border, if you like.
- CSS Properties: `direction`

## Button
Draws a button with text (probably also Images in the future) that you can click.
### Attributes:
- `@click`:function a function to call. It uses a primitive lua function parser and therefore only supports a syntax like this: `function_name('a string', 5)`

## Image
Render an image.
### Properties:
- `src`:string - The path to the image file

## Slider
Render a slider.
### Properties:
- `bind` - The data context variable to bind to

## Text
Render some text. Example `<Text>Hello</Text>`

All element support the `padding`, `margin` properties.

# Styling / Pseudo-CSS
The framework uses a custom implementation of CSS based solely on my own assumptions on how CSS works. It tries to mimic it without meeting any official specifications. Because it's custom made, it only implements a small subset of selectors and only a handful of properties. There are no IDs, only classes.
## Selectors that are available
- Element selector: `Layout`
- Class selector: `.classname`
- Ancestor selector: `Layout Button`
- Child selector: `Layout > Button`

And of course you can combine them like: `Layout.classname > Button Text.otherclass`

Margin and padding should work just like the CSS Box Model https://www.w3schools.com/css/css_boxmodel.asp

Except that there's no border except for the Layout element, which has an optional fixed border style and width of 3.

![alt text](www/assets/box_model.png "Title")
