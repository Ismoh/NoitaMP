#include <cstdint>
extern "C" {
#include <lua.h>
#include <lauxlib.h>
}
#include "entity_map.hpp"


/*
	single global map instance
	all LUA function work on this instance
*/
static global_entity_map g_entity_map;

/*
	export global Lua function that work on g_entity_map

	getEntityIdBy(serialisedString)
	getNuidBy(serialisedString)
	setMappingOfEntityIdToSerialisedString(entityId, serialisedString)
	setMappingOfNuidToSerialisedString(nuid, serialisedString)
	removeMappingOfNuid(nuid)
	removeMappingOfEntityId(entityId)

*/

static int l_NativeEntityMap_getNuidBySerializedString(lua_State* L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t eid, nuid;

	g_entity_map.get_ids_by_entry(entity_serialized((void*)s, len), eid, nuid);
	if (nuid == INVALID_ID)
		lua_pushnil(L);
	else
		lua_pushinteger(L, nuid);

	return 1;
}

static int l_NativeEntityMap_getEntityIdBySerializedString(lua_State* L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t eid, nuid;

	g_entity_map.get_ids_by_entry(entity_serialized((void*)s, len), eid, nuid);
	if (eid == INVALID_ID)
		lua_pushnil(L);
	else
		lua_pushinteger(L, eid);

	return 1;
}

static int l_NativeEntityMap_getSerializedStringByEntityId(lua_State* L) {
	uint32_t eid = lua_tonumber(L, 1);

	const entity_serialized* e = g_entity_map.get_entity(eid, INVALID_ID);
	if (!e)
		lua_pushnil(L);
	else
		lua_pushlstring(L, reinterpret_cast<const char*>(e->p.get()), e->len);

	return 1;
}

static int l_NativeEntityMap_getSerializedStringByNuid(lua_State* L) {
	uint32_t nuid = lua_tonumber(L, 1);

	const entity_serialized* e = g_entity_map.get_entity(INVALID_ID, nuid);
	if (!e)
		lua_pushnil(L);
	else
		lua_pushlstring(L, reinterpret_cast<const char*>(e->p.get()), e->len);

	return 1;
}

static int l_NativeEntityMap_setMappingOfEntityIdToSerialisedString(lua_State* L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t eid = lua_tonumber(L, 2), nuid = INVALID_ID;

	g_entity_map.add_id_to_entity(eid, nuid, entity_serialized((void*)s, len));

	return 0;
}

static int l_NativeEntityMap_setMappingOfNuidToSerialisedString(lua_State* L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t nuid = lua_tonumber(L, 2), eid = INVALID_ID;

	g_entity_map.add_id_to_entity(eid, nuid, entity_serialized((void*)s, len));

	return 0;
}

static int l_NativeEntityMap_removeMappingOfEntityId(lua_State* L) {
	uint32_t eid = lua_tonumber(L, 2), nuid = INVALID_ID;

	g_entity_map.remove_ids(eid, nuid);

	return 0;
}

static int l_NativeEntityMap_removeMappingOfNuid(lua_State* L) {
	uint32_t nuid = lua_tonumber(L, 2), eid = INVALID_ID;

	g_entity_map.remove_ids(eid, nuid);

	return 0;
}

static int l_NativeEntityMap_getSerializedStringCount(lua_State* L) {

	lua_pushinteger(L, g_entity_map.get_count());

	return 1;
}

static int l_NativeEntityMap_getMemoryUsage(lua_State* L) {

	lua_pushinteger(L, g_entity_map.get_memory_usage());

	return 1;
}

static int l_NativeEntityMap_removeAllMappings(lua_State* L) {

	g_entity_map.clear();

	return 0;
}

static void register_NativeEntityMap(lua_State * L) {
	luaL_Reg NativeEntityMaplib[] = {
		  {"getNuidBySerializedString", l_NativeEntityMap_getNuidBySerializedString},
		  {"getEntityIdBySerializedString", l_NativeEntityMap_getEntityIdBySerializedString},
		  {"getSerializedStringByEntityId", l_NativeEntityMap_getSerializedStringByEntityId},
		  {"getSerializedStringByNuid", l_NativeEntityMap_getSerializedStringByNuid},
		  {"setMappingOfNuidToSerialisedString", l_NativeEntityMap_setMappingOfNuidToSerialisedString},
		  {"setMappingOfEntityIdToSerialisedString", l_NativeEntityMap_setMappingOfEntityIdToSerialisedString},
		  {"removeMappingOfEntityId", l_NativeEntityMap_removeMappingOfEntityId},
		  {"removeMappingOfNuid", l_NativeEntityMap_removeMappingOfNuid},
		  {"getSerializedStringCount", l_NativeEntityMap_getSerializedStringCount},
		  {"getMemoryUsage", l_NativeEntityMap_getMemoryUsage},
		  {"removeAllMappings", l_NativeEntityMap_removeAllMappings},
		  {NULL, NULL},
	};
	luaL_register(L, "NativeEntityMap", NativeEntityMaplib);
}

__declspec(dllexport) int luaopen_lua_noitamp_native(lua_State* L)
{
	register_NativeEntityMap(L);

	return 1;
}
