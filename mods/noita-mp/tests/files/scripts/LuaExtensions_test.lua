local lu = require("luaunit")

TestLuaExtensionsNetworkCache = {}
local networkCacheMocked = {}

function TestLuaExtensionsNetworkCache:setUp()
    lu.skip("Skipping LuaExtentions_test.lua completely, because it's broken right now!")

    for i = 1, 50 do
        local peer = math.random(5)
        local messageId = i * 14
        local event = selectRandFromTable({
            "needNuid",
            "entityData",
            "deadNuids",
            "playerInfo"
        })
        local status = selectRandFromTable({
            "ack",
            "sent"
        })
        local ackedAt = math.random(10000)
        local sentAt = math.random(10000)
        local sum = md5.sumhexa(tostring(i))
        table.insert(networkCacheMocked, {
            event = event,
            messageId = messageId,
            dataChecksum = sum,
            status = status,
            ackedAt = ackedAt,
            sentAt = sentAt,
            peerNum = peer
        })
        NetworkCacheC.set(peer, messageId, event, status, ackedAt, sentAt, sum)
    end
end

math.randomseed(os.time())
local md5 = require("md5")
function selectRandFromTable(tbl)
    return tbl[math.random(1, #tbl)]
end

function getCacheEntry(id)
    for index, value in ipairs(networkCacheMocked) do
        if value.messageId == id then
            return value
        end
    end
end

function TestLuaExtensionsNetworkCache:testGetChecksum()
    for i = 1, 50 do
        local expected = networkCacheMocked[i]
        local actual = NetworkCacheC.getChecksum(expected.peerNum, expected.dataChecksum)
        lu.assertEquals(actual.dataChecksum, expected.dataChecksum)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.event, expected.event)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.ackedAt, expected.ackedAt)
        lu.assertEquals(actual.sentAt, expected.sentAt)
        lu.assertEquals(actual.status, expected.status)
    end
    local size = NetworkCacheC.size()
    local usage = NetworkCacheC.usage()
    lu.assertAlmostEquals(size, 50)
    lu.assertAlmostEquals(usage, 1400)
end

function TestLuaExtensionsNetworkCache:testGet()
    for i = 1, 50 do
        local expected = networkCacheMocked[i]
        local actual = NetworkCacheC.get(expected.peerNum, expected.event, expected.messageId)
        lu.assertEquals(actual.dataChecksum, expected.dataChecksum)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.event, expected.event)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.ackedAt, expected.ackedAt)
        lu.assertEquals(actual.sentAt, expected.sentAt)
        lu.assertEquals(actual.status, expected.status)
    end
end

function TestLuaExtensionsNetworkCache:testGetAll()
    local all = NetworkCacheC.getAll()
    for index, actual in ipairs(all) do
        local expected = getCacheEntry(actual.messageId)
        lu.assertEquals(actual.dataChecksum, expected.dataChecksum)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.event, expected.event)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.ackedAt, expected.ackedAt)
        lu.assertEquals(actual.sentAt, expected.sentAt)
        lu.assertEquals(actual.status, expected.status)
    end
end

function TestLuaExtensionsNetworkCache:testRemoveOldest()
    local size = NetworkCacheC.size()
    local usage = NetworkCacheC.usage()
    local id = NetworkCacheC.removeOldest()
    for index, value in ipairs(networkCacheMocked) do
        if value.messageId == id then table.remove(networkCacheMocked, index) end
    end
    local all = NetworkCacheC.getAll()
    for _, actual in ipairs(all) do
        local expected = getCacheEntry(actual.messageId)
        lu.assertEquals(actual.dataChecksum, expected.dataChecksum)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.event, expected.event)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.ackedAt, expected.ackedAt)
        lu.assertEquals(actual.sentAt, expected.sentAt)
        lu.assertEquals(actual.status, expected.status)
    end
    lu.assertEquals(NetworkCacheC.size(), size - 1)
    lu.assertEquals(NetworkCacheC.usage(), usage - 28)
end

-- Add the Z to ensure that clear is the last test run, as tests run in alphabetical order
function TestLuaExtensionsNetworkCache:testZClear()
    NetworkCacheC.clear(1)
    for index, value in ipairs(networkCacheMocked) do
        if value.peerNum == 1 then table.remove(networkCacheMocked, index) end
    end
    local all = NetworkCacheC.getAll()
    for _, actual in ipairs(all) do
        local expected = getCacheEntry(actual.messageId)
        lu.assertEquals(actual.dataChecksum, expected.dataChecksum)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.event, expected.event)
        lu.assertEquals(actual.messageId, expected.messageId)
        lu.assertEquals(actual.ackedAt, expected.ackedAt)
        lu.assertEquals(actual.sentAt, expected.sentAt)
        lu.assertEquals(actual.status, expected.status)
    end
end

local entityCacheMocked = {}
TestLuaExtensionsEntityCache = {}

function TestLuaExtensionsEntityCache:setUp()
    lu.skip("Skipping LuaExtentions_test.lua completely, because it's broken right now!")

    for i = 1, 50 do
        local entityId = i * 32
        local nuid = i * 14
        local ownerGuid = tostring(math.random(50000))
        local ownerName = tostring(math.random(10))
        local filepath = selectRandFromTable({
            "player.xml",
            "player_base.xml",
            "randomfile.xml",
            "randomfile2.xml",
        })
        local x = math.random(100)
        local y = math.random(100)
        local rotation = math.random()
        local vx = math.random(100)
        local vy = math.random(100)
        local cHealth = math.random(100)
        local maxHealth = math.random(100, 1000)
        table.insert(entityCacheMocked, {
            entityId = entityId,
            nuid = nuid,
            ownerGuid = ownerGuid,
            ownerName = ownerName,
            filepath = filepath,
            x = x,
            y = y,
            rotation = rotation,
            velX = vx,
            velY = vy,
            currentHealth = cHealth,
            maxHealth = maxHealth
        })
        EntityCacheC.set(entityId, nuid, ownerGuid, ownerName, filepath, x, y, rotation, vx, vy, cHealth, maxHealth)
    end
