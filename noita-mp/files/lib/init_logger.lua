local Logging = require ("logging")

local appender = function(self, level, message)
  print(level, message)
  return true
end

local logger = Logging.new(appender)

logger:setLevel(logger.DEBUG)

_G.logger = logger