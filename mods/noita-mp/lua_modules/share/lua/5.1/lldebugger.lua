--_VERSION = "v0.3.3-IsmohFixes"

local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file, ...)
    if ____moduleCache[file] then
        return ____moduleCache[file].value
    end
    if ____modules[file] then
        local module = ____modules[file]
        ____moduleCache[file] = { value = (select("#", ...) > 0) and module(...) or module(file) }
        return ____moduleCache[file].value
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
    ["luafuncs"] = function(...)
        local ____exports = {}
        if _G.unpack == nil then
            _G.unpack = table.unpack
        end
        ____exports.luaAssert = _G.assert
        ____exports.luaError = _G.error
        ____exports.luaCoroutineWrap = coroutine.wrap
        ____exports.luaDebugTraceback = debug.traceback
        ____exports.luaCoroutineCreate = coroutine.create
        ____exports.luaCoroutineResume = coroutine.resume
        ____exports.luaLenMetamethodSupported = (function()
            return #setmetatable(
                {},
                {
                    __len = function() return 42 end
                }
            ) == 42
        end)()
        ____exports.luaRawLen = rawlen or (function(v)
            if not ____exports.luaLenMetamethodSupported then
                return #v
            end
            local mt = debug.getmetatable(v)
            if (not mt) or (not rawget(mt, "__len")) then
                return #v
            else
                local len = 1
                while rawget(v, len) do
                    len = len + 1
                end
                return len - 1
            end
        end)
        function ____exports.loadLuaString(str, env)
            if setfenv ~= nil then
                local f, e = loadstring(str, str)
                if f and env then
                    setfenv(f, env)
                end
                return f, e
            else
                return load(str, str, "t", env)
            end
        end

        function ____exports.loadLuaFile(filename, env)
            if setfenv ~= nil then
                local f, e = loadfile(filename)
                if f and env then
                    setfenv(f, env)
                end
                return f, e
            else
                return loadfile(filename, "t", env)
            end
        end

        function ____exports.luaGetEnv(level, thread)
            local info = (thread and debug.getinfo(thread, level, "f")) or debug.getinfo(level + 1, "f")
            if (not info) or (not info.func) then
                return
            end
            if getfenv ~= nil then
                return getfenv(info.func)
            else
                local i = 1
                while true do
                    local name, value = debug.getupvalue(info.func, i)
                    if not name then
                        break
                    end
                    if name == "_ENV" then
                        return value
                    end
                    i = i + 1
                end
            end
        end

        return ____exports
    end,
    ["path"] = function(...)
        local ____exports = {}
        local ____luafuncs = require("luafuncs")
        local luaAssert = ____luafuncs.luaAssert
        ____exports.Path = {}
        local Path = ____exports.Path
        do
            Path.separator = (function()
                local config = _G.package.config
                if config then
                    local sep = config:match("^[^\n]+")
                    if sep then
                        return sep
                    end
                end
                return "/"
            end)()
            local cwd
            function Path.getCwd()
                if not cwd then
                    local p = io.popen(((Path.separator == "\\") and "cd") or "pwd")
                    if p then
                        local output = p:read("*a")
                        if output then
                            cwd = output:match("^%s*(.-)%s*$")
                        end
                    end
                    cwd = cwd or ""
                end
                return cwd
            end

            function Path.dirName(path)
                local dir = path:match(((("^(.-)" .. Path.separator) .. "+[^") .. Path.separator) .. "]+$")
                return dir or "."
            end

            function Path.splitDrive(path)
                local drive, pathPart = path:match("^[@=]?([a-zA-Z]:)[\\/](.*)")
                if drive then
                    drive = drive:upper() .. Path.separator
                else
                    drive, pathPart = path:match("^[@=]?([\\/]*)(.*)")
                end
                return luaAssert(drive), luaAssert(pathPart)
            end

            local formattedPathCache = {}
            function Path.format(path)
                local formattedPath = formattedPathCache[path]
                if not formattedPath then
                    local drive, pathOnly = Path.splitDrive(path)
                    local pathParts = {}
                    for part in luaAssert(pathOnly):gmatch("[^\\/]+") do
                        if part ~= "." then
                            if ((part == "..") and (#pathParts > 0)) and (pathParts[#pathParts] ~= "..") then
                                table.remove(pathParts)
                            else
                                table.insert(pathParts, part)
                            end
                        end
                    end
                    local formattedDrive = drive:gsub("[\\/]+", Path.separator)
                    formattedPath = formattedDrive .. table.concat(pathParts, Path.separator)
                    formattedPathCache[path] = formattedPath
                end
                return formattedPath
            end

            function Path.isAbsolute(path)
                local drive = Path.splitDrive(path)
                return #drive > 0
            end

            function Path.getAbsolute(path)
                if Path.isAbsolute(path) then
                    return Path.format(path)
                end
                return Path.format(
                    (Path.getCwd() .. Path.separator) .. path
                )
            end
        end
        return ____exports
    end,
    ["sourcemap"] = function(...)
        local ____exports = {}
        local ____luafuncs = require("luafuncs")
        local luaAssert = ____luafuncs.luaAssert
        local ____path = require("path")
        local Path = ____path.Path
        ____exports.SourceMap = {}
        local SourceMap = ____exports.SourceMap
        do
            local cache = {}
            local base64Lookup = {
                A = 0,
                B = 1,
                C = 2,
                D = 3,
                E = 4,
                F = 5,
                G = 6,
                H = 7,
                I = 8,
                J = 9,
                K = 10,
                L = 11,
                M = 12,
                N = 13,
                O = 14,
                P = 15,
                Q = 16,
                R = 17,
                S = 18,
                T = 19,
                U = 20,
                V = 21,
                W = 22,
                X = 23,
                Y = 24,
                Z = 25,
                a = 26,
                b = 27,
                c = 28,
                d = 29,
                e = 30,
                f = 31,
                g = 32,
                h = 33,
                i = 34,
                j = 35,
                k = 36,
                l = 37,
                m = 38,
                n = 39,
                o = 40,
                p = 41,
                q = 42,
                r = 43,
                s = 44,
                t = 45,
                u = 46,
                v = 47,
                w = 48,
                x = 49,
                y = 50,
                z = 51,
                ["0"] = 52,
                ["1"] = 53,
                ["2"] = 54,
                ["3"] = 55,
                ["4"] = 56,
                ["5"] = 57,
                ["6"] = 58,
                ["7"] = 59,
                ["8"] = 60,
                ["9"] = 61,
                ["+"] = 62,
                ["/"] = 63,
                ["="] = 0
            }
            local function base64Decode(input)
                local results = {}
                local bits = {}
                for c in input:gmatch(".") do
                    local sextet = luaAssert(base64Lookup[c])
                    for i = 1, 6 do
                        local bit = (sextet % 2) ~= 0
                        table.insert(bits, i, bit)
                        sextet = math.floor(sextet / 2)
                    end
                    if #bits >= 8 then
                        local value = 0
                        for i = 7, 0, -1 do
                            local bit = table.remove(bits)
                            if bit then
                                value = value + (2 ^ i)
                            end
                        end
                        table.insert(
                            results,
                            string.char(value)
                        )
                    end
                end
                return table.concat(results)
            end
            local function decodeBase64VLQ(input)
                local values = {}
                local bits = {}
                for c in input:gmatch(".") do
                    local sextet = luaAssert(base64Lookup[c])
                    for _ = 1, 5 do
                        local bit = (sextet % 2) ~= 0
                        table.insert(bits, bit)
                        sextet = math.floor(sextet / 2)
                    end
                    local continueBit = (sextet % 2) ~= 0
                    if not continueBit then
                        local value = 0
                        for i = 1, #bits - 1 do
                            if bits[i + 1] then
                                value = value + (2 ^ (i - 1))
                            end
                        end
                        if bits[1] then
                            value = -value
                        end
                        table.insert(values, value)
                        bits = {}
                    end
                end
                return values
            end
            local function build(data, mapDir, luaScript)
                local sources = data:match("\"sources\"%s*:%s*(%b[])")
                local mappings = data:match("\"mappings\"%s*:%s*\"([^\"]+)\"")
                if (not mappings) or (not sources) then
                    return nil
                end
                local sourceMap = { mappings = {}, sources = {}, sourceNames = {}, luaNames = {}, hasMappedNames = false }
                local sourceRoot = data:match("\"sourceRoot\"%s*:%s*\"([^\"]+)\"")
                if (sourceRoot == nil) or (#sourceRoot == 0) then
                    sourceRoot = "."
                end
                for source in sources:gmatch("\"([^\"]+)\"") do
                    if Path.isAbsolute(source) then
                        table.insert(
                            sourceMap.sources,
                            Path.format(source)
                        )
                    else
                        local sourcePath = (((mapDir .. Path.separator) .. sourceRoot) .. Path.separator) .. source
                        table.insert(
                            sourceMap.sources,
                            Path.getAbsolute(sourcePath)
                        )
                    end
                end
                local names = data:match("\"names\"%s*:%s*(%b[])")
                local nameList
                if names then
                    nameList = {}
                    for name in names:gmatch("\"([^\"]+)\"") do
                        table.insert(nameList, name)
                    end
                end
                local luaLines
                local line = 1
                local column = 1
                local sourceIndex = 0
                local sourceLine = 1
                local sourceColumn = 1
                local nameIndex = 0
                for mapping, separator in mappings:gmatch("([^;,]*)([;,]?)") do
                    if #mapping > 0 then
                        local colOffset, sourceOffset, sourceLineOffset, sourceColOffset, nameOffset = unpack(
                            decodeBase64VLQ(mapping)
                        )
                        column = column + (colOffset or 0)
                        sourceIndex = sourceIndex + (sourceOffset or 0)
                        sourceLine = sourceLine + (sourceLineOffset or 0)
                        sourceColumn = sourceColumn + (sourceColOffset or 0)
                        if nameList and nameOffset then
                            nameIndex = nameIndex + nameOffset
                            local sourceName = luaAssert(nameList[nameIndex + 1])
                            if not luaLines then
                                luaLines = {}
                                for luaLineStr in luaScript:gmatch("([^\r\n]*)\r?\n") do
                                    table.insert(luaLines, luaLineStr)
                                end
                            end
                            local luaLine = luaLines[line]
                            if luaLine then
                                local luaName = luaLine:sub(column):match("[a-zA-Z_][A-Za-z0-9_]*")
                                if luaName then
                                    sourceMap.sourceNames[luaName] = sourceName
                                    sourceMap.luaNames[sourceName] = luaName
                                    sourceMap.hasMappedNames = true
                                end
                            end
                        end
                        local lineMapping = sourceMap.mappings[line]
                        if ((not lineMapping) or (sourceLine < lineMapping.sourceLine)) or ((sourceLine == lineMapping.sourceLine) and (sourceColumn < lineMapping.sourceColumn)) then
                            sourceMap.mappings[line] = { sourceIndex = sourceIndex, sourceLine = sourceLine, sourceColumn = sourceColumn }
                        end
                    end
                    if separator == ";" then
                        line = line + 1
                        column = 1
                    end
                end
                return sourceMap
            end
            local scriptRootsEnv = "LOCAL_LUA_DEBUGGER_SCRIPT_ROOTS"
            local scriptRoots
            local function getScriptRoots()
                if not scriptRoots then
                    scriptRoots = {}
                    local scriptRootsStr = os.getenv(scriptRootsEnv)
                    if scriptRootsStr then
                        for path in scriptRootsStr:gmatch("[^;]+") do
                            path = Path.format(path) .. Path.separator
                            table.insert(scriptRoots, path)
                        end
                    end
                end
                return scriptRoots
            end
            local function getMap(filePath, file)
                local data = file:read("*a")
                file:close()
                if not data then
                    return
                end
                local encodedMap = data:match("--# sourceMappingURL=data:application/json;base64,([A-Za-z0-9+/=]+)%s*$")
                if encodedMap then
                    local map = base64Decode(encodedMap)
                    local fileDir = Path.dirName(filePath)
                    return build(map, fileDir, data)
                end
                local mapFile = io.open(filePath .. ".map")
                if mapFile then
                    local map = mapFile:read("*a")
                    mapFile:close()
                    if not map then
                        return
                    end
                    local fileDir = Path.dirName(filePath)
                    return build(map, fileDir, data)
                end
            end
            local function findMap(fileName)
                local file = io.open(fileName)
                if file then
                    local map = getMap(fileName, file)
                    if map then
                        return map
                    end
                end
                for ____, path in ipairs(
                    getScriptRoots()
                ) do
                    local filePath = path .. fileName
                    file = io.open(filePath)
                    if file then
                        local map = getMap(filePath, file)
                        if map then
                            return map
                        end
                    end
                end
            end
            function SourceMap.get(fileName)
                if fileName == "[C]" then
                    return nil
                end
                local sourceMap = cache[fileName]
                if sourceMap == nil then
                    sourceMap = findMap(fileName) or false
                    cache[fileName] = sourceMap
                end
                if sourceMap ~= false then
                    return sourceMap
                end
            end

            function SourceMap.find(sourceFile)
                for scriptFile, sourceMap in pairs(cache) do
                    if sourceMap ~= false then
                        for ____, source in ipairs(sourceMap.sources) do
                            if source == sourceFile then
                                return scriptFile, sourceMap
                            end
                        end
                    end
                end
                return nil, nil
            end
        end
        return ____exports
    end,
    ["breakpoint"] = function(...)
        local ____exports = {}
        local ____sourcemap = require("sourcemap")
        local SourceMap = ____sourcemap.SourceMap
        local ____path = require("path")
        local Path = ____path.Path
        ____exports.Breakpoint = {}
        local Breakpoint = ____exports.Breakpoint
        do
            local current = {}
            local count = 0
            function Breakpoint.get(file, line)
                file = Path.format(file)
                for breakpointLine, lineBreakpoints in pairs(current) do
                    for ____, breakpoint in ipairs(lineBreakpoints) do
                        if breakpoint.sourceMap then
                            if (breakpoint.sourceLine == line) and (breakpoint.sourceFile == file) then
                                return breakpoint
                            end
                        elseif (breakpointLine == line) and (breakpoint.file == file) then
                            return breakpoint
                        end
                    end
                end
            end

            function Breakpoint.getLookup()
                return current
            end

            function Breakpoint.getAll()
                local breakpointList = {}
                for _, lineBreakpoints in pairs(current) do
                    for ____, breakpoint in ipairs(lineBreakpoints) do
                        table.insert(breakpointList, breakpoint)
                    end
                end
                return breakpointList
            end

            function Breakpoint.add(file, line, condition)
                file = Path.format(file)
                local sourceFile
                local sourceLine
                local scriptFile, sourceMap = SourceMap.find(file)
                if scriptFile and sourceMap then
                    for scriptLine, mapping in pairs(sourceMap.mappings) do
                        if mapping.sourceLine == line then
                            sourceFile = file
                            file = scriptFile
                            sourceLine = line
                            line = scriptLine
                            break
                        end
                    end
                end
                local lineBreakpoints = current[line]
                if not lineBreakpoints then
                    lineBreakpoints = {}
                    current[line] = lineBreakpoints
                end
                table.insert(lineBreakpoints,
                    {
                        file = file,
                        line = line,
                        enabled = true,
                        condition = condition,
                        sourceFile = sourceFile,
                        sourceLine = sourceLine,
                        sourceMap = sourceMap
                    })
                count = count + 1
            end

            local function removeBreakpoint(breakpointLine, lineBreakpoints, i)
                table.remove(lineBreakpoints, i)
                if #lineBreakpoints == 0 then
                    current[breakpointLine] = nil
                end
                count = count - 1
            end
            function Breakpoint.remove(file, line)
                file = Path.format(file)
                for breakpointLine, lineBreakpoints in pairs(current) do
                    for i, breakpoint in ipairs(lineBreakpoints) do
                        if breakpoint.sourceMap then
                            if (breakpoint.sourceLine == line) and (breakpoint.sourceFile == file) then
                                removeBreakpoint(breakpointLine, lineBreakpoints, i)
                                return
                            end
                        elseif (breakpointLine == line) and (breakpoint.file == file) then
                            removeBreakpoint(breakpointLine, lineBreakpoints, i)
                            return
                        end
                    end
                end
            end

            function Breakpoint.clear()
                for line in pairs(current) do
                    current[line] = nil
                end
                count = 0
            end

            function Breakpoint.getCount()
                return count
            end
        end
        return ____exports
    end,
    ["format"] = function(...)
        local ____exports = {}
        local ____luafuncs = require("luafuncs")
        local luaRawLen = ____luafuncs.luaRawLen
        local luaAssert = ____luafuncs.luaAssert
        ____exports.Format = {}
        local Format = ____exports.Format
        do
            Format.arrayTag = {}
            function Format.makeExplicitArray(arr)
                if arr == nil then
                    arr = {}
                end
                arr[Format.arrayTag] = true
                return arr
            end

            local indentStr = "  "
            local escapes = { ["\n"] = "\\n", ["\r"] = "\\r", ["\""] = "\\\"", ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f", ["\t"] = "\\t" }
            local escapesPattern = "[\n\r\"\\\b\f\t%z-]"
            local function replaceEscape(char)
                local byte = luaAssert(
                    string.byte(char)
                )
                if (byte >= 0) and (byte < 32) then
                    return string.format("\\u%.4X", byte)
                end
                return luaAssert(escapes[char])
            end
            local function escape(str)
                local escaped = str:gsub(escapesPattern, replaceEscape)
                return escaped
            end
            local function isArray(val)
                if val[Format.arrayTag] then
                    return true
                end
                local len = luaRawLen(val)
                if len == 0 then
                    return false
                end
                for k in pairs(val) do
                    if (type(k) ~= "number") or (k > len) then
                        return false
                    end
                end
                return true
            end
            function Format.asJson(val, indent, tables)
                if indent == nil then
                    indent = 0
                end
                tables = tables or ({})
                local valType = type(val)
                if (valType == "table") and (not tables[val]) then
                    tables[val] = true
                    if isArray(val) then
                        local arrayVals = {}
                        for _, arrayVal in ipairs(val) do
                            local valStr = Format.asJson(arrayVal, indent + 1, tables)
                            table.insert(
                                arrayVals,
                                ("\n" .. indentStr:rep(indent + 1)) .. valStr
                            )
                        end
                        return ((("[" .. table.concat(arrayVals, ",")) .. "\n") .. indentStr:rep(indent)) .. "]"
                    else
                        local kvps = {}
                        for k, v in pairs(val) do
                            local valStr = Format.asJson(v, indent + 1, tables)
                            table.insert(
                                kvps,
                                (((("\n" .. indentStr:rep(indent + 1)) .. "\"") .. escape(
                                    tostring(k)
                                )) .. "\": ") .. valStr
                            )
                        end
                        return ((#kvps > 0) and (((("{" .. table.concat(kvps, ",")) .. "\n") .. indentStr:rep(indent)) .. "}")) or "{}"
                    end
                elseif (valType == "number") or (valType == "boolean") then
                    return tostring(val)
                else
                    return ("\"" .. escape(
                        tostring(val)
                    )) .. "\""
                end
            end
        end
        return ____exports
    end,
    ["thread"] = function(...)
        local ____exports = {}
        ____exports.mainThreadName = "main thread"
        function ____exports.isThread(val)
            return type(val) == "thread"
        end

        ____exports.mainThread = (function()
            local LUA_RIDX_MAINTHREAD = 1
            local registryMainThread = debug.getregistry()[LUA_RIDX_MAINTHREAD]
            return (____exports.isThread(registryMainThread) and registryMainThread) or ____exports.mainThreadName
        end)()
        return ____exports
    end,
    ["send"] = function(...)
        local ____exports = {}
        local ____luafuncs = require("luafuncs")
        local luaAssert = ____luafuncs.luaAssert
        local luaError = ____luafuncs.luaError
        local luaLenMetamethodSupported = ____luafuncs.luaLenMetamethodSupported
        local luaRawLen = ____luafuncs.luaRawLen
        local ____format = require("format")
        local Format = ____format.Format
        local ____thread = require("thread")
        local mainThread = ____thread.mainThread
        local mainThreadName = ____thread.mainThreadName
        ____exports.Send = {}
        local Send = ____exports.Send
        do
            local startToken = "@lldbg|"
            local endToken = "|lldbg@"
            local outputFileEnv = "LOCAL_LUA_DEBUGGER_OUTPUT_FILE"
            local outputFilePath = os.getenv(outputFileEnv)
            local outputFile
            if outputFilePath and (#outputFilePath > 0) then
                local file, err = io.open(outputFilePath, "w+")
                if not file then
                    luaError(
                        ((("Failed to open output file \"" .. outputFilePath) .. "\": ") .. tostring(err)) .. "\n"
                    )
                end
                outputFile = file
                outputFile:setvbuf("no")
            else
                outputFile = io.stdout
            end
            local function getPrintableValue(value)
                local valueType = type(value)
                if valueType == "string" then
                    return ("\"" .. tostring(value)) .. "\""
                elseif ((valueType == "number") or (valueType == "boolean")) or (valueType == "nil") then
                    return tostring(value)
                else
                    local _, str = pcall(tostring, value)
                    local strType = type(str)
                    if strType ~= "string" then
                        return ("[" .. strType) .. "]"
                    end
                    return ("[" .. str) .. "]"
                end
            end
            local function isElementKey(tbl, tblLen, key)
                return ((type(key) == "number") and (key >= 1)) and (key <= tblLen)
            end
            local function buildVariable(name, value)
                local dbgVar = {
                    type = type(value),
                    name = name,
                    value = getPrintableValue(value)
                }
                if type(value) == "table" then
                    dbgVar.length = luaRawLen(value)
                end
                return dbgVar
            end
            local function buildVarArgs(name, values)
                local valueStrs = {}
                for _, val in ipairs(values) do
                    table.insert(
                        valueStrs,
                        getPrintableValue(val)
                    )
                end
                return {
                    type = "table",
                    name = name,
                    value = table.concat(valueStrs, ", "),
                    length = #values
                }
            end
            local function send(message)
                outputFile:write(
                    (startToken .. Format.asJson(message)) .. endToken
                )
            end
            function Send.error(err)
                local dbgError = { tag = "$luaDebug", type = "error", error = err }
                send(dbgError)
            end

            function Send.debugBreak(message, breakType, threadId)
                local dbgBreak = { tag = "$luaDebug", type = "debugBreak", message = message, breakType = breakType, threadId = threadId }
                send(dbgBreak)
            end

            function Send.result(...)
                local values = { ... }
                local results = Format.makeExplicitArray()
                for ____, value in ipairs(values) do
                    table.insert(
                        results,
                        {
                            type = type(value),
                            value = getPrintableValue(value)
                        }
                    )
                end
                local dbgResult = { tag = "$luaDebug", type = "result", results = results }
                send(dbgResult)
            end

            function Send.frames(frameList)
                local dbgStack = { tag = "$luaDebug", type = "stack", frames = frameList }
                send(dbgStack)
            end

            function Send.threads(threadIds, activeThread)
                local dbgThreads = { tag = "$luaDebug", type = "threads", threads = {} }
                for thread, threadId in pairs(threadIds) do
                    if (thread == mainThread) or (coroutine.status(thread) ~= "dead") then
                        local dbgThread = {
                            name = ((thread == mainThread) and mainThreadName) or tostring(thread),
                            id = threadId,
                            active = (thread == activeThread) or nil
                        }
                        table.insert(dbgThreads.threads, dbgThread)
                    end
                end
                send(dbgThreads)
            end

            function Send.vars(varsObj)
                local dbgVariables = {
                    tag = "$luaDebug",
                    type = "variables",
                    variables = Format.makeExplicitArray()
                }
                for name, info in pairs(varsObj) do
                    local dbgVar = ((name == "...") and buildVarArgs(name, info.val)) or buildVariable(name, info.val)
                    table.insert(dbgVariables.variables, dbgVar)
                end
                send(dbgVariables)
            end

            function Send.props(tbl, kind, first, count)
                local dbgProperties = {
                    tag = "$luaDebug",
                    type = "properties",
                    properties = Format.makeExplicitArray()
                }
                if kind == "indexed" then
                    if first == nil then
                        first = 1
                    end
                    local last = (count and ((first + count) - 1)) or ((first + luaRawLen(tbl)) - 1)
                    for i = first, last do
                        local val = tbl[i]
                        local name = getPrintableValue(i)
                        local dbgVar = buildVariable(name, val)
                        table.insert(dbgProperties.properties, dbgVar)
                    end
                else
                    local len = luaRawLen(tbl)
                    for key, val in pairs(tbl) do
                        if (kind ~= "named") or (not isElementKey(tbl, len, key)) then
                            local name = getPrintableValue(key)
                            local dbgVar = buildVariable(name, val)
                            table.insert(dbgProperties.properties, dbgVar)
                        end
                    end
                    local meta = getmetatable(tbl)
                    if meta then
                        dbgProperties.metatable = {
                            type = type(meta),
                            value = getPrintableValue(meta)
                        }
                    end
                    local lenStatus, tblLen = pcall(
                        function() return #tbl end
                    )
                    if not lenStatus then
                        dbgProperties.length = {
                            type = type(tblLen),
                            error = tblLen
                        }
                    elseif tblLen ~= 0 then
                        dbgProperties.length = {
                            type = type(tblLen),
                            value = tostring(tblLen)
                        }
                    else
                        local mt = debug.getmetatable(tbl)
                        if ((not mt) and (#dbgProperties.properties == 0)) or ((mt and luaLenMetamethodSupported) and mt.__len) then
                            dbgProperties.length = {
                                type = type(tblLen),
                                value = tostring(tblLen)
                            }
                        end
                    end
                end
                send(dbgProperties)
            end

            local function getUpvalues(info)
                local ups = {}
                if (not info.nups) or (not info.func) then
                    return ups
                end
                for index = 1, info.nups do
                    local name, val = debug.getupvalue(info.func, index)
                    ups[luaAssert(name)] = val
                end
                return ups
            end
            function Send.functionUpvalues(f)
                local dbgProperties = {
                    tag = "$luaDebug",
                    type = "properties",
                    properties = Format.makeExplicitArray()
                }
                local upvalues = getUpvalues(
                    debug.getinfo(f, "fu")
                )
                for key, val in pairs(upvalues) do
                    local name = getPrintableValue(key)
                    local dbgVar = buildVariable(name, val)
                    table.insert(dbgProperties.properties, dbgVar)
                end
                send(dbgProperties)
            end

            function Send.breakpoints(breaks)
                local breakpointList = {}
                for ____, breakpoint in ipairs(breaks) do
                    table.insert(breakpointList,
                        {
                            line = breakpoint.sourceLine or breakpoint.line,
                            file = breakpoint.sourceFile or breakpoint.file,
                            condition = breakpoint.condition,
                            enabled = breakpoint.enabled
                        })
                end
                local dbgBreakpoints = {
                    tag = "$luaDebug",
                    type = "breakpoints",
                    breakpoints = Format.makeExplicitArray(breakpointList)
                }
                send(dbgBreakpoints)
            end

            function Send.help(...)
                local helpStrs = { ... }
                local nameLength = 0
                for _, nameAndDesc in ipairs(helpStrs) do
                    nameLength = math.max(nameLength, #nameAndDesc[2])
                end
                local builtStrs = {}
                for _, nameAndDesc in ipairs(helpStrs) do
                    local name, desc = unpack(nameAndDesc)
                    table.insert(
                        builtStrs,
                        ((name .. string.rep(" ", (nameLength - #name) + 1)) .. ": ") .. desc
                    )
                end
                outputFile:write(
                    table.concat(builtStrs, "\n") .. "\n"
                )
            end
        end
        return ____exports
    end,
    ["debugger"] = function(...)
        local ____exports = {}
        local ____luafuncs = require("luafuncs")
        local luaAssert = ____luafuncs.luaAssert
        local luaError = ____luafuncs.luaError
        local luaCoroutineCreate = ____luafuncs.luaCoroutineCreate
        local luaCoroutineWrap = ____luafuncs.luaCoroutineWrap
        local luaCoroutineResume = ____luafuncs.luaCoroutineResume
        local luaDebugTraceback = ____luafuncs.luaDebugTraceback
        local loadLuaString = ____luafuncs.loadLuaString
        local luaGetEnv = ____luafuncs.luaGetEnv
        local ____path = require("path")
        local Path = ____path.Path
        local ____sourcemap = require("sourcemap")
        local SourceMap = ____sourcemap.SourceMap
        local ____send = require("send")
        local Send = ____send.Send
        local ____breakpoint = require("breakpoint")
        local Breakpoint = ____breakpoint.Breakpoint
        local ____thread = require("thread")
        local mainThread = ____thread.mainThread
        local mainThreadName = ____thread.mainThreadName
        local isThread = ____thread.isThread
        ____exports.Debugger = {}
        local Debugger = ____exports.Debugger
        do
            local debuggerName = "lldebugger.lua"
            local builtinFunctionPrefix = "[builtin:"
            local inputFileEnv = "LOCAL_LUA_DEBUGGER_INPUT_FILE"
            local inputFilePath = os.getenv(inputFileEnv)
            local inputFile
            if inputFilePath and (#inputFilePath > 0) then
                local file, err = io.open(inputFilePath, "r+")
                if not file then
                    luaError(
                        ((("Failed to open input file \"" .. inputFilePath) .. "\": ") .. tostring(err)) .. "\n"
                    )
                end
                inputFile = file
                inputFile:setvbuf("no")
            else
                inputFile = io.stdin
            end
            local pullFileEnv = "LOCAL_LUA_DEBUGGER_PULL_FILE"
            local pullFilePath = os.getenv(pullFileEnv)
            local lastPullSeek = 0
            local pullFile
            if pullFilePath and (#pullFilePath > 0) then
                local file, err = io.open(pullFilePath, "r+")
                if not file then
                    luaError(
                        ((("Failed to open pull file \"" .. pullFilePath) .. "\": ") .. tostring(err)) .. "\n"
                    )
                end
                pullFile = file
                pullFile:setvbuf("no")
                local fileSize, errorSeek = pullFile:seek("end")
                if not fileSize then
                    luaError(
                        ((("Failed to read pull file \"" .. pullFilePath) .. "\": ") .. tostring(errorSeek)) .. "\n"
                    )
                else
                    lastPullSeek = fileSize
                end
            else
                pullFile = nil
            end
            local skipNextBreak = false
            local hookStack = {}
            local threadIds = setmetatable({}, { __mode = "k" })
            local threadStackOffsets = setmetatable({}, { __mode = "k" })
            local mainThreadId = 1
            threadIds[mainThread] = mainThreadId
            local nextThreadId = mainThreadId + 1
            local function getThreadId(thread)
                return luaAssert(threadIds[thread])
            end
            local function getActiveThread()
                return coroutine.running() or mainThread
            end
            local function getLine(info)
                local currentLine = info.currentline and tonumber(info.currentline)
                if currentLine and (currentLine > 0) then
                    return currentLine
                end
                local lineDefined = info.linedefined and tonumber(info.linedefined)
                if lineDefined and (lineDefined > 0) then
                    return lineDefined
                end
                return -1
            end
            local function backtrace(stack, frameIndex)
                local frames = {}
                for i = 0, #stack - 1 do
                    local info = luaAssert(stack[i + 1])
                    local frame = {
                        source = (info.source and Path.format(info.source)) or "?",
                        line = getLine(info)
                    }
                    if info.source then
                        local sourceMap = SourceMap.get(frame.source)
                        if sourceMap then
                            local lineMapping = sourceMap.mappings[frame.line]
                            if lineMapping then
                                frame.mappedLocation = {
                                    source = luaAssert(sourceMap.sources[lineMapping.sourceIndex + 1]),
                                    line = lineMapping.sourceLine,
                                    column = lineMapping.sourceColumn
                                }
                            end
                        end
                    end
                    if info.name then
                        frame.func = info.name
                    elseif info.func then
                        frame.func = tostring(info.func)
                    end
                    if i == frameIndex then
                        frame.active = true
                    end
                    table.insert(frames, frame)
                end
                Send.frames(frames)
            end
            local supportsUtf8Identifiers = (function()
                local identifier = (string.char(226) .. string.char(143)) .. string.char(176)
                local ____, err = loadLuaString((("local " .. identifier) .. " = true return ") .. identifier)
                return err == nil
            end)()
            local function isValidIdentifier(name)
                if supportsUtf8Identifiers then
                    for c in name:gmatch("[^a-zA-Z0-9_]") do
                        local a = c:byte()
                        if a and (a < 128) then
                            return false
                        end
                    end
                    return true
                else
                    local invalidChar = name:match("[^a-zA-Z0-9_]")
                    return invalidChar == nil
                end
            end
            local function getLocals(level, thread)
                local locs = { vars = {} }
                if thread == mainThreadName then
                    return locs
                end
                local info
                if thread then
                    info = debug.getinfo(thread, level, "u")
                else
                    info = debug.getinfo(level + 1, "u")
                end
                if not info then
                    return locs
                end
                local name
                local val
                local index = 1
                while true do
                    if thread then
                        name, val = debug.getlocal(thread, level, index)
                    else
                        name, val = debug.getlocal(level + 1, index)
                    end
                    if not name then
                        break
                    end
                    if isValidIdentifier(name) then
                        locs.vars[name] = {
                            val = val,
                            index = index,
                            type = type(val)
                        }
                    end
                    index = index + 1
                end
                local isVarArg = info.isvararg
                if isVarArg ~= false then
                    if isVarArg then
                        locs.varargs = {}
                    end
                    index = -1
                    while true do
                        if thread then
                            name, val = debug.getlocal(thread, level, index)
                        else
                            name, val = debug.getlocal(level + 1, index)
                        end
                        if not name then
                            break
                        end
                        if not locs.varargs then
                            locs.varargs = {}
                        end
                        table.insert(
                            locs.varargs,
                            {
                                val = val,
                                index = index,
                                type = type(val)
                            }
                        )
                        index = index - 1
                    end
                end
                return locs
            end
            local function getUpvalues(info)
                local ups = { vars = {} }
                if (not info.nups) or (not info.func) then
                    return ups
                end
                for index = 1, info.nups do
                    local name, val = debug.getupvalue(info.func, index)
                    ups.vars[luaAssert(name)] = {
                        val = val,
                        index = index,
                        type = type(val)
                    }
                end
                return ups
            end
            local function populateGlobals(globs, tbl, metaStack)
                metaStack[tbl] = true
                local meta = debug.getmetatable(tbl)
                if ((meta ~= nil) and (type(meta.__index) == "table")) and (metaStack[meta] == nil) then
                    populateGlobals(globs, meta.__index, metaStack)
                end
                for key, val in pairs(tbl) do
                    local name = tostring(key)
                    globs[name] = {
                        val = val,
                        type = type(val)
                    }
                end
            end
            local function getGlobals(level, thread)
                if thread == mainThreadName then
                    thread = nil
                end
                if not thread then
                    level = level + 1
                end
                local globs = {}
                local fenv = luaGetEnv(level, thread) or _G
                local metaStack = {}
                populateGlobals(globs, fenv, metaStack)
                return globs
            end
            local function mapVarNames(vars, sourceMap)
                if not sourceMap then
                    return
                end
                local addVars = {}
                local removeVars = {}
                for name, info in pairs(vars) do
                    local mappedName = sourceMap.sourceNames[name]
                    if mappedName then
                        addVars[mappedName] = info
                        table.insert(removeVars, name)
                    end
                end
                for _, name in ipairs(removeVars) do
                    vars[name] = nil
                end
                for name, info in pairs(addVars) do
                    vars[name] = info
                end
            end
            local function mapExpressionNames(expression, sourceMap)
                if (not sourceMap) or (not sourceMap.hasMappedNames) then
                    return expression
                end
                local function mapName(sourceName, isProperty)
                    if isProperty then
                        if not isValidIdentifier(sourceName) then
                            return ("[\"" .. sourceName) .. "\"]"
                        else
                            return "." .. sourceName
                        end
                    else
                        return luaAssert(sourceMap).luaNames[sourceName] or sourceName
                    end
                end
                local inQuote
                local isEscaped = false
                local nameStart
                local nameIsProperty = false
                local nonNameStart = 1
                local mappedExpression = ""
                for i = 1, #expression do
                    local char = expression:sub(i, i)
                    if inQuote then
                        if char == "\\" then
                            isEscaped = not isEscaped
                        elseif (char == inQuote) and (not isEscaped) then
                            inQuote = nil
                        else
                            isEscaped = false
                        end
                    elseif (char == "\"") or (char == "'") then
                        inQuote = char
                    else
                        local nameChar = char:match("[^\"'`~!@#%%^&*%(%)%-+=%[%]{}|\\/<>,%.:;%s]")
                        if nameStart then
                            if not nameChar then
                                local sourceName = expression:sub(nameStart, i - 1)
                                mappedExpression = mappedExpression .. mapName(sourceName, nameIsProperty)
                                nameStart = nil
                                nonNameStart = i
                            end
                        elseif nameChar then
                            local lastChar = expression:sub(i - 1, i - 1)
                            nameIsProperty = lastChar == "."
                            nameStart = i
                            mappedExpression = mappedExpression .. expression:sub(nonNameStart, nameStart - ((nameIsProperty and 2) or 1))
                        end
                    end
                end
                if nameStart then
                    local sourceName = expression:sub(nameStart)
                    mappedExpression = mappedExpression .. mapName(sourceName, nameIsProperty)
                else
                    mappedExpression = mappedExpression .. expression:sub(nonNameStart)
                end
                return mappedExpression
            end
            local metatableAccessor = "lldbg_getmetatable"
            local function execute(statement, level, info, thread)
                if thread == mainThreadName then
                    return false, "unable to access main thread while running in a coroutine"
                end
                if not thread then
                    level = level + 1
                end
                local locs = getLocals(level, thread)
                local ups = getUpvalues(info)
                local fenv = luaGetEnv(level, thread) or _G
                local env = setmetatable(
                    {},
                    {
                        __index = function(self, name)
                            if name == metatableAccessor then
                                return getmetatable
                            end
                            local variable = locs.vars[name] or ups.vars[name]
                            if variable ~= nil then
                                return variable.val
                            end
                            return fenv[name]
                        end,
                        __newindex = function(self, name, val)
                            local variable = locs.vars[name] or ups.vars[name]
                            if variable ~= nil then
                                variable.type = type(val)
                                variable.val = val
                            else
                                fenv[name] = val
                            end
                        end
                    }
                )
                local loadStringResult = {
                    loadLuaString(statement, env)
                }
                local func = loadStringResult[1]
                if not func then
                    return false, loadStringResult[2]
                end
                local varargs = {}
                if locs.varargs then
                    for ____, vararg in ipairs(locs.varargs) do
                        table.insert(varargs, vararg.val)
                    end
                end
                local results = {
                    pcall(
                        func,
                        unpack(varargs)
                    )
                }
                if results[1] then
                    for _, loc in pairs(locs.vars) do
                        if thread then
                            debug.setlocal(thread, level, loc.index, loc.val)
                        else
                            debug.setlocal(level, loc.index, loc.val)
                        end
                    end
                    for _, up in pairs(ups.vars) do
                        debug.setupvalue(
                            luaAssert(info.func),
                            up.index,
                            up.val
                        )
                    end
                    return true, unpack(results, 2)
                end
                return false, results[2]
            end
            local function getInput()
                local inp = inputFile:read("*l")
                return inp
            end
            local function getStack(threadOrOffset)
                local thread
                local i = 1
                if isThread(threadOrOffset) then
                    thread = threadOrOffset
                    local offset = threadStackOffsets[thread]
                    if offset then
                        i = i + offset
                    end
                else
                    i = i + threadOrOffset
                end
                local stack = {}
                while true do
                    local stackInfo
                    if thread then
                        stackInfo = debug.getinfo(thread, i, "nSluf")
                    else
                        stackInfo = debug.getinfo(i, "nSluf")
                    end
                    if not stackInfo then
                        break
                    end
                    table.insert(stack, stackInfo)
                    i = i + 1
                end
                return stack
            end
            local breakAtDepth = -1
            local breakInThread
            local updateHook
            local isDebugHookDisabled = true
            local ignorePatterns
            local inDebugBreak = false
            local function debugBreak(activeThread, stackOffset, activeLine)
                assert(not inDebugBreak)
                inDebugBreak = true
                stackOffset = stackOffset + 1
                local activeStack = getStack(stackOffset)
                if activeLine and (#activeStack > 0) then
                    luaAssert(activeStack[1]).currentline = activeLine
                end
                local activeThreadFrameOffset = stackOffset
                breakAtDepth = -1
                breakInThread = nil
                local frameOffset = activeThreadFrameOffset
                local frame = 0
                local currentThread = activeThread
                local currentStack = activeStack
                local info = luaAssert(currentStack[frame + 1])
                local source = Path.format(
                    luaAssert(info.source)
                )
                local sourceMap = SourceMap.get(source)
                while true do
                    local inp = getInput()
                    if (not inp) or (inp == "quit") then
                        os.exit(0)
                    elseif (inp == "cont") or (inp == "continue") then
                        break
                    elseif (inp == "autocont") or (inp == "autocontinue") then
                        updateHook()
                        inDebugBreak = false
                        return false
                    elseif inp == "help" then
                        Send.help({ "help", "show available commands" }, { "cont|continue", "continue execution" },
                            { "autocont|autocontinue", "continue execution if not stopped at a breakpoint" }, { "quit", "stop program and debugger" },
                            { "step", "step to next line" }, { "stepin", "step in to current line" }, { "stepout", "step out to calling line" },
                            { "stack", "show current stack trace" }, { "frame n", "set active stack frame" },
                            { "locals", "show all local variables available in current context" },
                            { "ups", "show all upvalue variables available in the current context" },
                            { "globals", "show all global variables in current environment" },
                            { "props indexed [start] [count]", "show array elements of a table" }, { "props named|all", "show properties of a table" },
                            { "eval", "evaluate an expression in the current context" }, { "exec", "execute a statement in the current context" },
                            { "break set file.ext:n [cond]", "set a breakpoint" }, { "break del|delete file.ext:n", "delete a breakpoint" },
                            { "break en|enable file.ext:n", "enable a breakpoint" }, { "break dis|disable file.ext:n", "disable a breakpoint" },
                            { "break list", "show all breakpoints" }, { "break clear", "delete all breakpoints" },
                            { "threads", "list active thread ids" }, { "thread n", "set current thread by id" },
                            { "script", "add known script file (pre-caches sourcemap for breakpoint)" },
                            { "ignore", "add pattern for files to ignore when stepping" })
                    elseif inp == "threads" then
                        Send.threads(threadIds, activeThread)
                    elseif inp:sub(1, 6) == "thread" then
                        local newThreadIdStr = inp:match("^thread%s+(%d+)$")
                        if newThreadIdStr ~= nil then
                            local newThreadId = luaAssert(
                                tonumber(newThreadIdStr)
                            )
                            local newThread
                            for thread, threadId in pairs(threadIds) do
                                if threadId == newThreadId then
                                    newThread = thread
                                    break
                                end
                            end
                            if newThread ~= nil then
                                if newThread == activeThread then
                                    currentStack = activeStack
                                elseif newThread == mainThreadName then
                                    currentStack = { { name = "unable to access main thread while running in a coroutine", source = "" } }
                                else
                                    currentStack = getStack(newThread)
                                    if #currentStack == 0 then
                                        table.insert(currentStack, { name = "thread has not been started", source = "" })
                                    end
                                end
                                currentThread = newThread
                                frame = 0
                                frameOffset = ((currentThread == activeThread) and activeThreadFrameOffset) or
                                    (1 + (threadStackOffsets[currentThread] or 0))
                                info = luaAssert(currentStack[frame + 1])
                                source = Path.format(
                                    luaAssert(info.source)
                                )
                                sourceMap = SourceMap.get(source)
                                backtrace(currentStack, frame)
                            else
                                Send.error("Bad thread id")
                            end
                        else
                            Send.error("Bad thread id")
                        end
                    elseif inp == "step" then
                        breakAtDepth = #activeStack
                        breakInThread = activeThread
                        break
                    elseif inp == "stepin" then
                        breakAtDepth = math.huge
                        breakInThread = nil
                        break
                    elseif inp == "stepout" then
                        breakAtDepth = #activeStack - 1
                        breakInThread = activeThread
                        break
                    elseif inp == "stack" then
                        backtrace(currentStack, frame)
                    elseif inp:sub(1, 5) == "frame" then
                        local newFrameStr = inp:match("^frame%s+(%d+)$")
                        if newFrameStr ~= nil then
                            local newFrame = luaAssert(
                                tonumber(newFrameStr)
                            )
                            if (newFrame > 0) and (newFrame <= #currentStack) then
                                frame = newFrame - 1
                                info = luaAssert(currentStack[frame + 1])
                                source = Path.format(
                                    luaAssert(info.source)
                                )
                                sourceMap = SourceMap.get(source)
                                backtrace(currentStack, frame)
                            else
                                Send.error("Bad frame")
                            end
                        else
                            Send.error("Bad frame")
                        end
                    elseif inp == "locals" then
                        local locs = getLocals(frame + frameOffset, ((currentThread ~= activeThread) and currentThread) or nil)
                        mapVarNames(locs.vars, sourceMap)
                        if locs.varargs then
                            local varArgVals = {}
                            for ____, vararg in ipairs(locs.varargs) do
                                table.insert(varArgVals, vararg.val)
                            end
                            locs.vars["..."] = { val = varArgVals, index = -1, type = "table" }
                        end
                        Send.vars(locs.vars)
                    elseif inp == "ups" then
                        local ups = getUpvalues(info)
                        mapVarNames(ups.vars, sourceMap)
                        Send.vars(ups.vars)
                    elseif inp == "globals" then
                        local globs = getGlobals(frame + frameOffset, ((currentThread ~= activeThread) and currentThread) or nil)
                        mapVarNames(globs, sourceMap)
                        Send.vars(globs)
                    elseif inp:sub(1, 5) == "break" then
                        local cmd = inp:match("^break%s+([a-z]+)")
                        local file
                        local line
                        local breakpoint
                        if ((((((cmd == "set") or (cmd == "del")) or (cmd == "delete")) or (cmd == "dis")) or (cmd == "disable")) or (cmd == "en")) or (cmd == "enable") then
                            local lineStr
                            file, lineStr = inp:match("^break%s+[a-z]+%s+(.-):(%d+)")
                            if (file ~= nil) and (lineStr ~= nil) then
                                line = luaAssert(
                                    tonumber(lineStr)
                                )
                                breakpoint = Breakpoint.get(file, line)
                            end
                        end
                        if cmd == "set" then
                            if (file ~= nil) and (line ~= nil) then
                                local condition = inp:match("^break%s+[a-z]+%s+.-:%d+%s+(.+)")
                                Breakpoint.add(file, line, condition)
                                breakpoint = luaAssert(
                                    Breakpoint.get(file, line)
                                )
                                Send.breakpoints({ breakpoint })
                            else
                                Send.error("Bad breakpoint")
                            end
                        elseif (cmd == "del") or (cmd == "delete") then
                            if (file ~= nil) and (line ~= nil) then
                                Breakpoint.remove(file, line)
                                Send.result(nil)
                            else
                                Send.error("Bad breakpoint")
                            end
                        elseif (cmd == "dis") or (cmd == "disable") then
                            if breakpoint ~= nil then
                                breakpoint.enabled = false
                                Send.breakpoints({ breakpoint })
                            else
                                Send.error("Bad breakpoint")
                            end
                        elseif (cmd == "en") or (cmd == "enable") then
                            if breakpoint ~= nil then
                                breakpoint.enabled = true
                                Send.breakpoints({ breakpoint })
                            else
                                Send.error("Bad breakpoint")
                            end
                        elseif cmd == "clear" then
                            Breakpoint.clear()
                            Send.breakpoints(
                                Breakpoint.getAll()
                            )
                        elseif cmd == "list" then
                            Send.breakpoints(
                                Breakpoint.getAll()
                            )
                        else
                            Send.error("Bad breakpoint command")
                        end
                    elseif inp:sub(1, 4) == "eval" then
                        local expression = inp:match("^eval%s+(.+)$")
                        if not expression then
                            Send.error("Bad expression")
                        else
                            local mappedExpression = mapExpressionNames(expression, sourceMap)
                            local results = {
                                execute("return " .. mappedExpression, frame + frameOffset, info,
                                    ((currentThread ~= activeThread) and currentThread) or nil)
                            }
                            if results[1] then
                                Send.result(
                                    unpack(results, 2)
                                )
                            else
                                Send.error(results[2])
                            end
                        end
                    elseif inp:sub(1, 5) == "props" then
                        local expression, kind, first, count = inp:match("^props%s+(.-)%s*([a-z]+)%s*(%d*)%s*(%d*)$")
                        if not expression then
                            Send.error("Bad expression")
                        elseif ((kind ~= "all") and (kind ~= "named")) and (kind ~= "indexed") then
                            Send.error(
                                "Bad kind: " .. (("'" .. tostring(kind)) .. "'")
                            )
                        else
                            local mappedExpression = mapExpressionNames(expression, sourceMap)
                            local s, r = execute("return " .. mappedExpression, frame + frameOffset, info,
                                ((currentThread ~= activeThread) and currentThread) or nil)
                            if s then
                                if type(r) == "table" then
                                    Send.props(
                                        r,
                                        kind,
                                        tonumber(first),
                                        tonumber(count)
                                    )
                                elseif type(r) == "function" then
                                    Send.functionUpvalues(r)
                                else
                                    Send.error(("Expression \"" .. mappedExpression) .. "\" is not a table nor a function")
                                end
                            else
                                Send.error(r)
                            end
                        end
                    elseif inp:sub(1, 4) == "exec" then
                        local statement = inp:match("^exec%s+(.+)$")
                        if not statement then
                            Send.error("Bad statement")
                        else
                            local results = {
                                execute(statement, frame + frameOffset, info, ((currentThread ~= activeThread) and currentThread) or nil)
                            }
                            if results[1] then
                                Send.result(
                                    unpack(results, 2)
                                )
                            else
                                Send.error(results[2])
                            end
                        end
                    elseif inp:sub(1, 6) == "script" then
                        local scriptFile = inp:match("^script%s+(.+)$")
                        if not scriptFile then
                            Send.error("Bad script file")
                        else
                            scriptFile = Path.format(scriptFile)
                            local foundSourceMap = SourceMap.get(scriptFile)
                            if foundSourceMap then
                                Send.result(("added " .. scriptFile) .. ": source map found")
                            else
                                Send.result(("added " .. scriptFile) .. ": source map NOT found!")
                            end
                        end
                    elseif inp:sub(1, 6) == "ignore" then
                        local ignorePattern = inp:match("^ignore%s+(.+)$")
                        if not ignorePattern then
                            Send.error("Bad ignore pattern")
                        else
                            local match, err = pcall(string.match, "", ignorePattern)
                            if not match then
                                Send.error(
                                    (("Bad ignore pattern \"" .. ignorePattern) .. "\": ") .. tostring(err)
                                )
                            else
                                if not ignorePatterns then
                                    ignorePatterns = {}
                                end
                                table.insert(ignorePatterns, ignorePattern)
                                Send.result(("Added ignore pattern \"" .. ignorePattern) .. "\"")
                            end
                        end
                    else
                        Send.error("Bad command")
                    end
                end
                updateHook()
                inDebugBreak = false
                return true
            end
            local function comparePaths(a, b)
                return Path.getAbsolute(a):lower() == Path.getAbsolute(b):lower()
            end
            local debugHookStackOffset = 2
            local breakpointLookup = Breakpoint.getLookup()
            local stepUnmappedLinesEnv = "LOCAL_LUA_DEBUGGER_STEP_UNMAPPED_LINES"
            local skipUnmappedLines = os.getenv(stepUnmappedLinesEnv) ~= "1"
            local function debugHook(event, line)
                if isDebugHookDisabled then
                    return
                end
                if breakAtDepth >= 0 then
                    local activeThread = getActiveThread()
                    local stepBreak
                    if breakInThread == nil then
                        stepBreak = true
                    elseif activeThread == breakInThread then
                        stepBreak = #getStack(debugHookStackOffset) <= breakAtDepth
                    else
                        stepBreak = (breakInThread ~= mainThread) and (coroutine.status(breakInThread) == "dead")
                    end
                    if stepBreak then
                        local topFrameSource = debug.getinfo(debugHookStackOffset, "S")
                        if (not topFrameSource) or (not topFrameSource.source) then
                            return
                        end
                        if topFrameSource.source:sub(- #debuggerName) == debuggerName then
                            return
                        end
                        if topFrameSource.short_src and (topFrameSource.short_src:sub(1, #builtinFunctionPrefix) == builtinFunctionPrefix) then
                            return
                        end
                        local source
                        if ignorePatterns then
                            source = Path.format(topFrameSource.source)
                            for ____, pattern in ipairs(ignorePatterns) do
                                local match = source:match(pattern)
                                if match then
                                    return
                                end
                            end
                        end
                        if skipUnmappedLines then
                            if not source then
                                source = Path.format(topFrameSource.source)
                            end
                            local sourceMap = SourceMap.get(source)
                            if sourceMap and (not sourceMap.mappings[line]) then
                                return
                            end
                        end
                        Send.debugBreak(
                            "step",
                            "step",
                            getThreadId(activeThread)
                        )
                        if debugBreak(activeThread, debugHookStackOffset, line) then
                            return
                        end
                    end
                end
                local lineBreakpoints = breakpointLookup[line]
                if not lineBreakpoints then
                    return
                end
                local topFrame = debug.getinfo(debugHookStackOffset, "S")
                if (not topFrame) or (not topFrame.source) then
                    return
                end
                local source = Path.format(topFrame.source)
                topFrame = nil
                for ____, breakpoint in ipairs(lineBreakpoints) do
                    if breakpoint.enabled and comparePaths(breakpoint.file, source) then
                        if breakpoint.condition then
                            local mappedCondition = mapExpressionNames(breakpoint.condition, breakpoint.sourceMap)
                            local condition = "return " .. mappedCondition
                            topFrame = topFrame or luaAssert(
                                debug.getinfo(debugHookStackOffset, "nSluf")
                            )
                            local success, result = execute(condition, debugHookStackOffset, topFrame)
                            if success and result then
                                local activeThread = getActiveThread()
                                local conditionDisplay = ((("\"" .. breakpoint.condition) .. "\" = \"") .. tostring(result)) .. "\""
                                local breakpointFile, breakpointLine = breakpoint.sourceFile or breakpoint.file,
                                    breakpoint.sourceLine or breakpoint.line
                                Send.debugBreak(
                                    (((("breakpoint hit: \"" .. breakpointFile) .. ":") .. tostring(breakpointLine)) .. "\", ") .. conditionDisplay,
                                    "breakpoint",
                                    getThreadId(activeThread)
                                )
                                debugBreak(activeThread, debugHookStackOffset, line)
                                break
                            end
                        else
                            local activeThread = getActiveThread()
                            local breakpointFile, breakpointLine = breakpoint.sourceFile or breakpoint.file, breakpoint.sourceLine or breakpoint.line
                            Send.debugBreak(
                                ((("breakpoint hit: \"" .. breakpointFile) .. ":") .. tostring(breakpointLine)) .. "\"",
                                "breakpoint",
                                getThreadId(activeThread)
                            )
                            debugBreak(activeThread, debugHookStackOffset, line)
                            break
                        end
                    end
                end
            end
            local function mapSource(indent, file, lineStr, remainder)
                file = Path.format(file)
                local sourceMap = SourceMap.get(file)
                if sourceMap then
                    local line = luaAssert(
                        tonumber(lineStr)
                    )
                    local lineMapping = sourceMap.mappings[line]
                    if lineMapping then
                        local sourceFile = sourceMap.sources[lineMapping.sourceIndex + 1]
                        local sourceLine = lineMapping.sourceLine
                        local sourceColumn = lineMapping.sourceColumn
                        return ((((((indent .. tostring(sourceFile)) .. ":") .. tostring(sourceLine)) .. ":") .. tostring(sourceColumn)) .. ":") ..
                            remainder
                    end
                end
                return ((((indent .. file) .. ":") .. lineStr) .. ":") .. remainder
            end
            local function mapSources(str)
                str = str:gsub("(%s*)([^\r\n]+):(%d+):([^\r\n]+)", mapSource)
                return str
            end
            local function breakForError(err, level, propagate)
                local message = mapSources(
                    tostring(err)
                )
                level = (level or 1) + 1
                if skipNextBreak then
                    skipNextBreak = false
                elseif not inDebugBreak then
                    local thread = getActiveThread()
                    Send.debugBreak(
                        message,
                        "error",
                        getThreadId(thread)
                    )
                    debugBreak(thread, level)
                end
                if propagate then
                    skipNextBreak = true
                    luaError(message, level)
                end
            end
            local function registerThread(thread)
                assert(not threadIds[thread])
                local threadId = nextThreadId
                nextThreadId = nextThreadId + 1
                threadIds[thread] = threadId
                local hook = debug.gethook()
                if hook == debugHook then
                    debug.sethook(thread, debugHook, "l")
                end
                return threadId
            end
            local canYieldAcrossPcall
            local function useXpcallInCoroutine()
                if canYieldAcrossPcall == nil then
                    local _, yieldResult = luaCoroutineResume(
                        luaCoroutineCreate(
                            function()
                                return pcall(
                                    function() return coroutine.yield(true) end
                                )
                            end
                        )
                    )
                    canYieldAcrossPcall = yieldResult == true
                end
                return canYieldAcrossPcall
            end
            local function debuggerCoroutineCreate(f, allowBreak)
                if allowBreak and useXpcallInCoroutine() then
                    local originalFunc = f
                    local function debugFunc(...)
                        local args = { ... }
                        local function wrappedFunc()
                            return originalFunc(
                                unpack(args)
                            )
                        end
                        local results = {
                            xpcall(wrappedFunc, breakForError)
                        }
                        if results[1] then
                            return unpack(results, 2)
                        else
                            skipNextBreak = true
                            local message = mapSources(
                                tostring(results[2])
                            )
                            return luaError(message, 2)
                        end
                    end
                    f = debugFunc
                end
                local thread = luaCoroutineCreate(f)
                registerThread(thread)
                return thread
            end
            local function debuggerCoroutineResume(thread, ...)
                local activeThread = getActiveThread()
                threadStackOffsets[activeThread] = 1
                local results = {
                    luaCoroutineResume(thread, ...)
                }
                if not results[1] then
                    breakForError(results[2], 2)
                end
                threadStackOffsets[activeThread] = nil
                return unpack(results)
            end
            local function debuggerCoroutineWrap(f)
                local thread = debuggerCoroutineCreate(f, true)
                local function resumer(...)
                    local activeThread = getActiveThread()
                    threadStackOffsets[activeThread] = 1
                    local results = {
                        luaCoroutineResume(thread, ...)
                    }
                    if not results[1] then
                        breakForError(results[2], 2, true)
                    end
                    threadStackOffsets[activeThread] = nil
                    return unpack(results, 2)
                end
                return resumer
            end
            local function debuggerTraceback(threadOrMessage, messageOrLevel, level)
                local trace
                if isThread(threadOrMessage) then
                    trace = luaDebugTraceback(threadOrMessage, messageOrLevel or "", (level or 1) + 1)
                else
                    trace = luaDebugTraceback(threadOrMessage or "", (messageOrLevel or 1) + 1)
                end
                trace = mapSources(trace)
                if skipNextBreak then
                    skipNextBreak = false
                elseif hookStack[#hookStack] == "global" then
                    local info = debug.getinfo(2, "S")
                    if info and (info.what == "C") then
                        local thread = (isThread(threadOrMessage) and threadOrMessage) or getActiveThread()
                        Send.debugBreak(
                            trace,
                            "error",
                            getThreadId(thread)
                        )
                        debugBreak(thread, 3)
                    end
                end
                return trace
            end
            local function debuggerError(message, level)
                breakForError(message, (level or 1) + 1, true)
            end
            local function debuggerAssert(v, ...)
                local args = { ... }
                if not v then
                    local message = ((args[1] ~= nil) and args[1]) or "assertion failed"
                    breakForError(message, 1, true)
                end
                return v, unpack(args)
            end
            local function setErrorHandler()
                local hookType = hookStack[#hookStack]
                if hookType ~= nil then
                    _G.error = debuggerError
                    _G.assert = debuggerAssert
                    debug.traceback = debuggerTraceback
                else
                    _G.error = luaError
                    _G.assert = luaAssert
                    debug.traceback = luaDebugTraceback
                end
            end
            updateHook = function()
                isDebugHookDisabled = (breakAtDepth < 0) and (Breakpoint.getCount() == 0)
                if isDebugHookDisabled and ((_G.jit == nil) or (pullFile == nil)) then
                    debug.sethook()
                    for thread in pairs(threadIds) do
                        if isThread(thread) and (coroutine.status(thread) ~= "dead") then
                            debug.sethook(thread)
                        end
                    end
                else
                    debug.sethook(debugHook, "l")
                    for thread in pairs(threadIds) do
                        if isThread(thread) and (coroutine.status(thread) ~= "dead") then
                            debug.sethook(thread, debugHook, "l")
                        end
                    end
                end
                debug.setmetatable(
                    function()
                    end,
                    {
                        __index = function(self, key)
                            local info = debug.getinfo(self, "fu")
                            if not info then
                                return nil
                            end
                            local val = getUpvalues(info).vars[key]
                            if not val then
                                return nil
                            end
                            return val.val
                        end
                    }
                )
            end
            function Debugger.clearHook()
                while #hookStack > 0 do
                    table.remove(hookStack)
                end
                setErrorHandler()
                coroutine.create = luaCoroutineCreate
                coroutine.wrap = luaCoroutineWrap
                coroutine.resume = luaCoroutineResume
                isDebugHookDisabled = true
                debug.sethook()
                for thread in pairs(threadIds) do
                    if isThread(thread) and (coroutine.status(thread) ~= "dead") then
                        debug.sethook(thread)
                    end
                end
                debug.setmetatable(
                    function()
                    end,
                    nil
                )
            end

            local breakInCoroutinesEnv = "LOCAL_LUA_DEBUGGER_BREAK_IN_COROUTINES"
            local breakInCoroutines = os.getenv(breakInCoroutinesEnv) == "1"
            function Debugger.pushHook(hookType)
                table.insert(hookStack, hookType)
                setErrorHandler()
                if #hookStack > 1 then
                    return
                end
                coroutine.create = function(f) return debuggerCoroutineCreate(f, breakInCoroutines) end
                coroutine.wrap = debuggerCoroutineWrap
                coroutine.resume = (breakInCoroutines and debuggerCoroutineResume) or luaCoroutineResume
                local currentThread = coroutine.running()
                if currentThread and (not threadIds[currentThread]) then
                    registerThread(currentThread)
                end
                updateHook()
            end

            function Debugger.popHook()
                table.remove(hookStack)
                if #hookStack == 0 then
                    Debugger.clearHook()
                else
                    setErrorHandler()
                    updateHook()
                end
            end

            function Debugger.triggerBreak()
                breakAtDepth = math.huge
                updateHook()
            end

            function Debugger.debugGlobal(breakImmediately)
                Debugger.pushHook("global")
                if breakImmediately then
                    Debugger.triggerBreak()
                end
            end

            function Debugger.debugFunction(func, breakImmediately, args)
                Debugger.pushHook("function")
                if breakImmediately then
                    Debugger.triggerBreak()
                end
                local results = {
                    xpcall(
                        function()
                            return func(
                                unpack(args)
                            )
                        end,
                        breakForError
                    )
                }
                Debugger.popHook()
                if results[1] then
                    return unpack(results, 2)
                else
                    skipNextBreak = true
                    local message = mapSources(
                        tostring(results[2])
                    )
                    return luaError(message, 2)
                end
            end

            function Debugger.pullBreakpoints()
                if pullFile then
                    local newPullSeek = pullFile:seek("end")
                    if newPullSeek > lastPullSeek then
                        lastPullSeek = newPullSeek
                        Debugger.triggerBreak()
                    end
                end
            end
        end
        return ____exports
    end,
    ["lldebugger"] = function(...)
        local ____exports = {}
        local ____luafuncs = require("luafuncs")
        local luaAssert = ____luafuncs.luaAssert
        local loadLuaFile = ____luafuncs.loadLuaFile
        local ____debugger = require("debugger")
        local Debugger = ____debugger.Debugger
        _G.lldebugger = _G.lldebugger or ____exports
        if io.stdout then
            io.stdout:setvbuf("no")
        end
        if io.stderr then
            io.stderr:setvbuf("no")
        end
        function ____exports.start(breakImmediately)
            if breakImmediately == nil then
                breakImmediately = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1"
            end
            Debugger.debugGlobal(breakImmediately)
        end

        function ____exports.finish()
            Debugger.popHook()
        end

        function ____exports.stop()
            Debugger.clearHook()
        end

        function ____exports.pullBreakpoints()
            Debugger.pullBreakpoints()
        end

        function ____exports.runFile(filePath, breakImmediately, arg)
            if type(filePath) ~= "string" then
                error(
                    ("expected string as first argument to runFile, but got '" .. type(filePath)) .. "'",
                    0
                )
            end
            if (breakImmediately ~= nil) and (type(breakImmediately) ~= "boolean") then
                error(
                    ("expected boolean as second argument to runFile, but got '" .. type(breakImmediately)) .. "'",
                    0
                )
            end
            local env = setmetatable(
                { arg = arg },
                {
                    __index = _G,
                    __newindex = function(____self, key, value)
                        _G[key] = value
                    end
                }
            )
            local func = luaAssert(
                loadLuaFile(filePath, env)
            )
            return Debugger.debugFunction(func, breakImmediately, arg or ({}))
        end

        function ____exports.call(func, breakImmediately, ...)
            local args = { ... }
            if type(func) ~= "function" then
                error(
                    ("expected string as first argument to debugFile, but got '" .. type(func)) .. "'",
                    0
                )
            end
            if (breakImmediately ~= nil) and (type(breakImmediately) ~= "boolean") then
                error(
                    ("expected boolean as second argument to debugFunction, but got '" .. type(breakImmediately)) .. "'",
                    0
                )
            end
            return Debugger.debugFunction(func, breakImmediately, args)
        end

        function ____exports.requestBreak()
            Debugger.triggerBreak()
        end

        return ____exports
    end,
}
return require("lldebugger", ...)
