_G.isTestLuaContext = true

---comment
---@see init_package_loading.lua
---@return string
function getRootDirectory()
    -- Get the current directory of the script or the executable
    local currentDirectory = io.popen("cd"):read("*l") .. "/" .. debug.getinfo(1).source
    print("currentDirectory: " .. currentDirectory)

    -- Check if we are inside of noita-mp directory. Don't forget to escape the dash!
    local startsAtI, endsAtI = string.find(currentDirectory, "noita%-mp") -- https://stackoverflow.com/a/20223010/3493998
    local rootDirectory      = nil
    if not startsAtI then
        error("The current directory is not inside the noita-mp directory. Please run it again somewhere inside the noita-mp directory.")
    else
        rootDirectory = string.sub(currentDirectory, 1, startsAtI - 7)
    end
    print("rootDirectory: " .. rootDirectory)
    return rootDirectory
end

local gDofile   = dofile
local gLoadfile = loadfile
local rootDir   = getRootDirectory()
dofile          = function(path)
    if path:sub(1, 4) == "mods" then
        local pathToMod = rootDir .. "/" .. path
        print("dofile path: " .. pathToMod)
        return gDofile(pathToMod)
    else
        return gDofile(path)
    end
end
loadfile        = function(path)
    if path:sub(1, 4) == "mods" then
        local pathToMod = rootDir .. "/" .. path
        print("loadfile path: " .. pathToMod)
        return gLoadfile(pathToMod)
    else
        return gLoadfile(path)
    end
end

if not ModSettingGet then
    ----------------------------------------
    --- MOCKING NOITA API GLOBAL FUNCTIONS:
    --- Only add ids, which are necessary for initialization of tests.
    --- DO NOT add ids, which are used in a test. Add those inside of the test itself!
    ----------------------------------------
    ModSettingGet                    = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return { "trace, debug, info, warn", "TRACE" }
        end
        if id == "noita-mp.name" then
            local name = minaUtils:getLocalMinaName()
            if utils:IsEmpty(name) then
                name = "initializeUnitTests"
            end
            return name
        end
        if id == "noita-mp.guid" then
            local guid = minaUtils:getLocalMinaGuid()
            if utils:IsEmpty(guid) then
                guid = guidUtils:generateNewGuid()
            end
            return guid
        end

        if id == "noita-mp.connect_server_seed" then
            return nil
        end

        if id == "noita-mp.saveSlotMetaDirectory" then
            return "%AppData%/LocalLow/Nolla_Games_Noita/save00"
        end

        error(("ModSettingGet '%s' is not mocked! Add it!"):format(id), 2)
    end

    ModSettingGetNextValue           = function(id)
        minaUtils = minaUtils or require("MinaUtils") --:new()

        if id == "noita-mp.toggle_profiler" then
            return false
        end
        if id == "noita-mp.guid" then
            return minaUtils:getLocalMinaGuid()
        end

        error(("ModSettingGetNextValue '%s' is not mocked! Add it!"):format(id), 2)
    end

    ModSettingSetNextValue           = function(id, value, is_default)
        logger:trace(logger.channels.testing, ("Mocked ModSettingSetNextValue(%s, %s, %s)"):format(id, value, is_default))
    end

    DebugGetIsDevBuild               = function()
        return false
    end

    ModGetActiveModIDs               = function()
        return { 'NoitaDearImGui', 'component-explorer', 'EnableLogger', 'minidump', 'cheatgui', 'noita-mp' }
    end

    ModIsEnabled                     = function(id)
        return true
    end

    GameGetRealWorldTimeSinceStarted = function()
        return 0
    end

    load_imgui                       = function()
        return true
    end

    ModMagicNumbersFileAdd           = function(path)
        return true
    end

    SetWorldSeed                     = function(seed)
        return true
    end

    EntityGetIsAlive                 = function(entity)
        return true
    end
    EntityGetRootEntity              = function(entity)
        return entity
    end
end

dofile("../noita-mp/files/scripts/init/init_.lua")

require("lldebugger").start()

local gui = {} -- mocked gui
local utils = require("Utils"):new()
local noitaMpSettings = require("NoitaMpSettings")
    :new(nil, nil, gui, nil, nil, nil, nil)
local customProfiler = require("CustomProfiler")
    :new(nil, nil, noitaMpSettings, nil, nil, utils, nil)
local logger = noitaMpSettings.logger or require("Logger")
    :new(nil, noitaMpSettings)
local fileUtils = require("FileUtils")
    :new(nil, customProfiler, logger, noitaMpSettings)
local globalsUtils = require("GlobalsUtils")
    :new(nil, customProfiler, logger, {}, utils)
local networkVscUtils = require("NetworkVscUtils")
    :new(nil, noitaMpSettings, customProfiler, logger, {}, globalsUtils, utils)
local minaUtils = require("MinaUtils")
    :new(nil, customProfiler, globalsUtils, logger, networkVscUtils,
        noitaMpSettings, utils)
local guidUtils = require("GuidUtils")
    :new(nil, customProfiler, fileUtils, logger, nil, nil, utils)


dofile("../noita-mp/init.lua")

-- local lfs = require("lfs")

-- --- Returns a list of all files in a directory
-- function getAllFilesInside(folder)
--     local files = {}
--     for entry in lfs.dir(folder) do
--         if entry ~= "." and entry ~= ".." and not entry:find("unitTestRunner") then
--             local path = folder .. "/" .. entry
--             local mode = lfs.attributes(path, "mode")
--             if mode == "file" then
--                 table.insert(files, path)
--                 print("Found file: " .. path)
--             elseif mode == "directory" then
--                 --print("Found directory: " .. path)
--                 local subfiles = getAllFilesInside(path)
--                 for _, subfile in ipairs(subfiles) do
--                     table.insert(files, subfile)
--                 end
--             end
--         end
--     end
--     return files
-- end

-- local testFiles = getAllFilesInside(lfs.currentdir() .. "/files/scripts")

-- for _, testFile in ipairs(testFiles) do
--     local command = ('start "LuaJIT profiler on %s" /D "%s" lua.bat -jp %s 2>&1 &'):format(testFile, lfs.currentdir(), testFile)
--     os.execute(command)
--     --loadfile(testFile)("-jp=a")
--     print(("%s profiled.."):format(testFile))
-- end

OnModPreInit()
OnWorldInitialized()
OnPlayerSpawned(1)
OnPausePreUpdate()
OnWorldPreUpdate()
OnWorldPostUpdate()
