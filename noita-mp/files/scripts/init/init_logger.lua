local Logging = require ("logging")

local appender = function(self, level, message)
  -- add file name to logs: https://stackoverflow.com/a/48469960/3493998
  local file_name = debug.getinfo(2, "S").source:sub(2)
  file_name = file_name:match("^.*/(.*)$") or file_name
  file_name = file_name
  level = string.trim(level)
  local time = os.date("%X")

  local msg = ("%s\n%s\n[%s] %s"):format(time, file_name, level, message)
  print(msg)
  --GamePrint(msg)
  return true
end

local logger = Logging.new(appender)

-- if DebugGetIsDevBuild() then
--   logger:setLevel(logger.DEBUG)
-- else
--   logger:setLevel(logger.WARN)
-- end

_G.logger = logger