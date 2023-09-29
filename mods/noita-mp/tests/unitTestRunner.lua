_G.isTestLuaContext = true
_G.disableLuaExtensionsDLL = true
local params = ...

---comment
---@see init_package_loading.lua
---@return string
function getNoitaMpRootDirectory()
    -- Get the current directory of the script or the executable
    local currentDirectory = io.popen("cd"):read("*l") .. "/" .. debug.getinfo(1).source
    print("currentDirectory: " .. currentDirectory)

    -- Check if we are inside of noita-mp directory. Don't forget to escape the dash!
    local startsAtI, endsAtI   = string.find(currentDirectory, "noita%-mp") -- https://stackoverflow.com/a/20223010/3493998
    local noitaMpRootDirectory = nil
    if not startsAtI then
        error("The current directory is not inside the noita-mp directory. Please run it again somewhere inside the noita-mp directory.")
    else
        noitaMpRootDirectory = string.sub(currentDirectory, 1, endsAtI)
    end
    print("noitaMpRootDirectory: " .. noitaMpRootDirectory)
    return noitaMpRootDirectory
end

local gDofile = dofile
if not ModSettingGet then
    ----------------------------------------
    --- MOCKING NOITA API GLOBAL FUNCTIONS:
    --- Only add ids, which are necessary for initialization of tests.
    --- DO NOT add ids, which are used in a test. Add those inside of the test itself!
    ----------------------------------------
    ModSettingGet          = function(id)
        utils = utils or require("Utils")             --:new()
        minaUtils = minaUtils or require("MinaUtils") --:new()
        guidUtils = guidUtils or require("GuidUtils") --:new()

        if string.contains(id, "noita-mp.log_level_") then
            return { "trace, debug, info, warn", "TRACE" }
        end
        if id == "noita-mp.name" then
            local name = minaUtils.getLocalMinaName()
            if utils.IsEmpty(name) then
                name = "initializeUnitTests"
            end
            return name
        end
        if id == "noita-mp.guid" then
            local guid = minaUtils.getLocalMinaGuid()
            if Utils.IsEmpty(guid) then
                guid = guidUtils:generateNewGuid()
            end
            return guid
        end

        error(("ModSettingGet '%s' is not mocked! Add it!"):format(id), 2)
    end

    ModSettingGetNextValue = function(id)
        minaUtils = minaUtils or require("MinaUtils") --:new()

        if id == "noita-mp.toggle_profiler" then
            return false
        end
        if id == "noita-mp.guid" then
            return minaUtils.getLocalMinaGuid()
        end

        error(("ModSettingGetNextValue '%s' is not mocked! Add it!"):format(id), 2)
    end

    ModSettingSetNextValue = function(id, value, is_default)
        gui = gui or {} -- mocked gui
        noitaMpSettings = noitaMpSettings or require("NoitaMpSettings")
            :new(nil, nil, gui, nil, nil, nil, nil)
        customProfiler = customProfiler or require("CustomProfiler")
            :new(nil, nil, noitaMpSettings, nil, nil, nil, nil)
        logger = logger or require("Logger")
            :new(nil, customProfiler)

        logger:trace(logger.channels.testing, ("Mocked ModSettingSetNextValue(%s, %s, %s)"):format(id, value, is_default))
    end

    DebugGetIsDevBuild     = function()
        return false
    end

    ModGetActiveModIDs     = function()
        return { 'NoitaDearImGui', 'component-explorer', 'EnableLogger', 'minidump', 'cheatgui', 'noita-mp' }
    end

    ModIsEnabled           = function(id)
        return true
    end

    local pathToMods = getNoitaMpRootDirectory() .. "/../.."
    print("pathToMods: " .. pathToMods)
    dofile = function(path)
        if path:sub(1, 4) == "mods" then
            local pathToMod = pathToMods .. "/" .. path
            print("dofile path: " .. pathToMod)
            return gDofile(pathToMod)
        else
            return gDofile(path)
        end
    end
end

dofile("../noita-mp/files/scripts/init/init_.lua")

local lfs = require("lfs")
local lu  = require("luaunit")

--- Returns a list of all files in a directory
function getAllFilesInside(folder)
    local files = {}
    for entry in lfs.dir(folder) do
        if entry ~= "." and entry ~= ".." and not entry:find("unitTestRunner") then
            local path = folder .. "/" .. entry
            local mode = lfs.attributes(path, "mode")
            if mode == "file" then
                table.insert(files, path)
                print("Found file: " .. path)
            elseif mode == "directory" then
                --print("Found directory: " .. path)
                local subfiles = getAllFilesInside(path)
                for _, subfile in ipairs(subfiles) do
                    table.insert(files, subfile)
                end
            end
        end
    end
    return files
end

local testFiles = getAllFilesInside(lfs.currentdir() .. "/tests")

for _, testFile in ipairs(testFiles) do
    dofile(testFile)
    print("Loaded test " .. _ .. " " .. testFile)
end

lu.LuaUnit.run(params)
