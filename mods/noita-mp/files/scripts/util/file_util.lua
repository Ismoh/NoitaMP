local fu      = {}
local ffi     = require("ffi")
local watcher = require("watcher")
local lfs     = require("lfs")
local json    = require("json")
local util    = require("util")

-----------------------------------------------------------------------------------------------------------------------
--- Version
-----------------------------------------------------------------------------------------------------------------------
function fu.getVersionByFile()
    local modsPath           = fu.GetAbsoluteDirectoryPathOfNoitaMP()
    local versionAbsFilePath = ("%s%s.version"):format(modsPath, pathSeparator)
    local content            = fu.ReadFile(versionAbsFilePath, "*l")
    if not content or util.IsEmpty(content) then
        error(("Unable to read NoitaMP version. Check if '%s' exists!")
                      :format(fu.GetAbsolutePathOfNoitaRootDirectory() + "/.version"), 2)
    end
    local jsonTable = json.decode(content)
    local version   = jsonTable.version
    Logger.info(Logger.channels.initialize, ("NoitaMP %s"):format(version))
    return version
end

----------------------------------------------------------------------------------------------------
--- Platform specific functions
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
        --logger:debug("file_util.lua | windows detected replace / with \\")
        path = string.gsub(path, "/", "\\")
    elseif _G.is_linux then
        --logger:debug("file_util.lua | unix detected replace \\ with /")
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
    if string.sub(path, -1, -1) == _G.pathSeparator then
        path = string.sub(path, 1, -2)
    end
    return path
end

