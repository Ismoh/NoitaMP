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

if logger then
  local setting_log_level = tostring(ModSettingGetNextValue("noita-mp.log_level")) -- "debug, warn, info, error" or "warn, info, error" or "info, error"
  local levels = setting_log_level:upper():split(",")
  logger:setLevel(levels[1])

  if not _G.logger then
    _G.logger = logger
  end
else
  print("ERROR: Unable to init logger!")
end

-- Reset pathes
package.path = default_package_path

_G.logger:info("_G.logger initialised!")
