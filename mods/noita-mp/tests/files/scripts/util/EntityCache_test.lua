TestEntityCache = {}

noitaMpSettings = noitaMpSettings or
    require("NoitaMpSettings")
    :new(nil, nil, {}, nil, nil, nil, nil, nil, nil)
customProfiler  = customProfiler or
    require("CustomProfiler")
    :new(nil, nil, noitaMpSettings, nil, nil, nil, nil)
guidUitls       = guidUtils or
    require("GuidUtils")
    :new(nil, customProfiler, nil, nil, nil, nil, nil, nil)
logger          = logger or
    require("Logger")
    :new(nil, noitaMpSettings)
entityCache     = entityCache or
    require("EntityCache")
    :new(nil, customProfiler, nil, nil)

local guid1     = guidUtils:generateNewGuid()
local guid2     = guidUtils:generateNewGuid({ guid1 })
local guid3     = guidUtils:generateNewGuid({ guid1, guid2 })
local guid4     = guidUtils:generateNewGuid({ guid1, guid2, guid3 })
local guid5     = guidUtils:generateNewGuid({ guid1, guid2, guid3, guid4 })

function TestEntityCache:setUp()
    logger:trace(logger.channels.testing, ("EntityCache.size() = %s"):format(entityCache:size()))
end

function TestEntityCache:testGet()
    entityCache:set(1, 213, guid1, "compOwnerName",
        "data/entities/items/flute.xml", 0, 0, 1, 57, 0, 100, 100)

    local data = entityCache:get(1)
    lu.assertEquals(data, {
        entityId      = 1,
        nuid          = 213,
        ownerGuid     = guid1,
        ownerName     = "compOwnerName",
        filename      = "data/entities/items/flute.xml",
        x             = 0,
        y             = 0,
        rotation      = 1,
        velX          = 57,
        velY          = 0,
        currentHealth = 100,
        maxHealth     = 100
    })

    entityCache:delete(1)
end

function TestEntityCache:testGetNuid()
    if _G.disableLuaExtensionsDLL then
        return
    end

    entityCache:set(1, 213, guid1, "compOwnerName",
        "data/entities/items/flute.xml", 0, 0, 1, 57, 0, 100, 100)

    local data = entityCache:getNuid(213)
    lu.assertEquals(data, {
        entityId      = 1,
        nuid          = 213,
        ownerGuid     = guid1,
        ownerName     = "compOwnerName",
        filepath      = "data/entities/items/flute.xml",
        x             = 0,
        y             = 0,
        rotation      = 1,
        velX          = 57,
        velY          = 0,
        currentHealth = 100,
        maxHealth     = 100
    })

    entityCache:delete(1)
end

function TestEntityCache:testDelete()
    entityCache:set(3, 231, guid3, "compOwnerName3",
        "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 50, 90)

    local hasDeleted = entityCache:delete(3)
    lu.assertEquals(hasDeleted, true)
    local data = entityCache:get(3)
    lu.assertIsNil(data)
end

function TestEntityCache:testDeleteNuid()
    if _G.disableLuaExtensionsDLL then
        return
    end

    entityCache:set(2, 222, guid2, "compOwnerName2",
        "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 10, 100)

    local hasDeleted = entityCache:deleteNuid(222)
    lu.assertEquals(hasDeleted, true)
    local data = entityCache:getNuid(222)
    lu.assertIsNil(data)
end

function TestEntityCache:testSize()
    entityCache:set(4, 402, guid4, "compOwnerName4",
        "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 1, 100)
    entityCache:set(5, 102, guid5, "compOwnerName5",
        "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 100, 100)

    lu.assertEquals(entityCache:size(), 2)

    entityCache:delete(4)
    entityCache:delete(5)
end

function TestEntityCache:testUsage()
    entityCache:set(4, 402, guid4, "compOwnerName4",
        "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 1, 100)
    entityCache:set(5, 102, guid5, "compOwnerName5",
        "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 100, 100)

    lu.assertError(entityCache.usage)

    entityCache:delete(4)
    entityCache:delete(5)
end
