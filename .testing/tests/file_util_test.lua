#!/usr/bin/env lua

dofile("noita-mp/files/lib/external/init_package_loading.lua")

local lu = require("luaunit")
local fu = require("file_util")

TestFileUtil = {}

function TestFileUtil:setUp()
    print("\n")
    -- Mock Noita Api global functions
    _G.DebugGetIsDevBuild = function ()
        return false
    end

    if not _G.noita_root_directory_path then
        fu.SetAbsolutePathOfNoitaRootDirectory()
    end
end

function TestFileUtil:tearDown()
    print("\n")
end

----------------------------------------------------------------------------------------------------
-- Platform specific functions
----------------------------------------------------------------------------------------------------

function TestFileUtil:testReplacePathSeparatorOnWindows()
    local old_is_windows = _G.is_windows
    local old_is_linux = _G.is_linux
    local old_path_separator = _G.path_separator

    _G.is_windows = true -- TODO: is there a better way to mock?
    _G.is_linux = false -- TODO: is there a better way to mock?
    _G.path_separator = "\\" -- TODO: is there a better way to mock?

    local path_unix = "/test/path/123"
    local path_windows = fu.ReplacePathSeparator(path_unix)

    lu.assertNotEquals(path_unix, path_windows)
    lu.assertEquals([[\test\path\123]], path_windows)

    _G.is_windows = old_is_windows
    _G.is_linux = old_is_linux
    _G.path_separator = old_path_separator
end

function TestFileUtil:testReplacePathSeparatorOnUnix()
    local old_is_windows = _G.is_windows
    local old_is_linux = _G.is_linux
    local old_path_separator = _G.path_separator

    _G.is_windows = false -- TODO: is there a better way to mock?
    _G.is_linux = true -- TODO: is there a better way to mock?
    _G.path_separator = "/" -- TODO: is there a better way to mock?

    local path_windows = "\\test\\path\\123"
    local path_unix = fu.ReplacePathSeparator(path_windows)

    lu.assertNotEquals(path_windows, path_unix)
    lu.assertEquals("/test/path/123", path_unix)

    _G.is_windows = old_is_windows
    _G.is_linux = old_is_linux
    _G.path_separator = old_path_separator
end

function TestFileUtil:testReplacePathSeparatorUnkownOs()
    local old_is_windows = _G.is_windows
    local old_is_linux = _G.is_linux

    _G.is_windows = false -- TODO: is there a better way to mock?
    _G.is_linux = false -- TODO: is there a better way to mock?

    lu.assertErrorMsgContains("file_util.lua | Unable to detect OS", fu.ReplacePathSeparator, "path doesnt matter")

    _G.is_windows = old_is_windows
    _G.is_linux = old_is_linux
end

function TestFileUtil:testRemoveTrailingPathSeparator()
    local path = tostring(_G.path_separator .. "persistent" .. _G.path_separator .. "flags" .. _G.path_separator)
    local result = fu.RemoveTrailingPathSeparator(path)

    lu.assertNotEquals(path, result)
    lu.assertEquals(_G.path_separator .. "persistent" .. _G.path_separator .. "flags", result)
end

----------------------------------------------------------------------------------------------------
-- Noita specific file, directory or path functions
----------------------------------------------------------------------------------------------------

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectory()
    fu.SetAbsolutePathOfNoitaRootDirectory()
    lu.assertNotIsNil(_G.noita_root_directory_path, "_G.noita_root_directory_path must not be nil!")
end

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectoryOnWindows()
    lu.skipIf(_G.is_linux)
    local old_is_windows = _G.is_windows
    local old_is_linux = _G.is_linux

    _G.is_windows = true -- TODO: is there a better way to mock?
    _G.is_linux = false -- TODO: is there a better way to mock?

    fu.SetAbsolutePathOfNoitaRootDirectory()
    lu.assertNotIsNil(_G.noita_root_directory_path, "_G.noita_root_directory_path must not be nil!")

    _G.is_windows = old_is_windows
    _G.is_linux = old_is_linux
end
--[[
function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectoryOnLinux()
    local old_is_windows = _G.is_windows
    local old_is_linux = _G.is_linux

    _G.is_windows = false -- TODO: is there a better way to mock?
    _G.is_linux = true -- TODO: is there a better way to mock?

    fu.SetAbsolutePathOfNoitaRootDirectory()
    lu.assertNotIsNil(_G.noita_root_directory_path, "_G.noita_root_directory_path must not be nil!")

    _G.is_windows = old_is_windows
    _G.is_linux = old_is_linux
end ]]

function TestFileUtil:testSetAbsolutePathOfNoitaRootDirectoryUnkownOs()
    local old_is_windows = _G.is_windows
    local old_is_linux = _G.is_linux

    _G.is_windows = false -- TODO: is there a better way to mock?
    _G.is_linux = false -- TODO: is there a better way to mock?

    lu.assertErrorMsgContains("file_util.lua | Unable to detect OS", fu.SetAbsolutePathOfNoitaRootDirectory, "path doesnt matter")

    _G.is_windows = old_is_windows
    _G.is_linux = old_is_linux
end

function TestFileUtil:testGetAbsolutePathOfNoitaRootDirectory()
    lu.assertEquals(fu.GetAbsolutePathOfNoitaRootDirectory(), _G.noita_root_directory_path)
end

----------------------------------------------------------------------------------------------------
-- Noita world and savegame specific functions
----------------------------------------------------------------------------------------------------

