
require "enet"

local host = enet.host_create()
local server = host:connect("localhost:7890", 2)

local done = false
while not done do
	local event = host:service(100)
	if event then
		if event.type == "connect" then
			server:send("wally world", 0)
			server:send("nut house", 1)
		elseif event.type == "receive" then
			print(event.type, event.data)
			done = true
		end
	end
end

server:disconnect()
host:flush()

print "done"
