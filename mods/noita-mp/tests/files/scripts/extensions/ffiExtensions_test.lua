-- Thanks GitHub Copilot chat for writing this test.

local lu = require("luaunit")
require("ffiExtensions")

TestFfiExtensions = {}

function TestFfiExtensions:test_os_execute()
    -- Test that os.execute returns 0 for a successful command
    lu.assertEquals(os.execute("echo hello"), 0)

    -- Test that os.execute returns 1 for a failed command
    lu.assertEquals(os.execute("exit 1"), 1)
end

function TestFfiExtensions:test_io_popen()
    -- Test that io.popen returns a file object
    local file = io.popen("echo hello")
    lu.assertNotNil(file)

    -- Test that we can read from the file object
    lu.assertEquals(file:read("*l"), "hello")

    -- Test that we can close the file object
    lu.assertTrue(file:close())
end

function TestFfiExtensions:test_pfile_read()
    -- Test reading a fixed number of bytes
    local file = io.popen("echo hello")
    lu.assertEquals(file:read(2), "he")
    lu.assertEquals(file:read(2), "ll")
    lu.assertEquals(file:read(2), "o\n")

    -- Test reading until the end of the file
    file = io.popen("echo hello")
    lu.assertEquals(file:read("*a"), "hello\n")

    lu.skip("pfile:read(n) with n = \"*L\" (keeping last line) is not implemented yet.")
    -- Test reading a line at a time
    file = io.popen("echo hello\necho world")
    lu.assertEquals(file:read("*l"), "hello")
    lu.assertEquals(file:read("*l"), "world")
end

function TestFfiExtensions:test_pfile_lines()
    lu.skip("pfile:read(n) with n = \"*L\" (keeping last line) is not implemented yet.")

    -- Test reading lines from a file object
    local file = io.popen("echo hello\nworld")
    local lines = {}
    for line in file:lines() do
        table.insert(lines, line)
    end
    lu.assertEquals(lines, {"hello", "world"})
end