-----------------------------------------------------------------------------------------------------------------------
--- eNet specific commands
-----------------------------------------------------------------------------------------------------------------------
function fu.getPidOfRunningEnetHostByPort()
    --if _G.whoAmI() == _G.Client.iAm then
    --    error("Makes no sense to get PID of eNet, when client!", 2)
    --    return
    --end

    local command = nil
    if _G.is_windows then
        command = ('netstat -abon | find /i "%s"'):format(_G.Server:getPort())
    else
        error("Unix system are not supported yet :(", 2)
        return
    end

    local file    = assert(io.popen(command, "r"))
    local content = file:read("*a")
    file:close()
    local cmdOutput = string.split(content, " ")
    local pid       = cmdOutput[#cmdOutput]
    return tonumber(pid)
end

function fu.killProcess(pid)
    local command = nil
    if _G.is_windows then
        command = ('taskkill /PID %s /F'):format(pid)
    else
        error("Unix system are not supported yet :(", 2)
        return
    end
    os.execute(command)
end

----------------------------------------------------------------------------------------------------
--- Noita specific file, directory or path functions
----------------------------------------------------------------------------------------------------
local noitaRootDirectory = nil
--- Sets root directory of noita.exe, i.e. C:\Program Files (x86)\Steam\steamapps\common\Noita
function fu.SetAbsolutePathOfNoitaRootDirectory()
    if _G.is_windows then
        noitaRootDirectory = assert(io.popen("cd"):read("*l"),
                                    "Unable to run windows command 'cd' to get Noitas root directory!")
    elseif _G.is_linux then
        noitaRootDirectory = assert(io.popen("pwd"):read("*l"),
                                    "Unable to run ubuntu command 'pwd' to get Noitas root directory!")
    else
        error(
                ("file_util.lua | Unable to detect OS(%s[%s]), therefore not able to replace path separator!"):format(
                        _G.os_name,
                        _G.os_arch
                ),
                2
        )
    end

    noitaRootDirectory = fu.ReplacePathSeparator(noitaRootDirectory)

    if isTestLuaContext then
        Logger.trace(Logger.channels.testing,
                     ("Absolute path of Noitas root directory set to %s, but we need to fix path! Removing \\mods\\noita-mp.")
                             :format(noitaRootDirectory))
        local i, _         = string.find(noitaRootDirectory, "mods")
        noitaRootDirectory = string.sub(noitaRootDirectory, 0, i - 1)
        Logger.trace(Logger.channels.testing,
                     ("NEW absolute path of Noitas root directory set to %s.")
                             :format(noitaRootDirectory))
    end
end

function fu.GetAbsolutePathOfNoitaRootDirectory()
    if not noitaRootDirectory then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
    return noitaRootDirectory
end

----------------------------------------------------------------------------------------------------
--- Noita world and savegame specific functions
----------------------------------------------------------------------------------------------------

--- Return the parent directory of the savegame directory save06.
--- If DebugGetIsDevBuild() then Noitas installation path is returned: 'C:\Program Files (x86)\Steam\steamapps\common\Noita'
--- otherwise it will return: '%appdata%\..\LocalLow\Nolla_Games_Noita' on windows
--- @return string save06_parent_directory_path string of absolute path to '..\Noita' or '..\Nolla_Games_Noita'
function fu.GetAbsoluteDirectoryPathOfParentSave()
    local file                = nil
    local command             = nil
    local find_directory_name = nil

    if _G.is_windows then
        command             = 'dir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\.." /s/b/ad'
        find_directory_name = "Nolla_Games_Noita"

        if DebugGetIsDevBuild() then
            command             = "dir .. /s/b/ad"
            find_directory_name = "Noita"
        end
    else
        error("Unix system are not supported yet :(", 2)
        --command = 'find "~/.steam/steam/userdata/$(id -u)/881100/Nolla_Games_Noita/"'
        --find_directory_name = "Nolla_Games_Noita"
    end

    file                               = assert(io.popen(command, "r")) -- path where noita.exe is

    local save06_parent_directory_path = nil
    local line                         = ""
    while line ~= nil do
        line = file:read("*l")
        --logger:debug("file_util.lua | GetAbsoluteDirectoryPathOfParentSave line = " .. line)
        if string.find(line, find_directory_name) then
            save06_parent_directory_path = line
            break
        end
    end
    file:close()

    if save06_parent_directory_path == nil or save06_parent_directory_path == "" then
        GamePrintImportant(
                "Unable to find world files",
                "Do yourself a favour and save&quit the game and start it again!", ""
        )
    end

    save06_parent_directory_path = fu.ReplacePathSeparator(save06_parent_directory_path)
    return save06_parent_directory_path
end

--- Returns fullpath of save06 directory on devBuild or release
--- @return string directory_path_of_save06 : noita installation path\save06 or %appdata%\..\LocalLow\Nolla_Games_Noita\save06 on windows and unknown for unix systems
function fu.GetAbsoluteDirectoryPathOfSave06()
    local directory_path_of_save06 = fu.GetAbsoluteDirectoryPathOfParentSave() .. _G.pathSeparator .. "save06"
    return directory_path_of_save06
end

--- Returns the ABSOLUTE path of the mods folder.
--- If fu.GetAbsolutePathOfNoitaRootDirectory() is not set yet, then it will be
--- @return string fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp"
function fu.GetAbsoluteDirectoryPathOfNoitaMP()
    if not fu.GetAbsolutePathOfNoitaRootDirectory() then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
    local p = fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp"
    p       = fu.ReplacePathSeparator(p)
    return p
end

--- Returns the RELATIVE path of the mods folder.
--- @return string "mods/noita-mp"
function fu.GetRelativeDirectoryPathOfNoitaMP()
    local p = "mods/noita-mp"
    p       = fu.ReplacePathSeparator(p)
    return p
end

--- Returns the RELATIVE path of the library folder required for this mod.
--- @return string "/mods/noita-mp/files/libs"
function fu.GetRelativeDirectoryPathOfRequiredLibs()
    local p = "mods/noita-mp/files/libs"
    p       = fu.ReplacePathSeparator(p)
    return p
end

--- Returns the ABSOLUTE path of the library folder required for this mod.
--- If fu.GetAbsolutePathOfNoitaRootDirectory() is not set yet, then it will be
--- @return string fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp/files/libs"
function fu.GetAbsoluteDirectoryPathOfRequiredLibs()
    if not fu.GetAbsolutePathOfNoitaRootDirectory() then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
    local p = fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp/files/libs"
    p       = fu.ReplacePathSeparator(p)
    return p
end

--- There is a world_state.xml per each saveSlot directory, which contains Globals. Nuid are stored in Globals.
--- @param saveSlotAbsDirectoryPath string Absolute directory path to the current selected save slot.
--- @return string absPath world_state.xml absolute file path
function fu.GetAbsDirPathOfWorldStateXml(saveSlotAbsDirectoryPath)
    return ("%s%s%s"):format(saveSlotAbsDirectoryPath, pathSeparator, "world_state.xml")
end

--- see _G.saveSlotMeta
---@return table
function fu.getLastModifiedSaveSlots()
    local save0                = fu.GetAbsoluteDirectoryPathOfParentSave() .. pathSeparator .. "save0"

    local saveSlotLastModified = {}
    for i = 0, 6, 1 do
        local save0X = save0 .. i

        watcher(save0X, function(lastModified)
            if lastModified > 0 then
                Logger.debug(Logger.channels.initialize,
                             ("SaveSlot(%s) directory was last modified at %s."):format("save0" .. i, lastModified))
                table.insert(saveSlotLastModified, { dir = save0X, lastModified = lastModified, slot = i })
            end
        end)
    end
    return saveSlotLastModified
end

--- Returns absolute path of NoitaMP settings directory,
--- @return string absPath i.e. "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\settings"
function fu.getAbsolutePathOfNoitaMpSettingsDirectory()
    return fu.GetAbsoluteDirectoryPathOfNoitaMP() .. pathSeparator .. "settings"
end

----------------------------------------------------------------------------------------------------
--- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

--- Checks if FILE or DIRECTORY exists
--- @param absolutePath string full path
--- @return boolean
function fu.exists(absolutePath)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(absolutePath) ~= "string" then
        error("Parameter 'absolutePath' '" .. tostring(absolutePath) .. "' is not type of string!", 2)
    end
    local exists = os.rename(absolutePath, absolutePath) and true or false
    return exists
end

function fu.IsFile(full_path)
    -- https://stackoverflow.com/a/21637809/3493998
    if type(full_path) ~= "string" then
        error("file_util.lua | Parameter full_path '" .. tostring(full_path) .. "' is not type of string!")
    end
    if not fu.exists(full_path) then
        --logger:debug("file_util.lua | Path '" .. tostring(full_path) .. "' does not exist!")
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
    local exists  = fu.exists(full_path)
    --logger:debug("file_util.lua | Directory " .. full_path .. " exists = " .. tostring(exists))
    local is_file = fu.IsFile(full_path)
    --logger:debug("file_util.lua | Is the directory a file? " .. full_path .. " is_file = " .. tostring(is_file))
    return (exists and not is_file)
end

function fu.ReadBinaryFile(file_fullpath)
    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file    = io.open(file_fullpath, "rb") -- r read mode and b binary mode
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
    local fh      = assert(io.open(file_fullpath, "wb"))
    fh:write(file_content)
    fh:flush()
    fh:close()
end

function fu.ReadFile(file_fullpath, mode)
    if mode == nil then
        mode = "*a"
    end

    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath = fu.ReplacePathSeparator(file_fullpath)
    -- https://stackoverflow.com/a/31857671/3493998
    local file    = io.open(file_fullpath, "r")
    if not file then
        error("Unable to open and read file: " .. file_fullpath)
    end
    local content = file:read(mode) -- *a or *all reads the whole file
    file:close()
    return content
end

function fu.WriteFile(file_fullpath, file_content)
    if type(file_fullpath) ~= "string" then
        error("file_util.lua | Parameter file_fullpath '" .. tostring(file_fullpath) .. "' is not type of string!")
    end
    file_fullpath         = fu.ReplacePathSeparator(file_fullpath)

    local segments        = string.split(file_fullpath, pathSeparator) or {}
    local pathPerSegments = ""
    for i = 1, #segments do
        -- recursively create directories
        local segment   = segments[i]
        pathPerSegments = pathPerSegments .. segment .. pathSeparator
        if not fu.exists(pathPerSegments) then
            if not pathPerSegments:contains(".") then
                -- dump check if it's a file
                fu.MkDir(pathPerSegments)
            end
        end
    end

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
    full_path     = fu.ReplacePathSeparator(full_path)

    local command = nil
    if _G.is_windows then
        command = ('mkdir "%s"'):format(full_path)
    else
        command = ('mkdir "%s"'):format(full_path)
    end
    os.execute(command)
end

function fu.AppendToFile(filenameAbsolutePath, appendContent)
    -- TODO rework: have a look on plotly.lua ">>"
    local isEmpty = true
    local file    = io.open(filenameAbsolutePath, "a+")
    for line in io.lines(filenameAbsolutePath) do
        isEmpty = false
        if line == nil then
            file:write(appendContent)
        end
    end
    if isEmpty then
        file:write(appendContent)
    end
    file:close()
end

---comment
--- http://lua-users.org/wiki/SplitJoin -> Example: Split a file path string into components.
---@param str any
---@return unknown
function fu.splitPath(str)
    return string.split(str, '[\\/]+') -- TODO: differ between windows and unix
    --parts = split_path("/usr/local/bin")
    --> {'usr','local','bin'}
end

-- Lua implementation of PHP scandir function
function fu.scanDir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile       = nil

    if is_windows then
        pfile = popen('dir "' .. directory .. '" /b /ad')
    else
        pfile = popen('ls -a "' .. directory .. '"')
    end

    for filename in pfile:lines() do
        i    = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

function fu.removeContentOfDirectory(absolutePath)
    local successRmDir, errorRmDir = lfs.rmdir(absolutePath)

    if not successRmDir or errorRmDir then
        local command                 = ('rmdir /s /q "%s"'):format(absolutePath)
        local success, exitCode, code = os.execute(command)
        Logger.debug(Logger.channels.testing,
                     ("Tried to remove directory. success=%s, exitCode=%s, code=%s"):format(success, exitCode, code))
    end

    lfs.mkdir(absolutePath)
end

----------------------------------------------------------------------------------------------------
--- 7zip stuff
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
        _G.seven_zip   = tostring(fu.ReplacePathSeparator(response))
        Logger.debug(Logger.channels.testing, "file_util.lua | Found 7z.exe: " .. _G.seven_zip)
    else
        error(
                "Unfortunately unix systems aren't supported yet. Please consider https://github.com/Ismoh/NoitaMP/issues!",
                2
        )
    end
end

function fu.exists7zip()
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
            fu.exists7zip(),
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
    absolute_destination_path              = fu.ReplacePathSeparator(absolute_destination_path)

    local command                          = 'cd "' ..
            absolute_destination_path ..
            '" && 7z.exe a -t7z ' .. archive_name .. ' "' .. absolute_directory_path_to_add_archive .. '"'
    Logger.debug(Logger.channels.testing, "file_util.lua | Running: " .. command)
    os.execute(command)

    local archive_full_path = absolute_destination_path .. _G.pathSeparator .. archive_name .. ".7z"
    return fu.ReadBinaryFile(archive_full_path)
end

---comment
---@param archive_absolute_directory_path string path to archive location like "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_"
---@param archive_name string server_save06_98-09-16_23:48:10.7z - with file extension (*.7z)
---@param extract_absolute_directory_path string "C:\Users\Ismoh-PC\AppData\LocalLow\Nolla_Games_Noita"
function fu.Extract7zipArchive(archive_absolute_directory_path, archive_name, extract_absolute_directory_path)
    archive_absolute_directory_path = fu.ReplacePathSeparator(archive_absolute_directory_path)
    extract_absolute_directory_path = fu.ReplacePathSeparator(extract_absolute_directory_path)

    local command                   = 'cd "' ..
            archive_absolute_directory_path ..
            '" && 7z.exe x -aoa ' .. archive_name .. ' -o"' .. extract_absolute_directory_path .. '"'
    Logger.debug(Logger.channels.testing, "file_util.lua | Running: " .. command)
    os.execute(command)
end

--cd "C:\Program Files (x86)\Steam\steamapps\common\Noita\mods\noita-mp\_" && 7z.exe x -aoa test.7z -o"C:\Program Files (x86)\Steam\steamapps\common\Noita\save06_test"

----------------------------------------------------------------------------------------------------
--- Noita restart, yay!
----------------------------------------------------------------------------------------------------

--- Credits to dextercd!
function fu.restartNoita()
    require("ffi").cast("void(__fastcall*)()", 0x0066e120)()
end

function fu.killNoitaAndRestart()
    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end

    fu.removeContentOfDirectory(_G.saveSlotMeta.dir)

    os.execute(('start "" %s -no_logo_splashes -save_slot %s -gamemode 4'):format(exe,
                                                                                  _G.saveSlotMeta.slot)) -- -gamemode 0
    os.exit()
end

--- This executes c code to sent SDL_QUIT command to the app
function fu.saveAndRestartNoita()
    ffi.cdef [[
        typedef union SDL_Event
        {
            uint32_t type;
            uint8_t padding[56];
        } SDL_Event;

        int SDL_PushEvent(SDL_Event * event);
    ]]
    SDL       = ffi.load("SDL2.dll")

    local evt = ffi.new("SDL_Event")
    evt.type  = 0x100 -- SDL_QUIT
    SDL.SDL_PushEvent(evt)

    if _G.Server then
        _G.Server:stop()
    end

    local exe = "noita.exe"
    if DebugGetIsDevBuild() then
        exe = "noita_dev.exe"
    end
    os.execute(('start "" %s -no_logo_splashes -save_slot %s -gamemode 4'):format(exe,
                                                                                  _G.saveSlotMeta.slot)) -- -gamemode 0
end

function fu.getAllFilesInDirectory(directory, fileExtension)
    local command = nil
    if _G.is_windows then
        command = "for /f tokens^=* %i in ('where /r \"" .. directory .. "\" *" .. fileExtension .. "')do @echo/ %~nxi"
    else
        error("Unix system are not supported yet :(", 2)
        return {}
    end

    local file    = assert(io.popen(command, "r"))
    local content = file:read("*a")
    file:close()
    local filenames = string.split(content, "\n")
    for i = 1, #filenames do
        filenames[i] = string.trim(filenames[i]):gsub("%." .. fileExtension, ""):lower()
    end
    return filenames
end

function fu.getDesktopDirectory()
    local command = nil
    if _G.is_windows then
        command = "echo %USERPROFILE%\\Desktop"
    else
        error("Unix system are not supported yet :(", 2)
        return {}
    end

    local file    = assert(io.popen(command, "r"))
    local content = file:read("*a")
    file:close()
    return string.trim(content)
end

return fu
