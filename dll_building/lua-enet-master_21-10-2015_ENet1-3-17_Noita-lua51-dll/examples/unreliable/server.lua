require "enet"

local host = enet.host_create("localhost:6789", nil, 2)

while true do
	local event = host:service(100)
	if event and event.type == "connect" then
		event.peer:send("hello world")
		for i = 0, 100 do
			event.peer:send(tostring(i), 1, "unreliable")
		end
	end
end
