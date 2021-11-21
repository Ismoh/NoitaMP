require "enet"

local host = enet.host_create"localhost:5678"

while true do
	local event = host:service(100)
	if event then 
		if event.type == "receive" then
			print("Got message: ",  event.data, event.peer)
			event.peer:send("howdy back at ya")
		elseif event.type == "connect" then
			print("Connect:", event.peer)
			host:broadcast("new client connected")
		else
			print("Got event", event.type, event.peer)
		end

	end
end