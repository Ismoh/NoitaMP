local SockClient = {}

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

--- All of the possible connection statuses for a client connection.
-- @see SockClient:getState
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

function SockClient:establishClient(serverOrAddress, port)
    serverOrAddress = serverOrAddress or self.address
    port            = port or self.port

    -- Two different forms for client creation:
    -- 1. Pass in (address, port) and connect to that.
    -- 2. Pass in (enet peer) and set that as the existing connection.
    -- The first would be the common usage for regular client code, while the
    -- latter is mostly used for creating clients in the server-side code.

    -- First form: (address, port)
    if port ~= nil and type(port) == "number" and serverOrAddress ~= nil and type(serverOrAddress) == "string" then
        self.address = serverOrAddress
        self.port    = port
        self.host    = enet.host_create()

        -- Second form: (enet peer)
    elseif type(serverOrAddress) == "userdata" then
        self.connection = serverOrAddress
        self.connectId  = self.connection:connect_id()
    end

    -- Serialization is set in Client.setConfigSettings()
    --if bitserLoaded then
    --    self:setSerialization(bitser.dumps, bitser.loads)
    --end
    --self:setSerialization(zstandard.compress, zstandard.decompress)
end

--- Check for network events and handle them.
function SockClient:update()
    local event = self.host:service(self.messageTimeout)

    while event do
        if event.type == "connect" then
            self:_activateTriggers("connect", event.data)
            self:log(event.type, "Connected to " .. tostring(self.connection))
        elseif event.type == "receive" then
            local eventName, data = self:__unpack(event.data)

            self:_activateTriggers(eventName, data)
            self:log(eventName, data)
        elseif event.type == "disconnect" then
            self:_activateTriggers("disconnect", event.data)
            self:log(event.type, "Disconnected from " .. tostring(self.connection))
        else
            self:log(event.type,
                ("event = %s, type = %s, data = %s, peer = %s"):format(event, event.type, event.data, event.peer))
        end

        event = self.host:service(self.messageTimeout)
    end
end

--- Connect to the chosen server.
-- Connection will not actually occur until the next time `SockClient:update` is called.
-- @tparam ?number code A number that can be associated with the connect event.
function SockClient:connect(code)
    if not self.host then
        self:establishClient()
    end

    -- number of channels for the client and server must match
    self.connection = self.host:connect(self.address .. ":" .. self.port, self.maxChannels, code)
    _G.Logger.info(_G.Logger.channels.network, "Connecting to " .. self.address .. ":" .. self.port)
    self.connectId = self.connection:connect_id()
end

--- Disconnect from the server, if connected. The client will disconnect the
-- next time that network messages are sent.
-- @tparam ?number code A code to associate with this disconnect event.
-- @todo Pass the code into the disconnect callback on the server
function SockClient:disconnect(code)
    code = code or 0
    self.connection:disconnect(code)
end

--- Disconnect from the server, if connected. The client will disconnect after
-- sending all queued packets.
-- @tparam ?number code A code to associate with this disconnect event.
-- @todo Pass the code into the disconnect callback on the server
function SockClient:disconnectLater(code)
    code = code or 0
    self.connection:disconnect_later(code)
end

--- Disconnect from the server, if connected. The client will disconnect immediately.
-- @tparam ?number code A code to associate with this disconnect event.
-- @todo Pass the code into the disconnect callback on the server
function SockClient:disconnectNow(code)
    code = code or 0
    self.connection:disconnect_now(code)
end

--- Forcefully disconnects the client. The server is not notified of the disconnection.
-- @tparam Client client The client to reset.
function SockClient:reset()
    if self.connection then
        self.connection:reset()
    end
end

-- Creates the unserialized message that will be used in callbacks
-- In: serialized message (string)
-- Out: event (string), data (mixed)
function SockClient:__unpack(data)
    if not self.deserialize then
        self:log("error", "Can't deserialize message: deserialize was not set")
        error("Can't deserialize message: deserialize was not set")
    end

    local message         = self.deserialize(data)
    local eventName, data = message[1], message[2]
    return eventName, data
end

-- Creates the serialized message that will be sent over the network
-- In: event (string), data (mixed)
-- Out: serialized message (string)
function SockClient:__pack(event, data)
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

--- Send a message to the server.
-- @tparam string event The event to trigger with this message.
-- @param data The data to send.
function SockClient:send(event, data)
    local networkMessageId = data[1] or data.networkMessageId
    if Utils.IsEmpty(networkMessageId) then
        error("networkMessageId is empty!", 3)
    end

    local serializedMessage = self:__pack(event, data)
    self.connection:send(serializedMessage, self.sendChannel, self.sendMode)
    self.packetsSent = self.packetsSent + 1
    self:resetSendSettings()

    return networkMessageId
end

