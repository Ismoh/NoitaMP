dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local x, y = EntityGetTransform( GetUpdatedEntityID() )
local radius = 96

local status = 0
local scomp = 0

local s = EntityGetComponent( entity_id, "VariableStorageComponent" )
if ( s ~= nil ) then
	for i,v in ipairs( s ) do
		local name = ComponentGetValue2( v, "name" )
		
		if ( name == "music_machine" ) then
			status = ComponentGetValue2( v, "value_int" )
			scomp = v
		end
	end
end

local targets = EntityGetInRadiusWithTag( x, y, radius, "musicmachine" )
local mm = { "musicmachine1", "musicmachine2", "musicmachine3", "musicmachine4" }

for i,v in ipairs( targets ) do
	local tags = EntityGetTags( v )
	local mm_id = 0
	local mm_flag = ""
	
	if ( tags ~= nil ) then
		for a,b in ipairs( mm ) do
			if ( string.find( tags, b ) ~= nil ) then
				mm_id = a
				mm_flag = b
				break
			end
		end
		
		if ( mm_id > 0 ) then
			if GameHasFlagRun( mm_flag ) and ( GameHasFlagRun( mm_flag .. "_done" ) == false ) then
				GameAddFlagRun( mm_flag .. "_done" )
				status = status + 1
				
				local desc_text = "$itemdesc_alchemy_key_musicbox_" .. tostring( math.min( math.max( status, 1 ), 4 ) )
				
				edit_component( entity_id, "ItemComponent", function(comp,vars)
					ComponentSetValue2( comp, "ui_description", desc_text )
				end)
				
				if ( status < 4 ) then
					EntityLoadToEntity( "data/entities/animals/boss_alchemist/key_particles_first_alt.xml", entity_id )
					GamePrintImportant( "$log_alchemist_key_alt_first", "$logdesc_alchemist_key_alt_first" )
				else
					EntityLoadToEntity( "data/entities/animals/boss_alchemist/key_particles_second_alt.xml", entity_id )
					GamePrintImportant( "$log_alchemist_key_alt_second", "$logdesc_alchemist_key_alt_second" )
				end
			end
		end
	end
end

if ( scomp ~= nil ) and ( scomp ~= 0 ) then
	ComponentSetValue2( scomp, "value_int", status )
end