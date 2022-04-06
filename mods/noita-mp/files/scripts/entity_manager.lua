local util = require("util")
local NetworkComponent = require("network_component_class")
local json = require("json")

local em = {
    nuid_counter = 0,
    cache = {
        all_entity_ids = {},
        nc_entity_ids = {} -- nc_entity_ids[entity_id] = { component_id, nuid }
    },
    --co_add_network_components = nil,
    --------------------------------
    --- Sets the VariableStorageComponent value with serialised nc (NetworkComponent)
    ---@param component_id number Noitas component_id for this network component
    ---@param nc table NetworkComponent
    setComponentValue = function(component_id, nc)
        -- local nc_serialisable = NetworkComponent.toSerialisableTable(nc)
        local nc_as_json = tostring(json.encode(NetworkComponent.toSerialisableTable(nc)))
        ComponentSetValue2(component_id, NetworkComponent.field_name, nc_as_json)
    end
}

--- Simply generates a new NUID by increasing by 1
--- @return integer nuid
function em:GetNextNuid()
    self.nuid_counter = self.nuid_counter + 1
    return self.nuid_counter
end

function em:AddNetworkComponentsResumeCoroutine()
    -- if not self.co_add_network_components then
    --     self.co_add_network_components = coroutine.create(self.AddNetworkComponentsCoroutine)
    -- end

    -- local status, result = coroutine.status(self.co_add_network_components)

    -- if status == "dead" then
    --     -- re-set the coroutine if status is dead otherwise new spawned entities won't be handled
    --     self.co_add_network_components = coroutine.create(self.AddNetworkComponentsCoroutine)
    --     -- refresh status
    --     status, result = coroutine.status(self.co_add_network_components)
    -- end

    -- if status ~= "dead" and status == "suspended" then
    --     local success, resume_result, third = coroutine.resume(self.co_add_network_components)
    --     if not success then
    --         error(("Coroutine failed: %s. %s").format(resume_result, third), 2)
    --     end
    -- end

    -- status, result = coroutine.status(self.co_add_network_components)
    em.AddNetworkComponentsCoroutine()
end

--- Checks for entities (only for his own - locally) in a specific range/radius to the player_units.
--- If there are entities in this radius, a NetworkComponent will be added as a VariableStorageComponent.
--- If entities does not have VelocityComponents, those will be ignored.
--- Every checked entity will be put into a cache list, to stop iterating over the same entities again and again.
function em.AddNetworkComponentsCoroutine()
    local player_unit_ids = EntityGetWithTag("player_unit")
    for i_p = 1, #player_unit_ids do
        -- get all player units
        local x, y, rot, scale_x, scale_y = EntityGetTransform(player_unit_ids[i_p])

        -- find all entities in a specific radius based on the player units position
        local entity_ids = EntityGetInRadius(x, y, 100)

        for i_e = 1, #entity_ids do
            local entity_id = entity_ids[i_e]
            local filename = EntityGetFilename(entity_id)

            if not em.cache.all_entity_ids[entity_id] then -- if entity was already checked, skip it
                -- loop all components of the entity
                local component_ids = EntityGetAllComponents(entity_id)

                local has_velocity_component = false
                if component_ids then
                    for i_c = 1, #component_ids do
                        local component_id = component_ids[i_c]

                        -- search for VelocityComponent
                        local component_name = ComponentGetTypeName(component_id)
                        if component_name == "VelocityComponent" then
                            has_velocity_component = true
                            local velo_x, velo_y = ComponentGetValue2(component_id, "mVelocity")
                            local velocity = {velo_x, velo_y}

                            local variable_storage_component_ids =
                                EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}

                            local has_network_component = false
                            for i_v = 1, #variable_storage_component_ids do
                                local variable_storage_component_id = variable_storage_component_ids[i_v]
                                -- check if the entity already has a VariableStorageComponent
                                local variable_storage_component_name =
                                    ComponentGetValue2(variable_storage_component_id, "name") or nil
                                if variable_storage_component_name == NetworkComponent.name then
                                    -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
                                    has_network_component = true
                                end
                            end

                            if has_network_component == false then
                                local owner = util.getLocalOwner()
                                local nuid = nil
                                local x_e, y_e, rot_e = EntityGetTransform(entity_id)

                                if _G.Server:amIServer() then
                                    nuid = em:GetNextNuid()

                                    _G.Server:sendNewNuid(owner, entity_id, nuid, x_e, y_e, rot_e, velocity, filename)
                                else
                                    _G.Client:sendNeedNuid(owner, entity_id, velocity)
                                end
                                -- if the VariableStorageComponent is not a 'network_component_class', then add one
                                em:AddNetworkComponentToEntity(entity_id, util.getLocalOwner(), nuid)
                                logger:debug(
                                    "AddNetworkComponent: owner=%s(%s), nuid=%s, local_entity_id=%s, component_id=%s",
                                    owner.username,
                                    owner.guid,
                                    nuid,
                                    entity_id,
                                    component_id
                                )
                            end
                        end
                    end
                end

                if has_velocity_component == false then
                    -- if the entity does not have a VelocityComponent, skip it always
                    -- logger:debug("Entity %s does not have a VelocityComponent. Ignore it.", entity_id)
                    em.cache.all_entity_ids[entity_id] = true
                end
            end
            --coroutine.yield(entity_id)
        end
    end
