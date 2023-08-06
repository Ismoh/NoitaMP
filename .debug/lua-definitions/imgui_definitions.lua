---@meta _
error("This is just an definitions file, it's not actually runnable Lua code.")

---@class ImPlot
local ImPlot = {}

---@class ImPlot.PlotPoint
---@field x number
---@field y number
ImPlot.PlotPoint = {}

---@param x number
---@param y number
---@return ImPlot.PlotPoint
function ImPlot.PlotPoint.new(x, y) end


---@class ImPlot.PlotRange
---@field Min number
---@field Max number
ImPlot.PlotRange = {}

---@param min number
---@param max number
---@return ImPlot.PlotRange
function ImPlot.PlotRange.new(min, max) end


---@class ImPlot.PlotRect
---@field X ImPlot.PlotRange
---@field Y ImPlot.PlotRange
ImPlot.PlotRect = {}

---@param x_min number
---@param x_max number
---@param y_min number
---@param y_max number
---@return ImPlot.PlotRect
function ImPlot.PlotRect.new(x_min, x_max, y_min, y_max) end


---@class ImGui
---@field implot ImPlot
local ImGui = {}

---@class ImGui.GuiIO
---@class ImGui.Font


---@class ImGui.ListClipper
---@field DisplayStart integer
---@field DisplayEnd integer
ImGui.ListClipper = {}

---@return ImGui.ListClipper
function ImGui.ListClipper.new() end

---@param items_count integer
---@param items_height number?
function ImGui.ListClipper:Begin(items_count, items_height) end

function ImGui.ListClipper:End() end

---@return boolean
function ImGui.ListClipper:Step() end

---@param item_min integer
---@param item_max integer
function ImGui.ListClipper.ForceDisplayRangeByIndices(item_min, item_max) end


---@class ImGui.Style
---@field Alpha number
---@field DisabledAlpha number
---@field WindowPadding_x number
---@field WindowPadding_y number
---@field WindowRounding number
---@field WindowBorderSize number
---@field WindowMinSize_x number
---@field WindowMinSize_y number
---@field WindowTitleAlign_x number
---@field WindowTitleAlign_y number
---@field WindowMenuButtonPosition Dir
---@field ChildRounding number
---@field ChildBorderSize number
---@field PopupRounding number
---@field PopupBorderSize number
---@field FramePadding_x number
---@field FramePadding_y number
---@field FrameRounding number
---@field FrameBorderSize number
---@field ItemSpacing_x number
---@field ItemSpacing_y number
---@field ItemInnerSpacing_x number
---@field ItemInnerSpacing_y number
---@field CellPadding_x number
---@field CellPadding_y number
---@field TouchExtraPadding_x number
---@field TouchExtraPadding_y number
---@field IndentSpacing number
---@field ColumnsMinSpacing number
---@field ScrollbarSize number
---@field ScrollbarRounding number
---@field GrabMinSize number
---@field GrabRounding number
---@field LogSliderDeadzone number
---@field TabRounding number
---@field TabBorderSize number
---@field TabMinWidthForCloseButton number
---@field ColorButtonPosition Dir
---@field ButtonTextAlign_x number
---@field ButtonTextAlign_y number
---@field SelectableTextAlign_x number
---@field SelectableTextAlign_y number
---@field DisplayWindowPadding_x number
---@field DisplayWindowPadding_y number
---@field DisplaySafeAreaPadding_x number
---@field DisplaySafeAreaPadding_y number
---@field MouseCursorScale number
---@field AntiAliasedLines number
---@field AntiAliasedLinesUseTex number
---@field AntiAliasedFill boolean
---@field CurveTessellationTol number
---@field CircleTessellationMaxError number
---@field Color fun(index: integer): (number, number, number, number)?


---@class ModSpec
---@field mod string Name of the mod that wants to use imgui.
---@field version string Version of imgui that the mod requires. e.g. "1.0.0"

---Grants access to the imgui bindings
---@param modspec ModSpec
---@return ImGui
---@nodiscard
function load_imgui(modspec) end



---@enum Col
ImGui.Col = {
    Text = 0,
    TextDisabled = 1,
    WindowBg = 2,
    ChildBg = 3,
    PopupBg = 4,
    Border = 5,
    BorderShadow = 6,
    FrameBg = 7,
    FrameBgHovered = 8,
    FrameBgActive = 9,
    TitleBg = 10,
    TitleBgActive = 11,
    TitleBgCollapsed = 12,
    MenuBarBg = 13,
    ScrollbarBg = 14,
    ScrollbarGrab = 15,
    ScrollbarGrabHovered = 16,
    ScrollbarGrabActive = 17,
    CheckMark = 18,
    SliderGrab = 19,
    SliderGrabActive = 20,
    Button = 21,
    ButtonHovered = 22,
    ButtonActive = 23,
    Header = 24,
    HeaderHovered = 25,
    HeaderActive = 26,
    Separator = 27,
    SeparatorHovered = 28,
    SeparatorActive = 29,
    ResizeGrip = 30,
    ResizeGripHovered = 31,
    ResizeGripActive = 32,
    Tab = 33,
    TabHovered = 34,
    TabActive = 35,
    TabUnfocused = 36,
    TabUnfocusedActive = 37,
    PlotLines = 40,
    PlotLinesHovered = 41,
    PlotHistogram = 42,
    PlotHistogramHovered = 43,
    TableHeaderBg = 44,
    TableBorderStrong = 45,
    TableBorderLight = 46,
    TableRowBg = 47,
    TableRowBgAlt = 48,
    TextSelectedBg = 49,
    DragDropTarget = 50,
    NavHighlight = 51,
    NavWindowingHighlight = 52,
    NavWindowingDimBg = 53,
    ModalWindowDimBg = 54,
    COUNT = 55,
}


---@enum StyleVar
ImGui.StyleVar = {
    Alpha = 0,
    DisabledAlpha = 1,
    WindowPadding = 2,
    WindowRounding = 3,
    WindowBorderSize = 4,
    WindowMinSize = 5,
    WindowTitleAlign = 6,
    ChildRounding = 7,
    ChildBorderSize = 8,
    PopupRounding = 9,
    PopupBorderSize = 10,
    FramePadding = 11,
    FrameRounding = 12,
    FrameBorderSize = 13,
    ItemSpacing = 14,
    ItemInnerSpacing = 15,
    IndentSpacing = 16,
    CellPadding = 17,
    ScrollbarSize = 18,
    ScrollbarRounding = 19,
    GrabMinSize = 20,
    GrabRounding = 21,
    TabRounding = 22,
    ButtonTextAlign = 23,
    SelectableTextAlign = 24,
    COUNT = 25,
}


---@param idx Col
---@param r number
---@param g number
---@param b number
function ImGui.PushStyleColor(idx, r, g, b) end

---@param idx Col
---@param r number
---@param g number
---@param b number
---@param a number
function ImGui.PushStyleColor(idx, r, g, b, a) end


function ImGui.PopStyleColor() end

---@param count integer
function ImGui.PopStyleColor(count) end


---@param idx StyleVar
---@param val number
function ImGui.PushStyleVar(idx, val) end

---@param idx StyleVar
---@param valx number
---@param valy number
function ImGui.PushStyleVar(idx, valx, valy) end


function ImGui.PopStyleVar() end

---@param count integer
function ImGui.PopStyleVar(count) end


---@param allow_keyboard_focus boolean
function ImGui.PushAllowKeyboardFocus(allow_keyboard_focus) end


function ImGui.PopAllowKeyboardFocus() end


---@param repeat_ boolean
function ImGui.PushButtonRepeat(repeat_) end


function ImGui.PopButtonRepeat() end


---@param item_width number
function ImGui.PushItemWidth(item_width) end


function ImGui.PopItemWidth() end


---@param item_width number
function ImGui.SetNextItemWidth(item_width) end


---@return number
function ImGui.CalcItemWidth() end


function ImGui.PushTextWrapPos() end

---@param wrap_local_pos_x number
function ImGui.PushTextWrapPos(wrap_local_pos_x) end


function ImGui.PopTextWrapPos() end


---@enum ComboFlags
ImGui.ComboFlags = {
    None = 0,
    PopupAlignLeft = 1,
    HeightSmall = 2,
    HeightRegular = 4,
    HeightLarge = 8,
    HeightLargest = 16,
    NoArrowButton = 32,
    NoPreview = 64,
    HeightMask_ = 30,
}


---@param label string
---@param preview_value string
---@return boolean
function ImGui.BeginCombo(label, preview_value) end

---@param label string
---@param preview_value string
---@param flags ComboFlags
---@return boolean
function ImGui.BeginCombo(label, preview_value, flags) end


function ImGui.EndCombo() end


---@param label string
---@param current_item integer
---@param items table
---@return boolean
---@return integer
function ImGui.Combo(label, current_item, items) end

---@param label string
---@param current_item integer
---@param items table
---@param popup_max_height_in_items integer
---@return boolean
---@return integer
function ImGui.Combo(label, current_item, items, popup_max_height_in_items) end


---@enum SelectableFlags
ImGui.SelectableFlags = {
    None = 0,
    DontClosePopups = 1,
    SpanAllColumns = 2,
    AllowDoubleClick = 4,
    Disabled = 8,
    AllowItemOverlap = 16,
}


---@param label string
---@return boolean
function ImGui.Selectable(label) end

---@param label string
---@param selected boolean
---@return boolean
function ImGui.Selectable(label, selected) end

---@param label string
---@param selected boolean
---@param flags SelectableFlags
---@return boolean
function ImGui.Selectable(label, selected, flags) end

---@param label string
---@param selected boolean
---@param flags SelectableFlags
---@param size_x number
---@param size_y number
---@return boolean
function ImGui.Selectable(label, selected, flags, size_x, size_y) end


---@return string
function ImGui.GetClipboardText() end


---@param text string
function ImGui.SetClipboardText(text) end


---@enum TreeNodeFlags
ImGui.TreeNodeFlags = {
    None = 0,
    Selected = 1,
    Framed = 2,
    AllowItemOverlap = 4,
    NoTreePushOnOpen = 8,
    NoAutoOpenOnLog = 16,
    DefaultOpen = 32,
    OpenOnDoubleClick = 64,
    OpenOnArrow = 128,
    Leaf = 256,
    Bullet = 512,
    FramePadding = 1024,
    SpanAvailWidth = 2048,
    SpanFullWidth = 4096,
    NavLeftJumpsBackHere = 8192,
    CollapsingHeader = 26,
}


---@param label string
---@return boolean
function ImGui.TreeNode(label) end

---@param label string
---@param flags TreeNodeFlags
---@return boolean
function ImGui.TreeNode(label, flags) end

---@param label string
---@param flags TreeNodeFlags
---@param text string
---@return boolean
function ImGui.TreeNode(label, flags, text) end


---@param str_id string
function ImGui.TreePush(str_id) end


function ImGui.TreePop() end


---@return number
function ImGui.GetTreeNodeToLabelSpacing() end


---@param label string
---@return boolean
function ImGui.CollapsingHeader(label) end

---@param label string
---@param flags TreeNodeFlags
---@return boolean
function ImGui.CollapsingHeader(label, flags) end

---@param label string
---@param visible boolean
---@return boolean
---@return boolean
function ImGui.CollapsingHeader(label, visible) end

---@param label string
---@param visible boolean
---@param flags TreeNodeFlags
---@return boolean
---@return boolean
function ImGui.CollapsingHeader(label, visible, flags) end


---@param is_open boolean
function ImGui.SetNextItemOpen(is_open) end

