local os_name = require("os_name")
TestFileUtil  = {}

function TestFileUtil:setUp()
    -- Mock Noita Api global functions
    _G.DebugGetIsDevBuild = function()
        return false
    end

    if not FileUtils.GetAbsolutePathOfNoitaRootDirectory() then
        FileUtils.SetAbsolutePathOfNoitaRootDirectory()
    end
end

function TestFileUtil:tearDown()
    -- Make sure OS detection isn't broken, when changed in tests
    _G.is_windows                                = true
    _G.is_linux                                  = false
    _G.pathSeparator                             = tostring(package.config:sub(1, 1))
    local current_platform, current_architecture = os_name.getOS()
    if current_platform == "Windows" then
        _G.is_windows    = true
        _G.is_linux      = false
        _G.pathSeparator = "\\"
    else
        _G.is_windows    = false
        _G.is_linux      = true
        _G.pathSeparator = "/"
    end
end

----------------------------------------------------------------------------------------------------
-- Platform specific functions
----------------------------------------------------------------------------------------------------

function TestFileUtil:testReplacePathSeparatorOnWindows()
    local old_is_windows    = _G.is_windows
    local old_is_linux      = _G.is_linux
    local old_pathSeparator = _G.pathSeparator

    _G.is_windows           = true -- TODO: is there a better way to mock?
    _G.is_linux             = false -- TODO: is there a better way to mock?
    _G.pathSeparator        = "\\" -- TODO: is there a better way to mock?

    local path_unix         = "/test/path/123"
    local path_windows      = FileUtils.ReplacePathSeparator(path_unix)

    lu.assertNotEquals(path_unix, path_windows)
    lu.assertEquals([[\test\path\123]], path_windows)

    _G.is_windows    = old_is_windows
    _G.is_linux      = old_is_linux
    _G.pathSeparator = old_pathSeparator
end

function TestFileUtil:testReplacePathSeparatorOnUnix()
    local old_is_windows    = _G.is_windows
    local old_is_linux      = _G.is_linux
    local old_pathSeparator = _G.pathSeparator

    _G.is_windows           = false -- TODO: is there a better way to mock?
    _G.is_linux             = true -- TODO: is there a better way to mock?
    _G.pathSeparator        = "/" -- TODO: is there a better way to mock?

    local path_windows      = "\\test\\path\\123"
    local path_unix         = FileUtils.ReplacePathSeparator(path_windows)

    lu.assertNotEquals(path_windows, path_unix)
    lu.assertEquals("/test/path/123", path_unix)

    _G.is_windows    = old_is_windows
    _G.is_linux      = old_is_linux
    _G.pathSeparator = old_pathSeparator
end

function TestFileUtil:testRemoveTrailingPathSeparator()
    local path   = tostring(_G.pathSeparator .. "persistent" .. _G.pathSeparator .. "flags" .. _G.pathSeparator)
    local result = FileUtils.RemoveTrailingPathSeparator(path)

    lu.assertNotEquals(path, result)
    lu.assertEquals(_G.pathSeparator .. "persistent" .. _G.pathSeparator .. "flags", result)
end

----------------------------------------------------------------------------------------------------
-- Noita specific file, directory or path functions
----------------------------------------------------------------------------------------------------

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectory()
    FileUtils.SetAbsolutePathOfNoitaRootDirectory()
    lu.assertNotIsNil(FileUtils.GetAbsolutePathOfNoitaRootDirectory(),
                      "FileUtils.GetAbsolutePathOfNoitaRootDirectory() must not be nil!")
    lu.assertNotStrContains(FileUtils.GetAbsolutePathOfNoitaRootDirectory(), "\\mods\\noita-mp")
end

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectoryUnknownOs()
    local old_is_windows = _G.is_windows
    local old_is_linux   = _G.is_linux

    _G.is_windows        = false -- TODO: is there a better way to mock?
    _G.is_linux          = false -- TODO: is there a better way to mock?

    lu.assertErrorMsgContains("FileUtils.lua | Unable to detect OS", FileUtils.SetAbsolutePathOfNoitaRootDirectory,
                              "path doesnt matter")

    _G.is_windows = old_is_windows
    _G.is_linux   = old_is_linux
