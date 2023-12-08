#define ENTITY_MAP_IMPLEMENTATION
#include "entity_map.hpp"

extern "C" {
#include <lua.h>
#include <lauxlib.h>
}

/*
 EntityString -> N
 N -> EntityString

 N -> EId, NUID
 EId  -> N
 NUID -> N
*/


void DumpHex(const void* data, size_t size) {
	char ascii[17];
	size_t i, j;
	ascii[16] = '\0';
	for (i = 0; i < size; ++i) {
		printf("%02X ", ((unsigned char*)data)[i]);
		if (((unsigned char*)data)[i] >= ' ' && ((unsigned char*)data)[i] <= '~') {
			ascii[i % 16] = ((unsigned char*)data)[i];
		}
		else {
			ascii[i % 16] = '.';
		}
		if ((i + 1) % 8 == 0 || i + 1 == size) {
			printf(" ");
			if ((i + 1) % 16 == 0) {
				printf("|  %s \n", ascii);
			}
			else if (i + 1 == size) {
				ascii[(i + 1) % 16] = '\0';
				if ((i + 1) % 16 <= 8) {
					printf(" ");
				}
				for (j = (i + 1) % 16; j < 16; ++j) {
					printf("   ");
				}
				printf("|  %s \n", ascii);
			}
		}
	}
}

#ifdef _DEBUG
#define DBG(fmt, ...) printf("XXX %s:%d " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#else
#define DBG(...)
#endif

entity_values * global_entity_map::get_entity_ptr(const entity_serialized& ed, bool create) {
	entity_values * p;

	auto r = entity_ptrs.find(ed);
	if (r == entity_ptrs.end()) {
		if (!create)
			return NULL;
		p = new entity_values({ ed, INVALID_ID, INVALID_ID });
		entity_ptrs[ed] = p;
		return p;
	}
	else {
		return r->second;
	}
}

void global_entity_map::remove_entity_ptr(entity_values * p) {
	entity_ptrs.erase(p->entity);
	delete p;
}

void global_entity_map::add_id_to_entity(uint32_t eid, uint32_t nuid, const entity_serialized& ed) {
	entity_values* p = get_entity_ptr(ed, true);

	if (eid != INVALID_ID) {
#ifdef _DEBUG
		if (p->eid != INVALID_ID && p->eid != eid) {
			DBG("overwriting eid %d with %d", p->eid, eid);
			/*
			printf("IN: LEN=%d PTR=%p HASH %llx\n", ed.len, ed.p.get(), XXHash64::hash(ed.p.get(), ed.len, 0xDEADBEEFDEADBEEFul));
			DumpHex(ed.p.get(), ed.len);
			printf("STORED: LEN=%d PTR=%p HASH %llx\n", p->entity.len, p->entity.p.get(), XXHash64::hash(p->entity.p.get(), p->entity.len, 0xDEADBEEFDEADBEEFul));
			DumpHex(p->entity.p.get(), ed.len);
			*/
		}
#endif
		p->eid = eid;

		eid_to_entity[eid] = p;
	}
	if (nuid != INVALID_ID) {
#ifdef _DEBUG
		if (p->nuid != INVALID_ID && p->nuid != nuid) {
			DBG("overwriting nuid %d with %d", p->nuid, nuid);
		}
#endif

		p->nuid = nuid;
		nuid_to_entity[nuid] = p;
	}
}

void global_entity_map::get_ids_by_entry(const entity_serialized& ed, uint32_t& eid, uint32_t& nuid) {
	entity_values* p = get_entity_ptr(ed);

	if (!p) {
		//DBG("no entity found");
		eid = nuid = INVALID_ID;
		return;
	}
	eid = p->eid;
	nuid = p->nuid;
}

