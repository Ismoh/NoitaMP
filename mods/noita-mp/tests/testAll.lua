dofile("../noita-mp/files/scripts/init/init_package_loading.lua")

local lfs = require("lfs")

function showFolder(folder)
    print('=====================  ' .. folder)
    local path = system.pathForFile(folder, system.ResourceDirectory)
    for file in lfs.dir(path) do
        print(file)
    end
end

local isWindows = string.find(os.getenv("OS"), "indows")

-- Lua implementation of PHP scandir function
-- copy from file_util.lua
function scanDir(directory)

    if not directory or type(directory) ~= "string" then
        error(("scanDir: directory is not a string or is nil: %s").format(directory))
    end

    local i, t, popen = 0, {}, io.popen
    local pfile       = nil

    if isWindows then
        for dir in io.popen([[dir "]] .. directory .. [[" /b /ad]]):lines() do
            i    = i + 1
            t[i] = dir
            print("dir: " .. dir)
        end
        pfile = popen('dir "' .. directory .. '" /b /ad')
    else
        pfile = popen('ls -a "' .. directory .. '"')
    end

    for filename in pfile:lines() do
        i    = i + 1
        t[i] = filename
        print("filename: " .. filename)
    end
    pfile:close()
    return t
end

local noitaMpDirectory = ""
if isWindows then
    noitaMpDirectory = io.popen("cd"):read()
    print("currentDirectory: " .. noitaMpDirectory)
else
    error("Not implemented yet, because OS is not Windows. :(")
end

local testFiles = showFolder(lfs.currentdir() .. "/tests/")
local testFiles = scanDir(noitaMpDirectory .. "/tests/")
for i, file in ipairs(testFiles) do
    if string.find(file, "test") then
        dofile(noitaMpDirectory .. "/tests/" .. file)
    end
end