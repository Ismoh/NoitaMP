local default_package_path = package.path
package.path = package.path .. ";mods/noita-mp/files/lib/external/?.lua;"

local Logging = require("logging")

local appender = function(self, level, channel, message)

  if channel then -- also have a look on dump_logger.lua
    local logLevelPerChannel = tostring(ModSettingGet(("noita-mp.log_level_%s"):format(channel)))
    if not logLevelPerChannel:contains(level) then
      return false
    end
  end

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
  -- if ModSettingGetNextValue then
  --   local setting_log_level = tostring(ModSettingGetNextValue("noita-mp.log_level")) -- "debug, warn, info, error" or "warn, info, error" or "info, error"
  --   local levels = setting_log_level:upper():split(",")
  --   logger:setLevel(levels[1])
  -- else
  logger:setLevel("DEBUG")
  --end

  logger.channels = {
    entity = "entity",
    globals = "globals",
    guid = "guid",
    network = "network",
    nuid = "nuid",
    vsc = "vsc",
  }

  if not _G.logger then
    _G.logger = logger
  end
else
  print("ERROR: Unable to init logger! logger is nil.")
end

-- Reset pathes
package.path = default_package_path

_G.logger:info(nil, "_G.logger initialised!")
