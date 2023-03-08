--- Make absolutely sure, that the already mocked Noita API function is not overwritten
local mockedModSettingGet = ModSettingGet
ModSettingGet             = function(id)
    if string.contains(id, "noita-mp.log_level_") then
        return { "trace, debug, info, warn", "TRACE" }
    end

    if mockedModSettingGet then
        mockedModSettingGet(id)
    end

    error(("Mod setting '%s' is not mocked! Add it!"):format(id), 2)
end

local fu                  = require("FileUtils")
local os_name             = require("os_name")

TestFileUtil              = {}

function TestFileUtil:setUp()

    -- Mock Noita Api global functions
    _G.DebugGetIsDevBuild = function()
        return false
    end

    if not fu.GetAbsolutePathOfNoitaRootDirectory() then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
end

function TestFileUtil:tearDown()
    -- Make sure OS detection isn't broken, when changed in tests
    _G.is_windows                                = true
    _G.is_linux                                  = false
    _G.pathSeparator                             = tostring(package.config:sub(1, 1))
    local current_platform, current_architecture = os_name.getOS()
    if current_platform == "Windows" then
        _G.is_windows = true
        _G.is_linux = false
        _G.pathSeparator = "\\"
    else
        _G.is_windows = false
        _G.is_linux = true
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
    local path_windows      = fu.ReplacePathSeparator(path_unix)

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
    local path_unix         = fu.ReplacePathSeparator(path_windows)

    lu.assertNotEquals(path_windows, path_unix)
    lu.assertEquals("/test/path/123", path_unix)

    _G.is_windows    = old_is_windows
    _G.is_linux      = old_is_linux
    _G.pathSeparator = old_pathSeparator
end

function TestFileUtil:testRemoveTrailingPathSeparator()
    local path   = tostring(_G.pathSeparator .. "persistent" .. _G.pathSeparator .. "flags" .. _G.pathSeparator)
    local result = fu.RemoveTrailingPathSeparator(path)

    lu.assertNotEquals(path, result)
    lu.assertEquals(_G.pathSeparator .. "persistent" .. _G.pathSeparator .. "flags", result)
end

----------------------------------------------------------------------------------------------------
-- Noita specific file, directory or path functions
----------------------------------------------------------------------------------------------------

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectory()
    fu.SetAbsolutePathOfNoitaRootDirectory()
    lu.assertNotIsNil(fu.GetAbsolutePathOfNoitaRootDirectory(),
                      "fu.GetAbsolutePathOfNoitaRootDirectory() must not be nil!")
    lu.assertNotStrContains(fu.GetAbsolutePathOfNoitaRootDirectory(), "\\mods\\noita-mp")
end

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectoryUnknownOs()
    local old_is_windows = _G.is_windows
    local old_is_linux   = _G.is_linux

    _G.is_windows        = false -- TODO: is there a better way to mock?
    _G.is_linux          = false -- TODO: is there a better way to mock?

    lu.assertErrorMsgContains("FileUtils.lua | Unable to detect OS", fu.SetAbsolutePathOfNoitaRootDirectory,
                              "path doesnt matter")

    _G.is_windows = old_is_windows
    _G.is_linux   = old_is_linux
end

