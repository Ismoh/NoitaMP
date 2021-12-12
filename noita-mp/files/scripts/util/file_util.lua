local ffi = require("ffi")

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
        -- path = string.gsub(path, "\\", _G.path_separator) TODO: \dir1\\dir2\dir3\\file.tmp
    else
        -- replace windows path separator with unix, if there are any \ in the path
        path = string.gsub(path, "\\", _G.path_separator)
    end
    return path
end


--- Removes trailing path separator in a string: \persistent\flags\ -> \persistent\flags
--- @param path string any string, i.e. \persistent\flags\
--- @return string path \persistent\flags
function RemoveTrailingPathSeparator(path)
    if type(path) ~= "string" then return path end
    if string.sub(path, -1, -1) == path_separator then -- check for trailing path separator
        path = string.sub(path, 1, -2) -- remove it
    end
    return tostring(path)
end


--- Sets Noitas root absolute path to _G
function SetAbsolutePathOfNoitaRootDirectory()
    local noita_root_directory_path = assert(io.popen("cd"):read("*l"), "Unable to run windows command \"cd\" to get Noitas root directory!")
    noita_root_directory_path = ReplacePathSeparator(noita_root_directory_path)

    _G.noita_root_directory_path = noita_root_directory_path

    print("file_util.lua | Absolute path of Noitas root directory set to " .. _G.noita_root_directory_path)
end


function GetAbsolutePathOfNoitaRootDirectory()
    return _G.noita_root_directory_path
end


-- --- Returns the relative path to the parent folder of the script, which executes this function.
-- --- Slash at the end is removed.
-- --- @return string|number match_last_slash i.e.: "mods/files/scripts"
-- function GetRelativeDirectoryPathOfSelfScript()
--     local rel_path_to_this_script = debug.getinfo(2, "S").source:sub(1)

--     -- TODO unix -> str:match("(.*/)")

--     local match_last_slash = rel_path_to_this_script:match("(.*[/\\])")
--     match_last_slash = string.sub(0, string.len(match_last_slash)-1)
--     print("file_util.lua | Relative path to parent folder of this script = " .. match_last_slash)

--     match_last_slash = ReplacePathSeparator(match_last_slash)
--     return match_last_slash
-- end


----------------------------------------------------------------------------------------------------
-- Savegame / world stuff
----------------------------------------------------------------------------------------------------

--- Returns files with its associated directory path relative to \save00\*
--- @return table [1] { "\persistent\flags" , "filename" }
--- @return integer amount of files within save00 (rekursive)
function GetRelativeDirectoryAndFilesOfSave00()
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

            if IsDirectory(path) then
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

            dir_name = RemoveTrailingPathSeparator(dir_name)

            t[i] = { dir_name, file_name }
            i = i + 1
        end
    end
    return t, i
end

---comment
---@return string save00_parent_directory_path noita installation path or %appdata%\..\LocalLow\Nolla_Games_Noita on windows and unknown for unix systems
function GetAbsoluteDirectoryPathOfParentSave00()
    local file = nil
    if unix then
        error("file_util.lua | Unix systems are not supported yet. I am sorry! :(")
    end

    local find_directory_name = nil
    if DebugGetIsDevBuild() then
        file = assert(io.popen("dir .. /s/b/ad", "r")) -- path where noita.exe is
        find_directory_name = "Noita"
    else
        file = assert(io.popen('dir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\.." /s/b/ad', "r"))
        find_directory_name = "Nolla_Games_Noita"
    end

    local save00_parent_directory_path = nil
    local line = ""
    while line ~= nil do
        line = file:read("*l")
        if string.find(line, find_directory_name) then
            save00_parent_directory_path = line -- .. "\\world"
            break
        end
    end
    file:close()

    if save00_parent_directory_path == nil or save00_parent_directory_path == "" then
        GamePrintImportant("Unable to find world files","Do yourself a favour and save&quit the game and start it again!")
    end

    save00_parent_directory_path = ReplacePathSeparator(save00_parent_directory_path)
    return save00_parent_directory_path
end

--- Returns fullpath of save00 directory on devBuild or release
--- @return string directory_path_of_save00 : noita installation path\save00 or %appdata%\..\LocalLow\Nolla_Games_Noita\save00 on windows and unknown for unix systems
function GetAbsoluteDirectoryPathOfSave00()
    local directory_path_of_save00 = GetAbsoluteDirectoryPathOfParentSave00() .. _G.path_separator .. "save00"
    return directory_path_of_save00
end


--- Returns the ABSOLUTE path of the mods folder.
--- If _G.noita_root_directory_path is not set yet, then it will be
--- @return string _G.noita_root_directory_path .. "/mods"
function GetAbsoluteDirectoryPathOfMods()
    if not _G.noita_root_directory_path then
        SetAbsolutePathOfNoitaRootDirectory()
    end
    local p = _G.noita_root_directory_path .. "/mods/noita-mp"
    p = ReplacePathSeparator(p)
    return p
end