end

function TestLuaExtensionsEntityCache:testGet()
    for i = 1, 50 do
        local expected = entityCacheMocked[i]
        local actual = EntityCacheC.get(expected.entityId)
        --- @cast actual table
        lu.assertEquals(actual.entityId, expected.entityId)
        lu.assertEquals(actual.nuid, expected.nuid)
        lu.assertEquals(actual.ownerGuid, expected.ownerGuid)
        lu.assertEquals(actual.ownerName, expected.ownerName)
        lu.assertEquals(actual.filepath, expected.filepath)
        lu.assertEquals(actual.x, expected.x)
        lu.assertEquals(actual.y, expected.y)
        lu.assertEquals(actual.rotation, expected.rotation)
        lu.assertEquals(actual.velX, expected.velX)
        lu.assertEquals(actual.velY, expected.velY)
        lu.assertEquals(actual.currentHealth, expected.currentHealth)
        lu.assertEquals(actual.maxHealth, expected.maxHealth)
    end
end

function TestLuaExtensionsEntityCache:testGetNuid()
    for i = 1, 50 do
        local expected = entityCacheMocked[i]
        local actual = EntityCacheC.getNuid(expected.nuid)
        --- @cast actual table
        lu.assertEquals(actual.entityId, expected.entityId)
        lu.assertEquals(actual.nuid, expected.nuid)
        lu.assertEquals(actual.ownerGuid, expected.ownerGuid)
        lu.assertEquals(actual.ownerName, expected.ownerName)
        lu.assertEquals(actual.filepath, expected.filepath)
        lu.assertEquals(actual.x, expected.x)
        lu.assertEquals(actual.y, expected.y)
        lu.assertEquals(actual.rotation, expected.rotation)
        lu.assertEquals(actual.velX, expected.velX)
        lu.assertEquals(actual.velY, expected.velY)
        lu.assertEquals(actual.currentHealth, expected.currentHealth)
        lu.assertEquals(actual.maxHealth, expected.maxHealth)
    end
end

function TestLuaExtensionsEntityCache:testSizeUsage()
    lu.assertEquals(EntityCacheC.size(), 50)
    lu.assertEquals(EntityCacheC.usage(), 4000)
end

function TestLuaExtensionsEntityCache:testZDelete()
    local d1 = math.random(50)
    local d2 = math.random(50)
    EntityCacheC.delete(entityCacheMocked[d1].entityId)
    table.remove(entityCacheMocked, d1)
    EntityCacheC.delete(entityCacheMocked[d2].entityId)
    table.remove(entityCacheMocked, d2)
    local all = EntityCacheC.getAll()
    for _, actual in ipairs(all) do
        local expected
        for _, value in ipairs(entityCacheMocked) do
            if value.entityId == actual.entityId then
                expected = value
            end
        end
        lu.assertEquals(actual.entityId, expected.entityId)
        lu.assertEquals(actual.nuid, expected.nuid)
        lu.assertEquals(actual.ownerGuid, expected.ownerGuid)
        lu.assertEquals(actual.ownerName, expected.ownerName)
        lu.assertEquals(actual.filepath, expected.filepath)
        lu.assertEquals(actual.x, expected.x)
        lu.assertEquals(actual.y, expected.y)
        lu.assertEquals(actual.rotation, expected.rotation)
        lu.assertEquals(actual.velX, expected.velX)
        lu.assertEquals(actual.velY, expected.velY)
        lu.assertEquals(actual.currentHealth, expected.currentHealth)
        lu.assertEquals(actual.maxHealth, expected.maxHealth)
    end
end

function TestLuaExtensionsEntityCache:testZDeleteNuid()
    local d1 = math.random(50)
    local d2 = math.random(50)
    EntityCacheC.deleteNuid(entityCacheMocked[d1].nuid)
    table.remove(entityCacheMocked, d1)
    EntityCacheC.deleteNuid(entityCacheMocked[d2].nuid)
    table.remove(entityCacheMocked, d2)
    local all = EntityCacheC.getAll()
    for _, actual in ipairs(all) do
        local expected
        for _, value in ipairs(entityCacheMocked) do
            if value.nuid == actual.nuid then
                expected = value
            end
        end
        lu.assertEquals(actual.entityId, expected.entityId)
        lu.assertEquals(actual.nuid, expected.nuid)
        lu.assertEquals(actual.ownerGuid, expected.ownerGuid)
        lu.assertEquals(actual.ownerName, expected.ownerName)
        lu.assertEquals(actual.filepath, expected.filepath)
        lu.assertEquals(actual.x, expected.x)
        lu.assertEquals(actual.y, expected.y)
        lu.assertEquals(actual.rotation, expected.rotation)
        lu.assertEquals(actual.velX, expected.velX)
        lu.assertEquals(actual.velY, expected.velY)
        lu.assertEquals(actual.currentHealth, expected.currentHealth)
        lu.assertEquals(actual.maxHealth, expected.maxHealth)
    end
end