end

--- Adds a NetworkComponent to an entity, if it doesn't exist already.
--- @param entity_id number The entity id where to add the NetworkComponent.
--- @param owner table { username, guid }
--- @param nuid number nuid to know the entity wiht network component
--- @return number component_id Returns the component_id. The already existed one or the newly created id.
function em:AddNetworkComponentToEntity(entity_id, owner, nuid)
    local variable_storage_component_ids =
        EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}

    -- check if the entity already has a NetworkComponent. If so skip this function by returning the component_id
    for i_v = 1, #variable_storage_component_ids do
        local variable_storage_component_id = variable_storage_component_ids[i_v]
        local variable_storage_component_name = ComponentGetValue2(variable_storage_component_id, "name") or nil
        --local nc_serialised = ComponentGetValue2(variable_storage_component_id, NetworkComponent.field_name) or nil
        local nc_as_json = ComponentGetValue2(variable_storage_component_id, NetworkComponent.field_name) or nil
        local nc = nil

        if variable_storage_component_name == NetworkComponent.name then
            if not util.IsEmpty(nc_as_json) then
                nc = json.decode(nc_as_json)

                if nc.nuid == nuid then
                    -- if entity already has a VariableStorageComponent with the name of 'network_component_class', skip it
                    self.cache.nc_entity_ids[entity_id] = {
                        component_id = variable_storage_component_id,
                        nuid = nuid
                    }
                    self.cache.all_entity_ids[entity_id] = true
                    return variable_storage_component_id
                end
            end
        end
    end

    local component_id =
        EntityAddComponent2(
        entity_id,
        "VariableStorageComponent",
        {
            name = NetworkComponent.name,
            value_string = nil -- will be set after creation, because NetworkComponent has to be serialised
        }
    )
    logger:debug(
        "VariableStorageComponent (nuid=%s) added with noita component_id = %s to entity_id = %s!",
        nuid,
        component_id,
        entity_id
    )

    local nc = NetworkComponent:new(owner, nuid, entity_id, component_id)
    em.setComponentValue(component_id, nc)

    logger:debug(
        "Added network component (nuid=%s) to the VariableStorageComponent as a serialised string: component_id=%s to entity_id=%s!",
        nuid,
        component_id,
        entity_id
    )

    self.cache.nc_entity_ids[entity_id] = {
        component_id = component_id,
        nuid = nuid
    }
    self.cache.all_entity_ids[entity_id] = true

    util.debug_entity(entity_id)

    return component_id
end

