_G.isTestLuaContext = true

dofile("../noita-mp/files/scripts/init/init_package_loading.lua")

local lfs = require("lfs")

--- Returns a list of all files in a directory
function getAllFilesInside(folder)
    local files = {}
    for entry in lfs.dir(folder) do
        if entry ~= "." and entry ~= ".." and not entry:find("_initializeUnitTests") then
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

local gDofile   = dofile
if not ModSettingGet then
    ----------------------------------------
    --- MOCKING NOITA API GLOBAL FUNCTIONS:
    --- Only add ids, which are necessary for initialization of tests.
    --- DO NOT add ids, which are used in a test. Add those inside of the test itself!
    ----------------------------------------
    ModSettingGet          = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return { "trace, debug, info, warn", "TRACE" }
        end
        if id == "noita-mp.guid" then
            return MinaUtils.getLocalMinaGuid()
        end

        error(("ModSettingGet '%s' is not mocked! Add it!"):format(id), 2)
    end

    ModSettingGetNextValue = function(id)
        if id == "noita-mp.toggle_profiler" then
            return false
        end
        if id == "noita-mp.guid" then
            return MinaUtils.getLocalMinaGuid()
        end

        error(("ModSettingGetNextValue '%s' is not mocked! Add it!"):format(id), 2)
    end

    ModSettingSetNextValue = function(id, value, is_default)
        Logger.trace(Logger.channels.testing, ("Mocked ModSettingSetNextValue(%s, %s, %s)")
                :format(id, value, is_default))
    end

    DebugGetIsDevBuild     = function()
        return false
    end

    local pathToMods       = lfs.currentdir() .. "/../.."
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

dofile("mods/noita-mp/files/scripts/init/init_.lua")

for _, testFile in ipairs(testFiles) do
    print("")
    print("")
    print("##################################################")
    print("Running test: " .. testFile)
    --dofile(testFile)
    assert(loadfile(testFile))("--verbose", "--error", "--failure")
end