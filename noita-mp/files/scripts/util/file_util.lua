local fu = {}

local ffi = require("ffi")

-- https://stackoverflow.com/a/14425862/3493998
local path_separator = package.config:sub(1,1)
_G.is_windows = string.find(path_separator, '\\') or 0
_G.is_unix = string.find(path_separator, '/') or 0
_G.path_separator = tostring(path_separator)

print("file_util.lua | Detected " .. (_G.is_windows and "Windows " or "Unix ") .. " with path separator '" .. path_separator .. "'.")


----------------------------------------------------------------------------------------------------
-- Platform specific functions
----------------------------------------------------------------------------------------------------

--- Replaces windows path separator to unix path separator and vice versa.
--- Error if path is not a string.
--- @param path string
--- @return string path
function fu.ReplacePathSeparator(path)
    if type(path) ~= "string" then error("path is not a string") end
    if _G.is_windows then
        print("file_util.lua | windows detected replace / with \\")
        path = string.gsub(path, "/", "\\")
    else
        print("file_util.lua | unix detected replace \\ with /")
        path = string.gsub(path, "\\", "/")
    end
    return path
end


--- Removes trailing path separator in a string: \persistent\flags\ -> \persistent\flags.
--- Error if path is not a string.
--- @param path string any string, i.e. \persistent\flags\
--- @return string path \persistent\flags
function fu.RemoveTrailingPathSeparator(path)
    if type(path) ~= "string" then error("path is not a string") end
    if string.sub(path, -1, -1) == _G.path_separator then
        path = string.sub(path, 1, -2)
    end
    return path
end


----------------------------------------------------------------------------------------------------
-- Noita specific file, directory or path functions
----------------------------------------------------------------------------------------------------

--- Sets Noitas root absolute path to _G
function fu.SetAbsolutePathOfNoitaRootDirectory()
    local noita_root_directory_path = nil

    if _G.is_windows then
        noita_root_directory_path = assert(io.popen("cd"):read("*l"), "Unable to run windows command 'cd' to get Noitas root directory!")
    else
        noita_root_directory_path = assert(io.popen("pwd"):read("*l"), "Unable to run ubuntu command 'pwd' to get Noitas root directory!")
    end

    noita_root_directory_path = fu.ReplacePathSeparator(noita_root_directory_path)

    _G.noita_root_directory_path = noita_root_directory_path

    print("file_util.lua | Absolute path of Noitas root directory set to " .. _G.noita_root_directory_path)
end


function fu.GetAbsolutePathOfNoitaRootDirectory()
    return _G.noita_root_directory_path
end


----------------------------------------------------------------------------------------------------
-- Noita world and savegame specific functions
----------------------------------------------------------------------------------------------------

--- Returns files with its associated directory path relative to \save06\*
--- @return table [1] { "\persistent\flags" , "filename" }
--- @return integer amount of files within save06 (rekursive)
function fu.GetRelativeDirectoryAndFilesOfSave06()
    local dir_save_06 = "save06"
    local command = nil

    if _G.is_windows then
        command = 'dir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\' .. dir_save_06 .. '" /b/s'
        if DebugGetIsDevBuild() then
            command = "dir " .. dir_save_06 .. " /b/s"
        end
    else
        error("Unix system are not supported yet :(",2)
    end

    local file = assert(io.popen(command, "r"), "Unable to execute command: " .. command)
    local path = ""
    local t = {}
    local i = 1
    while path ~= nil do
        path = file:read("*l")

        if path ~=nil and path ~= "" then -- EOF
            -- C:\Program Files (x86)\Steam\steamapps\common\Noita\save06\world\.autosave_player
            -- to world\.autosave_player
            local index_start, index_end = string.find(path, dir_save_06 .. "\\")
            local relative = string.sub(path, index_end + 1) -- +1 to get rid of \ or /

            local dir_name = ""
            local file_name = ""

            if fu.IsDirectory(path) then
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

            dir_name = fu.RemoveTrailingPathSeparator(dir_name)

            t[i] = { dir_name, file_name }
            i = i + 1
        end
    end
    return t, i
end

---comment
---@return string save06_parent_directory_path noita installation path or %appdata%\..\LocalLow\Nolla_Games_Noita on windows and unknown for unix systems
function fu.GetAbsoluteDirectoryPathOfParentSave06()
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

    local save06_parent_directory_path = nil
    local line = ""
    while line ~= nil do
        line = file:read("*l")
        if string.find(line, find_directory_name) then
            save06_parent_directory_path = line -- .. "\\world"
            break
        end
    end
    file:close()

    if save06_parent_directory_path == nil or save06_parent_directory_path == "" then
        GamePrintImportant("Unable to find world files","Do yourself a favour and save&quit the game and start it again!")
    end

    save06_parent_directory_path = fu.ReplacePathSeparator(save06_parent_directory_path)
    return save06_parent_directory_path
end

--- Returns fullpath of save06 directory on devBuild or release
--- @return string directory_path_of_save06 : noita installation path\save06 or %appdata%\..\LocalLow\Nolla_Games_Noita\save06 on windows and unknown for unix systems
function fu.GetAbsoluteDirectoryPathOfSave06()
    local directory_path_of_save06 = fu.GetAbsoluteDirectoryPathOfParentSave06() .. _G.path_separator .. "save06"
    return directory_path_of_save06
end


--- Returns the ABSOLUTE path of the mods folder.
--- If _G.noita_root_directory_path is not set yet, then it will be
--- @return string _G.noita_root_directory_path .. "/mods"
function fu.GetAbsoluteDirectoryPathOfMods()
    if not _G.noita_root_directory_path then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
    local p = _G.noita_root_directory_path .. "/mods/noita-mp"
    p = fu.ReplacePathSeparator(p)
    return p