---@param is_open boolean
---@param cond Cond
function ImGui.SetNextItemOpen(is_open, cond) end


---@enum WindowFlags
ImGui.WindowFlags = {
    None = 0,
    NoTitleBar = 1,
    NoResize = 2,
    NoMove = 4,
    NoScrollbar = 8,
    NoScrollWithMouse = 16,
    NoCollapse = 32,
    AlwaysAutoResize = 64,
    NoBackground = 128,
    NoSavedSettings = 256,
    NoMouseInputs = 512,
    MenuBar = 1024,
    HorizontalScrollbar = 2048,
    NoFocusOnAppearing = 4096,
    NoBringToFrontOnFocus = 8192,
    AlwaysVerticalScrollbar = 16384,
    AlwaysHorizontalScrollbar = 32768,
    AlwaysUseWindowPadding = 65536,
    NoNavInputs = 262144,
    NoNavFocus = 524288,
    UnsavedDocument = 1048576,
    NoDocking = 2097152,
    NoNav = 786432,
    NoDecoration = 43,
    NoInputs = 786944,
}


---@enum FocusedFlags
ImGui.FocusedFlags = {
    None = 0,
    ChildWindows = 1,
    RootWindow = 2,
    AnyWindow = 4,
    NoPopupHierarchy = 8,
    DockHierarchy = 16,
    RootAndChildWindows = 3,
}


---@param name string
---@param open boolean?
---@param flags WindowFlags?
---@return boolean
---@return boolean?
function ImGui.Begin(name, open, flags) end


function ImGui.End() end


---@param str_id string
---@return boolean
function ImGui.BeginChild(str_id) end

---@param str_id string
---@param size_x number
---@param size_y number
---@return boolean
function ImGui.BeginChild(str_id, size_x, size_y) end

---@param str_id string
---@param size_x number
---@param size_y number
---@param border boolean
---@return boolean
function ImGui.BeginChild(str_id, size_x, size_y, border) end

---@param str_id string
---@param size_x number
---@param size_y number
---@param border boolean
---@param flags WindowFlags
---@return boolean
function ImGui.BeginChild(str_id, size_x, size_y, border, flags) end


function ImGui.EndChild() end


---@return boolean
function ImGui.IsWindowAppearing() end


---@return boolean
function ImGui.IsWindowCollapsed() end


---@return boolean
function ImGui.IsWindowFocused() end

---@param flags FocusedFlags
---@return boolean
function ImGui.IsWindowFocused(flags) end


---@return boolean
function ImGui.IsWindowHovered() end

---@param flags HoveredFlags
---@return boolean
function ImGui.IsWindowHovered(flags) end


---@return number
---@return number
function ImGui.GetWindowPos() end


---@return number
---@return number
function ImGui.GetWindowSize() end


---@return number
function ImGui.GetWindowWidth() end


---@return number
function ImGui.GetWindowHeight() end


---@param pos_x number
---@param pos_y number
function ImGui.SetNextWindowPos(pos_x, pos_y) end

---@param pos_x number
---@param pos_y number
---@param cond Cond
function ImGui.SetNextWindowPos(pos_x, pos_y, cond) end

---@param pos_x number
---@param pos_y number
---@param cond Cond
---@param pivot_x number
---@param pivot_y number
function ImGui.SetNextWindowPos(pos_x, pos_y, cond, pivot_x, pivot_y) end


---@param size_x number
---@param size_y number
function ImGui.SetNextWindowSize(size_x, size_y) end

---@param size_x number
---@param size_y number
---@param cond Cond
function ImGui.SetNextWindowSize(size_x, size_y, cond) end


---@param min_x number
---@param min_y number
---@param max_x number
---@param max_y number
function ImGui.SetNextWindowSizeConstraints(min_x, min_y, max_x, max_y) end


---@param size_x number
---@param size_y number
function ImGui.SetNextWindowContentSize(size_x, size_y) end


---@param collapsed boolean
function ImGui.SetNextWindowCollapsed(collapsed) end

---@param collapsed boolean
---@param cond Cond
function ImGui.SetNextWindowCollapsed(collapsed, cond) end


function ImGui.SetNextWindowFocus() end


---@param alpha number
function ImGui.SetNextWindowBgAlpha(alpha) end


---@param viewport_id integer
function ImGui.SetNextWindowViewport(viewport_id) end


---@param pos_x number
---@param pos_y number
function ImGui.SetWindowPos(pos_x, pos_y) end

---@param pos_x number
---@param pos_y number
---@param cond Cond
function ImGui.SetWindowPos(pos_x, pos_y, cond) end

---@param name string
---@param pos_x number
---@param pos_y number
function ImGui.SetWindowPos(name, pos_x, pos_y) end

---@param name string
---@param pos_x number
---@param pos_y number
---@param cond Cond
function ImGui.SetWindowPos(name, pos_x, pos_y, cond) end


---@param pos_x number
---@param pos_y number
function ImGui.SetWindowSize(pos_x, pos_y) end

---@param pos_x number
---@param pos_y number
---@param cond Cond
function ImGui.SetWindowSize(pos_x, pos_y, cond) end

---@param name string
---@param pos_x number
---@param pos_y number
function ImGui.SetWindowSize(name, pos_x, pos_y) end

---@param name string
---@param pos_x number
---@param pos_y number
---@param cond Cond
function ImGui.SetWindowSize(name, pos_x, pos_y, cond) end


---@param collapsed boolean
function ImGui.SetWindowCollapsed(collapsed) end

---@param collapsed boolean
---@param cond Cond
function ImGui.SetWindowCollapsed(collapsed, cond) end

---@param name string
---@param collapsed boolean
function ImGui.SetWindowCollapsed(name, collapsed) end

---@param name string
---@param collapsed boolean
---@param cond Cond
function ImGui.SetWindowCollapsed(name, collapsed, cond) end


---@param name string
function ImGui.SetWindowFocus(name) end

function ImGui.SetWindowFocus() end


---@return number
---@return number
function ImGui.GetContentRegionAvail() end


---@return number
---@return number
function ImGui.GetContentRegionMax() end


---@return number
---@return number
function ImGui.GetWindowContentRegionMin() end


---@return number
---@return number
function ImGui.GetWindowContentRegionMax() end


---@return number
function ImGui.GetScrollX() end


---@return number
function ImGui.GetScrollY() end


---@param scroll_x number
function ImGui.SetScrollX(scroll_x) end


---@param scroll_y number
function ImGui.SetScrollY(scroll_y) end


---@return number
function ImGui.GetScrollMaxX() end


---@return number
function ImGui.GetScrollMaxY() end


---@param center_x_ratio number
function ImGui.SetScrollHereX(center_x_ratio) end


---@param center_y_ratio number
function ImGui.SetScrollHereY(center_y_ratio) end


---@param local_x number
function ImGui.SetScrollFromPosX(local_x) end

---@param local_x number
---@param center_x_ratio number
function ImGui.SetScrollFromPosX(local_x, center_x_ratio) end


---@param local_y number
function ImGui.SetScrollFromPosY(local_y) end

---@param local_y number
---@param center_y_ratio number
function ImGui.SetScrollFromPosY(local_y, center_y_ratio) end


---@param x number
---@param y number
function ImGui.SetNextWindowScroll(x, y) end


---@enum InputTextFlags
ImGui.InputTextFlags = {
    None = 0,
    CharsDecimal = 1,
    CharsHexadecimal = 2,
    CharsUppercase = 4,
    CharsNoBlank = 8,
    AutoSelectAll = 16,
    EnterReturnsTrue = 32,
    CallbackCompletion = 64,
    CallbackHistory = 128,
    CallbackAlways = 256,
    CallbackCharFilter = 512,
    AllowTabInput = 1024,
    CtrlEnterForNewLine = 2048,
    NoHorizontalScroll = 4096,
    AlwaysOverwrite = 8192,
    ReadOnly = 16384,
    Password = 32768,
    NoUndoRedo = 65536,
    CharsScientific = 131072,
    CallbackResize = 262144,
    CallbackEdit = 524288,
    EscapeClearsAll = 1048576,
}


---@param label string
---@param str string
---@return boolean
---@return string
function ImGui.InputText(label, str) end

---@param label string
---@param str string
---@param flags InputTextFlags
---@return boolean
---@return string
function ImGui.InputText(label, str, flags) end


---@param label string
---@param str string
---@return boolean
---@return string
function ImGui.InputTextMultiline(label, str) end

---@param label string
---@param str string
---@param size_x number
---@param size_y number
---@return boolean
---@return string
function ImGui.InputTextMultiline(label, str, size_x, size_y) end

---@param label string
---@param str string
---@param size_x number
---@param size_y number
---@param flags InputTextFlags
---@return boolean
---@return string
function ImGui.InputTextMultiline(label, str, size_x, size_y, flags) end


---@param label string
---@param hint string
---@param str string
---@return boolean
---@return string
function ImGui.InputTextWithHint(label, hint, str) end

---@param label string
---@param hint string
---@param str string
---@param flags InputTextFlags
---@return boolean
---@return string
function ImGui.InputTextWithHint(label, hint, str, flags) end


---@param label string
---@param v number
---@return boolean
---@return number
function ImGui.InputFloat(label, v) end

---@param label string
---@param v number
---@param step number
---@return boolean
---@return number
function ImGui.InputFloat(label, v, step) end

---@param label string
---@param v number
---@param step number
---@param step_fast number
---@return boolean
---@return number
function ImGui.InputFloat(label, v, step, step_fast) end

---@param label string
---@param v number
---@param step number
---@param step_fast number
---@param format string
---@return boolean
---@return number
function ImGui.InputFloat(label, v, step, step_fast, format) end

