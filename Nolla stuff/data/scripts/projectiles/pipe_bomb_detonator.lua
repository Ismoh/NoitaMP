local pipe_bombs = EntityGetWithTag( "pipe_bomb" )
if( #pipe_bombs > 0 ) then
	for i,v in ipairs(pipe_bombs) do
		EntityKill(v)
	end
end

-- kill this...
local entity_id = GetUpdatedEntityID()
EntityKill(entity_id)