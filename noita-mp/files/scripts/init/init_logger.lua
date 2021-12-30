local Logging = require ("logging")

local appender = function(self, level, message)
  -- add file name to logs
  local file_name = debug.getinfo(2, "S").source:sub(2)
  file_name = file_name:match("^.*/(.*).lua$") or file_name

  print(file_name, level, message)
  return true
end

local logger = Logging.new(appender)

logger:setLevel(logger.DEBUG)

_G.logger = logger