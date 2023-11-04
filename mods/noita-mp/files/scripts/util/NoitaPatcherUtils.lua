---@class NoitaPatcherUtils
local NoitaPatcherUtils = {

    --[[ Attributes ]]
}

-- Must define these callbacks else you get errors every
-- time a projectile is fired. Functions are empty since
-- we don't use these callbacks at the moment.
function OnProjectileFired() end

function OnProjectileFiredPost() end

---Serialize an entity to a base64 and md5 string.
---@param entityId number
---@return string
function NoitaPatcherUtils:serializeEntity(entityId)
    local cpc = self.customProfiler:start("NoitaPatcherUtils:serializeEntity")

    if not self.base64_fast then
        self.base64_fast = require("base64_fast")
    end

    if not self.luaBase64 then
        -- luarocks remove LuaBase64

        self.luaBase64 = require("LuaBase64")
    end

    if not self.utf8 then
        -- luarocks remove luautf8

        self.utf8 = require("lua-utf8")
    end

    print("__________________")
    local start = GameGetRealWorldTimeSinceStarted()
    local binaryString = self.np.SerializeEntity(entityId)
    local finish = GameGetRealWorldTimeSinceStarted()
    print("self.np.SerializeEntity(entityId) took " .. (finish - start) .. "ms")
    print("binaryString: " .. binaryString)

    print("")
    start = GameGetRealWorldTimeSinceStarted()
    local ffiString = self.ffi.string(binaryString)
    finish = GameGetRealWorldTimeSinceStarted()
    print("self.ffi.string(binaryString) took " .. (finish - start) .. "ms")
    print("ffiString: " .. ffiString)

    print("")
    start = GameGetRealWorldTimeSinceStarted()
    local base64String = self.base64.encode(binaryString, nil, false)
    finish = GameGetRealWorldTimeSinceStarted()
    print("self.base64.encode(binaryString, nil, false) took " .. (finish - start) .. "ms")
    print("base64String: " .. base64String)

    print("")
    start = GameGetRealWorldTimeSinceStarted()
    local encodedBase64 = self.base64_fast.encode(binaryString)
    finish = GameGetRealWorldTimeSinceStarted()
    print("self.base64_fast.encode(binaryString) took " .. (finish - start) .. "ms")
    print("encodedBase64: " .. encodedBase64)

    print("")
    start = GameGetRealWorldTimeSinceStarted()
    local luaBase64String = self.luaBase64.encode(binaryString)
    finish = GameGetRealWorldTimeSinceStarted()
    print("self.luaBase64.encode(binaryString) took " .. (finish - start) .. "ms")
    print("luaBase64String: " .. luaBase64String)

    print("")
    start = GameGetRealWorldTimeSinceStarted()
    local utf8String = self.utf8.escape(binaryString)
    finish = GameGetRealWorldTimeSinceStarted()
    print("self.utf8.escape(binaryString) took " .. (finish - start) .. "ms")
    print("utf8String: " .. utf8String)

    self.customProfiler:stop("NoitaPatcherUtils:serializeEntity", cpc)
    return binaryString
end

--- Removes NUL(\0) bytes from a string.
---@param binaryString string Binary string to remove NUL bytes from.
---@return string Binary string without NUL bytes.
function NoitaPatcherUtils:prepareForVsc(binaryString)
    local cpc = self.customProfiler:start("NoitaPatcherUtils:prepareForVsc")
    print("NUL " .. binaryString)
    binaryString = binaryString:gsub("\0", "|")
    print("| " .. binaryString)
    self.customProfiler:stop("NoitaPatcherUtils:prepareForVsc", cpc)
    return binaryString
end

---Deserialize an entity from a base64 string and create it at the given position.
---@param entityId number
---@param serializedEntityString base64 encoded string
---@param x number
---@param y number
---@return number
function NoitaPatcherUtils:deserializeEntity(entityId, serializedEntityString, x, y)
    local cpc = self.customProfiler:start("NoitaPatcherUtils.deserializeEntity")
    --local decoded = self.base64.decode(serializedEntityString, nil, false)
    --local entityId = self.np.DeserializeEntity(entityId, decoded, x, y)
    if not self.base64_fast then
        self.base64_fast = require("base64_fast")
    end
    local decoded = self.base64_fast.decode(serializedEntityString)
    local entityId = self.np.DeserializeEntity(entityId, decoded, x, y)
    if not entityId or self.utils:isEmpty(entityId) then
        error("Failed to deserialize entity from base64 string.", 2)
    end
    self.customProfiler:stop("NoitaPatcherUtils.deserializeEntity", cpc)
    return entityId
end

---NoitaPatcherUtils constructor.
---@param noitaPatcherUtilsObject NoitaPatcherUtils|nil
---@param base64 base64|nil
---@param customProfiler CustomProfiler required
---@param np noitapatcher required
---@return NoitaPatcherUtils
function NoitaPatcherUtils:new(noitaPatcherUtilsObject, base64, customProfiler, np)
    ---@class NoitaPatcherUtils
    noitaPatcherUtilsObject = setmetatable(noitaPatcherUtilsObject or self, NoitaPatcherUtils)

    if not customProfiler then
        error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    end

    local cpc = customProfiler:start("NoitaPatcherUtils:new")

    --[[ Imports ]]
    --Initialize all imports to avoid recursive imports

    if not noitaPatcherUtilsObject.base64 then
        ---@type base64
        noitaPatcherUtilsObject.base64 = base64 or require("base64")
    end

    if not noitaPatcherUtilsObject.customProfiler then
        ---@type CustomProfiler
        noitaPatcherUtilsObject.customProfiler = customProfiler or error("NoitaPatcherUtils:new requires a CustomProfiler object", 2)
    end

    if not noitaPatcherUtilsObject.np then
        ---@type noitapatcher
        noitaPatcherUtilsObject.np = np or error("NoitaPatcherUtils:new requires a NoitaPatcher object", 2)
    end

    if not noitaPatcherUtilsObject.utils then
        ---@type Utils
        noitaPatcherUtilsObject.utils = require("Utils"):new(nil)
    end

    if not noitaPatcherUtilsObject.ffi then
        ---@type ffilib
        noitaPatcherUtilsObject.ffi = require("ffi")
    end

    customProfiler:stop("EntityUtils:new", cpc)

    return noitaPatcherUtilsObject
end

return NoitaPatcherUtils
