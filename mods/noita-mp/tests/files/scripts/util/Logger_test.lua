TestLogger = {}
TestLogger.mockedLogLevel = { "trace, debug, info, warn", "TRACE" }

local globalModSettingsGet = ModSettingGet
function TestLogger:setUp()
    ModSettingGet = function(id)
        if string.contains(id, "noita-mp.log_level_") then
            return TestLogger.mockedLogLevel
        end
        globalModSettingsGet(id)
    end
end

function TestLogger:tearDown()
    ModSettingGet = globalModSettingsGet
    print(
    "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print(
    "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestLogger:errors()
    lu.assertErrorMsgContains("'level' is nil!",
        logger.trace, nil, nil)
    lu.assertErrorMsgContains("'channel' is nil!",
        logger.trace, nil, nil)
    lu.assertErrorMsgContains("You're kidding! 'message' is nil",
        logger.trace, logger.channels.guid, nil)
    lu.assertErrorMsgContains("Log channel '%s' is not valid!",
        logger.trace, "asdf", nil)
    lu.assertErrorMsgContains("There is a directive (%) in your log message. ",
        logger.trace, logger.channels.testing, "Directive in here %s %S %x")
end

function TestLogger:testTrace()
    TestLogger.mockedLogLevel = { "trace, debug, info, warn", "TRACE" }
    lu.assertIsTrue(logger:trace(logger.channels.testing, "This should be logged, trace level!"))
    lu.assertIsTrue(logger:debug(logger.channels.testing, "This should be logged, debug level!"))
    lu.assertIsTrue(logger:info(logger.channels.testing, "This should be logged, info level!"))
    lu.assertIsTrue(logger:warn(logger.channels.testing, "This should be logged, warn level!"))
end

function TestLogger:testDebug()
    TestLogger.mockedLogLevel = { "debug, info, warn", "DEBUG" }
    lu.assertIsFalse(logger:trace(logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsTrue(logger:debug(logger.channels.testing, "This should be logged, debug level!"))
    lu.assertIsTrue(logger:info(logger.channels.testing, "This should be logged, info level!"))
    lu.assertIsTrue(logger:warn(logger.channels.testing, "This should be logged, warn level!"))
end

function TestLogger:testInfo()
    TestLogger.mockedLogLevel = { "info, warn", "INFO" }
    lu.assertIsFalse(logger:trace(logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsFalse(logger:debug(logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsTrue(logger:info(logger.channels.testing, "This should be logged, info level!"))
    lu.assertIsTrue(logger:warn(logger.channels.testing, "This should be logged, warn level!"))
end

function TestLogger:testWarn()
    TestLogger.mockedLogLevel = { "warn", "WARN" }
    lu.assertIsFalse(logger:trace(logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsFalse(logger:debug(logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsFalse(logger:info(logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsTrue(logger:warn(logger.channels.testing, "This should be logged, warn level!"))
end
