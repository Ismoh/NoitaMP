#pragma once

#ifdef ENTITY_MAP_IMPLEMENTATION
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif

#include "xxhash64.h"

#define USE_HOPSCOTCH

#ifdef USE_HOPSCOTCH
#include "tsl/hopscotch_map.h"
#define HT_TYPE tsl::hopscotch_map
#else
#include <unordered_map>
#define HT_TYPE std:unordered_map
#endif


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


struct entity_values {
	entity_serialized entity;
	uint32_t eid;
	uint32_t nuid;
};

#define INVALID_ID (uint32_t(0xFFFFFFFF))
/*
 EntityString -> N
 N -> EntityString

 N -> EId, NUID
 EId  -> N
 NUID -> N
*/



 struct EXPORT global_entity_map
{
	HT_TYPE < entity_serialized, entity_values *, entity_serialized_hasher > entity_ptrs;

	HT_TYPE < uint32_t, entity_values *> eid_to_entity;
	HT_TYPE < uint32_t, entity_values *> nuid_to_entity;

	entity_values * get_entity_ptr(const entity_serialized& ed, bool create = false);
	void remove_entity_ptr(entity_values* p);

	void add_id_to_entity(uint32_t eid, uint32_t nuid, const entity_serialized& ed);
	void get_ids_by_entry(const entity_serialized& ed, uint32_t& eid, uint32_t& nuid);
	void remove_ids(uint32_t eid, uint32_t nuid);

	const entity_serialized* get_entity(uint32_t eid) {
		auto it = eid_to_entity.find(eid);
		if (it != eid_to_entity.end()) {
			return &it->second->entity;
		}
		return NULL;
	}
	size_t get_count(void) const {
		return entity_ptrs.size();
	}

	void clear(void) {
		for (auto it = entity_ptrs.begin(); it != entity_ptrs.end(); ++it) {
			delete it->second;
		}
		entity_ptrs.clear();
		eid_to_entity.clear();
		nuid_to_entity.clear();
	}

	size_t get_memory_usage(void) {
		// approximate...
		size_t total = 0;

		total += sizeof(*this);

		for (auto it = entity_ptrs.begin(); it != entity_ptrs.end(); ++it) {
			total += sizeof(it->first) + it->first.len;
			total += sizeof(it->second);
		}
		total += sizeof(eid_to_entity) + eid_to_entity.size() * (sizeof(uint32_t) + sizeof(eid_to_entity[0]));
		total += sizeof(nuid_to_entity) + nuid_to_entity.size() * (sizeof(uint32_t) + sizeof(nuid_to_entity[0]));

		return total;
	}
};


//extern global_entity_map g_entity_map;
