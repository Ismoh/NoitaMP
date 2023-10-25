local SockServer = {}

--- A Lua networking library for LÖVE games.
-- * [Source code](https://github.com/camchenry/sock.lua)
-- * [Examples](https://github.com/camchenry/sock.lua/tree/master/examples)

---@class sock
local sock = {
    _VERSION     = 'sock.lua v0.3.0',
    _DESCRIPTION = 'A Lua networking library for LÖVE games',
    _URL         = 'https://github.com/camchenry/sock.lua',
    _LICENSE     = [[
        MIT License

        Copyright (c) 2016 Cameron McHenry

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]]
}

local enet = require("enet")

print("lua-enet version = master branch 21.10.2015")
print(("enet version = %s"):format(enet.linked_version())) -- 1.3.17

-- links variables to keys based on their order
-- note that it only works for boolean and number values, not strings
local function zipTable(items, keys, event)
    local data = {}

    -- convert variable at index 1 into the value for the key value at index 1, and so on
    for i, value in ipairs(items) do
        local key = keys[i]

        if not key then
            error(("Missing data key for event '%s'! items = %s schema = %s")
                :format(event, utils:pformat(items), utils:pformat(keys)), 2)
        end

        data[key] = value
    end

    return data
end

--- All of the possible connection statuses for a client connection.
-- @see Client:getState
sock.CONNECTION_STATES    = {
    "disconnected",             -- Disconnected from the server.
    "connecting",               -- In the process of connecting to the server.
    "acknowledging_connect",    --
    "connection_pending",       --
    "connection_succeeded",     --
    "connected",                -- Successfully connected to the server.
    "disconnect_later",         -- Disconnecting, but only after sending all queued packets.
    "disconnecting",            -- In the process of disconnecting from the server.
    "acknowledging_disconnect", --
    "zombie",                   --
    "unknown",                  --
}

--- States that represent the client connecting to a server.
sock.CONNECTING_STATES    = {
    "connecting",            -- In the process of connecting to the server.
    "acknowledging_connect", --
    "connection_pending",    --
    "connection_succeeded",  --
}

--- States that represent the client disconnecting from a server.
sock.DISCONNECTING_STATES = {
    "disconnect_later",         -- Disconnecting, but only after sending all queued packets.
    "disconnecting",            -- In the process of disconnecting from the server.
    "acknowledging_disconnect", --
}

--- Valid modes for sending messages.
sock.SEND_MODES           = {
    "reliable",    -- Message is guaranteed to arrive, and arrive in the order in which it is sent.
    "unsequenced", -- Message has no guarantee on the order that it arrives.
    "unreliable",  -- Message is not guaranteed to arrive.
}

local function isValidSendMode(mode)
    for _, validMode in ipairs(sock.SEND_MODES) do
        if mode == validMode then
            return true
        end
    end
    return false
end

--- NoitaMp Moved this part from newServer to SockServer:start
---@param ip string
---@param port number
---@param fileUtils FileUtils
---@param logger Logger
function SockServer:start(ip, port, fileUtils, logger)
    ip           = ip or self.address
    port         = port or self.port

    self.address = ip
    self.port    = port

    -- ip, max peers, max channels, in bandwidth, out bandwidth
    -- number of channels for the client and server must match
    self.host    = enet.host_create(ip .. ":" .. port, self.maxPeers, self.maxChannels)

    if not self.host then
        --error("Failed to create the host. Is there another server running on :" .. self.port .. "?")
        self:log("", { "Failed to create the host. Is there another server running on :" .. self.port .. "?" })
        local pid = fileUtils:GetPidOfRunningEnetHostByPort()
        fileUtils:KillProcess(pid)
        return false
    end

    self.address = string.sub(self:getSocketAddress(), 1, string.find(self:getSocketAddress(), ":", 1, true) - 1) --ip
    self.port    = port

    self:setBandwidthLimit(0, 0)

    self.logger:info(logger.channels.network, ("Started server on %s:%s"):format(self.address, self.port))
    -- Serialization is set in Server.setConfigSettings()
    --if bitserLoaded then
    --    self:setSerialization(bitser.dumps, bitser.loads)
    --end
    --self:setSerialization(zstandard.compress, zstandard.decompress)
    return true
end

--- Check for network events and handle them.
function SockServer:update()
    local event = self.host:service(self.messageTimeout)

    while event do
        if event.type == "connect" then
            local eventClient = require("Client"):new(nil, event.peer, nil, nil, self)
            eventClient:establishClient(event.peer)
            eventClient:setSerialization(self.serialize, self.deserialize)
            eventClient.clientCacheId = self.guidUtils.toNumber(eventClient.guid)
            table.insert(self.peers, event.peer)
            table.insert(self.clients, eventClient)
            self:_activateTriggers("connect", event.data, eventClient)
            self:log(event.type, tostring(event.peer) .. " connected")
        elseif event.type == "receive" then
            local eventName, data = self:__unpack(event.data)
            local eventClient     = self:getClient(event.peer)

            self:_activateTriggers(eventName, data, eventClient)
            self:log(eventName, data)
        elseif event.type == "disconnect" then
            -- remove from the active peer list
            for i, peer in pairs(self.peers) do
                if peer == event.peer then
                    table.remove(self.peers, i)
                end
            end
            local eventClient = self:getClient(event.peer)
            for i, client in pairs(self.clients) do
                if client == eventClient then
                    table.remove(self.clients, i)
                end
            end
            self:_activateTriggers("disconnect", event.data, eventClient)
            self:log(event.type, tostring(event.peer) .. " disconnected")
        else
            self:log(event.type,
                ("event = %s, type = %s, data = %s, peer = %s"):format(event, event.type, event.data, event.peer))
        end

        event = self.host:service(self.messageTimeout)
    end
end

-- Creates the unserialized message that will be used in callbacks
-- In: serialized message (string)
-- Out: event (string), data (mixed)
function SockServer:__unpack(data)
    if not self.deserialize then
        self:log("error", "Can't deserialize message: deserialize was not set")
        error("Can't deserialize message: deserialize was not set")
    end

    local message         = self.deserialize(data)
    local eventName, data = message[1], message[2]
    return eventName, data
end

--- Added for NoitaMP
---@param data any
---@return any
function SockServer:unpack(data)
    if not self.deserialize then
        self:log("error", "Can't deserialize message: deserialize was not set")
        error("Can't deserialize message: deserialize was not set")
    end

    return self.deserialize(data)
end

-- Creates the serialized message that will be sent over the network
-- In: event (string), data (mixed)
-- Out: serialized message (string)
function SockServer:__pack(event, data)
    local message = { event, data }
    local serializedMessage

    if not self.serialize then
        self:log("error", "Can't serialize message: serialize was not set")
        error("Can't serialize message: serialize was not set")
    end

    -- 'Data' = binary data class in Love
    if type(data) == "userdata" and data.type and data:typeOf("Data") then
        message[2]        = data:getString()
        serializedMessage = self.serialize(message)
    else
        serializedMessage = self.serialize(message)
    end

    return serializedMessage
end

--- Added for NoitaMP
---@param data any
---@return any
function SockServer:pack(data)
    if not self.serialize then
        self:log("error", "Can't serialize message: serialize was not set")
        error("Can't serialize message: serialize was not set")
    end

    return self.serialize(data)
end

--- Send a message to all clients, except one.
-- Useful for when the client does something locally, but other clients
-- need to be updated at the same time. This way avoids duplicating objects by
-- never sending its own event to itself in the first place.
-- @tparam Client client The client to not receive the message.
-- @tparam string event The event to trigger with this message.
-- @param data The data to send.
function SockServer:sendToAllBut(client, event, data)
    error("SockServer:sendToAllBut is deprecated, because cache wont work. Use SockServer:sendToPeer instead.", 2)
    local serializedMessage = self:__pack(event, data)

    for _, p in pairs(self.peers) do
        if p ~= client.connection then
            self.packetsSent = self.packetsSent + 1
            p:send(serializedMessage, self.sendChannel, self.sendMode)
        end
    end

    self:resetSendSettings()
end

--- Send a message to all clients.
-- @tparam string event The event to trigger with this message.
-- @param data The data to send.
--@usage
--server:sendToAll("gameStarting", true)
function SockServer:sendToAll(event, data)
    error("SockServer:sendToAll is deprecated, because cache wont work. Use SockServer:sendToPeer instead.", 2)
    local serializedMessage = self:__pack(event, data)

    self.packetsSent        = self.packetsSent + #self.peers

    self.host:broadcast(serializedMessage, self.sendChannel, self.sendMode)

    self:resetSendSettings()

    return true
end

function SockServer:sendToAll2(event, data)
    error("SockServer:sendToAll2 is deprecated, because cache wont work. Use SockServer:sendToPeer instead.", 2)
    local cpc               = CustomProfiler.start("SockServer:sendToAll2")
    local serializedMessage = self:__pack(event, data)

    for _, p in pairs(self.peers) do
        self.packetsSent = self.packetsSent + 1
        p:send(serializedMessage, self.sendChannel, self.sendMode)
    end

    self:resetSendSettings()
    CustomProfiler.stop("SockServer:sendToAll2", cpc)
end

--- Send a message to a single peer. Useful to send data to a newly connected player
--- without sending to everyone who already received it.
--- @param peer Client|Server|enet_peer The enet peer to receive the message.
--- @param event string The event to trigger with this message.
--- @param data table to send to the peer.
--- Usage: server:sendToPeer(peer, "initialGameInfo", {...})
function SockServer:sendToPeer(peer, event, data)
    local cpc              = CustomProfiler.start("SockServer:sendToPeer")
    local networkMessageId = data[1] or data.networkMessageId
    if Utils.IsEmpty(networkMessageId) then
        error("networkMessageId is empty!", 3)
    end
    self.packetsSent = self.packetsSent + 1
    peer:send(event, data)
    self:resetSendSettings()
    CustomProfiler.stop("SockServer:sendToPeer", cpc)
    return networkMessageId
end

--- Add a callback to an event.
-- @tparam string event The event that will trigger the callback.
-- @tparam function callback The callback to be triggered.
-- @treturn function The callback that was passed in.
--@usage
--server:on("connect", function(data, client)
--    print("Client connected!")
--end)
function SockServer:on(event, callback)
    return self.listener:addCallback(event, callback)
end

function SockServer:_activateTriggers(event, data, client)
    local result         = self.listener:trigger(event, data, client)

    self.packetsReceived = self.packetsReceived + 1

    if not result then
        self:log("warning", "Server tried to activate trigger: '" .. tostring(event) .. "' but it does not exist.")
    end
end

--- Remove a specific callback for an event.
-- @tparam function callback The callback to remove.
-- @treturn boolean Whether or not the callback was removed.
--@usage
--local callback = server:on("chatMessage", function(message)
--    print(message)
--end)
--server:removeCallback(callback)
function SockServer:removeCallback(callback)
    return self.listener:removeCallback(callback)
end

--- Log an event.
-- Alias for Server.logger:log.
-- @tparam string event The type of event that happened.
-- @tparam string data The message to log.
--@usage
--if somethingBadHappened then
--    server:log("error", "Something bad happened!")
--end
function SockServer:log(event, data)
    return self.logger:log(event, data)
end

--- Reset all send options to their default values.
function SockServer:resetSendSettings()
    self.sendMode    = self.defaultSendMode
    self.sendChannel = self.defaultSendChannel
end

--- Enables an adaptive order-2 PPM range coder for the transmitted data of all peers. Both the client and server must both either have compression enabled or disabled.
--
-- Note: lua-enet does not currently expose a way to disable the compression after it has been enabled.
function SockServer:enableCompression()
    return self.host:compress_with_range_coder()
end

--- Destroys the server and frees the port it is bound to.
function SockServer:destroy()
    self.host:destroy()
end

--- Set the send mode for the next outgoing message.
-- The mode will be reset after the next message is sent. The initial default
-- is "reliable".
-- @tparam string mode A valid send mode.
-- @see SEND_MODES
-- @usage
--server:setSendMode("unreliable")
--server:sendToAll("playerState", {...})
function SockServer:setSendMode(mode)
    if not isValidSendMode(mode) then
        self:log("warning", "Tried to use invalid send mode: '" .. mode .. "'. Defaulting to reliable.")
        mode = "reliable"
    end

    self.sendMode = mode
end

--- Set the default send mode for all future outgoing messages.
-- The initial default is "reliable".
-- @tparam string mode A valid send mode.
-- @see SEND_MODES
function SockServer:setDefaultSendMode(mode)
    if not isValidSendMode(mode) then
        self:log("error", "Tried to set default send mode to invalid mode: '" .. mode .. "'")
        error("Tried to set default send mode to invalid mode: '" .. mode .. "'")
    end

    self.defaultSendMode = mode
end

--- Set the send channel for the next outgoing message.
-- The channel will be reset after the next message. Channels are zero-indexed
-- and cannot exceed the maximum number of channels allocated. The initial
-- default is 0.
-- @tparam number channel Channel to send data on.
-- @usage
--server:setSendChannel(2) -- the third channel
--server:sendToAll("importantEvent", "The message")
function SockServer:setSendChannel(channel)
    if channel > (self.maxChannels - 1) then
        self:log("warning",
            "Tried to use invalid channel: " .. channel .. " (max is " .. self.maxChannels - 1 .. "). Defaulting to 0.")
        channel = 0
    end

    self.sendChannel = channel
end

--- Set the default send channel for all future outgoing messages.
-- The initial default is 0.
-- @tparam number channel Channel to send data on.
function SockServer:setDefaultSendChannel(channel)
    self.defaultSendChannel = channel
end

--- Set the data schema for an event.
--
-- Schemas allow you to set a specific format that the data will be sent. If the
-- client and server both know the format ahead of time, then the table keys
-- do not have to be sent across the network, which saves bandwidth.
-- @tparam string event The event to set the data schema for.
-- @tparam {string,...} schema The data schema.
-- @usage
-- server = sock.newServer(...)
-- client = sock.newClient(...)
--
-- -- Without schemas
-- client:send("update", {
--     x = 4,
--     y = 100,
--     vx = -4.5,
--     vy = 23.1,
--     rotation = 1.4365,
-- })
-- server:on("update", function(data, client)
--     -- data = {
--     --    x = 4,
--     --    y = 100,
--     --    vx = -4.5,
--     --    vy = 23.1,
--     --    rotation = 1.4365,
--     -- }
-- end)
--
--
-- -- With schemas
-- server:setSchema("update", {
--     "x",
--     "y",
--     "vx",
--     "vy",
--     "rotation",
-- })
-- -- client no longer has to send the keys, saving bandwidth
-- client:send("update", {
--     4,
--     100,
--     -4.5,
--     23.1,
--     1.4365,
-- })
-- server:on("update", function(data, client)
--     -- data = {
--     --    x = 4,
--     --    y = 100,
--     --    vx = -4.5,
--     --    vy = 23.1,
--     --    rotation = 1.4365,
--     -- }
-- end)
function SockServer:setSchema(event, schema)
    return self.listener:setSchema(event, schema)
end

--- Set the incoming and outgoing bandwidth limits.
-- @tparam number incoming The maximum incoming bandwidth in bytes.
-- @tparam number outgoing The maximum outgoing bandwidth in bytes.
function SockServer:setBandwidthLimit(incoming, outgoing)
    return self.host:bandwidth_limit(incoming, outgoing)
end

--- Set the maximum number of channels.
-- @tparam number limit The maximum number of channels allowed. If it is 0,
-- then the maximum number of channels available on the system will be used.
function SockServer:setMaxChannels(limit)
    self.host:channel_limit(limit)
end

--- Set the timeout to wait for packets.
-- @tparam number timeout Time to wait for incoming packets in milliseconds. The
-- initial default is 0.
function SockServer:setMessageTimeout(timeout)
    self.messageTimeout = timeout
end

--- Set the serialization functions for sending and receiving data.
-- Both the client and server must share the same serialization method.
-- @tparam function serialize The serialization function to use.
-- @tparam function deserialize The deserialization function to use.
-- @usage
--bitser = require "bitser" -- or any library you like
--server = sock.newServer("localhost", 1337)
--server:setSerialization(bitser.dumps, bitser.loads)
function SockServer:setSerialization(serialize, deserialize)
    assert(type(serialize) == "function", "Serialize must be a function, got: '" .. type(serialize) .. "'")
    assert(type(deserialize) == "function", "Deserialize must be a function, got: '" .. type(deserialize) .. "'")
    self.serialize   = serialize
    self.deserialize = deserialize
end

--- Gets the Client object associated with an enet peer.
-- @tparam peer peer An enet peer.
-- @treturn Client Object associated with the peer.
function SockServer:getClient(peer)
    for _, client in pairs(self.clients) do
        if peer == client.connection then
            return client
        end
    end
end

--- Gets the Client object that has the given connection id.
-- @tparam number connectId The unique client connection id.
-- @treturn Client
function SockServer:getClientByConnectId(connectId)
    for _, client in pairs(self.clients) do
        if connectId == client.connectId then
            return client
        end
    end
end

--- Get the Client object that has the given peer index.
-- @treturn Client
function SockServer:getClientByIndex(index)
    for _, client in pairs(self.clients) do
        if index == client:getIndex() then
            return client
        end
    end
end

--- Get the enet_peer that has the given index.
-- @treturn enet_peer The underlying enet peer object.
function SockServer:getPeerByIndex(index)
    return self.host:get_peer(index)
end

--- Get the total sent data since the server was created.
-- @treturn number The total sent data in bytes.
function SockServer:getTotalSentData()
    return self.host:total_sent_data()
end

--- Get the total received data since the server was created.
-- @treturn number The total received data in bytes.
function SockServer:getTotalReceivedData()
    return self.host:total_received_data()
end

--- Get the total number of packets (messages) sent since the server was created.
-- Everytime a message is sent or received, the corresponding figure is incremented.
-- Therefore, this is not necessarily an accurate indicator of how many packets were actually
-- exchanged over the network.
-- @treturn number The total number of sent packets.
function SockServer:getTotalSentPackets()
    return self.packetsSent
end

--- Get the total number of packets (messages) received since the server was created.
-- @treturn number The total number of received packets.
-- @see SockServer:getTotalSentPackets
function SockServer:getTotalReceivedPackets()
    return self.packetsReceived
end

--- Get the last time when network events were serviced.
-- @treturn number Timestamp of the last time events were serviced.
function SockServer:getLastServiceTime()
    return self.host:service_time()
end

--- Get the number of allocated slots for peers.
-- @treturn number Number of allocated slots.
function SockServer:getMaxPeers()
    return self.maxPeers
end

--- Get the number of allocated channels.
-- Channels are zero-indexed, e.g. 16 channels allocated means that the
-- maximum channel that can be used is 15.
-- @treturn number Number of allocated channels.
function SockServer:getMaxChannels()
    return self.maxChannels
end

--- Get the timeout for packets.
-- @treturn number Time to wait for incoming packets in milliseconds.
-- initial default is 0.
function SockServer:getMessageTimeout()
    return self.messageTimeout
end

--- Get the socket address of the host.
-- @treturn string A description of the socket address, in the format
-- "A.B.C.D:port" where A.B.C.D is the IP address of the used socket.
function SockServer:getSocketAddress()
    return self.host:get_socket_address()
end

--- Get the current send mode.
-- @treturn string
-- @see SEND_MODES
function SockServer:getSendMode()
    return self.sendMode
end

--- Get the default send mode.
-- @treturn string
-- @see SEND_MODES
function SockServer:getDefaultSendMode()
    return self.defaultSendMode
end

--- Get the IP address or hostname that the server was created with.
-- @treturn string
function SockServer:getAddress()
    return self.address
end

--- Get the port that the server is hosted on.
-- @treturn number
function SockServer:getPort()
    return self.port
end

--- Get the table of Clients actively connected to the server.
-- @return {Client,...}
function SockServer:getClients()
    return self.clients
end

--- Get the number of Clients that are currently connected to the server.
-- @treturn number The number of active clients.
function SockServer:getClientCount()
    return #self.clients
end

function SockServer:getRoundTripTime()
    return 0
end

function SockServer:new()
    ---@class SockServer
    local sockServer = setmetatable(self, SockServer)

    return sockServer
end

return SockServer