void global_entity_map::remove_ids(uint32_t eid, uint32_t nuid) {
	entity_values* p;

	if (eid == INVALID_ID && nuid != INVALID_ID) {
		auto r_nuid = nuid_to_entity.find(nuid);
		if (r_nuid == nuid_to_entity.end())
			return;

		p = r_nuid->second;
		nuid_to_entity.erase(r_nuid);
		if (p->eid != INVALID_ID)
			eid_to_entity.erase(p->eid);
		remove_entity_ptr(p);
	}
	else if (eid != INVALID_ID && nuid == INVALID_ID) {
		auto r_eid = eid_to_entity.find(eid);
		if (r_eid == eid_to_entity.end())
			return;
		p = r_eid->second;
		eid_to_entity.erase(r_eid);
		if (p->nuid != INVALID_ID)
			nuid_to_entity.erase(p->nuid);
		remove_entity_ptr(p);
	}
	else {
		DBG("passed nuid & eid at the same time (or none of them)");
	}
}

global_entity_map g_entity_map;

/*
getEntityIdBy(serialisedString)
getNuidBy(serialisedString)
setMappingOfEntityIdToSerialisedString(entityId, serialisedString)
setMappingOfNuidToSerialisedString(nuid, serialisedString)
removeMappingOfNuid(nuid)
removeMappingOfEntityId(entityId)
*/

static int l_NativeEntityMap_getNuidBySerializedString(lua_State * L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t eid, nuid;

	g_entity_map.get_ids_by_entry(entity_serialized((void *)s, len), eid, nuid);
	if (nuid == INVALID_ID)
		lua_pushnil(L);
	else
		lua_pushinteger(L, nuid);

	return 1;
}

static int l_NativeEntityMap_getEntityIdBySerializedString(lua_State * L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t eid, nuid;

	g_entity_map.get_ids_by_entry(entity_serialized((void *)s, len), eid, nuid);
	if (eid == INVALID_ID)
		lua_pushnil(L);
	else
		lua_pushinteger(L, eid);

	return 1;
}

static int l_NativeEntityMap_getSerializedStringByEntityId(lua_State* L) {
	uint32_t eid = lua_tonumber(L, 2);

	const entity_serialized *e = g_entity_map.get_entity(eid);
	if (!e)
		lua_pushnil(L);
	else
		lua_pushlstring(L, reinterpret_cast<const char *>(e->p.get()), e->len);

	return 1;
}

static int l_NativeEntityMap_setMappingOfEntityIdToSerialisedString(lua_State * L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t eid = lua_tonumber(L, 2), nuid = INVALID_ID;

	g_entity_map.add_id_to_entity(eid, nuid, entity_serialized((void*)s, len));

	return 0;
}

static int l_NativeEntityMap_setMappingOfNuidToSerialisedString(lua_State * L) {
	const char* s = lua_tostring(L, 1);
	size_t len = lua_strlen(L, 1);
	uint32_t nuid = lua_tonumber(L, 2), eid = INVALID_ID;

	g_entity_map.add_id_to_entity(eid, nuid, entity_serialized((void*)s, len));

	return 0;
}

static int l_NativeEntityMap_removeMappingOfEntityId(lua_State * L) {
	uint32_t eid = lua_tonumber(L, 2), nuid = INVALID_ID;

	g_entity_map.remove_ids(eid, nuid);

	return 0;
}

static int l_NativeEntityMap_removeMappingOfNuid(lua_State * L) {
	uint32_t nuid = lua_tonumber(L, 2), eid = INVALID_ID;

	g_entity_map.remove_ids(eid, nuid);

	return 0;
}

static int l_NativeEntityMap_getSerializedStringCount(lua_State * L) {

	lua_pushinteger(L, g_entity_map.get_count());

	return 1;
}

static int l_NativeEntityMap_getMemoryUsage(lua_State * L) {

	lua_pushinteger(L, g_entity_map.get_memory_usage());

	return 1;
}

static int l_NativeEntityMap_removeAllMappings(lua_State * L) {

	g_entity_map.clear();

	return 0;
}

