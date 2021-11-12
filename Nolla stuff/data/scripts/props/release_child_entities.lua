dofile_once("data/scripts/lib/utilities.lua")


function physics_body_modified( is_destroyed )
	local entity_id = GetUpdatedEntityID()
	
	local children = EntityGetAllChildren(entity_id)
	if not children then return end
	
	-- release all child entities as to independent entities
	for k,child in pairs(children) do
		-- attach child to new parent
		local x,y = EntityGetTransform(child)
		local parent = EntityLoad("data/entities/misc/dummy_entity.xml", x, y)
		EntityRemoveFromParent(child)
		EntityAddChild( parent, child)
	end
end
