--package.cpath = package.cpath .. ";"
--.. string.gsub("/home/runner/work/NoitaMP/NoitaMP/luajit/lib/?.dll;", "/", "\\")
--.. string.gsub("/home/runner/work/NoitaMP/NoitaMP/luajit/lib/?.so;", "/", "\\")

print("package.path = " .. package.path)
print("package.cpath = " .. package.cpath)

local fu = require("noita-mp/files/scripts/util/file_util")

describe("file_util.lua", function()
  -- tests go here

  describe("ReplacePathSeparator(path)", function()
    it("is_windows = true", function()
      _G.is_windows = true -- TODO: mock this on a better way: https://olivinelabs.com/busted/#spies-mocks-stubs
      local path = "/test/path/123"
      local result = fu.ReplacePathSeparator(path)

      assert.has_no.errors(fu.ReplacePathSeparator(path))
      assert.are_not.equals(path, result)
      assert.are.equals("\\test\\path\\123", result)
    end)

    it("is_windows = false (unix)", function()
      _G.is_windows = false -- TODO: mock this on a better way: https://olivinelabs.com/busted/#spies-mocks-stubs
      local path = "\\test\\path\\123"
      local result = fu.ReplacePathSeparator(path)

      assert.has_no.errors(fu.ReplacePathSeparator(path))
      assert.are_not.equals(path, result)
      assert.are.equals("/test/path/123", result)
    end)
  end)

  -- more tests pertaining to the top level
end)
