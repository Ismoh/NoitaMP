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
--- @return string|number match_last_slash i.e.: "mods/files/scripts"
function GetPathOfScript()
    local rel_path_to_this_script = debug.getinfo(2, "S").source:sub(1)

    -- TODO unix -> str:match("(.*/)")

    local match_last_slash = rel_path_to_this_script:match("(.*[/\\])")
    match_last_slash = string.sub(0, string.len(match_last_slash)-1)
    print("file_util.lua | Relative path to parent folder of this script = " .. match_last_slash)

    match_last_slash = ReplacePathSeparator(match_last_slash)
    return match_last_slash
end


----------------------------------------------------------------------------------------------------
-- Savegame / world stuff
----------------------------------------------------------------------------------------------------

--- Returns files with its associated directory path relative to \save00
--- @return table [1] { "\dir1\dir2" , "filename" }
--- @return integer amount of files within save00 (rekursive)
function GetDirAndFilesOfSave00()
    local dir_save_00 = "save00"
    local command = 'dir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\' .. dir_save_00 .. '" /b/s'
    if DebugGetIsDevBuild() then
        command = "dir " .. dir_save_00 .. " /b/s"
    end
    if unix then
        error("Unix system are not supported yet :(",2)-- use ls bla bla
    end

    local file = assert(io.popen(command, "r"), "Unable to execute command: " .. command)
    local path = ""
    local t = {}
    local i = 1
    while path ~= nil do
        path = file:read("*l")

        if path ~=nil and path ~= "" then
            -- C:\Program Files (x86)\Steam\steamapps\common\Noita\save00\world\.autosave_player
            -- to world\.autosave_player
            local index_start, index_end = string.find(path, dir_save_00 .. "\\")
            local relative = string.sub(path, index_end + 1) -- +1 to get rid of \ or /

            local dir_name = ""
            local file_name = ""

            if IsDir(path) then
                dir_name = relative
            else
                local t_match = {}
                local i_match = 0
                for match in relative:gmatch("[^\\" .. path_separator .. "]*") do
                    if match ~= "" then
                        i_match = i_match + 1
                        t_match[i_match] = match
                    end
                end

                for ind, dir_or_file in ipairs(t_match) do
                    if ind < i_match then
                        dir_name = dir_name .. dir_or_file .. path_separator
                    else
                        file_name = dir_or_file
                    end
                end
            end

            if string.sub(dir_name, -1, -1) == path_separator then -- check for trailing path separator
                dir_name = string.sub(dir_name, 1, -2) -- remove it
            end

            t[i] = { dir_name, file_name }
            i = i + 1
        end
    end
    return t, i
end


--- Returns fullpath of save00 directory on devBuild or release
--- @return string save00_path : noita installation path\save00, %appdata%\..\LocalLow\Nolla_Games_Noita\save00 on windows and unknown for unix systems
function GetDirPathOfSave00()
    local file = nil
    if unix then
        error("file_util.lua | Unix systems are not supported yet. I am sorry! :(")
    end

    if DebugGetIsDevBuild() then
        file = assert(io.popen("dir /s/b/ad", "r")) -- path where noita.exe is
    else
        file = assert(io.popen("dir \"%appdata%\\..\\LocalLow\\Nolla_Games_Noita\" /s/b/ad", "r"))
    end

    local save00_path = nil
    local line = ""
    while line ~= nil do
        line = file:read("*l")
        if string.find(line, "save00") then
            save00_path = line -- .. "\\world"
            break
        end
    end
    file:close()

    if save00_path == nil or save00_path == "" then
        GamePrintImportant("Unable to find world files","Do yourself a favour and save&quit the game and start it again!")
    end

    save00_path = ReplacePathSeparator(save00_path)
    return save00_path
end


--- Returns the ABSOLUTE path of the mods folder.
--- If _G.noita_root_path is not set yet, then it will be
--- @return string _G.noita_root_path .. "/mods"
function GetAbsolutePathOfModFolder()
    if not _G.noita_root_path then
        SetNoitaRootAbsolutePath()
    end
    local p = _G.noita_root_path .. "/mods/noita-mp"
    p = ReplacePathSeparator(p)
    return p
end


--- Returns the RELATIVE path of the mods folder.
--- @return string "mods/noita-mp"
function GetRelativePathOfModFolder()
    local p = "mods/noita-mp"
    p = ReplacePathSeparator(p)
    return p
end

--- Returns the RELATIVE path of the library folder required for this mod.
--- @return string "/mods/noita-mp/files/libs"
function GetRelativePathOfRequiredLibs()
    local p = "mods/noita-mp/files/libs"
    p = ReplacePathSeparator(p)
    return p
end


--- Returns the ABSOLUTE path of the library folder required for this mod.
--- If _G.noita_root_path is not set yet, then it will be
--- @return string _G.noita_root_path .. "/mods/noita-mp/files/libs"
function GetAbsolutePathOfRequiredLibs()
    if not _G.noita_root_path then
        SetNoitaRootAbsolutePath()
    end
    local p = _G.noita_root_path .. "/mods/noita-mp/files/libs"
    p = ReplacePathSeparator(p)
    return p
end


----------------------------------------------------------------------------------------------------
-- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

function Exists(name)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(name)~="string" then return false end
    return os.rename(name,name) and true or false
end


function IsFile(name)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(name)~="string" then return false end
    if not Exists(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end


function IsDir(name)
    -- https://stackoverflow.com/a/21637809/3493998
    return (Exists(name) and not IsFile(name))
end


function ReadBinaryFile(file_fullpath)
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

----------------------------------------------------------------------------------------------------
-- Noita restart, yay!
----------------------------------------------------------------------------------------------------

function RestartNoita()
    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute("start \"\" " .. exe .. " -no_logo_splashes -save_slot 0 -gamemode 0")
    os.exit()
end
