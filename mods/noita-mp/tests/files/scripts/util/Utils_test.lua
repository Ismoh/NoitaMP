TestUtil = {}

noitaMpSettings = noitaMpSettings or
    require("NoitaMpSettings")
    :new(nil, nil, {}, nil, nil, nil, nil, nil, nil)
utils = utils or
    require("Utils")
    :new()
logger = logger or
    require("Logger")
    :new(nil, noitaMpSettings)

function TestUtil:setUp()

end

function TestUtil:tearDown()
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
    print(
        "\n-------------------------------------------------------------------------------------------------------------------------------------------------------")
end

function TestUtil:testSleep()
    lu.assertErrorMsgContains("Unable to wait if parameter 'seconds' isn't a number:", utils.sleep, "seconds")

    local seconds_to_wait  = 4
    local timestamp_before = os.clock()
    utils:sleep(seconds_to_wait)
    local timestamp_after = os.clock()
    local diff            = timestamp_before + seconds_to_wait
    logger:debug(logger.channels.testing, ("timestamp_before=%s, timestamp_after=%s, diff=%s"):format(timestamp_before, timestamp_after, diff))
    lu.almostEquals(diff, timestamp_after, 0.1)
end

function TestUtil:testIsEmpty()
    local tbl = {}
    table.insert(tbl, "1234")
    lu.assertIsFalse(utils:isEmpty(tbl))

    lu.assertIsTrue(utils:isEmpty(nil))
    lu.assertIsTrue(utils:isEmpty(""))
    lu.assertIsTrue(utils:isEmpty({}))
end
