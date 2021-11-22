-- https://stackoverflow.com/a/14425862/3493998
local path_separator = package.config:sub(1,1)
local windows = string.find(path_separator, '\\')
local unix = string.find(path_separator, '/')

_G.is_windows = windows
_G.is_unix = unix
if windows then
    _G.path_separator = tostring(path_separator)
else
    _G.path_separator = tostring(path_separator)
end


function ReplacePathSeparator(path)
    if _G.is_windows then
        -- replace unix path separator with windows, if there are any / in the path
        path = string.gsub(path, "/", _G.path_separator)
        -- fix string path C:\tmp\tmp1\\test.xml to C:\\tmp\\tmp1\\test.xml
        --path = string.gsub(path, "\\", _G.path_separator)
    else
        -- replace windows path separator with unix, if there are any \ in the path
        path = string.gsub(path, "\\", _G.path_separator)
    end
    return path
end


--- Sets Noitas root absolute path to _G
function SetNoitaRootAbsolutePath()
    local noita_root_path = assert(io.popen("cd"):read("*l"), "Unable to run windows command \"cd\" to get Noitas root folder!")
    noita_root_path = ReplacePathSeparator(noita_root_path)

    _G.noita_root_path = noita_root_path

    print("file_util.lua | Noitas root absolute path set to " .. _G.noita_root_path)
end


function GetNoitaRootAbsolutePath()
    return _G.noita_root_path
end


--- Returns the relative path to the parent folder of the script, which executes this function.
--- Slash at the end is removed.
---@return string|number match_last_slash i.e.: "mods/files/scripts"
function GetPathOfScript()
    local rel_path_to_this_script = debug.getinfo(2, "S").source:sub(1)

    -- TODO unix -> str:match("(.*/)")

    local match_last_slash = rel_path_to_this_script:match("(.*[/\\])")
    match_last_slash = string.sub(0, string.len(match_last_slash)-1)
    print("file_util.lua | Relative path to parent folder of this script = " .. match_last_slash)

    match_last_slash = ReplacePathSeparator(match_last_slash)
    return match_last_slash
end


--- Returns the worlds folder depending on devBuild or release
---@return string world_path : noita installation path, %appdata%\..\LocalLow\Nolla_Games_Noita\ on windows and unknown for unix systems
function GetWorldFolder()
    local file = nil

    if unix then
        error("file_util.lua | Unix systems are not supported yet. I am sorry! :(")
    end

    if DebugGetIsDevBuild() then
        file = assert(io.popen("dir /s/b/ad", "r")) -- path where noita.exe is
    else
        file = assert(io.popen("dir \"%appdata%\\..\\LocalLow\\Nolla_Games_Noita\" /s/b/ad", "r"))
    end

    --local content = file:read("*a")
    local world_path = nil
    local line = ""
    while line ~= nil do
        line = file:read("*l")
        if string.find(line, "save00") then
            world_path = line .. "\\world"
            break
        end
    end
    file:close()

    if world_path == nil or world_path == "" then
        GamePrintImportant("Unable to find world files","Do yourself a favour and save&quit the game and start it again!")
    end

    world_path = ReplacePathSeparator(world_path)
    return world_path
end


-- function GetAmountOfWorldFiles()
--     local file = nil

--     if unix then
--         error("file_util.lua | Unix systems are not supported yet. I am sorry! :(")
--     end

--     local command = 'dir "' .. GetWorldFolder() .. '" /s/b'
--     file = assert(io.popen(command, "r"), "Unable to count world files. command: " .. command)

--     local count = 0
--     local line = ""
--     while line ~= nil do
--         line = file:read("*l")
--         count = count + 1
--     end
--     file:close()

--     if count <= 0 then
--         GamePrintImportant("Unable to find world files","Do yourself a favour and save&quit the game and start it again! Count = " .. count)
--     end

--     return count
-- end


--- Returns the ABSOLUTE path of the mods folder.
--- If _G.noita_root_path is not set yet, then it will be
---@return string _G.noita_root_path .. "/mods"
function GetAbsolutePathOfModFolder()
    if not _G.noita_root_path then
        SetNoitaRootAbsolutePath()
    end
    local p = _G.noita_root_path .. "/mods/noita-mp"
    p = ReplacePathSeparator(p)
    return p
end


--- Returns the RELATIVE path of the mods folder.
---@return string "mods/noita-mp"
function GetRelativePathOfModFolder()
    local p = "mods/noita-mp"
    p = ReplacePathSeparator(p)
    return p
end

--- Returns the RELATIVE path of the library folder required for this mod.
---@return string "/mods/noita-mp/files/libs"
function GetRelativePathOfRequiredLibs()
    local p = "mods/noita-mp/files/libs"
    p = ReplacePathSeparator(p)
    return p
end


--- Returns the ABSOLUTE path of the library folder required for this mod.
--- If _G.noita_root_path is not set yet, then it will be
---@return string _G.noita_root_path .. "/mods/noita-mp/files/libs"
function GetAbsolutePathOfRequiredLibs()
    if not _G.noita_root_path then
        SetNoitaRootAbsolutePath()
    end
    local p = _G.noita_root_path .. "/mods/noita-mp/files/libs"
    p = ReplacePathSeparator(p)
    return p
end

----------------------------------------------------------------------------------------------------

function FileExists(path)
    path = ReplacePathSeparator(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
  end

function GetSavegameWorldFileNames()
    local command = ""
    if windows then
        command = 'dir "' .. GetWorldFolder() .. '" /s/b'
    end
    -- if unix then
    --     path = "??"
    --     command = "ls -a " .. path -- TODO where are the savegames stored on unix?
    -- end

    -- https://stackoverflow.com/a/11130774/3493998
    local i, t, popen = 0, {}, io.popen
    local pfile = popen(command)
    for file_fullpath in pfile:lines() do
        i = i + 1
        t[i] = file_fullpath
    end
    pfile:close()
    return t, i
end


function ReadSavegameWorldFile(file_fullpath)
    file_fullpath = ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file = io.open(file_fullpath, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


function WriteBinaryFile(file_fullpath, file_content)
    file_fullpath = ReplacePathSeparator(file_fullpath)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "wb"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end


function WriteFile(file_fullpath, file_content)
    file_fullpath = ReplacePathSeparator(file_fullpath)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "w"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end


function RestartNoita()
    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute("start \"\" " .. exe .. " -save_slot 0 -gamemode 0")
    os.exit()
end
