
require "enet"

local channel_responders = {
	[0] = function(event)
		print("doing nothing")
	end,
	[1] = function(event)
		print("sending back...")
		event.peer:send(event.data, event.channel)
	end
}

local host = enet.host_create("localhost:7890", nil, 2)

while true do
	local event = host:service(100)
	if event then
		if event.type == "receive" then
			print("receive, channel:", event.channel)
			channel_responders[event.channel](event)
		else
			print(event.type, event.peer)
		end
	end
end

