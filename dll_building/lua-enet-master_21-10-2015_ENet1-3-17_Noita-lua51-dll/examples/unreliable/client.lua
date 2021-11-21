
require "enet"

local host = enet.host_create()
local server = host:connect("localhost:6789", 2)

local done = false
while not done do
	local event = host:service(200)
	if event then
		if event.type == "receive" then
			print(event.channel, event.data)
		end
	end
end

server:disconnect()
host:flush()

print "done"

