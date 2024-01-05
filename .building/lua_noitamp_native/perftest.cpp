#include <cstdio>
#include <cstdlib>
#include "entity_map.hpp"

entity_serialized make_random_entity() {
    uint8_t buf[1024];

    int es_size = 256 + rand() % 256;
    for (int i = 0; i < es_size; i++)
        buf[i] = (rand() % 256);

    return entity_serialized(buf, es_size);
}

int main(void) {
    int seed = 4654681;
    global_entity_map em;
    printf("SEED = %d\n", seed);
    srand(seed);
    printf("entity_map test\n");
    printf("empty mem usage: %zu bytes\n", em.get_memory_usage());

    entity_serialized es = make_random_entity();
    const entity_serialized* pes;
    uint32_t eid, nuid;

    em.add_id_to_entity(INVALID_ID, INVALID_ID, es);
    assert(em.get_count() == 1);

    printf("mem usage with %zu elements: %zu bytes\n", em.get_count(), em.get_memory_usage());

    em.get_ids_by_entry(es, eid, nuid);
    assert(eid == INVALID_ID);
    assert(nuid == INVALID_ID);

    em.add_id_to_entity(1, INVALID_ID, es);
    em.get_ids_by_entry(es, eid, nuid);
    assert(eid == 1);
    assert(nuid == INVALID_ID);

    em.add_id_to_entity(INVALID_ID, 2, es);
    em.get_ids_by_entry(es, eid, nuid);
    assert(eid == 1);
    assert(nuid == 2);

    em.remove_ids(1, INVALID_ID);
    assert(em.get_count() == 0);
    em.get_ids_by_entry(es, eid, nuid);
    assert(eid == INVALID_ID);
    assert(nuid == INVALID_ID);

    em.add_id_to_entity(3, 4, es);
    assert(em.get_count() == 1);
    pes = em.get_entity(3, INVALID_ID);
    assert(pes);
    assert(pes->len == es.len);
    assert(memcmp(pes->p.get(), es.p.get(), es.len) == 0);

    pes = em.get_entity(INVALID_ID, 4);
    assert(pes);
    assert(pes->len == es.len);
    assert(memcmp(pes->p.get(), es.p.get(), es.len) == 0);

    em.remove_ids(INVALID_ID, 4);
    assert(em.get_count() == 0);

    em.add_id_to_entity(1, 2, es);
    em.add_id_to_entity(3, 4, es);
    em.add_id_to_entity(5, 6, es);
    assert(em.get_count() == 1);
    em.clear();
    assert(em.get_count() == 0);

    int big_input = 10000;
    for (int i = 1; i <= big_input; i++) {
        es = make_random_entity();
        em.add_id_to_entity(i, i, es);
        if (i % 100 == 0)
            printf("mem usage with %zu elements: %zu bytes (%zuMB)\n", em.get_count(), em.get_memory_usage(), em.get_memory_usage() / 1024 / 1024);
    }

    printf("all OK!\n");
}

