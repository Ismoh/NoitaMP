require("file_util.lua")

describe("file_util.lua", function()
  -- tests go here

  describe("ReplacePathSeparator(path)", function()
    it("is_windows = true", function()
      _G.is_windows = true -- TODO: mock this on a better way: https://olivinelabs.com/busted/#spies-mocks-stubs
      local path = "\test\path\123"
      local result = ReplacePathSeparator(path)
            
            assert.has_no.errors(ReplacePathSeparator(path))
            assert.are_not.equals(path, result)
            assert.are.equals("//test//path//123", result)
    end)
  end)

  -- more tests pertaining to the top level
end)
