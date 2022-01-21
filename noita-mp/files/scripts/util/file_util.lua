local fu = {}
local ffi = require("ffi")

if not logger then
---@diagnostic disable-next-line: lowercase-global
    logger = _G.logger
end

----------------------------------------------------------------------------------------------------
-- Platform specific functions
----------------------------------------------------------------------------------------------------

--- Replaces windows path separator to unix path separator and vice versa.
--- Error if path is not a string.
--- @param path string
--- @return string path
function fu.ReplacePathSeparator(path)
    if type(path) ~= "string" then
        error("path is not a string")
    end
    if _G.is_windows then
        logger:debug("file_util.lua | windows detected replace / with \\")
        path = string.gsub(path, "/", "\\")
    elseif _G.is_linux then
        logger:debug("file_util.lua | unix detected replace \\ with /")
        path = string.gsub(path, "\\", "/")
    else
        error(
            ("file_util.lua | Unable to detect OS(%s[%s]), therefore not able to replace path separator!"):format(
                _G.os_name,
                _G.os_arch
            ),
            2
        )
    end
    return path
end

--- Removes trailing path separator in a string: \persistent\flags\ -> \persistent\flags.
--- Error if path is not a string.
--- @param path string any string, i.e. \persistent\flags\
--- @return string path \persistent\flags
function fu.RemoveTrailingPathSeparator(path)
    if type(path) ~= "string" then
        error("path is not a string")
    end
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
        noita_root_directory_path =
            assert(io.popen("cd"):read("*l"), "Unable to run windows command 'cd' to get Noitas root directory!")
    elseif _G.is_linux then
        noita_root_directory_path =
            assert(io.popen("pwd"):read("*l"), "Unable to run ubuntu command 'pwd' to get Noitas root directory!")
    else
        error(
            ("file_util.lua | Unable to detect OS(%s[%s]), therefore not able to replace path separator!"):format(
                _G.os_name,
                _G.os_arch
            ),
            2
        )
    end

    noita_root_directory_path = fu.ReplacePathSeparator(noita_root_directory_path)

    _G.noita_root_directory_path = noita_root_directory_path

    logger:debug("file_util.lua | Absolute path of Noitas root directory set to " .. _G.noita_root_directory_path)
end

function fu.GetAbsolutePathOfNoitaRootDirectory()
    return _G.noita_root_directory_path
end

----------------------------------------------------------------------------------------------------
-- Noita world and savegame specific functions
----------------------------------------------------------------------------------------------------

--- Return the parent directory of the savegame directory save06.
--- If DebugGetIsDevBuild() then Noitas installation path is returned: 'C:\Program Files (x86)\Steam\steamapps\common\Noita'
--- otherwise it will return: '%appdata%\..\LocalLow\Nolla_Games_Noita' on windows
--- @return string save06_parent_directory_path string of absolute path to '..\Noita' or '..\Nolla_Games_Noita'
function fu.GetAbsoluteDirectoryPathOfParentSave06()
    local file = nil
    local command = nil
    local find_directory_name = nil

    if _G.is_windows then
        command = 'dir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\.." /s/b/ad'
        find_directory_name = "Nolla_Games_Noita"

        if DebugGetIsDevBuild() then
            command = "dir .. /s/b/ad"
            find_directory_name = "Noita"
        end
    else
        error("Unix system are not supported yet :(",2)
        --command = 'find "~/.steam/steam/userdata/$(id -u)/881100/Nolla_Games_Noita/"'
        --find_directory_name = "Nolla_Games_Noita"
    end

    file = assert(io.popen(command, "r")) -- path where noita.exe is

    local save06_parent_directory_path = nil
    local line = ""
    while line ~= nil do
        line = file:read("*l")
        logger:debug("file_util.lua | GetAbsoluteDirectoryPathOfParentSave06 line = " .. line)
        if string.find(line, find_directory_name) then
            save06_parent_directory_path = line
            break
        end
    end
    file:close()

    if save06_parent_directory_path == nil or save06_parent_directory_path == "" then
        GamePrintImportant(
            "Unable to find world files",
            "Do yourself a favour and save&quit the game and start it again!"
        )
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
--- @param full_path string full path
--- @return boolean
function fu.Exists(full_path)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(full_path) ~= "string" then
        error("file_util.lua | Parameter full_path '" .. tostring(full_path) .. "' is not type of string!")
    end
    local exists = os.rename(full_path, full_path) and true or false
    logger:debug("file_util.lua | File or directory " .. full_path .. " exists = " .. tostring(exists))
    return exists
end

function fu.IsFile(full_path)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(full_path) ~= "string" then
        error("file_util.lua | Parameter full_path '" .. tostring(full_path) .. "' is not type of string!")
    end
    if not fu.Exists(full_path) then
        logger:debug("file_util.lua | Path '" .. tostring(full_path) .. "' does not exist!")
        return false
    end
    local f = io.open(full_path)
    if f then
        f:close()
        return true
    end
    return false