end

function TestFileUtil:testGetAbsolutePathOfNoitaRootDirectory()
    Logger.trace(Logger.channels.testing,
                 ("Need to verify absolute path of root noita: %s"):format(FileUtils.GetAbsolutePathOfNoitaRootDirectory()))
    lu.assertStrContains(FileUtils.GetAbsolutePathOfNoitaRootDirectory(),
                         _G.pathSeparator) -- TODO: Need a better test for this!
end

----------------------------------------------------------------------------------------------------
-- Noita world and savegame specific functions
----------------------------------------------------------------------------------------------------

--[[ function TestFileUtil:testGetRelativeDirectoryAndFilesOfSave06()
    -- Mock stuff
    local mkdir_command = nil
    local newfile_command = nil
    if _G.is_windows then
        mkdir_command = 'mkdir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\save06"'
        newfile_command = 'echo "file1" > %appdata%\\..\\LocalLow\\Nolla_Games_Noita\\save06\\file1.txt'
    end
    if _G.is_linux then
        mkdir_command = 'mkdir ~/.steam/steam/userdata/$(id -u)/881100/'
        newfile_command = 'echo "file1" > ~/.steam/steam/userdata/$(id -u)/881100/file1.txt'
    end

    local mkdir_command_result = assert(io.popen(mkdir_command, "r"), "Unable to execute command: " .. mkdir_command)
    print(mkdir_command_result:read("*a"))

    local newfile_command_result = assert(io.popen(newfile_command, "r"), "Unable to execute command: " .. newfile_command)
    print(newfile_command_result:read("*a"))

    local table, index = FileUtils.GetRelativeDirectoryAndFilesOfSave06()
    print(table[1])

    lu.assertEquals(table[1].dir_name, nil, "Returned relativ path doesn't match.")
    lu.assertEquals(table[1].file_name, "file1.txt", "Filename isn't equal.")
    lu.assertNotNil(table)
    lu.assertIsPlusZero(#table)
    lu.assertIsPlusZero(index)
end ]]

function TestFileUtil:testGetAbsoluteDirectoryPathOfParentSave()
    lu.skipIf(_G.is_linux, "Linux not supported yet!")
    -- Mock begin
    local mkdir_command = nil

    if _G.is_windows then
        mkdir_command = 'mkdir "%appdata%\\..\\LocalLow\\Nolla_Games_Noita\\"'
    end
    if _G.is_linux then
        mkdir_command = 'mkdir ~/.steam/steam/userdata/$(id -u)/881100/Nolla_Games_Noita/'
    end

    local mkdir_command_result = assert(io.popen(mkdir_command, "r"), "Unable to execute command: " .. mkdir_command)
    print(mkdir_command_result:read("*a"))
    -- Mock end

    local path = FileUtils.GetAbsoluteDirectoryPathOfParentSave()
    print(path)
    lu.assertNotNil(path)
    lu.assertStrContains(path, "Noita", "", "Parent directory of save06 does not contain Noita!")
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfSave06()
    --lu.assertError(FileUtils.GetAbsoluteDirectoryPathOfSave06)
    --lu.assertErrorMsgContains("", FileUtils.GetAbsoluteDirectoryPathOfSave06)
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfNoitaMP()
    local actual_path = FileUtils.GetAbsoluteDirectoryPathOfNoitaMP()
    local expected    = FileUtils.ReplacePathSeparator(FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp")
    lu.assertEquals(actual_path, expected)
end

function TestFileUtil:testGetRelativeDirectoryPathOfNoitaMP()
    lu.assertEquals(FileUtils.GetRelativeDirectoryPathOfNoitaMP(), FileUtils.ReplacePathSeparator("mods/noita-mp"))
end

function TestFileUtil:testGetRelativeDirectoryPathOfRequiredLibs()
    lu.assertEquals(FileUtils.GetRelativeDirectoryPathOfRequiredLibs(), FileUtils.ReplacePathSeparator("mods/noita-mp/files/libs"))
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfRequiredLibs()
    local actual_path = FileUtils.GetAbsoluteDirectoryPathOfRequiredLibs()
    local expected    = FileUtils.ReplacePathSeparator(FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp/files/libs")
    lu.assertEquals(actual_path, expected)
end

----------------------------------------------------------------------------------------------------
-- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

function TestFileUtil:testExists()
    lu.assertNotIsTrue(FileUtils.Exists("nonexistingfile.asdf"))
    lu.assertErrorMsgContains("is not type of string!", FileUtils.Exists)
    lu.assertIsTrue(FileUtils.Exists(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml"))
end

function TestFileUtil:testIsFile()
    lu.assertNotIsTrue(FileUtils.IsFile("nonexistingfile.asdf"))
    lu.assertErrorMsgContains("is not type of string!", FileUtils.IsFile)
    lu.assertIsTrue(FileUtils.IsFile(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml"))
end

function TestFileUtil:testIsDirectory()
    lu.assertNotIsTrue(FileUtils.IsDirectory("nonexistingdirectory"))
    lu.assertErrorMsgContains("is not type of string!", FileUtils.IsDirectory)
    -- lu.assertIsTrue(FileUtils.IsDirectory(FileUtils.GetAbsolutePathOfNoitaRootDirectory())) TODO: https://github.com/Ismoh/NoitaMP/issues/13
end

function TestFileUtil:testReadBinaryFile()
    lu.assertErrorMsgContains("is not type of string!", FileUtils.ReadBinaryFile)
    lu.assertErrorMsgContains("Unable to open and read file: ", FileUtils.ReadBinaryFile, "nonexistingfile.asdf")

    local content = FileUtils.ReadBinaryFile(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml")
    lu.assertNotNil(content)
end

function TestFileUtil:testWriteBinaryFile()
    lu.assertErrorMsgContains("is not type of string!", FileUtils.WriteBinaryFile)

    local full_path = FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/write-temporary-binary-test-file.txt"
    FileUtils.WriteBinaryFile(full_path, "File Content")
    lu.assertIsTrue(FileUtils.Exists(full_path))
    os.remove(full_path)
end

function TestFileUtil:testReadFile()
    lu.assertErrorMsgContains("is not type of string!", FileUtils.ReadFile)
    lu.assertErrorMsgContains("Unable to open and read file: ", FileUtils.ReadFile, "nonexistingfile.asdf")

    local content = FileUtils.ReadFile(FileUtils.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml")
    lu.assertNotNil(content)
end

function TestFileUtil:testWriteFile()
    lu.assertErrorMsgContains("is not type of string!", FileUtils.WriteFile)

    local full_path = FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/write-temporary-test-file.txt"
    FileUtils.WriteFile(full_path, "File Content")
    lu.assertIsTrue(FileUtils.Exists(full_path))
    os.remove(full_path)
end

function TestFileUtil:testMkDir()
    lu.assertErrorMsgContains("is not type of string!", FileUtils.MkDir)

    -- TODO: windows
    -- local dir_path = FileUtils.GetAbsolutePathOfNoitaRootDirectory() .. "/tests/temp-test-dir"
    -- FileUtils.MkDir(dir_path)
    -- lu.assertIsTrue(FileUtils.exists(dir_path))
    -- lu.assertIsTrue(FileUtils.IsDirectory(dir_path))
end

function TestFileUtil:testFind7zipExecutable()

end

function TestFileUtil:testExists7zip()
    local old    = _G.seven_zip
    _G.seven_zip = false -- mock
    lu.assertNotIsTrue(FileUtils.Exists7zip())
    _G.seven_zip = true -- mock
    lu.assertIsTrue(FileUtils.Exists7zip())
    _G.seven_zip = old
end

function TestFileUtil:testCreate7zipArchive()
    --FileUtils.Create7zipArchive()
end