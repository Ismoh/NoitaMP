TestLogger = {}
TestLogger.mockedLogLevel = { "trace, debug, info, warn", "TRACE" }

function TestLogger:setUp()

end

function TestLogger:tearDown()

end

function TestLogger:errors()
    lu.assertErrorMsgContains("'level' is nil!",
                              Logger.log, nil, nil, nil)
    lu.assertErrorMsgContains("'channel' is nil!",
                              Logger.log, Logger.level.trace, nil, nil)
    lu.assertErrorMsgContains("You're kidding! 'message' is nil",
                              Logger.log, Logger.level.trace, Logger.channels.guid, nil)
    lu.assertErrorMsgContains("Log level '%s' is not valid!",
                                Logger.log, "asdf", nil, nil)
    lu.assertErrorMsgContains("Log level '%s' is not valid!",
                              Logger.log, Logger.level.trace, "asdf", nil)
    lu.assertErrorMsgContains("There is a directive (%) in your log message. ",
                              Logger.log, "trace", Logger.channels.testing, "Directive in here %s %S %x")
end

function TestLogger:testLog()
    local level = "off"
    local logged = Logger.log(level, Logger.channels.testing, "asd")
    lu.assertIsFalse(logged)
end

function TestLogger:testTrace()
    TestLogger.mockedLogLevel = { "trace, debug, info, warn", "TRACE" }
    lu.assertIsTrue(Logger.trace(Logger.channels.testing, "This should be logged, trace level!"))
    lu.assertIsTrue(Logger.debug(Logger.channels.testing, "This should be logged, debug level!"))
    lu.assertIsTrue(Logger.info(Logger.channels.testing, "This should be logged, info level!"))
    lu.assertIsTrue(Logger.warn(Logger.channels.testing, "This should be logged, warn level!"))
end

function TestLogger:testDebug()
    TestLogger.mockedLogLevel = { "debug, info, warn", "DEBUG" }
    lu.assertIsFalse(Logger.trace(Logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsTrue(Logger.debug(Logger.channels.testing, "This should be logged, debug level!"))
    lu.assertIsTrue(Logger.info(Logger.channels.testing, "This should be logged, info level!"))
    lu.assertIsTrue(Logger.warn(Logger.channels.testing, "This should be logged, warn level!"))
end

function TestLogger:testInfo()
    TestLogger.mockedLogLevel = { "info, warn", "INFO" }
    lu.assertIsFalse(Logger.trace(Logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsFalse(Logger.debug(Logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsTrue(Logger.info(Logger.channels.testing, "This should be logged, info level!"))
    lu.assertIsTrue(Logger.warn(Logger.channels.testing, "This should be logged, warn level!"))
end

function TestLogger:testWarn()
    TestLogger.mockedLogLevel = { "warn", "WARN" }
    lu.assertIsFalse(Logger.trace(Logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsFalse(Logger.debug(Logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsFalse(Logger.info(Logger.channels.testing, "This should NOT be logged!"))
    lu.assertIsTrue(Logger.warn(Logger.channels.testing, "This should be logged, warn level!"))
end