---@param label string
---@param v number
---@param step number
---@param step_fast number
---@param format string
---@param flags InputTextFlags
---@return boolean
---@return number
function ImGui.InputFloat(label, v, step, step_fast, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@return boolean
---@return number
---@return number
function ImGui.InputFloat2(label, v1, v2) end

---@param label string
---@param v1 number
---@param v2 number
---@param format string
---@return boolean
---@return number
---@return number
function ImGui.InputFloat2(label, v1, v2, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param format string
---@param flags InputTextFlags
---@return boolean
---@return number
---@return number
function ImGui.InputFloat2(label, v1, v2, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.InputFloat3(label, v1, v2, v3) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param format string
---@return boolean
---@return number
---@return number
---@return number
function ImGui.InputFloat3(label, v1, v2, v3, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param format string
---@param flags InputTextFlags
---@return boolean
---@return number
---@return number
---@return number
function ImGui.InputFloat3(label, v1, v2, v3, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.InputFloat4(label, v1, v2, v3, v4) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param format string
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.InputFloat4(label, v1, v2, v3, v4, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param format string
---@param flags InputTextFlags
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.InputFloat4(label, v1, v2, v3, v4, format, flags) end


---@param label string
---@param v integer
---@return boolean
---@return integer
function ImGui.InputInt(label, v) end

---@param label string
---@param v integer
---@param step integer
---@return boolean
---@return integer
function ImGui.InputInt(label, v, step) end

---@param label string
---@param v integer
---@param step integer
---@param step_fast integer
---@return boolean
---@return integer
function ImGui.InputInt(label, v, step, step_fast) end

---@param label string
---@param v integer
---@param step integer
---@param step_fast integer
---@param flags InputTextFlags
---@return boolean
---@return integer
function ImGui.InputInt(label, v, step, step_fast, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@return boolean
---@return integer
---@return integer
function ImGui.InputInt2(label, v1, v2) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param flags InputTextFlags
---@return boolean
---@return integer
---@return integer
function ImGui.InputInt2(label, v1, v2, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.InputInt3(label, v1, v2, v3) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param flags InputTextFlags
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.InputInt3(label, v1, v2, v3, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.InputInt4(label, v1, v2, v3, v4) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param flags InputTextFlags
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.InputInt4(label, v1, v2, v3, v4, flags) end


---@param label string
---@param v number
---@return boolean
---@return number
function ImGui.InputDouble(label, v) end

---@param label string
---@param v number
---@param step number
---@return boolean
---@return number
function ImGui.InputDouble(label, v, step) end

---@param label string
---@param v number
---@param step number
---@param step_fast number
---@return boolean
---@return number
function ImGui.InputDouble(label, v, step, step_fast) end

---@param label string
---@param v number
---@param step number
---@param step_fast number
---@param format string
---@return boolean
---@return number
function ImGui.InputDouble(label, v, step, step_fast, format) end

---@param label string
---@param v number
---@param step number
---@param step_fast number
---@param format string
---@param flags InputTextFlags
---@return boolean
---@return number
function ImGui.InputDouble(label, v, step, step_fast, format, flags) end


---@enum TabBarFlags
ImGui.TabBarFlags = {
    None = 0,
    Reorderable = 1,
    AutoSelectNewTabs = 2,
    TabListPopupButton = 4,
    NoCloseWithMiddleMouseButton = 8,
    NoTabListScrollingButtons = 16,
    NoTooltip = 32,
    FittingPolicyResizeDown = 64,
    FittingPolicyScroll = 128,
    FittingPolicyMask_ = 192,
    FittingPolicyDefault_ = 64,
}


---@param str_id string
---@return boolean
function ImGui.BeginTabBar(str_id) end

---@param str_id string
---@param flags TabBarFlags
---@return boolean
function ImGui.BeginTabBar(str_id, flags) end


function ImGui.EndTabBar() end


---@enum TabItemFlags
ImGui.TabItemFlags = {
    None = 0,
    UnsavedDocument = 1,
    SetSelected = 2,
    NoCloseWithMiddleMouseButton = 4,
    NoPushId = 8,
    NoTooltip = 16,
    NoReorder = 32,
    Leading = 64,
    Trailing = 128,
}


---@param label string
---@param open boolean?
---@param flags TabItemFlags?
---@return boolean
---@return boolean?
function ImGui.BeginTabItem(label, open, flags) end


function ImGui.EndTabItem() end


---@param label string
---@return boolean
function ImGui.TabItemButton(label) end

---@param label string
---@param flags TabItemFlags
---@return boolean
function ImGui.TabItemButton(label, flags) end


---@param tab_or_docked_window_label string
function ImGui.SetTabItemClosed(tab_or_docked_window_label) end


---@enum ColorEditFlags
ImGui.ColorEditFlags = {
    None = 0,
    NoAlpha = 2,
    NoPicker = 4,
    NoOptions = 8,
    NoSmallPreview = 16,
    NoInputs = 32,
    NoTooltip = 64,
    NoLabel = 128,
    NoSidePreview = 256,
    NoDragDrop = 512,
    NoBorder = 1024,
    AlphaBar = 65536,
    AlphaPreview = 131072,
    AlphaPreviewHalf = 262144,
    HDR = 524288,
    DisplayRGB = 1048576,
    DisplayHSV = 2097152,
    DisplayHex = 4194304,
    Uint8 = 8388608,
    Float = 16777216,
    PickerHueBar = 33554432,
    PickerHueWheel = 67108864,
    InputRGB = 134217728,
    InputHSV = 268435456,
    DefaultOptions_ = 177209344,
}


---@param label string
---@param r number
---@param g number
---@param b number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.ColorEdit3(label, r, g, b) end

---@param label string
---@param r number
---@param g number
---@param b number
---@param flags ColorEditFlags
---@return boolean
---@return number
---@return number
---@return number
function ImGui.ColorEdit3(label, r, g, b, flags) end


---@param label string
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.ColorEdit4(label, r, g, b, a) end

---@param label string
---@param r number
---@param g number
---@param b number
---@param a number
---@param flags ColorEditFlags
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.ColorEdit4(label, r, g, b, a, flags) end


---@param label string
---@param r number
---@param g number
---@param b number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.ColorPicker3(label, r, g, b) end

---@param label string
---@param r number
---@param g number
---@param b number
---@param flags ColorEditFlags
---@return boolean
---@return number
---@return number
---@return number
function ImGui.ColorPicker3(label, r, g, b, flags) end


---@param label string
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.ColorPicker4(label, r, g, b, a) end

---@param label string
---@param r number
---@param g number
---@param b number
---@param a number
---@param flags ColorEditFlags
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.ColorPicker4(label, r, g, b, a, flags) end


---@param desc_id string
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
function ImGui.ColorButton(desc_id, r, g, b, a) end

---@param desc_id string
---@param r number
---@param g number
---@param b number
---@param a number
---@param flags ColorEditFlags
---@return boolean
function ImGui.ColorButton(desc_id, r, g, b, a, flags) end

---@param desc_id string
---@param r number
---@param g number
---@param b number
---@param a number
---@param flags ColorEditFlags
---@param size_x number
---@param size_y number
---@return boolean
function ImGui.ColorButton(desc_id, r, g, b, a, flags, size_x, size_y) end


---@enum ButtonFlags
ImGui.ButtonFlags = {
    None = 0,
    MouseButtonLeft = 1,
    MouseButtonRight = 2,
    MouseButtonMiddle = 4,
}


---@param label string
---@return boolean
function ImGui.Button(label) end

---@param label string
---@param width number
---@param height number
---@return boolean
function ImGui.Button(label, width, height) end


---@param label string
---@return boolean
function ImGui.SmallButton(label) end


---@param str_id string
---@param size_x number
---@param size_y number
---@return boolean
function ImGui.InvisibleButton(str_id, size_x, size_y) end

---@param str_id string
---@param size_x number
---@param size_y number
---@param flags ButtonFlags
---@return boolean
function ImGui.InvisibleButton(str_id, size_x, size_y, flags) end


---@param str_id string
---@param dir Dir
---@return boolean
function ImGui.ArrowButton(str_id, dir) end


---@param label string
---@param value boolean
---@return boolean
---@return boolean
function ImGui.Checkbox(label, value) end


---@param label string
---@param flags integer
---@param flags_value integer
---@return boolean
---@return integer
function ImGui.CheckboxFlags(label, flags, flags_value) end


---@param label string
---@param active boolean
---@return boolean
function ImGui.RadioButton(label, active) end


---@param fraction number
function ImGui.ProgressBar(fraction) end

---@param fraction number
---@param size_x number
function ImGui.ProgressBar(fraction, size_x) end

---@param fraction number
---@param size_x number
---@param size_y number
function ImGui.ProgressBar(fraction, size_x, size_y) end

---@param fraction number
---@param size_x number
---@param size_y number
---@param overlay string
function ImGui.ProgressBar(fraction, size_x, size_y, overlay) end


function ImGui.Bullet() end


---@enum TableFlags
ImGui.TableFlags = {
    None = 0,
    Resizable = 1,
    Reorderable = 2,
    Hideable = 4,
    Sortable = 8,
    NoSavedSettings = 16,
    ContextMenuInBody = 32,
    RowBg = 64,
    BordersInnerH = 128,
    BordersOuterH = 256,
    BordersInnerV = 512,
    BordersOuterV = 1024,
    BordersH = 384,
    BordersV = 1536,
    BordersInner = 640,
    BordersOuter = 1280,
    Borders = 1920,
    NoBordersInBody = 2048,
    NoBordersInBodyUntilResize = 4096,
    SizingFixedFit = 8192,
    SizingFixedSame = 16384,
    SizingStretchProp = 24576,
    SizingStretchSame = 32768,
    NoHostExtendX = 65536,
    NoHostExtendY = 131072,
    NoKeepColumnsVisible = 262144,
    PreciseWidths = 524288,
    NoClip = 1048576,
    PadOuterX = 2097152,
    NoPadOuterX = 4194304,
    NoPadInnerX = 8388608,
    ScrollX = 16777216,
    ScrollY = 33554432,
    SortMulti = 67108864,
    SortTristate = 134217728,
}


---@enum TableRowFlags
ImGui.TableRowFlags = {
    None = 0,
    Headers = 1,
}


---@enum TableColumnFlags
ImGui.TableColumnFlags = {
    None = 0,
    Disabled = 1,
    DefaultHide = 2,
    DefaultSort = 4,
    WidthStretch = 8,
    WidthFixed = 16,
    NoResize = 32,
    NoReorder = 64,
    NoHide = 128,
    NoClip = 256,
    NoSort = 512,
    NoSortAscending = 1024,
    NoSortDescending = 2048,
    NoHeaderLabel = 4096,
    NoHeaderWidth = 8192,
    PreferSortAscending = 16384,
    PreferSortDescending = 32768,
    IndentEnable = 65536,
    IndentDisable = 131072,
    IsEnabled = 16777216,
    IsVisible = 33554432,
    IsSorted = 67108864,
    IsHovered = 134217728,
}


---@enum TableBgTarget
ImGui.TableBgTarget = {
    None = 0,
    RowBg0 = 1,
    RowBg1 = 2,
    CellBg = 3,
}


---@param str_id string
---@param column integer
---@return boolean
function ImGui.BeginTable(str_id, column) end

---@param str_id string
---@param column integer
---@param flags TableFlags
---@return boolean
function ImGui.BeginTable(str_id, column, flags) end

---@param str_id string
---@param column integer
---@param flags TableFlags
---@param outer_size_x number
---@param outer_size_y number
---@return boolean
function ImGui.BeginTable(str_id, column, flags, outer_size_x, outer_size_y) end

---@param str_id string
---@param column integer
---@param flags TableFlags
---@param outer_size_x number
---@param outer_size_y number
---@param inner_size number
---@return boolean
function ImGui.BeginTable(str_id, column, flags, outer_size_x, outer_size_y, inner_size) end


function ImGui.EndTable() end


function ImGui.TableNextRow() end

---@param row_flags TableRowFlags
function ImGui.TableNextRow(row_flags) end

---@param row_flags TableRowFlags
---@param min_row_height number
function ImGui.TableNextRow(row_flags, min_row_height) end


---@return boolean
function ImGui.TableNextColumn() end


---@param column_n integer
---@return boolean
function ImGui.TableSetColumnIndex(column_n) end


---@param label string
function ImGui.TableSetupColumn(label) end

---@param label string
---@param flags TableColumnFlags
function ImGui.TableSetupColumn(label, flags) end

---@param label string
---@param flags TableColumnFlags
---@param init_width_or_weight number
function ImGui.TableSetupColumn(label, flags, init_width_or_weight) end

---@param label string
---@param flags TableColumnFlags
---@param init_width_or_weight number
---@param user_id integer
function ImGui.TableSetupColumn(label, flags, init_width_or_weight, user_id) end


---@param cols integer
---@param rows integer
function ImGui.TableSetupScrollFreeze(cols, rows) end


function ImGui.TableHeadersRow() end


---@param label string
function ImGui.TableHeader(label) end


---@return integer
function ImGui.TableGetColumnCount() end


---@return integer
function ImGui.TableGetColumnIndex() end


---@return integer
function ImGui.TableGetRowIndex() end


---@return string
function ImGui.TableGetColumnName() end

---@param column_n integer
---@return string
function ImGui.TableGetColumnName(column_n) end


---@return integer
function ImGui.TableGetColumnFlags() end

---@param column_n integer
---@return TableColumnFlags
function ImGui.TableGetColumnFlags(column_n) end


---@param column_n integer
---@param v boolean
function ImGui.TableSetColumnEnabled(column_n, v) end


---@param target TableBgTarget
---@param r number
---@param g number
---@param b number
---@param a number
function ImGui.TableSetBgColor(target, r, g, b, a) end

---@param target TableBgTarget
---@param r number
---@param g number
---@param b number
---@param a number
---@param column_n integer
function ImGui.TableSetBgColor(target, r, g, b, a, column_n) end


---@enum HoveredFlags
ImGui.HoveredFlags = {
    None = 0,
    ChildWindows = 1,
    RootWindow = 2,
    AnyWindow = 4,
    NoPopupHierarchy = 8,
    AllowWhenBlockedByPopup = 32,
    AllowWhenBlockedByActiveItem = 128,
    AllowWhenOverlapped = 256,
    AllowWhenDisabled = 512,
    NoNavOverride = 1024,
    RectOnly = 416,
}


---@return boolean
function ImGui.IsItemHovered() end

---@param flags HoveredFlags
---@return boolean
function ImGui.IsItemHovered(flags) end


---@return boolean
function ImGui.IsItemActive() end


---@return boolean
function ImGui.IsItemFocused() end


---@return boolean
function ImGui.IsItemClicked() end

---@param mouse_button MouseButton
---@return boolean
function ImGui.IsItemClicked(mouse_button) end


---@return boolean
function ImGui.IsItemVisible() end


---@return boolean
function ImGui.IsItemEdited() end


---@return boolean
function ImGui.IsItemActivated() end


---@return boolean
function ImGui.IsItemDeactivated() end


---@return boolean
function ImGui.IsItemDeactivatedAfterEdit() end


---@return boolean
function ImGui.IsItemToggledOpen() end


---@return boolean
function ImGui.IsAnyItemHovered() end


---@return boolean
function ImGui.IsAnyItemActive() end


---@return boolean
function ImGui.IsAnyItemFocused() end


---@return integer
function ImGui.GetItemID() end


---@return number
---@return number
function ImGui.GetItemRectMin() end


---@return number
---@return number
function ImGui.GetItemRectMax() end


---@return number
---@return number
function ImGui.GetItemRectSize() end


function ImGui.SetItemAllowOverlap() end


function ImGui.BeginTooltip() end


function ImGui.EndTooltip() end


---@param text string
function ImGui.SetTooltip(text) end


---@return ImGui.GuiIO
function ImGui.GetIO() end


---@enum Cond
ImGui.Cond = {
    None = 0,
    Always = 1,
    Once = 2,
    FirstUseEver = 4,
    Appearing = 8,
}


---@enum Axis
ImPlot.Axis = {
    X1 = 0,
    X2 = 1,
    X3 = 2,
    Y1 = 3,
    Y2 = 4,
    Y3 = 5,
}


---@enum PlotFlags
ImPlot.PlotFlags = {
    None = 0,
    NoTitle = 1,
    NoLegend = 2,
    NoMouseText = 4,
    NoInputs = 8,
    NoMenus = 16,
    NoBoxSelect = 32,
    NoChild = 64,
    NoFrame = 128,
    Equal = 256,
    Crosshairs = 512,
    CanvasOnly = 55,
}


---@enum PlotAxisFlags
ImPlot.PlotAxisFlags = {
    None = 0,
    NoLabel = 1,
    NoGridLines = 2,
    NoTickMarks = 4,
    NoTickLabels = 8,
    NoInitialFit = 16,
    NoMenus = 32,
    NoSideSwitch = 64,
    NoHighlight = 128,
    Opposite = 256,
    Foreground = 512,
    Invert = 1024,
    AutoFit = 2048,
    RangeFit = 4096,
    PanStretch = 8192,
    LockMin = 16384,
    LockMax = 32768,
    Lock = 49152,
    NoDecorations = 15,
    AuxDefault = 258,
}


---@enum PlotSubplotFlags
ImPlot.PlotSubplotFlags = {
    None = 0,
    NoTitle = 1,
    NoLegend = 2,
    NoMenus = 4,
    NoResize = 8,
    NoAlign = 16,
    ShareItems = 32,
    LinkRows = 64,
    LinkCols = 128,
    LinkAllX = 256,
    LinkAllY = 512,
    ColMajor = 1024,
}


---@enum PlotLegendFlags
ImPlot.PlotLegendFlags = {
    None = 0,
    NoButtons = 1,
    NoHighlightItem = 2,
    NoHighlightAxis = 4,
    NoMenus = 8,
    Outside = 16,
    Horizontal = 32,
    Sort = 64,
}


---@enum PlotMouseTextFlags
ImPlot.PlotMouseTextFlags = {
    None = 0,
    NoAuxAxes = 1,
    NoFormat = 2,
    ShowAlways = 4,
}


---@enum PlotDragToolFlags
ImPlot.PlotDragToolFlags = {
    None = 0,
    NoCursors = 1,
    NoFit = 2,
    NoInputs = 4,
    Delayed = 8,
}


---@enum PlotColormapScaleFlags
ImPlot.PlotColormapScaleFlags = {
    None = 0,
    NoLabel = 1,
    Opposite = 2,
    Invert = 4,
}


---@enum PlotItemFlags
ImPlot.PlotItemFlags = {
    None = 0,
    NoLegend = 1,
    NoFit = 2,
}


---@enum PlotLineFlags
ImPlot.PlotLineFlags = {
    None = 0,
    Segments = 1024,
    Loop = 2048,
    SkipNaN = 4096,
    NoClip = 8192,
    Shaded = 16384,
}


---@enum PlotScatterFlags
ImPlot.PlotScatterFlags = {
    None = 0,
    NoClip = 1024,
}


---@enum PlotStairsFlags
ImPlot.PlotStairsFlags = {
    None = 0,
    PreStep = 1024,
    Shaded = 2048,
}


---@enum PlotShadedFlags
ImPlot.PlotShadedFlags = {
    None = 0,
}


---@enum PlotBarsFlags
ImPlot.PlotBarsFlags = {
    None = 0,
    Horizontal = 1024,
}


---@enum PlotBarGroupsFlags
ImPlot.PlotBarGroupsFlags = {
    None = 0,
    Horizontal = 1024,
    Stacked = 2048,
}


---@enum PlotErrorBarsFlags
ImPlot.PlotErrorBarsFlags = {
    None = 0,
    Horizontal = 1024,
}


---@enum PlotStemsFlags
ImPlot.PlotStemsFlags = {
    None = 0,
    Horizontal = 1024,
}


---@enum PlotInfLinesFlags
ImPlot.PlotInfLinesFlags = {
    None = 0,
    Horizontal = 1024,
}


---@enum PlotPieChartFlags
ImPlot.PlotPieChartFlags = {
    None = 0,
    Normalize = 1024,
}


---@enum PlotHeatmapFlags
ImPlot.PlotHeatmapFlags = {
    None = 0,
    ColMajor = 1024,
}


---@enum PlotHistogramFlags
ImPlot.PlotHistogramFlags = {
    None = 0,
    Horizontal = 1024,
    Cumulative = 2048,
    Density = 4096,
    NoOutliers = 8192,
    ColMajor = 16384,
}


---@enum PlotDigitalFlags
ImPlot.PlotDigitalFlags = {
    None = 0,
}


---@enum PlotImageFlags
ImPlot.PlotImageFlags = {
    None = 0,
}


---@enum PlotTextFlags
ImPlot.PlotTextFlags = {
    None = 0,
    Vertical = 1024,
}


---@enum PlotDummyFlags
ImPlot.PlotDummyFlags = {
    None = 0,
}


---@enum PlotCond
ImPlot.PlotCond = {
    None = 0,
    Always = 1,
    Once = 2,
}


---@enum PlotCol
ImPlot.PlotCol = {
    Line = 0,
    Fill = 1,
    MarkerOutline = 2,
    MarkerFill = 3,
    ErrorBar = 4,
    FrameBg = 5,
    PlotBg = 6,
    PlotBorder = 7,
    LegendBg = 8,
    LegendBorder = 9,
    LegendText = 10,
    TitleText = 11,
    InlayText = 12,
    AxisText = 13,
    AxisGrid = 14,
    AxisTick = 15,
    AxisBg = 16,
    AxisBgHovered = 17,
    AxisBgActive = 18,
    Selection = 19,
    Crosshairs = 20,
}


---@enum PlotStyleVar
ImPlot.PlotStyleVar = {
    LineWeight = 0,
    Marker = 1,
    MarkerSize = 2,
    MarkerWeight = 3,
    FillAlpha = 4,
    ErrorBarSize = 5,
    ErrorBarWeight = 6,
    DigitalBitHeight = 7,
    DigitalBitGap = 8,
    PlotBorderSize = 9,
    MinorAlpha = 10,
    MajorTickLen = 11,
    MinorTickLen = 12,
    MajorTickSize = 13,
    MinorTickSize = 14,
    MajorGridSize = 15,
    MinorGridSize = 16,
    PlotPadding = 17,
    LabelPadding = 18,
    LegendPadding = 19,
    LegendInnerPadding = 20,
    LegendSpacing = 21,
    MousePosPadding = 22,
    AnnotationPadding = 23,
    FitPadding = 24,
    PlotDefaultSize = 25,
    PlotMinSize = 26,
}


---@enum PlotScale
ImPlot.PlotScale = {
    Linear = 0,
    Time = 1,
    Log10 = 2,
    SymLog = 3,
}


---@enum PlotMarker
ImPlot.PlotMarker = {
    None = -1,
    Circle = 0,
    Square = 1,
    Diamond = 2,
    Up = 3,
    Down = 4,
    Left = 5,
    Right = 6,
    Cross = 7,
    Plus = 8,
    Asterisk = 9,
}


---@enum PlotColormap
ImPlot.PlotColormap = {
    Deep = 0,
    PlotColormap_Dark = 1,
    Pastel = 2,
    Paired = 3,
    Viridis = 4,
    Plasma = 5,
    Hot = 6,
    Cool = 7,
    Pink = 8,
    Jet = 9,
    Twilight = 10,
    RdBu = 11,
    BrBG = 12,
    PiYG = 13,
    Spectral = 14,
    Greys = 15,
}


---@enum PlotLocation
ImPlot.PlotLocation = {
    Center = 0,
    North = 1,
    South = 2,
    West = 4,
    East = 8,
    NorthWest = 5,
    NorthEast = 9,
    SouthWest = 6,
    SouthEast = 10,
}


---@enum PlotBin
ImPlot.PlotBin = {
    Sqrt = -1,
    Sturges = -2,
    Rice = -3,
    Scott = -4,
}


---@param title_id string
---@return boolean
function ImPlot.BeginPlot(title_id) end

---@param title_id string
---@param size_x number
---@param size_y number
---@return boolean
function ImPlot.BeginPlot(title_id, size_x, size_y) end

---@param title_id string
---@param size_x number
---@param size_y number
---@param flags PlotFlags
---@return boolean
function ImPlot.BeginPlot(title_id, size_x, size_y, flags) end


function ImPlot.EndPlot() end


---@param title_id string
---@param rows integer
---@param cols integer
---@param size_x number
---@param size_y number
---@return boolean
function ImPlot.BeginSubplots(title_id, rows, cols, size_x, size_y) end

---@param title_id string
---@param rows integer
---@param cols integer
---@param size_x number
---@param size_y number
---@param flags PlotSubplotFlags
---@return boolean
function ImPlot.BeginSubplots(title_id, rows, cols, size_x, size_y, flags) end


function ImPlot.EndSubplots() end


---@param axis Axis
function ImPlot.SetupAxis(axis) end

---@param axis Axis
---@param label string
function ImPlot.SetupAxis(axis, label) end

---@param axis Axis
---@param label string
---@param flags PlotAxisFlags
function ImPlot.SetupAxis(axis, label, flags) end

---@param axis Axis
---@param label string
---@param flags PlotAxisFlags
function ImPlot.SetupAxis(axis, label, flags) end


---@param axis Axis
---@param v_min number
---@param v_max number
function ImPlot.SetupAxisLimits(axis, v_min, v_max) end

---@param axis Axis
---@param v_min number
---@param v_max number
---@param cond PlotCond
function ImPlot.SetupAxisLimits(axis, v_min, v_max, cond) end


---@param axis Axis
---@param fmt string
function ImPlot.SetupAxisFormat(axis, fmt) end


---@param axis Axis
---@param values number[]
---@param labels string[]?
---@param keep_default boolean?
function ImPlot.SetupAxisTicks(axis, values, labels, keep_default) end

---@param axis Axis
---@param v_min number
---@param v_max number
---@param n_ticks integer
---@param labels string[]?
---@param keep_default boolean?
function ImPlot.SetupAxisTicks(axis, v_min, v_max, n_ticks, labels, keep_default) end


---@param axis Axis
---@param scale PlotScale
function ImPlot.SetupAxisScale(axis, scale) end


---@param axis Axis
---@param v_min number
---@param v_max number
function ImPlot.SetupAxisLimitsConstraints(axis, v_min, v_max) end


---@param axis Axis
---@param z_min number
---@param z_max number
function ImPlot.SetupAxisZoomConstraints(axis, z_min, z_max) end


---@param x_label string
---@param y_label string
function ImPlot.SetupAxes(x_label, y_label) end

---@param x_label string
---@param y_label string
---@param x_flags PlotAxisFlags
function ImPlot.SetupAxes(x_label, y_label, x_flags) end

---@param x_label string
---@param y_label string
---@param x_flags PlotAxisFlags
---@param y_flags PlotAxisFlags
function ImPlot.SetupAxes(x_label, y_label, x_flags, y_flags) end


---@param x_min number
---@param x_max number
---@param y_min number
---@param y_max number
function ImPlot.SetupAxesLimits(x_min, x_max, y_min, y_max) end

---@param x_min number
---@param x_max number
---@param y_min number
---@param y_max number
---@param cond PlotCond
function ImPlot.SetupAxesLimits(x_min, x_max, y_min, y_max, cond) end


---@param location PlotLocation
function ImPlot.SetupLegend(location) end

---@param location PlotLocation
---@param flags PlotLegendFlags
function ImPlot.SetupLegend(location, flags) end


---@param location PlotLocation
function ImPlot.SetupMouseText(location) end

---@param location PlotLocation
---@param flags PlotMouseTextFlags
function ImPlot.SetupMouseText(location, flags) end


function ImPlot.SetupFinish() end


---@param axis Axis
---@param v_min number
---@param v_max number
function ImPlot.SetNextAxisLimits(axis, v_min, v_max) end

---@param axis Axis
---@param v_min number
---@param v_max number
---@param cond PlotCond
function ImPlot.SetNextAxisLimits(axis, v_min, v_max, cond) end


---@param axis Axis
function ImPlot.SetNextAxisToFit(axis) end


---@param x_min number
---@param x_max number
---@param y_min number
---@param y_max number
function ImPlot.SetNextAxesLimits(x_min, x_max, y_min, y_max) end

---@param x_min number
---@param x_max number
---@param y_min number
---@param y_max number
---@param cond PlotCond
function ImPlot.SetNextAxesLimits(x_min, x_max, y_min, y_max, cond) end


function ImPlot.SetNextAxesToFit() end


---@param label_id string
---@param values number[]
function ImPlot.PlotLine(label_id, values) end

---@param label_id string
---@param values number[]
---@param xscale number
function ImPlot.PlotLine(label_id, values, xscale) end

---@param label_id string
---@param values number[]
---@param xscale number
---@param xstart number
function ImPlot.PlotLine(label_id, values, xscale, xstart) end

---@param label_id string
---@param values number[]
---@param xscale number
---@param xstart number
---@param flags PlotLineFlags
function ImPlot.PlotLine(label_id, values, xscale, xstart, flags) end

---@param label_id string
---@param xs number[]
---@param ys number[]
function ImPlot.PlotLine(label_id, xs, ys) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param flags PlotLineFlags
function ImPlot.PlotLine(label_id, xs, ys, flags) end


---@param label_id string
---@param values number[]
function ImPlot.PlotScatter(label_id, values) end

---@param label_id string
---@param values number[]
---@param xscale number
function ImPlot.PlotScatter(label_id, values, xscale) end

---@param label_id string
---@param values number[]
---@param xscale number
---@param xstart number
function ImPlot.PlotScatter(label_id, values, xscale, xstart) end

---@param label_id string
---@param values number[]
---@param xscale number
---@param xstart number
---@param flags PlotScatterFlags
function ImPlot.PlotScatter(label_id, values, xscale, xstart, flags) end

---@param label_id string
---@param xs number[]
---@param ys number[]
function ImPlot.PlotScatter(label_id, xs, ys) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param flags PlotScatterFlags
function ImPlot.PlotScatter(label_id, xs, ys, flags) end


---@param label_id string
---@param values number[]
function ImPlot.PlotStairs(label_id, values) end

---@param label_id string
---@param values number[]
---@param xscale number
function ImPlot.PlotStairs(label_id, values, xscale) end

---@param label_id string
---@param values number[]
---@param xscale number
---@param xstart number
function ImPlot.PlotStairs(label_id, values, xscale, xstart) end

---@param label_id string
---@param values number[]
---@param xscale number
---@param xstart number
---@param flags PlotStairsFlags
function ImPlot.PlotStairs(label_id, values, xscale, xstart, flags) end

---@param label_id string
---@param xs number[]
---@param ys number[]
function ImPlot.PlotStairs(label_id, xs, ys) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param flags PlotStairsFlags
function ImPlot.PlotStairs(label_id, xs, ys, flags) end


---@param label_id string
---@param values number[]
function ImPlot.PlotBars(label_id, values) end

---@param label_id string
---@param values number[]
---@param bar_size number
function ImPlot.PlotBars(label_id, values, bar_size) end

---@param label_id string
---@param values number[]
---@param bar_size number
---@param shift number
function ImPlot.PlotBars(label_id, values, bar_size, shift) end

---@param label_id string
---@param values number[]
---@param bar_size number
---@param shift number
---@param flags PlotBarsFlags
function ImPlot.PlotBars(label_id, values, bar_size, shift, flags) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param bar_size number
function ImPlot.PlotBars(label_id, xs, ys, bar_size) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param flags PlotBarsFlags
---@param bar_size number
function ImPlot.PlotBars(label_id, xs, ys, flags, bar_size) end


---@param label_id string
---@param xs number[]
---@param ys number[]
---@param err number[]
---@param flags PlotErrorBarsFlags?
function ImPlot.PlotErrorBars(label_id, xs, ys, err, flags) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param neg number[]
---@param pos number[]
---@param flags PlotErrorBarsFlags?
function ImPlot.PlotErrorBars(label_id, xs, ys, neg, pos, flags) end


---@param label_id string
---@param values number[]
---@param ref number?
---@param scale number?
---@param start number?
---@param flags PlotStemsFlags?
function ImPlot.PlotStems(label_id, values, ref, scale, start, flags) end

---@param label_id string
---@param xs number[]
---@param ys number[]
---@param ref number?
---@param flags PlotStemsFlags?
function ImPlot.PlotStems(label_id, xs, ys, ref, flags) end


---@param label_id string
---@param values number[]
---@param flags PlotInfLinesFlags?
function ImPlot.PlotInfLines(label_id, values, flags) end


---@param label_ids string[]
---@param values number[]
---@param x number
---@param y number
---@param radius number
---@param label_fmt string?
---@param angle0 number?
---@param flags PlotPieChartFlags?
function ImPlot.PlotPieChart(label_ids, values, x, y, radius, label_fmt, angle0, flags) end


---@param label_id string
---@param values number[]
---@param rows integer
---@param cols integer
---@param scale_min number?
---@param scale_max number?
---@param label_fmt string?
---@param bounds_min ImPlot.PlotPoint?
---@param bounds_max ImPlot.PlotPoint?
---@param flags PlotHeatmapFlags?
function ImPlot.PlotHeatmap(label_id, values, rows, cols, scale_min, scale_max, label_fmt, bounds_min, bounds_max, flags) end


---@param label_id string
---@param values number[]
---@param bins PlotBin?
---@param bar_scale number?
---@param range ImPlot.PlotRange?
---@param flags PlotHistogramFlags?
---@return number
function ImPlot.PlotHistogram(label_id, values, bins, bar_scale, range, flags) end


---@param label_id string
---@param xs number[]
---@param ys number[]
---@param x_bins PlotBin?
---@param y_bins PlotBin?
---@param range ImPlot.PlotRect?
---@param flags PlotHistogramFlags?
---@return number
function ImPlot.PlotHistogram2D(label_id, xs, ys, x_bins, y_bins, range, flags) end


---@param label_id string
---@param xs number[]
---@param ys number[]
---@param flags PlotDigitalFlags?
function ImPlot.PlotDigital(label_id, xs, ys, flags) end


---@param text string
---@param x number
---@param y number
function ImPlot.PlotText(text, x, y) end

---@param text string
---@param x number
---@param y number
---@param pix_offset_x number
---@param pix_offset_y number
function ImPlot.PlotText(text, x, y, pix_offset_x, pix_offset_y) end

---@param text string
---@param x number
---@param y number
---@param pix_offset_x number
---@param pix_offset_y number
---@param flags PlotTextFlags
function ImPlot.PlotText(text, x, y, pix_offset_x, pix_offset_y, flags) end


---@param label_id string
function ImPlot.PlotDummy(label_id) end

---@param label_id string
---@param flags PlotDummyFlags
function ImPlot.PlotDummy(label_id, flags) end


---@param id integer
---@param x number
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
---@return number
---@return number
function ImPlot.DragPoint(id, x, y, r, g, b, a) end

---@param id integer
---@param x number
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param size number
---@return boolean
---@return number
---@return number
function ImPlot.DragPoint(id, x, y, r, g, b, a, size) end

---@param id integer
---@param x number
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param size number
---@param flags PlotDragToolFlags
---@return boolean
---@return number
---@return number
function ImPlot.DragPoint(id, x, y, r, g, b, a, size, flags) end


---@param id integer
---@param x number
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
---@return number
function ImPlot.DragLineX(id, x, r, g, b, a) end

---@param id integer
---@param x number
---@param r number
---@param g number
---@param b number
---@param a number
---@param thickness number
---@return boolean
---@return number
function ImPlot.DragLineX(id, x, r, g, b, a, thickness) end

---@param id integer
---@param x number
---@param r number
---@param g number
---@param b number
---@param a number
---@param thickness number
---@param flags PlotDragToolFlags
---@return boolean
---@return number
function ImPlot.DragLineX(id, x, r, g, b, a, thickness, flags) end


---@param id integer
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
---@return number
function ImPlot.DragLineY(id, y, r, g, b, a) end

---@param id integer
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param thickness number
---@return boolean
---@return number
function ImPlot.DragLineY(id, y, r, g, b, a, thickness) end

---@param id integer
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param thickness number
---@param flags PlotDragToolFlags
---@return boolean
---@return number
function ImPlot.DragLineY(id, y, r, g, b, a, thickness, flags) end


---@param id integer
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param r number
---@param g number
---@param b number
---@param a number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImPlot.DragRect(id, x1, y1, x2, y2, r, g, b, a) end

---@param id integer
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@param r number
---@param g number
---@param b number
---@param a number
---@param flags PlotDragToolFlags
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImPlot.DragRect(id, x1, y1, x2, y2, r, g, b, a, flags) end


---@param x number
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param pix_offset_x number
---@param pix_offset_y number
---@param clamp boolean
function ImPlot.Annotation(x, y, r, g, b, a, pix_offset_x, pix_offset_y, clamp) end

---@param x number
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param pix_offset_x number
---@param pix_offset_y number
---@param clamp boolean
---@param round boolean
function ImPlot.Annotation(x, y, r, g, b, a, pix_offset_x, pix_offset_y, clamp, round) end

---@param x number
---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param pix_offset_x number
---@param pix_offset_y number
---@param clamp boolean
---@param text string
function ImPlot.Annotation(x, y, r, g, b, a, pix_offset_x, pix_offset_y, clamp, text) end


---@param x number
---@param r number
---@param g number
---@param b number
---@param a number
function ImPlot.TagX(x, r, g, b, a) end

---@param x number
---@param r number
---@param g number
---@param b number
---@param a number
---@param round boolean
function ImPlot.TagX(x, r, g, b, a, round) end

---@param x number
---@param r number
---@param g number
---@param b number
---@param a number
---@param text string
function ImPlot.TagX(x, r, g, b, a, text) end


---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
function ImPlot.TagY(y, r, g, b, a) end

---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param round boolean
function ImPlot.TagY(y, r, g, b, a, round) end

---@param y number
---@param r number
---@param g number
---@param b number
---@param a number
---@param text string
function ImPlot.TagY(y, r, g, b, a, text) end


---@param axis Axis
function ImPlot.SetAxis(axis) end


---@param x_axis Axis
---@param y_axis Axis
function ImPlot.SetAxes(x_axis, y_axis) end


---@param x number
---@param y number
---@return number
---@return number
function ImPlot.PixelsToPlot(x, y) end

---@param x number
---@param y number
---@param x_axis Axis
---@return number
---@return number
function ImPlot.PixelsToPlot(x, y, x_axis) end

---@param x number
---@param y number
---@param x_axis Axis
---@param y_axis Axis
---@return number
---@return number
function ImPlot.PixelsToPlot(x, y, x_axis, y_axis) end


---@param x number
---@param y number
---@return number
---@return number
function ImPlot.PlotToPixels(x, y) end

---@param x number
---@param y number
---@param x_axis Axis
---@return number
---@return number
function ImPlot.PlotToPixels(x, y, x_axis) end

---@param x number
---@param y number
---@param x_axis Axis
---@param y_axis Axis
---@return number
---@return number
function ImPlot.PlotToPixels(x, y, x_axis, y_axis) end

---@param plt ImPlot.PlotPoint
---@return number
---@return number
function ImPlot.PlotToPixels(plt) end

---@param plt ImPlot.PlotPoint
---@param x_axis Axis
---@return number
---@return number
function ImPlot.PlotToPixels(plt, x_axis) end

---@param plt ImPlot.PlotPoint
---@param x_axis Axis
---@param y_axis Axis
---@return number
---@return number
function ImPlot.PlotToPixels(plt, x_axis, y_axis) end


---@return number
---@return number
function ImPlot.GetPlotPos() end


---@return number
---@return number
function ImPlot.GetPlotSize() end


---@return number
---@return number
function ImPlot.GetPlotMousePos() end

---@param x_axis Axis
---@return number
---@return number
function ImPlot.GetPlotMousePos(x_axis) end

---@param x_axis Axis
---@param y_axis Axis
---@return number
---@return number
function ImPlot.GetPlotMousePos(x_axis, y_axis) end


---@return ImPlot.PlotRect
function ImPlot.GetPlotLimits() end

---@param x_axis Axis
---@return ImPlot.PlotRect
function ImPlot.GetPlotLimits(x_axis) end

---@param x_axis Axis
---@param y_axis Axis
---@return ImPlot.PlotRect
function ImPlot.GetPlotLimits(x_axis, y_axis) end


---@return boolean
function ImPlot.IsPlotHovered() end


---@param axis Axis
---@return boolean
function ImPlot.IsAxisHovered(axis) end


---@return boolean
function ImPlot.IsSubplotsHovered() end


---@return boolean
function ImPlot.IsPlotSelected() end


---@return ImPlot.PlotRect
function ImPlot.GetPlotSelection() end

---@param x_axis Axis
---@return ImPlot.PlotRect
function ImPlot.GetPlotSelection(x_axis) end

---@param x_axis Axis
---@param y_axis Axis
---@return ImPlot.PlotRect
function ImPlot.GetPlotSelection(x_axis, y_axis) end

---@param x_axis Axis
---@param y_axis Axis
---@return ImPlot.PlotRect
function ImPlot.GetPlotSelection(x_axis, y_axis) end


function ImPlot.CancelPlotSelection() end


function ImPlot.HideNextItem() end

---@param hidden boolean
function ImPlot.HideNextItem(hidden) end

---@param hidden boolean
---@param cond PlotCond
function ImPlot.HideNextItem(hidden, cond) end


---@param group_id string
---@return boolean
function ImPlot.BeginAlignedPlots(group_id) end

---@param group_id string
---@param vertical boolean
---@return boolean
function ImPlot.BeginAlignedPlots(group_id, vertical) end


function ImPlot.EndAlignedPlots() end


---@param label_id string
---@return boolean
function ImPlot.BeginLegendPopup(label_id) end

---@param label_id string
---@param mouse_button MouseButton
---@return boolean
function ImPlot.BeginLegendPopup(label_id, mouse_button) end


function ImPlot.EndLegendPopup() end


---@param label_id string
---@return boolean
function ImPlot.IsLegendEntryHovered(label_id) end


---@return boolean
function ImPlot.BeginDragDropTargetPlot() end


---@param axis Axis
---@return boolean
function ImPlot.BeginDragDropTargetAxis(axis) end


---@return boolean
function ImPlot.BeginDragDropTargetLegend() end


function ImPlot.EndDragDropTarget() end


---@param idx PlotCol
---@param r number
---@param g number
---@param b number
---@param a number
function ImPlot.PushStyleColor(idx, r, g, b, a) end

---@param idx PlotCol
---@param col integer
function ImPlot.PushStyleColor(idx, col) end


function ImPlot.PopStyleColor() end

---@param count integer
function ImPlot.PopStyleColor(count) end


---@param idx PlotStyleVar
---@param val number
function ImPlot.PushStyleVarFloat(idx, val) end


---@param idx PlotStyleVar
---@param val integer
function ImPlot.PushStyleVarInt(idx, val) end


---@param idx PlotStyleVar
---@param x number
---@param y number
function ImPlot.PushStyleVarVec2(idx, x, y) end


function ImPlot.PopStyleVar() end

---@param count integer
function ImPlot.PopStyleVar(count) end


---@param r number?
---@param g number?
---@param b number?
---@param a number?
---@param weight number?
function ImPlot.SetNextLineStyle(r, g, b, a, weight) end


---@param r number?
---@param g number?
---@param b number?
---@param a number?
---@param alpha_mod number?
function ImPlot.SetNextFillStyle(r, g, b, a, alpha_mod) end


---@param marker PlotMarker?
---@param size number?
---@param fill_r number?
---@param fill_g number?
---@param fill_b number?
---@param fill_a number?
---@param weight number?
---@param outline_r number?
---@param outline_g number?
---@param outline_b number?
---@param outline_a number?
function ImPlot.SetNextMarkerStyle(marker, size, fill_r, fill_g, fill_b, fill_a, weight, outline_r, outline_g, outline_b, outline_a) end


---@param r number?
---@param g number?
---@param b number?
---@param a number?
---@param size number?
---@param weight number?
function ImPlot.SetNextErrorBarStyle(r, g, b, a, size, weight) end


---@return number
---@return number
---@return number
---@return number
function ImPlot.GetLastItemColor() end


---@param idx PlotCol
---@return string
function ImPlot.GetStyleColorName(idx) end


---@param idx PlotMarker
---@return string
function ImPlot.GetMarkerName(idx) end


---@param col integer
function ImPlot.ItemIcon(col) end

---@param r number
---@param g number
---@param b number
---@param a number
function ImPlot.ItemIcon(r, g, b, a) end


---@param cmap PlotColormap
function ImPlot.ColormapIcon(cmap) end


function ImPlot.PushPlotClipRect() end

---@param expand number
function ImPlot.PushPlotClipRect(expand) end


function ImPlot.PopPlotClipRect() end


---@param label string
---@return boolean
function ImPlot.ShowStyleSelector(label) end


---@param label string
---@return boolean
function ImPlot.ShowColormapSelector(label) end


---@param label string
---@return boolean
function ImPlot.ShowInputMapSelector(label) end


function ImPlot.ShowUserGuide() end


function ImPlot.ShowMetricsWindow() end

---@param open boolean
---@return boolean
function ImPlot.ShowMetricsWindow(open) end


function ImPlot.ShowDemoWindow() end

---@param open boolean
---@return boolean
function ImPlot.ShowDemoWindow(open) end


---@return boolean
function ImGui.BeginMenuBar() end


function ImGui.EndMenuBar() end


---@return boolean
function ImGui.BeginMainMenuBar() end


function ImGui.EndMainMenuBar() end


---@param label string
---@return boolean
function ImGui.BeginMenu(label) end

---@param label string
---@param enabled boolean
---@return boolean
function ImGui.BeginMenu(label, enabled) end


function ImGui.EndMenu() end


---@param label string
---@return boolean
function ImGui.MenuItem(label) end

---@param label string
---@param shortcut string
---@return boolean
function ImGui.MenuItem(label, shortcut) end

---@param label string
---@param shortcut string
---@param selected boolean
---@return boolean
---@return boolean
function ImGui.MenuItem(label, shortcut, selected) end

---@param label string
---@param shortcut string
---@param selected boolean
---@param enabled boolean
---@return boolean
---@return boolean
function ImGui.MenuItem(label, shortcut, selected, enabled) end


---@enum PopupFlags
ImGui.PopupFlags = {
    None = 0,
    MouseButtonLeft = 0,
    MouseButtonRight = 1,
    MouseButtonMiddle = 2,
    MouseButtonMask_ = 31,
    MouseButtonDefault_ = 1,
    NoOpenOverExistingPopup = 32,
    NoOpenOverItems = 64,
    AnyPopupId = 128,
    AnyPopupLevel = 256,
    AnyPopup = 384,
}


---@param str_id string
---@return boolean
function ImGui.BeginPopup(str_id) end

---@param str_id string
---@param flags WindowFlags
---@return boolean
function ImGui.BeginPopup(str_id, flags) end


---@param str_id string
---@return boolean
function ImGui.BeginPopupModal(str_id) end

---@param str_id string
---@param open boolean
---@return boolean
---@return boolean
function ImGui.BeginPopupModal(str_id, open) end

---@param str_id string
---@param open boolean
---@param flags WindowFlags
---@return boolean
---@return boolean
function ImGui.BeginPopupModal(str_id, open, flags) end


function ImGui.EndPopup() end


---@param str_id string
function ImGui.OpenPopup(str_id) end

---@param str_id string
---@param popup_flags PopupFlags
function ImGui.OpenPopup(str_id, popup_flags) end

---@param id integer
function ImGui.OpenPopup(id) end

---@param id integer
---@param popup_flags PopupFlags
function ImGui.OpenPopup(id, popup_flags) end


function ImGui.OpenPopupOnItemClick() end

---@param str_id string
function ImGui.OpenPopupOnItemClick(str_id) end

---@param str_id string
---@param popup_flags PopupFlags
function ImGui.OpenPopupOnItemClick(str_id, popup_flags) end


function ImGui.CloseCurrentPopup() end


---@return boolean
function ImGui.BeginPopupContextItem() end

---@param str_id string
---@return boolean
function ImGui.BeginPopupContextItem(str_id) end

---@param str_id string
---@param popup_flags PopupFlags
---@return boolean
function ImGui.BeginPopupContextItem(str_id, popup_flags) end


---@return boolean
function ImGui.BeginPopupContextWindow() end

---@param str_id string
---@return boolean
function ImGui.BeginPopupContextWindow(str_id) end

---@param str_id string
---@param popup_flags PopupFlags
---@return boolean
function ImGui.BeginPopupContextWindow(str_id, popup_flags) end


---@return boolean
function ImGui.BeginPopupContextVoid() end

---@param str_id string
---@return boolean
function ImGui.BeginPopupContextVoid(str_id) end

---@param str_id string
---@param popup_flags PopupFlags
---@return boolean
function ImGui.BeginPopupContextVoid(str_id, popup_flags) end


---@param str_id string
---@return boolean
function ImGui.IsPopupOpen(str_id) end

---@param str_id string
---@param flags PopupFlags
---@return boolean
function ImGui.IsPopupOpen(str_id, flags) end


---@enum MouseButton
ImGui.MouseButton = {
    Left = 0,
    Right = 1,
    Middle = 2,
    COUNT = 5,
}


---@param button MouseButton
---@return boolean
function ImGui.IsMouseDown(button) end


---@param button MouseButton
---@return boolean
function ImGui.IsMouseClicked(button) end

---@param button MouseButton
---@param repeat_ boolean
---@return boolean
function ImGui.IsMouseClicked(button, repeat_) end


---@param button MouseButton
---@return boolean
function ImGui.IsMouseReleased(button) end


---@param button MouseButton
---@return boolean
function ImGui.IsMouseDoubleClicked(button) end


---@param button MouseButton
---@return integer
function ImGui.GetMouseClickedCount(button) end


---@return boolean
function ImGui.IsMousePosValid() end

---@param posx number
---@param posy number
---@return boolean
function ImGui.IsMousePosValid(posx, posy) end


---@return number
---@return number
function ImGui.GetMousePos() end


---@return number
---@return number
function ImGui.GetMousePosOnOpeningCurrentPopup() end


---@param button MouseButton
---@return boolean
function ImGui.IsMouseDragging(button) end

---@param button MouseButton
---@param lock_threshold number
---@return boolean
function ImGui.IsMouseDragging(button, lock_threshold) end


---@return number
---@return number
function ImGui.GetMouseDragDelta() end

---@param button MouseButton
---@return number
---@return number
function ImGui.GetMouseDragDelta(button) end

---@param button MouseButton
---@param lock_threshold number
---@return number
---@return number
function ImGui.GetMouseDragDelta(button, lock_threshold) end


function ImGui.ResetMouseDragDelta() end

---@param button MouseButton
function ImGui.ResetMouseDragDelta(button) end


---@enum MouseCursor
ImGui.MouseCursor = {
    None = -1,
    Arrow = 0,
    TextInput = 1,
    ResizeAll = 2,
    ResizeNS = 3,
    ResizeEW = 4,
    ResizeNESW = 5,
    ResizeNWSE = 6,
    Hand = 7,
    NotAllowed = 8,
    COUNT = 9,
}


---@return MouseCursor
function ImGui.GetMouseCursor() end


---@param cursor_type MouseCursor
function ImGui.SetMouseCursor(cursor_type) end


---@param want_capture_mouse boolean
function ImGui.SetNextFrameWantCaptureMouse(want_capture_mouse) end


---@param str_id string
function ImGui.PushID(str_id) end

---@param int_id integer
function ImGui.PushID(int_id) end


function ImGui.PopID() end


---@param str_id string
---@return integer
function ImGui.GetID(str_id) end


---@param font_index integer
---@return ImGui.Font
function ImGui.GetFontIndex(font_index) end


---@return ImGui.Font
function ImGui.GetNoitaFont() end


---@return ImGui.Font
function ImGui.GetNoitaFont1_4x() end


---@return ImGui.Font
function ImGui.GetNoitaFont1_8x() end


---@return ImGui.Font
function ImGui.GetImGuiFont() end


---@param font ImGui.Font
function ImGui.PushFont(font) end


function ImGui.PopFont() end


---@return number
function ImGui.GetFontSize() end


---@enum SliderFlags
ImGui.SliderFlags = {
    None = 0,
    AlwaysClamp = 16,
    Logarithmic = 32,
    NoRoundToFormat = 64,
    NoInput = 128,
    InvalidMask_ = 1879048207,
}


---@param label string
---@param v number
---@return boolean
---@return number
function ImGui.DragFloat(label, v) end

---@param label string
---@param v number
---@param v_speed number
---@return boolean
---@return number
function ImGui.DragFloat(label, v, v_speed) end

---@param label string
---@param v number
---@param v_speed number
---@param v_min number
---@return boolean
---@return number
function ImGui.DragFloat(label, v, v_speed, v_min) end

---@param label string
---@param v number
---@param v_speed number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
function ImGui.DragFloat(label, v, v_speed, v_min, v_max) end

---@param label string
---@param v number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
function ImGui.DragFloat(label, v, v_speed, v_min, v_max, format) end

---@param label string
---@param v number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
function ImGui.DragFloat(label, v, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@return boolean
---@return number
---@return number
function ImGui.DragFloat2(label, v1, v2) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_speed number
---@return boolean
---@return number
---@return number
function ImGui.DragFloat2(label, v1, v2, v_speed) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_speed number
---@param v_min number
---@return boolean
---@return number
---@return number
function ImGui.DragFloat2(label, v1, v2, v_speed, v_min) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
function ImGui.DragFloat2(label, v1, v2, v_speed, v_min, v_max) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
function ImGui.DragFloat2(label, v1, v2, v_speed, v_min, v_max, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
function ImGui.DragFloat2(label, v1, v2, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.DragFloat3(label, v1, v2, v3) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.DragFloat3(label, v1, v2, v3, v_speed) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed number
---@param v_min number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.DragFloat3(label, v1, v2, v3, v_speed, v_min) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.DragFloat3(label, v1, v2, v3, v_speed, v_min, v_max) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
---@return number
function ImGui.DragFloat3(label, v1, v2, v3, v_speed, v_min, v_max, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
---@return number
function ImGui.DragFloat3(label, v1, v2, v3, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.DragFloat4(label, v1, v2, v3, v4) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.DragFloat4(label, v1, v2, v3, v4, v_speed) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed number
---@param v_min number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.DragFloat4(label, v1, v2, v3, v4, v_speed, v_min) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.DragFloat4(label, v1, v2, v3, v4, v_speed, v_min, v_max) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.DragFloat4(label, v1, v2, v3, v4, v_speed, v_min, v_max, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.DragFloat4(label, v1, v2, v3, v4, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v_current_min number
---@param v_current_max number
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max) end

---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed number
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max, v_speed) end

---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed number
---@param v_min number
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min) end

---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max) end

---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format) end

---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@param format_max string
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max) end

---@param label string
---@param v_current_min number
---@param v_current_max number
---@param v_speed number
---@param v_min number
---@param v_max number
---@param format string
---@param format_max string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
function ImGui.DragFloatRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags) end


---@param label string
---@param v integer
---@return boolean
---@return integer
function ImGui.DragInt(label, v) end

---@param label string
---@param v integer
---@param v_speed number
---@return boolean
---@return integer
function ImGui.DragInt(label, v, v_speed) end

---@param label string
---@param v integer
---@param v_speed number
---@param v_min integer
---@return boolean
---@return integer
function ImGui.DragInt(label, v, v_speed, v_min) end

---@param label string
---@param v integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
function ImGui.DragInt(label, v, v_speed, v_min, v_max) end

---@param label string
---@param v integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
function ImGui.DragInt(label, v, v_speed, v_min, v_max, format) end

---@param label string
---@param v integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
function ImGui.DragInt(label, v, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@return boolean
---@return integer
---@return integer
function ImGui.DragInt2(label, v1, v2) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_speed number
---@return boolean
---@return integer
---@return integer
function ImGui.DragInt2(label, v1, v2, v_speed) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_speed number
---@param v_min integer
---@return boolean
---@return integer
---@return integer
function ImGui.DragInt2(label, v1, v2, v_speed, v_min) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
function ImGui.DragInt2(label, v1, v2, v_speed, v_min, v_max) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
function ImGui.DragInt2(label, v1, v2, v_speed, v_min, v_max, format) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
function ImGui.DragInt2(label, v1, v2, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.DragInt3(label, v1, v2, v3) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_speed number
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.DragInt3(label, v1, v2, v3, v_speed) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_speed number
---@param v_min integer
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.DragInt3(label, v1, v2, v3, v_speed, v_min) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.DragInt3(label, v1, v2, v3, v_speed, v_min, v_max) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.DragInt3(label, v1, v2, v3, v_speed, v_min, v_max, format) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.DragInt3(label, v1, v2, v3, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.DragInt4(label, v1, v2, v3, v4) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_speed number
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.DragInt4(label, v1, v2, v3, v4, v_speed) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_speed number
---@param v_min integer
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.DragInt4(label, v1, v2, v3, v4, v_speed, v_min) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.DragInt4(label, v1, v2, v3, v4, v_speed, v_min, v_max) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.DragInt4(label, v1, v2, v3, v4, v_speed, v_min, v_max, format) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.DragInt4(label, v1, v2, v3, v4, v_speed, v_min, v_max, format, flags) end


---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max) end

---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@param v_speed number
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max, v_speed) end

---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@param v_speed number
---@param v_min integer
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min) end

---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max) end

---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format) end

---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@param format_max string
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max) end

---@param label string
---@param v_current_min integer
---@param v_current_max integer
---@param v_speed number
---@param v_min integer
---@param v_max integer
---@param format string
---@param format_max string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
function ImGui.DragIntRange2(label, v_current_min, v_current_max, v_speed, v_min, v_max, format, format_max, flags) end


---@enum Dir
ImGui.Dir = {
    None = -1,
    Left = 0,
    Right = 1,
    Up = 2,
    Down = 3,
    COUNT = 4,
}


---@return ImGui.Style
function ImGui.GetStyle() end


---@return integer
function ImGui.GetMainViewportID() end


---@return number
---@return number
function ImGui.GetMainViewportWorkPos() end


---@return number
---@return number
function ImGui.GetMainViewportPos() end


---@return number
---@return number
function ImGui.GetMainViewportSize() end


---@return number
---@return number
function ImGui.GetMainViewportWorkSize() end


---@enum DragDropFlags
ImGui.DragDropFlags = {
    None = 0,
    SourceNoPreviewTooltip = 1,
    SourceNoDisableHover = 2,
    SourceNoHoldToOpenOthers = 4,
    SourceAllowNullID = 8,
    SourceExtern = 16,
    SourceAutoExpirePayload = 32,
    AcceptBeforeDelivery = 1024,
    AcceptNoDrawDefaultRect = 2048,
    AcceptNoPreviewTooltip = 4096,
    AcceptPeekOnly = 3072,
}


---@return boolean
function ImGui.BeginDragDropSource() end

---@param flags DragDropFlags
---@return boolean
function ImGui.BeginDragDropSource(flags) end


---@param type string
---@param payload any
---@return boolean
function ImGui.SetDragDropPayload(type, payload) end

---@param type string
---@param payload any
---@param cond Cond
---@return boolean
function ImGui.SetDragDropPayload(type, payload, cond) end


function ImGui.EndDragDropSource() end


---@param type string
---@return any
function ImGui.AcceptDragDropPayload(type) end

---@param type string
---@param flags DragDropFlags
---@return any
function ImGui.AcceptDragDropPayload(type, flags) end


---@return boolean
function ImGui.BeginDragDropTarget() end


function ImGui.EndDragDropTarget() end


---@return any
function ImGui.GetDragDropPayload() end


function ImGui.BeginDisabled() end

---@param disabled boolean
function ImGui.BeginDisabled(disabled) end


function ImGui.EndDisabled() end


function ImGui.Separator() end


function ImGui.SameLine() end

---@param offset_from_start_x number
function ImGui.SameLine(offset_from_start_x) end

---@param offset_from_start_x number
---@param spacing number
function ImGui.SameLine(offset_from_start_x, spacing) end


function ImGui.NewLine() end


function ImGui.Spacing() end


---@param size_x number
---@param size_y number
function ImGui.Dummy(size_x, size_y) end


function ImGui.Indent() end

---@param indent_w number
function ImGui.Indent(indent_w) end


function ImGui.Unindent() end

---@param indent_w number
function ImGui.Unindent(indent_w) end


function ImGui.BeginGroup() end


function ImGui.EndGroup() end


---@return number
---@return number
function ImGui.GetCursorPos() end


---@return number
function ImGui.GetCursorPosX() end


---@return number
function ImGui.GetCursorPosY() end


---@param local_pos_x number
---@param local_pos_y number
function ImGui.SetCursorPos(local_pos_x, local_pos_y) end


---@param local_x number
function ImGui.SetCursorPosX(local_x) end


---@param local_y number
function ImGui.SetCursorPosY(local_y) end


---@return number
---@return number
function ImGui.GetCursorStartPos() end


---@return number
---@return number
function ImGui.GetCursorScreenPos() end


---@param size_x number
---@param size_y number
function ImGui.SetCursorScreenPos(size_x, size_y) end


function ImGui.AlignTextToFramePadding() end


---@return number
function ImGui.GetTextLineHeight() end


---@return number
function ImGui.GetTextLineHeightWithSpacing() end


---@return number
function ImGui.GetFrameHeight() end


---@return number
function ImGui.GetFrameHeightWithSpacing() end


---@param label string
---@param v number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
function ImGui.SliderFloat(label, v, v_min, v_max) end

---@param label string
---@param v number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
function ImGui.SliderFloat(label, v, v_min, v_max, format) end

---@param label string
---@param v number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
function ImGui.SliderFloat(label, v, v_min, v_max, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
function ImGui.SliderFloat2(label, v1, v2, v_min, v_max) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
function ImGui.SliderFloat2(label, v1, v2, v_min, v_max, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
function ImGui.SliderFloat2(label, v1, v2, v_min, v_max, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
---@return number
function ImGui.SliderFloat3(label, v1, v2, v3, v_min, v_max) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
---@return number
function ImGui.SliderFloat3(label, v1, v2, v3, v_min, v_max, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
---@return number
function ImGui.SliderFloat3(label, v1, v2, v3, v_min, v_max, format, flags) end


---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_min number
---@param v_max number
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.SliderFloat4(label, v1, v2, v3, v4, v_min, v_max) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_min number
---@param v_max number
---@param format string
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.SliderFloat4(label, v1, v2, v3, v4, v_min, v_max, format) end

---@param label string
---@param v1 number
---@param v2 number
---@param v3 number
---@param v4 number
---@param v_min number
---@param v_max number
---@param format string
---@param flags SliderFlags
---@return boolean
---@return number
---@return number
---@return number
---@return number
function ImGui.SliderFloat4(label, v1, v2, v3, v4, v_min, v_max, format, flags) end


---@param label string
---@param v integer
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
function ImGui.SliderInt(label, v, v_min, v_max) end

---@param label string
---@param v integer
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
function ImGui.SliderInt(label, v, v_min, v_max, format) end

---@param label string
---@param v integer
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
function ImGui.SliderInt(label, v, v_min, v_max, format, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
function ImGui.SliderInt2(label, v1, v2, v_min, v_max) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
function ImGui.SliderInt2(label, v1, v2, v_min, v_max, format) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
function ImGui.SliderInt2(label, v1, v2, v_min, v_max, format, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.SliderInt3(label, v1, v2, v3, v_min, v_max) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.SliderInt3(label, v1, v2, v3, v_min, v_max, format) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
---@return integer
function ImGui.SliderInt3(label, v1, v2, v3, v_min, v_max, format, flags) end


---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_min integer
---@param v_max integer
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.SliderInt4(label, v1, v2, v3, v4, v_min, v_max) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_min integer
---@param v_max integer
---@param format string
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.SliderInt4(label, v1, v2, v3, v4, v_min, v_max, format) end

---@param label string
---@param v1 integer
---@param v2 integer
---@param v3 integer
---@param v4 integer
---@param v_min integer
---@param v_max integer
---@param format string
---@param flags SliderFlags
---@return boolean
---@return integer
---@return integer
---@return integer
---@return integer
function ImGui.SliderInt4(label, v1, v2, v3, v4, v_min, v_max, format, flags) end


---@param text string
function ImGui.TextUnformatted(text) end


---@param text string
function ImGui.Text(text) end


---@param colr number
---@param colg number
---@param colb number
---@param cola number
---@param text string
function ImGui.TextColored(colr, colg, colb, cola, text) end


---@param text string
function ImGui.TextDisabled(text) end


---@param text string
function ImGui.TextWrapped(text) end


---@param label string
---@param text string
function ImGui.LabelText(label, text) end


---@param text string
function ImGui.BulletText(text) end


---@enum Key
ImGui.Key = {
    None = 0,
    Tab = 512,
    LeftArrow = 513,
    RightArrow = 514,
    UpArrow = 515,
    DownArrow = 516,
    PageUp = 517,
    PageDown = 518,
    Home = 519,
    End = 520,
    Insert = 521,
    Delete = 522,
    Backspace = 523,
    Space = 524,
    Enter = 525,
    Escape = 526,
    LeftCtrl = 527,
    LeftShift = 528,
    LeftAlt = 529,
    LeftSuper = 530,
    RightCtrl = 531,
    RightShift = 532,
    RightAlt = 533,
    RightSuper = 534,
    Menu = 535,
    _0 = 536,
    _1 = 537,
    _2 = 538,
    _3 = 539,
    _4 = 540,
    _5 = 541,
    _6 = 542,
    _7 = 543,
    _8 = 544,
    _9 = 545,
    A = 546,
    B = 547,
    C = 548,
    D = 549,
    E = 550,
    F = 551,
    G = 552,
    H = 553,
    I = 554,
    J = 555,
    K = 556,
    L = 557,
    M = 558,
    N = 559,
    O = 560,
    P = 561,
    Q = 562,
    R = 563,
    S = 564,
    T = 565,
    U = 566,
    V = 567,
    W = 568,
    X = 569,
    Y = 570,
    Z = 571,
    F1 = 572,
    F2 = 573,
    F3 = 574,
    F4 = 575,
    F5 = 576,
    F6 = 577,
    F7 = 578,
    F8 = 579,
    F9 = 580,
    F10 = 581,
    F11 = 582,
    F12 = 583,
    Apostrophe = 584,
    Comma = 585,
    Minus = 586,
    Period = 587,
    Slash = 588,
    Semicolon = 589,
    Equal = 590,
    LeftBracket = 591,
    Backslash = 592,
    RightBracket = 593,
    GraveAccent = 594,
    CapsLock = 595,
    ScrollLock = 596,
    NumLock = 597,
    PrintScreen = 598,
    Pause = 599,
    Keypad0 = 600,
    Keypad1 = 601,
    Keypad2 = 602,
    Keypad3 = 603,
    Keypad4 = 604,
    Keypad5 = 605,
    Keypad6 = 606,
    Keypad7 = 607,
    Keypad8 = 608,
    Keypad9 = 609,
    KeypadDecimal = 610,
    KeypadDivide = 611,
    KeypadMultiply = 612,
    KeypadSubtract = 613,
    KeypadAdd = 614,
    KeypadEnter = 615,
    KeypadEqual = 616,
    GamepadStart = 617,
    GamepadBack = 618,
    GamepadFaceLeft = 619,
    GamepadFaceRight = 620,
    GamepadFaceUp = 621,
    GamepadFaceDown = 622,
    GamepadDpadLeft = 623,
    GamepadDpadRight = 624,
    GamepadDpadUp = 625,
    GamepadDpadDown = 626,
    GamepadL1 = 627,
    GamepadR1 = 628,
    GamepadL2 = 629,
    GamepadR2 = 630,
    GamepadL3 = 631,
    GamepadR3 = 632,
    GamepadLStickLeft = 633,
    GamepadLStickRight = 634,
    GamepadLStickUp = 635,
    GamepadLStickDown = 636,
    GamepadRStickLeft = 637,
    GamepadRStickRight = 638,
    GamepadRStickUp = 639,
    GamepadRStickDown = 640,
    MouseLeft = 641,
    MouseRight = 642,
    MouseMiddle = 643,
    MouseX1 = 644,
    MouseX2 = 645,
    MouseWheelX = 646,
    MouseWheelY = 647,
    COUNT = 652,
    ModCtrl = 4096,
    ModShift = 8192,
    ModAlt = 16384,
    ModSuper = 32768,
    KeyPadEnter = 615,
}


---@enum Mod
ImGui.Mod = {
    None = 0,
    Ctrl = 4096,
    Shift = 8192,
    Alt = 16384,
    Super = 32768,
    Shortcut = 2048,
    Mask_ = 63488,
}


---@param key Key
---@return boolean
function ImGui.IsKeyDown(key) end


---@param key Key
---@return boolean
function ImGui.IsKeyPressed(key) end

---@param key Key
---@param repeat_ boolean
---@return boolean
function ImGui.IsKeyPressed(key, repeat_) end


---@param key Key
---@return boolean
function ImGui.IsKeyReleased(key) end


---@param key Key
---@param repeat_delay number
---@param rate number
---@return integer
function ImGui.GetKeyPressedAmount(key, repeat_delay, rate) end


---@param key Key
---@return string
function ImGui.GetKeyName(key) end


---@param want_capture_keyboard boolean
function ImGui.SetNextFrameWantCaptureKeyboard(want_capture_keyboard) end


---@param allow_keyboard_focus boolean
function ImGui.PushAllowKeyboardFocus(allow_keyboard_focus) end


function ImGui.PopAllowKeyboardFocus() end


function ImGui.SetKeyboardFocusHere() end

---@param offset integer
function ImGui.SetKeyboardFocusHere(offset) end
