-- FYI:
-- no require available
-- no args available

print("Extending Component Explorer..")

local entity_list = dofile_once("mods/component-explorer/entity_list.lua")

local nuidColumn = {
    name = "NUID",
    func = function(entity_id)
        local compIds = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
        if not compIds then
            return ""
        end
        for i = 1, #compIds do
            local compName = ComponentGetValue2(compIds[i], "name")
            if compName == "noita-mp.nc_nuid" then
                return ComponentGetValue2(compIds[i], "value_int")
            end
        end
        return ""
    end
}
table.insert(entity_list.extra_columns, nuidColumn)
