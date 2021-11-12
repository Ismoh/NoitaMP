dofile_once( "data/scripts/lib/utilities.lua" )

-- ensure fx are not left running in case game was closed while the machine was active
local entity = GetUpdatedEntityID()
EntitySetComponentsWithTagEnabled( entity, "fx", false )
EntityRemoveTag( entity, "fish_attractor" )