--- Returns the RELATIVE path of the mods folder.
--- @return string "mods/noita-mp"
function GetRelativeDirectoryPathOfMods()
    local p = "mods/noita-mp"
    p = ReplacePathSeparator(p)
    return p
end

--- Returns the RELATIVE path of the library folder required for this mod.
--- @return string "/mods/noita-mp/files/libs"
function GetRelativeDirectoryPathOfRequiredLibs()
    local p = "mods/noita-mp/files/libs"
    p = ReplacePathSeparator(p)
    return p
end


--- Returns the ABSOLUTE path of the library folder required for this mod.
--- If _G.noita_root_directory_path is not set yet, then it will be
--- @return string _G.noita_root_directory_path .. "/mods/noita-mp/files/libs"
function GetAbsoluteDirectoryPathOfRequiredLibs()
    if not _G.noita_root_directory_path then
        SetAbsolutePathOfNoitaRootDirectory()
    end
    local p = _G.noita_root_directory_path .. "/mods/noita-mp/files/libs"
    p = ReplacePathSeparator(p)
    return p
end


----------------------------------------------------------------------------------------------------
-- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

--- Checks if FILE or DIRECTORY exists
--- @param name string full path
--- @return boolean
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


function IsDirectory(name)
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


function MkDir(full_path)
    -- https://stackoverflow.com/a/1690932/3493998
    full_path = ReplacePathSeparator(full_path)
    os.execute('mkdir "' .. full_path .. '"')
end


----------------------------------------------------------------------------------------------------
-- 7zip stuff
----------------------------------------------------------------------------------------------------

function Find7zipExecutable()
    if is_windows then
        local f = io.popen("where.exe 7z", "r")
        if not f then
            error("Unable to find 7z.exe, please install 7z via https://7-zip.de/download.html and restart the Noita!", 2)
            os.exit()
        end
        local response = f:read("*a")
        _G.seven_zip = tostring(ReplacePathSeparator(response))
        print("file_util.lua | Found 7z.exe: " .. _G.seven_zip)
    else
        error("Unfortunately unix systems aren't supported yet. Please consider https://github.com/Ismoh/NoitaMP/issues!", 2)
    end
end

function Exists7zip()
    if _G.seven_zip then
        return true
    else
        return false
    end
end

---comment
---@param archive_name string server_save00_98-09-16_23:48:10 - without file extension (*.7z)
---@param absolute_directory_path_to_add_archive string "C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita\save00"
---@param absolute_destination_path string "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_"
---@return string|number content binary content of archive
function Create7zipArchive(archive_name, absolute_directory_path_to_add_archive, absolute_destination_path)
    assert(Exists7zip(), "Unable to find 7z.exe, please install 7z via https://7-zip.de/download.html and restart the Noita!")

    absolute_directory_path_to_add_archive = ReplacePathSeparator(absolute_directory_path_to_add_archive)
    absolute_destination_path = ReplacePathSeparator(absolute_destination_path)

    local command = 'cd "' .. absolute_destination_path .. '" && 7z.exe a -t7z ' .. archive_name .. ' "' .. absolute_directory_path_to_add_archive .. '"'
    print("file_util.lua | Running: " .. command)
    os.execute(command)

    local archive_full_path = absolute_destination_path .. _G.path_separator .. archive_name .. ".7z"
    return ReadBinaryFile(archive_full_path)
end

---comment
---@param archive_absolute_directory_path string path to archive location like "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_"
---@param archive_name string server_save00_98-09-16_23:48:10.7z - with file extension (*.7z)
---@param extract_absolute_directory_path string "C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita"
function Extract7zipArchive(archive_absolute_directory_path, archive_name, extract_absolute_directory_path)
    archive_absolute_directory_path = ReplacePathSeparator(archive_absolute_directory_path)
    extract_absolute_directory_path = ReplacePathSeparator(extract_absolute_directory_path)

    local command = 'cd "' .. archive_absolute_directory_path .. '" && 7z.exe x -aoa ' .. archive_name .. ' -o"' .. extract_absolute_directory_path .. '"'
    print("file_util.lua | Running: " .. command)
    os.execute(command)
end
--cd "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_" && 7z.exe x -aoa test.7z -o"C:\Program Files (x86)\Steam\steamapps\common\Noita\save00_test"

----------------------------------------------------------------------------------------------------
-- Noita restart, yay!
----------------------------------------------------------------------------------------------------

function ForceQuitAndStartNoita()
    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute('start "" ' .. exe .. ' -no_logo_splashes -save_slot 0 -gamemode 0')
    os.exit()
end

--- This executes c code to sent SDL_QUIT command to the app
function StopSaveAndStartNoita()
    ffi.cdef[[
        typedef union SDL_Event
        {
            uint32_t type;
            uint8_t padding[56];
        } SDL_Event;

        int SDL_PushEvent(SDL_Event * event);
    ]]
    SDL = ffi.load('SDL2.dll')

    local evt = ffi.new('SDL_Event')
    evt.type = 0x100 -- SDL_QUIT
    SDL.SDL_PushEvent(evt)
end