function TestFileUtil:testGetAbsolutePathOfNoitaRootDirectory()
    Logger.trace(Logger.channels.testing,
                 ("Need to verify absolute path of root noita: %s"):format(fu.GetAbsolutePathOfNoitaRootDirectory()))
    lu.assertStrContains(fu.GetAbsolutePathOfNoitaRootDirectory(),
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

    local table, index = fu.GetRelativeDirectoryAndFilesOfSave06()
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

    local path = fu.GetAbsoluteDirectoryPathOfParentSave()
    print(path)
    lu.assertNotNil(path)
    lu.assertStrContains(path, "Noita", "", "Parent directory of save06 does not contain Noita!")
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfSave06()
    --lu.assertError(fu.GetAbsoluteDirectoryPathOfSave06)
    --lu.assertErrorMsgContains("", fu.GetAbsoluteDirectoryPathOfSave06)
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfNoitaMP()
    local actual_path = fu.GetAbsoluteDirectoryPathOfNoitaMP()
    local expected    = fu.ReplacePathSeparator(fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp")
    lu.assertEquals(actual_path, expected)
end

function TestFileUtil:testGetRelativeDirectoryPathOfNoitaMP()
    lu.assertEquals(fu.GetRelativeDirectoryPathOfNoitaMP(), fu.ReplacePathSeparator("mods/noita-mp"))
end

function TestFileUtil:testGetRelativeDirectoryPathOfRequiredLibs()
    lu.assertEquals(fu.GetRelativeDirectoryPathOfRequiredLibs(), fu.ReplacePathSeparator("mods/noita-mp/files/libs"))
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfRequiredLibs()
    local actual_path = fu.GetAbsoluteDirectoryPathOfRequiredLibs()
    local expected    = fu.ReplacePathSeparator(fu.GetAbsolutePathOfNoitaRootDirectory() .. "/mods/noita-mp/files/libs")
    lu.assertEquals(actual_path, expected)
end

----------------------------------------------------------------------------------------------------
-- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

function TestFileUtil:testExists()
    lu.assertNotIsTrue(fu.Exists("nonexistingfile.asdf"))
    lu.assertErrorMsgContains("is not type of string!", fu.Exists)
    lu.assertIsTrue(fu.Exists(fu.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml"))
end

function TestFileUtil:testIsFile()
    lu.assertNotIsTrue(fu.IsFile("nonexistingfile.asdf"))
    lu.assertErrorMsgContains("is not type of string!", fu.IsFile)
    lu.assertIsTrue(fu.IsFile(fu.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml"))
end

function TestFileUtil:testIsDirectory()
    lu.assertNotIsTrue(fu.IsDirectory("nonexistingdirectory"))
    lu.assertErrorMsgContains("is not type of string!", fu.IsDirectory)
    -- lu.assertIsTrue(fu.IsDirectory(fu.GetAbsolutePathOfNoitaRootDirectory())) TODO: https://github.com/Ismoh/NoitaMP/issues/13
end

function TestFileUtil:testReadBinaryFile()
    lu.assertErrorMsgContains("is not type of string!", fu.ReadBinaryFile)
    lu.assertErrorMsgContains("Unable to open and read file: ", fu.ReadBinaryFile, "nonexistingfile.asdf")

    local content = fu.ReadBinaryFile(fu.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml")
    lu.assertNotNil(content)
end

function TestFileUtil:testWriteBinaryFile()
    lu.assertErrorMsgContains("is not type of string!", fu.WriteBinaryFile)

    local full_path = fu.GetAbsolutePathOfNoitaRootDirectory() .. "/write-temporary-binary-test-file.txt"
    fu.WriteBinaryFile(full_path, "File Content")
    lu.assertIsTrue(fu.Exists(full_path))
    os.remove(full_path)
end

function TestFileUtil:testReadFile()
    lu.assertErrorMsgContains("is not type of string!", fu.ReadFile)
    lu.assertErrorMsgContains("Unable to open and read file: ", fu.ReadFile, "nonexistingfile.asdf")

    local content = fu.ReadFile(fu.GetAbsoluteDirectoryPathOfNoitaMP() .. "/mod.xml")
    lu.assertNotNil(content)
end

function TestFileUtil:testWriteFile()
    lu.assertErrorMsgContains("is not type of string!", fu.WriteFile)

    local full_path = fu.GetAbsolutePathOfNoitaRootDirectory() .. "/write-temporary-test-file.txt"
    fu.WriteFile(full_path, "File Content")
    lu.assertIsTrue(fu.Exists(full_path))
    os.remove(full_path)
end

function TestFileUtil:testMkDir()
    lu.assertErrorMsgContains("is not type of string!", fu.MkDir)

    -- TODO: windows
    -- local dir_path = fu.GetAbsolutePathOfNoitaRootDirectory() .. "/tests/temp-test-dir"
    -- fu.MkDir(dir_path)
    -- lu.assertIsTrue(fu.exists(dir_path))
    -- lu.assertIsTrue(fu.IsDirectory(dir_path))
end

function TestFileUtil:testFind7zipExecutable()

end

function TestFileUtil:testExists7zip()
    local old    = _G.seven_zip
    _G.seven_zip = false -- mock
    lu.assertNotIsTrue(fu.Exists7zip())
    _G.seven_zip = true -- mock
    lu.assertIsTrue(fu.Exists7zip())
    _G.seven_zip = old
end

function TestFileUtil:testCreate7zipArchive()
    --fu.Create7zipArchive()
end