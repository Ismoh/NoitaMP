local params = ...
local lu     = require("luaunit")
require("luaExtensions")

TestEntityCache = {}

local guid1 = GuidUtils:getGuid()
local guid2 = GuidUtils:getGuid({ guid1 })
local guid3 = GuidUtils:getGuid({ guid1, guid2 })
local guid4 = GuidUtils:getGuid({ guid1, guid2, guid3 })
local guid5 = GuidUtils:getGuid({ guid1, guid2, guid3, guid4 })

function TestEntityCache:setUp()
    EntityCache.set(1, 213, guid1, "compOwnerName",
                    "data/entities/items/flute.xml", 0, 0, 1, 57, 0, 100, 100)
    EntityCache.set(2, 222, guid2, "compOwnerName2",
                    "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 10, 100)
    EntityCache.set(3, 231, guid3, "compOwnerName3",
                    "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 50, 90)
    EntityCache.set(4, 402, guid4, "compOwnerName4",
                    "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 1, 100)
    EntityCache.set(5, 102, guid5, "compOwnerName5",
                    "data/entities/items/eye.xml", 10, 0, 1, 57, 0, 100, 100)
end

function TestEntityCache:testGet()
    local data = EntityCache.get(1)
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
end

function TestEntityCache:testGetNuid()
    local data = EntityCache.getNuid(213)
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
end

function TestEntityCache:testDelete()
    local hasDeleted = EntityCache.delete(1)
    lu.assertEquals(hasDeleted, true)
    local data = EntityCache.get(1)
    lu.assertIsNil(data)
end

function TestEntityCache:testDeleteNuid()
    local hasDeleted = EntityCache.deleteNuid(222)
    lu.assertEquals(hasDeleted, true)
    local data = EntityCache.getNuid(222)
    lu.assertIsNil(data)
end

function TestEntityCache:testSize()
    lu.assertAlmostEquals(EntityCache.size(), 5, 2)
end

function TestEntityCache:testUsage()
    lu.assertNotIsNaN(EntityCache.usage())
end

lu.LuaUnit.run(params)