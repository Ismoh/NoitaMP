local default_package_path = package.path
package.path = package.path .. ";mods/noita-mp/files/lib/external/?.lua;"

local Logging = require("logging")

local appender = function(self, level, message)
  -- add file name to logs: https://stackoverflow.com/a/48469960/3493998
  local file_name = debug.getinfo(2, "S").source:sub(2)
  file_name = file_name:match("^.*/(.*)$") or file_name
  file_name = file_name
  level = string.trim(level)
  local time = os.date("%X")

  local msg = ("%s [%s] %s ( in %s )"):format(time, level, message, file_name)
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

print("_G.logger initialised!")
_G.logger = logger

-- Reset pathes
package.path = default_package_path
