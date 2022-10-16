local json        = require("dkjson")
local lfs         = require("lfs")

local plotly      = {}

plotly.cdn_main   = "<script src='https://cdn.plot.ly/plotly-2.16.0.min.js'></script>"
plotly.header     = ""
plotly.body       = ""
plotly.id_count   = 1
plotly.sleep_time = 1

---Converts a set of figures to an HTML string
---@param figues table
---@return string
function plotly.tohtml(figues)
    -- Create header tags
    header = "<head>\n" .. plotly.cdn_main .. "\n" .. plotly.header .. "\n" .. "\n</head>\n"

    -- Create body tags
    plots  = ""
    for i, fig in pairs(figues) do
        plots = plots .. fig:toplotstring()
    end

    return header .. "<body>\n" .. plots .. "</body>"
end

---Saves a set of figures to filename
---@param filename string
---@param figures table
function plotly.tofile(filename, figures)
    html_str = plotly.tohtml(figures)
    file     = io.open(filename, "w")
    file:write(html_str)
    file:close()
end

---Shows a set of figures in the browser
---@param figures table
function plotly.show(figures)
    filename = "_temp.html"
    plotly.tofile(filename, figures)
    open_url(filename)
    if filename == "_temp.html" then
        sleep(plotly.sleep_time)
        os.remove(filename)
    end
end

function sleep (a)
    local sec = tonumber(os.clock() + a)
    while (os.clock() < sec) do
    end
end

-- From: https://stackoverflow.com/questions/11163748/open-web-browser-using-lua-in-a-vlc-extension#18864453
-- Attempts to open a given URL in the system default browser, regardless of Operating System.
local open_cmd -- this needs to stay outside the function, or it'll re-sniff every time...
function open_url(url)
    if not open_cmd then
        if package.config:sub(1, 1) == '\\' then
            -- windows
            open_cmd = function(url)
                -- Should work on anything since (and including) win'95
                os.execute(string.format('start "%s"', url))
            end
            -- the only systems left should understand uname...
        elseif (io.popen("uname -s"):read '*a') == "Darwin" then
            -- OSX/Darwin ? (I can not test.)
            open_cmd = function(url)
                -- I cannot test, but this should work on modern Macs.
                os.execute(string.format('open "%s"', url))
            end
        else
            -- that ought to only leave Linux
            open_cmd = function(url)
                -- should work on X-based distros.
                os.execute(string.format('xdg-open "%s"', url))
            end
        end
    end

    open_cmd(url)
end

---Checks if a file exists.
function exists(path)
    return os.rename(path, path) and true or false
end

---Counts the size of a table.
function size(T)
    -- https://stackoverflow.com/a/64882015/3493998
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

--- https://fhug.org.uk/kb/code-snippet/split-a-filename-into-path-file-and-extension/#ftoc-heading-4
---@param strFilename string C:\users\documents\myfile.txt will return 3 variables as follows:
---@return string C:\users\documents\
---@return string myfile.txt
---@return string txt
function splitFilename(strFilename)
    -- Returns the Path, Filename, and Extension as 3 values
    if lfs.attributes(strFilename, "mode") == "directory" then
        local strPath = strFilename:gsub("[\\/]$", "")
        return strPath .. "\\", "", ""
    end
    strFilename = strFilename .. "."
    return strFilename:match("^(.-)([^\\/]-%.([^\\/%.]-))%.?$")
end

-- Figure metatable
local figure = {}

