#pragma once

#include "debug.hpp"
#include "xxhash64.h"

#define USE_HOPSCOTCH
#ifdef USE_HOPSCOTCH
#include "tsl/hopscotch_map.h"
#define HT_TYPE tsl::hopscotch_map
#else
#include <unordered_map>
#define HT_TYPE std:unordered_map
#endif

// simple wrapper to keep a copy of the serialized entity buffer
// use shared_ptr for cheap&safe copies
struct entity_serialized {
	std::shared_ptr<uint8_t> p;
	uint32_t len;

	entity_serialized(void* in_p, size_t in_len)
		: p(new uint8_t[in_len]), len(in_len)
	{
		memcpy(p.get(), in_p, in_len);
	}

	bool operator==(const entity_serialized& rhs) const {
		return len == rhs.len && (p == rhs.p || memcmp(p.get(), rhs.p.get(), len) == 0);
	}
};

// helper to hash entity_serialized so it can be used as a map key
class entity_serialized_hasher
{
public:
	size_t operator() (const entity_serialized& key) const
	{
		// in 32bit, size_t will only truncate the hash
		// might save time by switching to 32 bit hashing?
		return size_t(XXHash64::hash(key.p.get(), key.len, 0xDEADBEEFDEADBEEFul));
	}
};

// Entity value
struct entity_values {
	entity_serialized entity;
	uint32_t eid;
	uint32_t nuid;
};

#define INVALID_ID (uint32_t(0xFFFFFFFF))

/*
	global_entity_map stores entities and allows fast access to them:
	- by serialized form
	- by entity ID (eid)
	- by Network Unique ID (nuid)
*/

 struct global_entity_map
{
	// entity_ptrs owns entity_value pointers
	HT_TYPE < entity_serialized, entity_values *, entity_serialized_hasher > entity_ptrs;

	HT_TYPE < uint32_t, entity_values *> eid_to_entity;
	HT_TYPE < uint32_t, entity_values *> nuid_to_entity;

	entity_values * get_entity_ptr(const entity_serialized& ed, bool create = false);
	void remove_entity_ptr(entity_values* p);
	void add_id_to_entity(uint32_t eid, uint32_t nuid, const entity_serialized& ed);
	void get_ids_by_entry(const entity_serialized& ed, uint32_t& eid, uint32_t& nuid);
	void remove_ids(uint32_t eid, uint32_t nuid);
	const entity_serialized* get_entity(uint32_t eid, uint32_t nuid);
	void clear(void);
	size_t get_memory_usage(void);

	size_t get_count(void) const {
		return entity_ptrs.size();
	}
};