--- Add a callback to an event.
-- @tparam string event The event that will trigger the callback.
-- @tparam function callback The callback to be triggered.
-- @treturn function The callback that was passed in.
--@usage
--client:on("connect", function(data)
--    print("Connected to the server!")
--end)
function SockClient:on(event, callback)
    return self.listener:addCallback(event, callback)
end

function SockClient:_activateTriggers(event, data)
    local result         = self.listener:trigger(event, data)

    self.packetsReceived = self.packetsReceived + 1

    if not result then
        self:log("warning", "Client tried to activate trigger: '" .. tostring(event) .. "' but it does not exist.")
    end
end

--- Remove a specific callback for an event.
-- @tparam function callback The callback to remove.
-- @treturn boolean Whether or not the callback was removed.
--@usage
--local callback = client:on("chatMessage", function(message)
--    print(message)
--end)
--client:removeCallback(callback)
function SockClient:removeCallback(callback)
    return self.listener:removeCallback(callback)
end

--- Log an event.
-- Alias for Client.logger:log.
-- @tparam string event The type of event that happened.
-- @tparam string data The message to log.
--@usage
--if somethingBadHappened then
--    client:log("error", "Something bad happened!")
--end
function SockClient:log(event, data)
    return self.logger:log(event, data)
end

--- Reset all send options to their default values.
function SockClient:resetSendSettings()
    self.sendMode    = self.defaultSendMode
    self.sendChannel = self.defaultSendChannel
end

--- Enables an adaptive order-2 PPM range coder for the transmitted data of all peers. Both the client and server must both either have compression enabled or disabled.
--
-- Note: lua-enet does not currently expose a way to disable the compression after it has been enabled.
function SockClient:enableCompression()
    return self.host:compress_with_range_coder()
end