extern "C" void register_NativeEntityMap(lua_State * L) {
	luaL_Reg NativeEntityMaplib[] = {
		  {"getNuidBySerializedString", l_NativeEntityMap_getNuidBySerializedString},
		  {"getEntityIdBySerializedString", l_NativeEntityMap_getEntityIdBySerializedString},
		  {"getSerializedStringByEntityId", l_NativeEntityMap_getSerializedStringByEntityId},
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

/*
struct guid
{
	uint8_t byte[16];
};

static uint8_t hex_map[256];

static void init_hex_map(void)
{
	hex_map['0'] = 0;
	hex_map['1'] = 1;
	hex_map['2'] = 2;
	hex_map['3'] = 3;
	hex_map['4'] = 4;
	hex_map['5'] = 5;
	hex_map['6'] = 6;
	hex_map['7'] = 7;
	hex_map['8'] = 8;
	hex_map['9'] = 9;

	hex_map['A'] = 10;
	hex_map['a'] = 10;

	hex_map['b'] = 11;
	hex_map['B'] = 11;

	hex_map['c'] = 12;
	hex_map['C'] = 12;

	hex_map['d'] = 13;
	hex_map['D'] = 13;

	hex_map['e'] = 14;
	hex_map['E'] = 14;

	hex_map['f'] = 15;
	hex_map['F'] = 15;
}

static void str_to_guid(const char* s, guid* guid)
{
	if (*s == '{')
		s++;

	// index-hi  00 00 00 00 0 00 00 0 00 11 1 11 11 1 11 11 11 11 22 22
	// index-lo  01 23 45 67 8 9A BC D EF 01 2 34 56 7 89 AB CD EF 01 23
	// -----------------------------------------------------------------
	// guid      00 11 22 33 - 44 55 - 66 77 - 88 99 - AA BB CC DD EE FF

	guid->byte[0x0] = (hex_map[s[0x00]] << 4) | hex_map[s[0x01]];
	guid->byte[0x1] = (hex_map[s[0x02]] << 4) | hex_map[s[0x03]];
	guid->byte[0x2] = (hex_map[s[0x04]] << 4) | hex_map[s[0x05]];
	guid->byte[0x3] = (hex_map[s[0x06]] << 4) | hex_map[s[0x07]];

	guid->byte[0x4] = (hex_map[s[0x09]] << 4) | hex_map[s[0x0A]];
	guid->byte[0x5] = (hex_map[s[0x0B]] << 4) | hex_map[s[0x0C]];

	guid->byte[0x6] = (hex_map[s[0x0E]] << 4) | hex_map[s[0x0F]];
	guid->byte[0x7] = (hex_map[s[0x10]] << 4) | hex_map[s[0x11]];

	guid->byte[0x8] = (hex_map[s[0x13]] << 4) | hex_map[s[0x14]];
	guid->byte[0x9] = (hex_map[s[0x15]] << 4) | hex_map[s[0x16]];

	guid->byte[0xA] = (hex_map[s[0x18]] << 4) | hex_map[s[0x19]];
	guid->byte[0xB] = (hex_map[s[0x1A]] << 4) | hex_map[s[0x1B]];
	guid->byte[0xC] = (hex_map[s[0x1C]] << 4) | hex_map[s[0x1D]];
	guid->byte[0xD] = (hex_map[s[0x1E]] << 4) | hex_map[s[0x1F]];
	guid->byte[0xE] = (hex_map[s[0x20]] << 4) | hex_map[s[0x21]];
	guid->byte[0xF] = (hex_map[s[0x22]] << 4) | hex_map[s[0x23]];
}

/*
struct entity_desc {
	uint32_t len;
	uint8_t desc[0];
	// flex array is supported via msvc extension
	// https://learn.microsoft.com/en-us/cpp/error-messages/compiler-warnings/compiler-warning-levels-2-and-4-c4200?view=msvc-160&viewFallbackFrom=vs-2019
	// => ignore warning
};

static struct entity_desc* make_entity_desc(const uint8_t* desc, uint32_t len)
{
	entity_desc* p = reinterpret_cast<entity_desc*>(new uint8_t[sizeof(entity_desc) + len]);
	p->len = len;
	memcpy(p->desc, desc, len);
	return p;
}

static void free_entity_desc(entity_desc* p)
{
	delete[] reinterpret_cast<uint8_t*>(p);
}
*/

/*
class entity_desc_equal
{
public:
	bool operator() (entity_desc const& t1, entity_desc const& t2) const
	{

	}
};
*/
