local Utils   = require("Utils")

TestUtil     = {}

function TestUtil:setUp()

end

function TestUtil:tearDown()

end

function TestUtil:testSleep()
    lu.assertErrorMsgContains("Unable to wait if parameter 'seconds' isn't a number:", Utils.Sleep, "seconds")

    local seconds_to_wait  = 4
    local timestamp_before = os.clock()
    Utils.Sleep(seconds_to_wait)
    local timestamp_after = os.clock()
    local diff            = timestamp_before + seconds_to_wait
    Logger.debug(Logger.channels.testing,("timestamp_before=%s, timestamp_after=%s, diff=%s"):format(timestamp_before, timestamp_after, diff))
    lu.almostEquals(diff, timestamp_after, 0.1)
end

function TestUtil:testIsEmpty()
    local tbl = {}
    table.insert(tbl, "1234")
    lu.assertIsFalse(Utils.IsEmpty(tbl))

    lu.assertIsTrue(Utils.IsEmpty(nil))
    lu.assertIsTrue(Utils.IsEmpty(""))
    lu.assertIsTrue(Utils.IsEmpty({}))
end