function em:setNuid(owner, local_entity_id, nuid)
    local nc = self:GetNetworkComponent(owner, local_entity_id, nuid)

    if nc == util.IsEmpty(nc) then
        logger.error(
            ("Unable to set NUID, because unable to find Network Component. owner = %s(%s), local_entity_id = %s, nuid = %s"):format(
                owner.username,
                owner.guid,
                local_entity_id,
                nuid
            )
        )
        return
    end

    if nc.nuid ~= nil and nc.nuid ~= "nil" then
        logger:warning(
            "Nuid %s of entity %s was already set, although it's a local new one? It will be skipped!",
            nuid,
            local_entity_id
        )
        return
    end

    local owner_guid = owner.guid
    local nc_guid = nc.owner.guid

    if nc_guid ~= owner_guid then
        error(
            ("%s (%s) tries to set nuid %s of different nc.owners %s (%s) entity %s."):format(
                owner.username,
                owner.guid,
                nuid,
                nc.owner.username,
                nc.owner.guid,
                local_entity_id
            ),
            2
        )
    end

    nc.nuid = nuid
    em.setComponentValue(nc.component_id, nc)

    logger:debug("Set new nuid (%s) from %s (%s) to entity %s", nuid, owner.username, owner_guid, local_entity_id)
end

--- Spwans an entity and applies the transform and velocity to it. Also adds the network_component.
---@param owner table { username, guid }
---@param nuid any
---@param x any
---@param y any
---@param rot any
---@param velocity table {x, y} - can be nil
---@param filename any
---@param local_entity_id number this is the initial entity_id created by server OR client. It's owner specific! Every owner has its own entity ids.
---@return number entity_id Returns the entity_id of a already existing entity, found by nuid or the newly created entity.
function em:SpawnEntity(owner, nuid, x, y, rot, velocity, filename, local_entity_id)
    local local_guid = util.getLocalOwner().guid or util.getLocalOwner()[2]
    local owner_guid = owner.guid or owner[2]

    if local_guid == owner_guid then
        -- if the owner sent by network is the local owner, don't spawn an additional entity, but update the nuid
        self:setNuid(owner, local_entity_id, nuid)
        return
    end

    -- double check, if there is already an entity with this NUID and return the entity_id
    local nc = self:GetNetworkComponent(owner, local_entity_id, nuid)
    if nc then
        logger:warn(
            "There is already an entity(%s) with the set nuid(%s), therefore it won't be spawned/loaded again!",
            nc.local_entity_id,
            nuid
        )
        return nc.local_entity_id
    end

    local entity_id = EntityLoad(filename, x, y)

    self:AddNetworkComponentToEntity(entity_id, owner, nuid)
    EntityApplyTransform(entity_id, x, y, rot)

    local velo_comp_id = EntityGetFirstComponent(entity_id, "VelocityComponent")
    if velocity and velo_comp_id then
        ---@diagnostic disable-next-line: redundant-parameter
        ComponentSetValue2(velo_comp_id, "mVelocity", velocity[1], velocity[2])
    end
    return entity_id
end

function em:DespawnEntity(owner, local_entity_id, nuid, is_alive)
    local nc = self:GetNetworkComponent(owner, local_entity_id, nuid)
    local entity_id = local_entity_id

    if nc.local_entity_id ~= local_entity_id then
        -- update entity_id, because the owner of the entity is not the local owner and the local_entity_id is not the correct one
        entity_id = nc.local_entity_id
    end

    if not is_alive then
        -- might be that the entity already was killed locally
        local alive = EntityGetIsAlive(entity_id)
        if alive then
            EntityKill(entity_id)
            logger:debug("Killed entity %s!", entity_id)
        else
            logger:debug("Entity %s was already killed locally!", entity_id)
        end
    end
end

function em:UpdateEntities()
    for index, entity_id in ipairs(self.cache.nc_entity_ids) do
        --local owner = util.getLocalOwner()
        local nc = self:GetNetworkComponent(nil, entity_id, nil)
        local nuid = nc.nuid
        local owner = {
            username = nc.owner.username,
            guid = nc.owner.guid
        }

        if not EntityGetIsAlive(entity_id) then
            if _G.Server:amIServer() then
                _G.Server.super:sendToAll2("entityAlive", {owner, entity_id, nuid, false})
            else
                _G.Client.super:send("entityAlive", {owner, entity_id, nuid, false})
            end
        else
            local x, y, rot = EntityGetTransform(entity_id)
            local velo_comp_id = EntityGetFirstComponent(entity_id, "VelocityComponent")
            local velo_x, velo_y = ComponentGetValue2(velo_comp_id, "mVelocity")
            local velocity = {velo_x, velo_y}

            if _G.Server:amIServer() then
                _G.Server.super:sendToAll2("entityState", {owner, entity_id, nuid, x, y, rot, velocity, health})
            else
                _G.Client.super:send("entityState", {owner, entity_id, nuid, x, y, rot, velocity, health})
            end
        end
    end
