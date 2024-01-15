#include "entity_map.hpp"

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
			hexdump(ed.p.get(), ed.len);
			printf("STORED: LEN=%d PTR=%p HASH %llx\n", p->entity.len, p->entity.p.get(), XXHash64::hash(p->entity.p.get(), p->entity.len, 0xDEADBEEFDEADBEEFul));
			hexdump(p->entity.p.get(), ed.len);
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

const entity_serialized* global_entity_map::get_entity(uint32_t eid, uint32_t nuid)
{
		if (eid != INVALID_ID) {
			auto it = eid_to_entity.find(eid);
			if (it != eid_to_entity.end()) {
				return &it->second->entity;
			}
		}
		else if (nuid != INVALID_ID) {
			auto it = nuid_to_entity.find(nuid);
			if (it != nuid_to_entity.end()) {
				return &it->second->entity;
			}
		}
		return NULL;
}


size_t global_entity_map::get_memory_usage(void)
{
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

void global_entity_map::clear(void)
{
	for (auto it = entity_ptrs.begin(); it != entity_ptrs.end(); ++it) {
		delete it->second;
	}
	entity_ptrs.clear();
	eid_to_entity.clear();
	nuid_to_entity.clear();
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
