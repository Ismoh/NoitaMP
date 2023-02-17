---@meta
---@class Vec2
---@field x number
---@field y number
---@class EntityOwner
---@field name string
---@field guid string
---@class EntityHealthData
---@field current number
---@field max number
---@class PlayerInfo
---@field name string
---@field entityId number
---@field guid string
---@field nuid number?

---@class SockClient
---@field host unknown
local SockClient = {}
---@param serialize function
---@param deserialize function
function SockClient:setSerialization(serialize, deserialize) end
---@param limit number
---@param minimum number
---@param maximum number
function SockClient:setTimeout(limit, minimum, maximum) end
---@param name string
---@param schema table
function SockClient:setSchema(name, schema) end
---@param name string
---@param func function
function SockClient:on(name, func) end
---@return boolean
function SockClient:isConnecting() end
---@return string
function SockClient:getAddress() end
---@return number
function SockClient:getPort() end
---@param code number?
function SockClient.disconnect(code) end
---@return boolean
function SockClient:isDisconnected() end
---@param ip string
---@param port number
function SockClient:establishClient(ip, port) end

---@class Client: SockClient
---@field iAm "CLIENT"
local Client = {}
---@param ownerName string
---@param ownerGuid any
---@param entityId number
function Client.sendNeedNuid(ownerName, ownerGuid, entityId) end

---@class Server
---@field iAm "SERVER"
local Server = {}
---@return boolean
function Server.amIServer() end
function Server.stop() end
---@param ip string?
---@param port number?
function Server.start(ip, port) end
---@return boolean
function Server.isRunning() end