--- Set the send mode for the next outgoing message.
-- The mode will be reset after the next message is sent. The initial default
-- is "reliable".
-- @tparam string mode A valid send mode.
-- @see SEND_MODES
-- @usage
--client:setSendMode("unreliable")
--client:send("position", {...})
function SockClient:setSendMode(mode)
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
function SockClient:setDefaultSendMode(mode)
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
--client:setSendChannel(2) -- the third channel
--client:send("important", "The message")
function SockClient:setSendChannel(channel)
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
function SockClient:setDefaultSendChannel(channel)
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
-- server:send("update", {
--     x = 4,
--     y = 100,
--     vx = -4.5,
--     vy = 23.1,
--     rotation = 1.4365,
-- })
-- client:on("update", function(data)
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
-- client:setSchema("update", {
--     "x",
--     "y",
--     "vx",
--     "vy",
--     "rotation",
-- })
-- -- client no longer has to send the keys, saving bandwidth
-- server:send("update", {
--     4,
--     100,
--     -4.5,
--     23.1,
--     1.4365,
-- })
-- client:on("update", function(data)
--     -- data = {
--     --    x = 4,
--     --    y = 100,
--     --    vx = -4.5,
--     --    vy = 23.1,
--     --    rotation = 1.4365,
--     -- }
-- end)
function SockClient:setSchema(event, schema)
    return self.listener:setSchema(event, schema)
end

--- Set the maximum number of channels.
-- @tparam number limit The maximum number of channels allowed. If it is 0,
-- then the maximum number of channels available on the system will be used.
function SockClient:setMaxChannels(limit)
    self.host:channel_limit(limit)
end

--- Set the timeout to wait for packets.
-- @tparam number timeout Time to wait for incoming packets in milliseconds. The initial
-- default is 0.
function SockClient:setMessageTimeout(timeout)
    self.messageTimeout = timeout
end

--- Set the incoming and outgoing bandwidth limits.
-- @tparam number incoming The maximum incoming bandwidth in bytes.
-- @tparam number outgoing The maximum outgoing bandwidth in bytes.
function SockClient:setBandwidthLimit(incoming, outgoing)
    return self.host:bandwidth_limit(incoming, outgoing)
end

--- Set how frequently to ping the server.
-- The round trip time is updated each time a ping is sent. The initial
-- default is 500ms.
-- @tparam number interval The interval, in milliseconds.
function SockClient:setPingInterval(interval)
    if self.connection then
        self.connection:ping_interval(interval)
    end
end

--- Change the probability at which unreliable packets should not be dropped.
-- @tparam number interval Interval, in milliseconds, over which to measure lowest mean RTT. (default: 5000ms)
-- @tparam number acceleration Rate at which to increase the throttle probability as mean RTT declines. (default: 2)
-- @tparam number deceleration Rate at which to decrease the throttle probability as mean RTT increases.
function SockClient:setThrottle(interval, acceleration, deceleration)
    interval     = interval or 5000
    acceleration = acceleration or 2
    deceleration = deceleration or 2
    if self.connection then
        self.connection:throttle_configure(interval, acceleration, deceleration)
    end
end

--- Set the parameters for attempting to reconnect if a timeout is detected.
-- @tparam ?number limit A factor that is multiplied with a value that based on the average round trip time to compute the timeout limit. (default: 32)
-- @tparam ?number minimum Timeout value in milliseconds that a reliable packet has to be acknowledged if the variable timeout limit was exceeded. (default: 5000)
-- @tparam ?number maximum Fixed timeout in milliseconds for which any packet has to be acknowledged.
function SockClient:setTimeout(limit, minimum, maximum)
    limit   = limit or 32
    minimum = minimum or 5000
    maximum = maximum or 30000
    if self.connection then
        self.connection:timeout(limit, minimum, maximum)
    end
end

--- Set the serialization functions for sending and receiving data.
-- Both the client and server must share the same serialization method.
-- @tparam function serialize The serialization function to use.
-- @tparam function deserialize The deserialization function to use.
-- @usage
--bitser = require "bitser" -- or any library you like
--client = sock.newClient("localhost", 1337)
--client:setSerialization(bitser.dumps, bitser.loads)
function SockClient:setSerialization(serialize, deserialize)
    assert(type(serialize) == "function", "Serialize must be a function, got: '" .. type(serialize) .. "'")
    assert(type(deserialize) == "function", "Deserialize must be a function, got: '" .. type(deserialize) .. "'")
    self.serialize   = serialize
    self.deserialize = deserialize
end

--- Gets whether the client is connected to the server.
-- @treturn boolean Whether the client is connected to the server.
-- @usage
-- client:connect()
-- client:isConnected() -- false
-- -- After a few client updates
-- client:isConnected() -- true
function SockClient:isConnected()
    return self.connection ~= nil and self:getState() == "connected"
end

--- Gets whether the client is disconnected from the server.
-- @treturn boolean Whether the client is connected to the server.
-- @usage
-- client:disconnect()
-- client:isDisconnected() -- false
-- -- After a few client updates
-- client:isDisconnected() -- true
function SockClient:isDisconnected()
    return self.connection ~= nil and self:getState() == "disconnected"
end

--- Gets whether the client is connecting to the server.
-- @treturn boolean Whether the client is connected to the server.
-- @usage
-- client:connect()
-- client:isConnecting() -- true
-- -- After a few client updates
-- client:isConnecting() -- false
-- client:isConnected() -- true
function SockClient:isConnecting()
    local inConnectingState = false
    for _, state in ipairs(sock.CONNECTING_STATES) do
        if state == self:getState() then
            inConnectingState = true
            break
        end
    end
    return self.connection ~= nil and inConnectingState
end

--- Gets whether the client is disconnecting from the server.
-- @treturn boolean Whether the client is connected to the server.
-- @usage
-- client:disconnect()
-- client:isDisconnecting() -- true
-- -- After a few client updates
-- client:isDisconnecting() -- false
-- client:isDisconnected() -- true
function SockClient:isDisconnecting()
    local inDisconnectingState = false
    for _, state in ipairs(sock.DISCONNECTING_STATES) do
        if state == self:getState() then
            inDisconnectingState = true
            break
        end
    end
    return self.connection ~= nil and inDisconnectingState
end

--- Get the total sent data since the server was created.
-- @treturn number The total sent data in bytes.
function SockClient:getTotalSentData()
    return self.host:total_sent_data()
end

--- Get the total received data since the server was created.
-- @treturn number The total received data in bytes.
function SockClient:getTotalReceivedData()
    return self.host:total_received_data()
end

--- Get the total number of packets (messages) sent since the client was created.
-- Everytime a message is sent or received, the corresponding figure is incremented.
-- Therefore, this is not necessarily an accurate indicator of how many packets were actually
-- exchanged over the network.
-- @treturn number The total number of sent packets.
function SockClient:getTotalSentPackets()
    return self.packetsSent
end

--- Get the total number of packets (messages) received since the client was created.
-- @treturn number The total number of received packets.
-- @see SockClient:getTotalSentPackets
function SockClient:getTotalReceivedPackets()
    return self.packetsReceived
end

--- Get the last time when network events were serviced.
-- @treturn number Timestamp of the last time events were serviced.
function SockClient:getLastServiceTime()
    return self.host:service_time()
end

--- Get the number of allocated channels.
-- Channels are zero-indexed, e.g. 16 channels allocated means that the
-- maximum channel that can be used is 15.
-- @treturn number Number of allocated channels.
function SockClient:getMaxChannels()
    return self.maxChannels
end

--- Get the timeout for packets.
-- @treturn number Time to wait for incoming packets in milliseconds.
-- initial default is 0.
function SockClient:getMessageTimeout()
    return self.messageTimeout
end

--- Return the round trip time (RTT, or ping) to the server, if connected.
-- It can take a few seconds for the time to approach an accurate value.
-- @treturn number The round trip time.
function SockClient:getRoundTripTime()
    if self.connection then
        return self.connection:round_trip_time()
    end
    return 9999
end

--- Get the unique connection id, if connected.
-- @treturn number The connection id.
function SockClient:getConnectId()
    if self.connection then
        return self.connection:connect_id()
    end
end

--- Get the current connection state, if connected.
-- @treturn string The connection state.
-- @see CONNECTION_STATES
function SockClient:getState()
    if self.connection then
        return self.connection:state()
    end
end

--- Get the index of the enet peer. All peers of an ENet host are kept in an array. This function finds and returns the index of the peer of its host structure.
-- @treturn number The index of the peer.
function SockClient:getIndex()
    if self.connection then
        return self.connection:index()
    end
end

--- Get the socket address of the host.
-- @treturn string A description of the socket address, in the format "A.B.C.D:port" where A.B.C.D is the IP address of the used socket.
function SockClient:getSocketAddress()
    return self.host:get_socket_address()
end

--- Get the enet_peer that has the given index.
-- @treturn enet_peer The underlying enet peer object.
function SockClient:getPeerByIndex(index)
    return self.host:get_peer(index)
end

--- Get the current send mode.
-- @treturn string
-- @see SEND_MODES
function SockClient:getSendMode()
    return self.sendMode
end

--- Get the default send mode.
-- @treturn string
-- @see SEND_MODES
function SockClient:getDefaultSendMode()
    return self.defaultSendMode
end

--- Get the IP address or hostname that the client was created with.
-- @treturn string
function SockClient:getAddress()
    return self.address
end

--- Get the port that the client is connecting to.
-- @treturn number
function SockClient:getPort()
    return self.port
end

--- Creates a new Client instance.
-- @tparam ?string/peer serverOrAddress Usually the IP address or hostname to connect to. It can also be an enet peer. (default: "localhost")
-- @tparam ?number port Port number of the server to connect to. (default: 1337)
-- @tparam ?number maxChannels Maximum channels available to send and receive data. (default: 1)
-- @return A new Client object.
-- @see Client
-- @within sock
-- @usage
--local sock = require "sock"
--
-- -- Client that will connect to localhost:1337 (by default)
--client = sock.newClient()
--
-- -- Client that will connect to localhost:1234
--client = sock.newClient("localhost", 1234)
--
-- -- Client that will connect to 123.45.67.89:1234, using two channels
-- -- NOTE: Server must also allocate two channels!
--client = sock.newClient("123.45.67.89", 1234, 2)
---Creates a new Client instance.
---@param address string|nil The IP address or hostname to connect to. Default: "localhost" Available: "localhost", "*", "xxx.xxx.xxx.xxx" or nil
---@param port number|nil The port to listen to for data. Default: 14017
---@param maxChannels number|nil
---@return SockClient client
function SockClient.new(address, port, maxChannels)
    address         = address or "localhost"
    port            = port or 14017
    maxChannels     = maxChannels or 1

    ---@class SockClient
    local sockClient = setmetatable({
        address            = nil,
        port               = nil,
        host               = nil,

        connection         = nil, -- aka peer
        connectId          = nil,

        messageTimeout     = 0,
        maxChannels        = maxChannels,
        sendMode           = "reliable",
        defaultSendMode    = "reliable",
        sendChannel        = 0,
        defaultSendChannel = 0,

        listener           = require("SockListener"):newListener(),--newListener(),
        --logger             = newLogger("CLIENT"),

        serialize          = nil,
        deserialize        = nil,

        packetsReceived    = 0,
        packetsSent        = 0,

    }, SockClient)

    sockClient.zipTable = require("NetworkUtils").zipTable

    -- -- Two different forms for client creation:
    -- -- 1. Pass in (address, port) and connect to that.
    -- -- 2. Pass in (enet peer) and set that as the existing connection.
    -- -- The first would be the common usage for regular client code, while the
    -- -- latter is mostly used for creating clients in the server-side code.

    -- -- First form: (address, port)
    -- if port ~= nil and type(port) == "number" and serverOrAddress ~= nil and type(serverOrAddress) == "string" then
    --     client.address = serverOrAddress
    --     client.port = port
    --     client.host = enet.host_create()

    --     -- Second form: (enet peer)
    -- elseif type(serverOrAddress) == "userdata" then
    --     client.connection = serverOrAddress
    --     client.connectId = client.connection:connect_id()
    -- end

    -- if bitserLoaded then
    --     client:setSerialization(bitser.dumps, bitser.loads)
    -- end

    return sockClient
end

return SockClient