end


--- Returns the RELATIVE path of the mods folder.
--- @return string "mods/noita-mp"
function fu.GetRelativeDirectoryPathOfMods()
    local p = "mods/noita-mp"
    p = fu.ReplacePathSeparator(p)
    return p
end

--- Returns the RELATIVE path of the library folder required for this mod.
--- @return string "/mods/noita-mp/files/libs"
function fu.GetRelativeDirectoryPathOfRequiredLibs()
    local p = "mods/noita-mp/files/libs"
    p = fu.ReplacePathSeparator(p)
    return p
end


--- Returns the ABSOLUTE path of the library folder required for this mod.
--- If _G.noita_root_directory_path is not set yet, then it will be
--- @return string _G.noita_root_directory_path .. "/mods/noita-mp/files/libs"
function fu.GetAbsoluteDirectoryPathOfRequiredLibs()
    if not _G.noita_root_directory_path then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
    local p = _G.noita_root_directory_path .. "/mods/noita-mp/files/libs"
    p = fu.ReplacePathSeparator(p)
    return p
end


----------------------------------------------------------------------------------------------------
-- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

--- Checks if FILE or DIRECTORY exists
--- @param name string full path
--- @return boolean
function fu.Exists(name)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(name)~="string" then return false end
    return os.rename(name,name) and true or false
end


function fu.IsFile(name)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(name)~="string" then return false end
    if not fu.Exists(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end


function fu.IsDirectory(name)
    -- https://stackoverflow.com/a/21637809/3493998
    return (fu.Exists(name) and not fu.IsFile(name))
end


function fu.ReadBinaryFile(file_fullpath)
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file = io.open(file_fullpath, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


function fu.WriteBinaryFile(file_fullpath, file_content)
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "wb"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end


function fu.ReadFile(file_fullpath)
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file = io.open(file_fullpath, "r")
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end


function fu.WriteFile(file_fullpath, file_content)
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "w"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end


function fu.MkDir(full_path)
    -- https://stackoverflow.com/a/1690932/3493998
    full_path = fu.ReplacePathSeparator(full_path)
    os.execute('mkdir "' .. full_path .. '"')
end


----------------------------------------------------------------------------------------------------
-- 7zip stuff
----------------------------------------------------------------------------------------------------

function fu.Find7zipExecutable()
    if is_windows then
        local f = io.popen("where.exe 7z", "r")
        if not f then
            error("Unable to find 7z.exe, please install 7z via https://7-zip.de/download.html and restart the Noita!", 2)
            os.exit()
        end
        local response = f:read("*a")
        _G.seven_zip = tostring(fu.ReplacePathSeparator(response))
        print("file_util.lua | Found 7z.exe: " .. _G.seven_zip)
    else
        error("Unfortunately unix systems aren't supported yet. Please consider https://github.com/Ismoh/NoitaMP/issues!", 2)
    end
end

function fu.Exists7zip()
    if _G.seven_zip then
        return true
    else
        return false
    end
end

---comment
---@param archive_name string server_save06_98-09-16_23:48:10 - without file extension (*.7z)
---@param absolute_directory_path_to_add_archive string "C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita\save06"
---@param absolute_destination_path string "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_"
---@return string|number content binary content of archive
function fu.Create7zipArchive(archive_name, absolute_directory_path_to_add_archive, absolute_destination_path)
    assert(fu.Exists7zip(), "Unable to find 7z.exe, please install 7z via https://7-zip.de/download.html and restart the Noita!")

    absolute_directory_path_to_add_archive = fu.ReplacePathSeparator(absolute_directory_path_to_add_archive)
    absolute_destination_path = fu.ReplacePathSeparator(absolute_destination_path)

    local command = 'cd "' .. absolute_destination_path .. '" && 7z.exe a -t7z ' .. archive_name .. ' "' .. absolute_directory_path_to_add_archive .. '"'
    print("file_util.lua | Running: " .. command)
    os.execute(command)

    local archive_full_path = absolute_destination_path .. _G.path_separator .. archive_name .. ".7z"
    return fu.ReadBinaryFile(archive_full_path)
end

---comment
---@param archive_absolute_directory_path string path to archive location like "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_"
---@param archive_name string server_save06_98-09-16_23:48:10.7z - with file extension (*.7z)
---@param extract_absolute_directory_path string "C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita"
function fu.Extract7zipArchive(archive_absolute_directory_path, archive_name, extract_absolute_directory_path)
    archive_absolute_directory_path = fu.ReplacePathSeparator(archive_absolute_directory_path)
    extract_absolute_directory_path = fu.ReplacePathSeparator(extract_absolute_directory_path)

    local command = 'cd "' .. archive_absolute_directory_path .. '" && 7z.exe x -aoa ' .. archive_name .. ' -o"' .. extract_absolute_directory_path .. '"'
    print("file_util.lua | Running: " .. command)
    os.execute(command)
end
--cd "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_" && 7z.exe x -aoa test.7z -o"C:\Program Files (x86)\Steam\steamapps\common\Noita\save06_test"

----------------------------------------------------------------------------------------------------
-- Noita restart, yay!
----------------------------------------------------------------------------------------------------

function fu.StopWithoutSaveAndStartNoita()
    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute('start "" ' .. exe .. ' -no_logo_splashes -save_slot 6 -gamemode 0')
    os.exit()
end

--- This executes c code to sent SDL_QUIT command to the app
function fu.StopSaveAndStartNoita()
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

    if _G.Server then
        _G.Server:destroy()
    end

    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute('start "" ' .. exe .. ' -no_logo_splashes -save_slot 6 -gamemode 0')
end

return fu