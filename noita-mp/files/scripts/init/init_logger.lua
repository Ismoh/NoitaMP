local Logging = require ("logging")

local appender = function(self, level, message)
  -- add file name to logs: https://stackoverflow.com/a/48469960/3493998
  local file_name = debug.getinfo(2, "S").source:sub(2)
  file_name = file_name:match("^.*/(.*)$") or file_name
  file_name = "\n" .. file_name .. " | "
  level = string.trim(level)

  print(file_name .. level .. " | " .. message)
  GamePrint(level .. " | " .. message)
  return true
end

local logger = Logging.new(appender)

if DebugGetIsDevBuild() then
  logger:setLevel(logger.DEBUG)
else
  logger:setLevel(logger.WARN)
end

_G.logger = logger