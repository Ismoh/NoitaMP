dofile("../noita-mp/files/scripts/init/init_package_loading.lua")

local lfs = require("lfs")

--- Returns a list of all files in a directory
function getAllFilesInside(folder)
    local files = {}
    for entry in lfs.dir(folder) do
        if entry ~= "." and entry ~= ".." and not entry:find("startUnitTests") then
            local path = folder .. "/" .. entry
            local mode = lfs.attributes(path, "mode")
            if mode == "file" then
                table.insert(files, path)
                print("Found file: " .. path)
            elseif mode == "directory" then
                --print("Found directory: " .. path)
                local subfiles = getAllFilesInside(path)
                for _, subfile in ipairs(subfiles) do
                    print("Found file: " .. subfile)
                    table.insert(files, subfile)
                end
            end
        end
    end
    return files
end

local testFiles = getAllFilesInside(lfs.currentdir() .. "/tests")

local doFile    = dofile
if not ModSettingGet then
    local pathToMods = lfs.currentdir() .. "/../.."
    print("pathToMods: " .. pathToMods)
    dofile = function(path)
        if path:sub(1, 4) == "mods" then
            local pathToMod = pathToMods .. "/" .. path
            print("dofile path: " .. pathToMod)
            return doFile(pathToMod)
        else
            return doFile(path)
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