end

--- Searching for a network component by "owner and entity_id"-search or by NUID-search
---@param owner table owner = { username = string|nil, guid = string|nil }
---@param entity_id number
---@param nuid number
---@return table nc NetworkComponent or nil, if there is no network component
function em:GetNetworkComponent(owner, entity_id, nuid)
    local nc = self:GetNetworkComponentByOwnerAndEntityId(owner, entity_id)

    if not nc then
        nc = self:GetNetworkComponentByNuid(nuid)
    end

    if not nc then
        logger:warn(
            "Unable to find network component: owner(%s, %s) entity_id(%s) nuid(%s)",
            owner.username,
            owner.guid,
            entity_id,
            nuid
        )
    end

    return nc
end

--- Returns the network component table of an entity depending of the owner rights.
---@param owner table owner = { username = string|nil, guid = string|nil }
---@param entity_id number entity_id, doesn't matter of local_entity_id or remote_entity_id
---@return table nc If owner or entity_id isn't set, it returns nil. If nc was found, but owner mismatch, returns nil. Otherwise the network component table.
function em:GetNetworkComponentByOwnerAndEntityId(owner, entity_id)
    if not owner then
        logger:warn(
            "Unable to find network component by owner(%s, %s) and entity_id(%s), because owner is nil.",
            owner.username,
            owner.guid,
            entity_id
        )
        return nil
    end

    if not entity_id then
        logger:warn(
            "Unable to find network component by owner(%s, %s) and entity_id(%s), because entity_id is nil.",
            owner.username,
            owner.guid,
            entity_id
        )
        return nil
    end

    local username = owner.username
    local guid = owner.guid
    local cached_nc_entity_id_map = self.cache.nc_entity_ids[entity_id]

    if not cached_nc_entity_id_map then
        logger:warn(
            "Unable to find network component by owner(%s, %s) and entity_id(%s), because cached_nc_entity_id_map is nil.",
            owner.username,
            owner.guid,
            entity_id
        )
        return nil
    end

    local componet_id = cached_nc_entity_id_map.component_id
    local nuid = cached_nc_entity_id_map.nuid
    local nc_as_json = ComponentGetValue2(componet_id, NetworkComponent.field_name)
    local nc = json.decode(nc_as_json)
     --util.deserialise(nc_serialised)
    local nc_owner_guid = nc.owner.guid or nc.owner[2]

    -- double check if owner is correct
    if guid ~= nc_owner_guid then
        logger:warn(
            "Found network component(%s) in cache by entity_id(%s), but the owner doesn't match: owner(%s, %s) nc.owner(%s, %s)",
            componet_id,
            entity_id,
            username,
            guid,
            nc.owner.username,
            nc.owner.guid
        )
        return nil
    end

    return nc
end

--- Returns the network component table of an entity searched by NUID.
---@param nuid number Network unique identifier
---@return table nc If nuid isn't set, it returns nil, otherwise the network component table.
function em:GetNetworkComponentByNuid(nuid)
    if not nuid then
        logger:warn("Unable to find to find network component by nuid(%s), because it is nil.", nuid)
        return nil
    end

    for index, tbl in ipairs(self.cache.nc_entity_ids) do
        local component_id = tbl.component_id
        local nuid_cached = tbl.nuid

        if nuid == nuid_cached then
            local nc_as_json = ComponentGetValue2(component_id, NetworkComponent.field_name)
            return json.decode(nc_as_json)
         --util.deserialise(nc_serialised)
        end
    end
    return nil
end

function em:getLocalPlayerId()
    local player_unit_ids = EntityGetWithTag("player_unit")
    for i_p = 1, #player_unit_ids do
        local nc = self:GetNetworkComponent(util.getLocalOwner(), player_unit_ids[i_p])
        if nc and nc.owner.guid == ModSettingGet("noita-mp.guid") then
            return player_unit_ids[i_p]
        end
    end
    return player_unit_ids[1]
end

return em
