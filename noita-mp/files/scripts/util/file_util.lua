-- https://stackoverflow.com/a/14425862/3493998
local path_separator = package.config:sub(1,1)
local windows = string.find(path_separator, '\\')
local unix = string.find(path_separator, '/')

local path = ""
local command = ""
if windows then
    path = "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\save00\\world"
    command = "dir " .. path .. " /s/b" -- add '/ad' for directories only
end
if unix then
    path = "??"
    command = "ls -a " .. path -- TODO where are the savegames stored on unix?
end

function GetSavegameWorldFileNames()
    -- https://stackoverflow.com/a/11130774/3493998
    local i, t, popen = 0, {}, io.popen
    local pfile = popen(command)
    for file_fullpath in pfile:lines() do
        i = i + 1
        t[i] = file_fullpath
    end
    pfile:close()
    return t

end

function ReadSavegameWorldFile(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file = io.open(file_fullpath, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function WriteSavegameWorldFile(file_fullpath, file_content)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "wb"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end