---Adding a trace for the figure. All options can be found here: https://plotly.com/javascript/reference/index/
---Easy to call like: figure:add_trace{x=x, y=y, ...}
---@param self table
---@param trace table
function figure.add_trace(self, trace)
    self["data"][#self["data"] + 1] = trace
end

local dash_style     = { ["-"] = "solid", [":"] = "dot", ["--"] = "dash" }
local mode_shorthand = { ["m"] = "markers", ["l"] = "lines", ["m+l"] = "lines+markers", ["l+m"] = "lines+markers" }


--[[Adding a trace for the figure with shorthand for common options (similar to matlab or matplotlib).   
All js options can be found here: https://plotly.com/javascript/reference/index/  
Easy to call like: figure:plot{x, y, ...}  
Shorthand options:  
| key | explanation |
| :----: | :---------: |
| *1* | x-values  |
| *2* | y-values   |
| *ls* | line-style (options: "-", ".", "--")  |
| *lw* | line-width (numeric value - default 2) |
| *ms* | marker-size (numeric value - default 2) |
| *c* or *color* | sets color of line and marker |
| *mode* | shorter mode forms (options: "m"="markers", "l"="lines", "m+l" or "l+m"="markers+lines") |
| *title* | sets/updates the title of the figure |
| *xlabel* | sets/updates the xlabel of the figure |
| *ylabel* | sets/updates the ylabel of the figure |
]]
---@param self plotly.figure
---@param trace table
---@return plotly.figure
function figure.plot(self, trace)
    if not trace["line"] then
        trace["line"] = {}
    end
    if not trace["marker"] then
        trace["marker"] = {}
    end
    local layout = {}
    for name, val in pairs(trace) do
        if name == "ls" then
            trace["line"]["dash"] = dash_style[val]
            trace[name]           = nil
        elseif name == "lw" then
            trace["line"]["width"] = val
            trace[name]            = nil
        elseif name == "title" then
            layout["title"] = val
            trace[name]     = nil
        elseif name == 1 then
            trace["x"]  = val
            trace[name] = nil
        elseif name == 2 then
            trace["y"]  = val
            trace[name] = nil
        elseif name == "ms" then
            trace["marker"]["size"] = val
            trace[name]             = nil
        elseif name == "c" or name == "color" then
            trace["marker"]["color"] = val
            trace["line"]["color"]   = val
            trace[name]              = nil
        elseif name == "mode" and mode_shorthand[val] then
            trace["mode"] = mode_shorthand[val]
        elseif name == "xlabel" then
            layout["xaxis"] = { title = { text = val } }
            trace[name]     = nil
        elseif name == "ylabel" then
            layout["yaxis"] = { title = { text = val } }
            trace[name]     = nil
        end
    end
    self:add_trace(trace)
    self:update_layout(layout)
    return self
end

---Updates the plotly figure layout (options can be seen here: https://plotly.com/javascript/reference/layout/)
---@param self table
---@param layout table
function figure.update_layout(self, layout)
    for name, val in pairs(layout) do
        self["layout"][name] = val
    end
end

---Updates the plotly figure config (options can be seen here: https://plotly.com/javascript/configuration-options/)
---@param self table
---@param config table
function figure.update_config(self, config)
    for name, val in pairs(config) do
        self["config"][name] = val
    end
end

function figure.toplotstring(self)
    -- Converting input
    data_str   = json.encode(self["data"])
    layout_str = json.encode(self["layout"])
    config_str = json.encode(self["config"])
    if not self.div_id then
        div_id = "plot" .. plotly.id_count
    end
    plotly.id_count = plotly.id_count + 1
    -- Creating string
    plot            = [[<div id='%s'></div>
    <script type="text/javascript">
    var data = %s
    var layout = %s
    var config = %s
    Plotly.newPlot(%s, data, layout, config);
    </script>
    ]]
    plot            = string.format(plot, div_id, data_str, layout_str, config_str, div_id)
    return plot
end

---Creates the necessary html code to display the plotly figure in a browser, when loading JSON from files.
---@param self table
---@param output_absolute_json_directory_path string absolute directory path, where the json files are located. (default: "jsons")
function figure.toplotstringwithjsondatafiles(self, output_absolute_json_directory_path)
    layout_str = json.encode(self["layout"])
    config_str = json.encode(self["config"])

    if not self.div_id then
        div_id = "plot" .. plotly.id_count
    end

    plotly.id_count = plotly.id_count + 1
    plot            = string.format([[  <div id='%s'></div>
    ]], div_id)

    plot            = plot .. [[
    <script type="text/javascript">
      var data = [];
    ]]

    for jsonfile in lfs.dir(output_absolute_json_directory_path) do
        local jsonfilepath = output_absolute_json_directory_path .. "/" .. jsonfile
        if lfs.attributes(jsonfilepath, "mode") == "file" then
            local dir, filename, extension = splitFilename(jsonfile)
            plot                           = plot .. string.format([[
            data.push(%s);
            ]], filename:gsub("%.js",""))
        end
    end

    plot = plot .. [[
    var layout = %s;
    var config = %s;
    Plotly.newPlot(%s, data, layout, config);
  </script>
    ]]

    plot = string.format(plot, layout_str, config_str, div_id)
    return plot
end

function figure.tohtmlstring(self)
    -- Create header tags
    header = "<head>\n" .. plotly.cdn_main .. "\n" .. plotly.header .. "\n</head>\n"

    -- Create body tags
    plot   = self:toplotstring()

    return header .. "<body>\n" .. plot .. "</body>"
end

---Writes the plotly figure to a html file and loads the data from a JSON file with *jsondatafilename*
---@param self table
---@param output_absolute_json_directory_path string absolute directory path, where the json files are located. (default: "../../../jsons")
---@param output_json_directory string directory name, where the json files are located. (default: "jsons")
function figure.tohtmlstringwithjsondatafile(self, output_absolute_json_directory_path, output_json_directory)
    -- Create header tags
    header = "<head>\n" .. plotly.cdn_main .. "\n" .. plotly.header

    for jsonfile in lfs.dir(output_absolute_json_directory_path) do
        local jsonfilepath = output_absolute_json_directory_path .. "/" .. jsonfile
        if lfs.attributes(jsonfilepath, "mode") == "file" then
            header = header .. string.format([[
      <script src='./%s/%s'></script>
    ]], output_json_directory, jsonfile)
        end
    end

    header = header .. "\n</head>\n"

    -- Create body tags
    plot   = self:toplotstringwithjsondatafiles(output_absolute_json_directory_path)

    return header .. "<body>\n" .. plot .. "</body>"
end

---Saves the figure to an HTML file with *filename*
---@param self table
---@param filename string
function figure.tofile(self, filename)
    html_str = self:tohtmlstring()
    file     = io.open(filename, "w")
    file:write(html_str)
    file:close()
    return self
end

---Saves the figure to an HTML file with *outputfilename* and loads the data from a JSON file with *jsondatadirectory*
---@param self table
---@param output_filename string filename of the report html file.
---@param output_root_directory string root directory path, where {output_filename}.html is located.
---@param output_json_directory string optional: relative directory path, where the json files are located. (default: "jsons")
function figure.tofilewithjsondatafile(self, output_filename, output_root_directory, output_json_directory)
    if not exists(output_root_directory) then
        local success, error_message = lfs.mkdir(output_root_directory)
        if not success then
            print(error_message)
        end
    end

    if not output_json_directory then
        output_json_directory = "jsons"
    end
    local output_absolute_json_directory_path = output_root_directory .. "/" .. output_json_directory
    if not exists(output_absolute_json_directory_path) then
        success, error_message = lfs.mkdir(output_absolute_json_directory_path)
        if not success then
            print(error_message)
        end
    end

    html_str = self:tohtmlstringwithjsondatafile(output_absolute_json_directory_path, output_json_directory)
    file     = io.open(output_filename, "w")
    file:write(html_str)
    file:close()
    return self
end

---Saves the trace data to a JSON file with its trace name.
---@param self table
---@param trace table
---@param output_root_directory string root directory path, where {output_filename}.html is located.
---@param output_json_directory string optional: relative directory path, where the json files are located. (default: "jsons")
function figure.write_trace_to_file(self, trace, output_root_directory, output_json_directory)
    if not exists(output_root_directory) then
        local success, error_message = lfs.mkdir(output_root_directory)
        if not success then
            print(error_message)
        end
    end

    if output_json_directory then
        output_json_directory = output_root_directory .. "/" .. output_json_directory
    else
        output_json_directory = output_root_directory .. "/jsons"
    end
    if not exists(output_json_directory) then
        success, error_message = lfs.mkdir(output_json_directory)
        if not success then
            print(error_message)
        end
    end

    local trace_name     = trace["name"]:gsub('[%p%c%s]', '')
    --local trace_size     = size(trace.x)
    --if trace_size > 0 then
    --    trace_name = trace_name .. trace.x[trace_size]
    --else
    --    trace_name = trace_name .. "0"
    --end

    local outputfilename = output_json_directory .. "/" .. trace_name .. ".js"
    if not exists(outputfilename) then
        local content = "var " .. trace_name .. " = " .. json.encode(trace) .. ";"
        file          = io.open(outputfilename, "w")
        file:write(content)
        file:close()
    else
        local handle = io.popen("echo " .. trace_name .. ".x.push(..." .. json.encode(trace.x) .. "); >> \"" .. outputfilename .. "\"")
        local result = handle:read("*a")
        handle:close()
        print(result)

        handle = io.popen("echo " .. trace_name .. ".y.push(..." .. json.encode(trace.y) .. "); >> \"" .. outputfilename .. "\"")
        result = handle:read("*a")
        handle:close()
        print(result)
    end

    return self
end

---Opens/shows the plot in the browser
---@param self plotly.figure
function figure.show(self)
    filename = "_temp.html"
    self:tofile(filename)
    open_url(filename)
    if filename == "_temp.html" then
        sleep(plotly.sleep_time)
        os.remove(filename)
    end
end


-- Assigning functions
function plotly.figure()
    local fig = { data = {}, layout = {}, config = {} }
    setmetatable(fig, { __index = figure })
    return fig
end

--[[Adding a trace for the figure with shorthand for common options (similar to matlab or matplotlib).   
All js options can be found here: https://plotly.com/javascript/reference/index/  
Easy to call like: plotly.plot{x, y, ...}  
Shorthand options:  
| key | explanation |
| :----: | :---------: |
| *1* | x-values  |
| *2* | y-values   |
| *ls* | line-style (options: "-", ".", "--")  |
| *lw* | line-width (numeric value - default 2) |
| *ms* | marker-size (numeric value - default 2) |
| *c* or *color* | sets color of line and marker |
| *mode* | shorter mode forms (options: "m"="markers", "l"="lines", "m+l" or "l+m"="markers+lines") |
| *title* | sets/updates the title of the figure |
| *xlabel* | sets/updates the xlabel of the figure |
| *ylabel* | sets/updates the ylabel of the figure |
]]
---@param trace table
---@return plotly.figure
function plotly.plot(trace)
    fig = plotly.figure()
    fig:plot(trace)
    return fig
end

return plotly