function TestFileUtil:testGetRelativeDirectoryAndFilesOfSave06()
    lu.skipIf(_G.is_linux, "Unix systems aren't supported yet.")
    fu.GetRelativeDirectoryAndFilesOfSave06()
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfParentSave06()
    lu.assertError(fu.GetAbsoluteDirectoryPathOfParentSave06)
    lu.assertErrorMsgContains("", fu.GetAbsoluteDirectoryPathOfParentSave06)
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfSave06()
    lu.assertError(fu.GetAbsoluteDirectoryPathOfSave06)
    lu.assertErrorMsgContains("", fu.GetAbsoluteDirectoryPathOfSave06)
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfMods()
    local actual_path = fu.GetAbsoluteDirectoryPathOfMods()
    local expected = fu.ReplacePathSeparator(_G.noita_root_directory_path .. "/mods/noita-mp")
    lu.assertEquals(actual_path, expected)
end

function TestFileUtil:testGetRelativeDirectoryPathOfMods()
    lu.assertEquals(fu.GetRelativeDirectoryPathOfMods(), fu.ReplacePathSeparator("mods/noita-mp"))
end

function TestFileUtil:testGetRelativeDirectoryPathOfRequiredLibs()
    lu.assertEquals(fu.GetRelativeDirectoryPathOfRequiredLibs(), fu.ReplacePathSeparator("mods/noita-mp/files/libs"))
end

function TestFileUtil:testGetAbsoluteDirectoryPathOfRequiredLibs()
    _G.noita_root_directory_path = nil -- TODO: is there a better way to mock?
    local actual_path = fu.GetAbsoluteDirectoryPathOfRequiredLibs()
    local expected = fu.ReplacePathSeparator(_G.noita_root_directory_path .. "/mods/noita-mp/files/libs")
    lu.assertEquals(actual_path, expected)
end

----------------------------------------------------------------------------------------------------
-- File and Directory checks, writing and reading
----------------------------------------------------------------------------------------------------

function TestFileUtil:testExists()
    lu.assertNotIsTrue(fu.Exists("nonexistingfile.asdf"))
    lu.assertErrorMsgContains("is not type of string!", fu.Exists)
    lu.assertIsTrue(fu.Exists(_G.noita_root_directory_path .. "/.gitignore"))
end

function TestFileUtil:testIsFile()
    lu.assertNotIsTrue(fu.IsFile("nonexistingfile.asdf"))
    lu.assertErrorMsgContains("is not type of string!", fu.IsFile)
    lu.assertIsTrue(fu.IsFile(_G.noita_root_directory_path .. "/.gitignore"))
end

function TestFileUtil:testIsDirectory()
    lu.assertNotIsTrue(fu.IsDirectory("nonexistingdirectory"))
    lu.assertErrorMsgContains("is not type of string!", fu.IsDirectory)
    -- lu.assertIsTrue(fu.IsDirectory(_G.noita_root_directory_path)) TODO: https://github.com/Ismoh/NoitaMP/issues/13
end

function TestFileUtil:testReadBinaryFile()
    lu.assertErrorMsgContains("is not type of string!", fu.ReadBinaryFile)
    lu.assertErrorMsgContains("Unable to open and read file: ", fu.ReadBinaryFile, "nonexistingfile.asdf")

    local content = fu.ReadBinaryFile(_G.noita_root_directory_path .. "/.gitignore")
    lu.assertNotNil(content)
end

function TestFileUtil:testWriteBinaryFile()
    lu.assertErrorMsgContains("is not type of string!", fu.WriteBinaryFile)

    local full_path = _G.noita_root_directory_path .. "/.testing/write-temporary-binary-test-file.txt"
    fu.WriteBinaryFile(full_path, "File Content")
    lu.assertIsTrue(fu.Exists(full_path))
end

function TestFileUtil:testReadFile()
    lu.assertErrorMsgContains("is not type of string!", fu.ReadFile)
    lu.assertErrorMsgContains("Unable to open and read file: ", fu.ReadFile, "nonexistingfile.asdf")

    local content = fu.ReadFile(_G.noita_root_directory_path .. "/.gitignore")
    lu.assertNotNil(content)
end

function TestFileUtil:testWriteFile()
    lu.assertErrorMsgContains("is not type of string!", fu.WriteFile)

    local full_path = _G.noita_root_directory_path .. "/.testing/write-temporary-test-file.txt"
    fu.WriteFile(full_path, "File Content")
    lu.assertIsTrue(fu.Exists(full_path))
end

function TestFileUtil:testMkDir()
    lu.assertErrorMsgContains("is not type of string!", fu.MkDir)

    -- TODO: windows
    -- local dir_path = _G.noita_root_directory_path .. "/.testing/temp-test-dir"
    -- fu.MkDir(dir_path)
    -- lu.assertIsTrue(fu.Exists(dir_path))
    -- lu.assertIsTrue(fu.IsDirectory(dir_path))
end

function TestFileUtil:testFind7zipExecutable()

end

function TestFileUtil:testExists7zip()
    local old = _G.seven_zip
    _G.seven_zip = false -- mock
    lu.assertNotIsTrue(fu.Exists7zip())
    _G.seven_zip = true -- mock
    lu.assertIsTrue(fu.Exists7zip())
    _G.seven_zip = old
end

function TestFileUtil:testCreate7zipArchive()
    --fu.Create7zipArchive()
end

os.exit(lu.LuaUnit.run())