end

function fu.IsDirectory(full_path)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(full_path) ~= "string" then
        error("file_util.lua | Parameter full_path '" .. tostring(full_path) .. "' is not type of string!")
    end
    local exists = fu.Exists(full_path)
    logger:debug("file_util.lua | Directory " .. full_path .. " exists = " .. tostring(exists))
    local is_file = fu.IsFile(full_path)
    logger:debug("file_util.lua | Is the directory a file? " .. full_path .. " is_file = " .. tostring(is_file))
    return (exists and not is_file)
end

function fu.ReadBinaryFile(file_fullpath)
    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file = io.open(file_fullpath, "rb") -- r read mode and b binary mode
    if not file then
        error("Unable to open and read file: " .. file_fullpath)
    end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function fu.WriteBinaryFile(file_fullpath, file_content)
    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "wb"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end

function fu.ReadFile(file_fullpath)
    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file = io.open(file_fullpath, "r")
    if not file then
        error("Unable to open and read file: " .. file_fullpath)
    end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function fu.WriteFile(file_fullpath, file_content)
    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- http://lua-users.org/wiki/FileInputOutput
    local fh = assert(io.open(file_fullpath, "w"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end

function fu.MkDir(full_path)
    if type(full_path) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(full_path) .. "' is not type of string!")
    end
    -- https://stackoverflow.com/a/1690932/3493998
    full_path = fu.ReplacePathSeparator(full_path)

    local command = nil
    if _G.is_windows then
        command = 'mkdir "' .. full_path .. '"'
    else
        error("Unfortunately unix systems aren't supported yet.")
    end
    os.execute(command)
end

----------------------------------------------------------------------------------------------------
-- 7zip stuff
----------------------------------------------------------------------------------------------------

function fu.Find7zipExecutable()
    if is_windows then
        local f = io.popen("where.exe 7z", "r")
        if not f then
            error(
                "Unable to find 7z.exe, please install 7z via https://7-zip.de/download.html and restart the Noita!",
                2
            )
            os.exit()
        end
        local response = f:read("*a")
        _G.seven_zip = tostring(fu.ReplacePathSeparator(response))
        logger:debug("file_util.lua | Found 7z.exe: " .. _G.seven_zip)
    else
        error(
            "Unfortunately unix systems aren't supported yet. Please consider https://github.com/Ismoh/NoitaMP/issues!",
            2
        )
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
    assert(
        fu.Exists7zip(),
        "Unable to find 7z.exe, please install 7z via https://7-zip.de/download.html and restart the Noita!"
    )

    if type(archive_name) ~= "string" then
        error("file_util.lua | Parameter archive_name '" .. tostring(archive_name) .. "' is not type of string!")
    end
    if type(absolute_directory_path_to_add_archive) ~= "string" then
        error(
            "file_util.lua | Parameter absolute_directory_path_to_add_archive '" ..
                tostring(absolute_directory_path_to_add_archive) .. "' is not type of string!"
        )
    end
    if type(absolute_destination_path) ~= "string" then
        error(
            "file_util.lua | Parameter absolute_destination_path '" ..
                tostring(absolute_destination_path) .. "' is not type of string!"
        )
    end

    absolute_directory_path_to_add_archive = fu.ReplacePathSeparator(absolute_directory_path_to_add_archive)
    absolute_destination_path = fu.ReplacePathSeparator(absolute_destination_path)

    local command =
        'cd "' ..
        absolute_destination_path ..
            '" && 7z.exe a -t7z ' .. archive_name .. ' "' .. absolute_directory_path_to_add_archive .. '"'
    logger:debug("file_util.lua | Running: " .. command)
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

    local command =
        'cd "' ..
        archive_absolute_directory_path ..
            '" && 7z.exe x -aoa ' .. archive_name .. ' -o"' .. extract_absolute_directory_path .. '"'
    logger:debug("file_util.lua | Running: " .. command)
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
    os.execute('start "" ' .. exe .. " -no_logo_splashes -save_slot 6 -gamemode 0")
    os.exit()
end

--- This executes c code to sent SDL_QUIT command to the app
function fu.StopSaveAndStartNoita()
    ffi.cdef [[
        typedef union SDL_Event
        {
            uint32_t type;
            uint8_t padding[56];
        } SDL_Event;

        int SDL_PushEvent(SDL_Event * event);
    ]]
    SDL = ffi.load("SDL2.dll")

    local evt = ffi.new("SDL_Event")
    evt.type = 0x100 -- SDL_QUIT
    SDL.SDL_PushEvent(evt)

    if _G.Server then
        _G.Server:stop()
    end

    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute('start "" ' .. exe .. " -no_logo_splashes -save_slot 6 -gamemode 0")
end

return fu
