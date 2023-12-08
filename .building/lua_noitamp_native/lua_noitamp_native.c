#include <lua.h>
#include <lauxlib.h>
#include <string.h>

#pragma region EntityCache
#define entityCacheSize sizeof(EntityCacheEntry)
typedef struct EntityCacheEntry
{
    int entityId;
    int nuid;
    char *ownerGuid;
    char *ownerName;
    char *filepath;
    double x;
    double y;
    double rotation;
    double velX;
    double velY;
    double currentHealth;
    double maxHealth;
} EntityCacheEntry;

EntityCacheEntry *entityEntries;
int entityCurrentSize = 0;
static int l_entityCacheSize(lua_State *L)
{
    lua_pushinteger(L, entityCurrentSize);
    return 1;
}
static int l_entityCacheUsage(lua_State *L)
{
    lua_pushnumber(L, entityCurrentSize * entityCacheSize);
    return 1;
}
static int l_entityCacheWrite(lua_State *L)
{
    int entityId = luaL_checkint(L, 1);
    int nuid = lua_tointeger(L, 2);
    if (nuid == NULL)
    {
        nuid = -1;
    };
    for (int i = 0; i < entityCurrentSize; i++)
    {
        EntityCacheEntry *entry = entityEntries + i;
        if (entry->entityId == entityId)
        {
            entry->entityId = entityId;
            entry->nuid = nuid;
            entry->ownerGuid = luaL_checkstring(L, 3);
            entry->ownerName = luaL_checkstring(L, 4);
            entry->filepath = luaL_checkstring(L, 5);
            entry->x = luaL_checknumber(L, 6);
            entry->y = luaL_checknumber(L, 7);
            entry->rotation = luaL_checknumber(L, 8);
            entry->velX = luaL_checknumber(L, 9);
            entry->velY = luaL_checknumber(L, 10);
            entry->currentHealth = luaL_checknumber(L, 11);
            entry->maxHealth = luaL_checknumber(L, 12);
            return 0;
        };
    }
    ++entityCurrentSize;
    entityEntries = realloc(entityEntries, entityCacheSize * entityCurrentSize);
    EntityCacheEntry *newEntry = entityEntries + (entityCurrentSize - 1);
    newEntry->entityId = entityId;
    newEntry->nuid = nuid;
    newEntry->ownerGuid = luaL_checkstring(L, 3);
    newEntry->ownerName = luaL_checkstring(L, 4);
    newEntry->filepath = luaL_checkstring(L, 5);
    newEntry->x = luaL_checknumber(L, 6);
    newEntry->y = luaL_checknumber(L, 7);
    newEntry->rotation = luaL_checknumber(L, 8);
    newEntry->velX = luaL_checknumber(L, 9);
    newEntry->velY = luaL_checknumber(L, 10);
    newEntry->currentHealth = luaL_checknumber(L, 11);
    newEntry->maxHealth = luaL_checknumber(L, 12);
    return 0;
}

static void l_createEntityCacheReturnTable(lua_State *L, EntityCacheEntry *entry)
{
    lua_createtable(L, 0, 4);
    lua_pushinteger(L, entry->entityId);
    lua_setfield(L, -2, "entityId");
    if (entry->nuid == -1)
    {
        lua_pushnil(L);
        lua_setfield(L, -2, "nuid");
    }
    else
    {
        lua_pushinteger(L, entry->nuid);
        lua_setfield(L, -2, "nuid");
    }
    lua_pushstring(L, entry->ownerGuid);
    lua_setfield(L, -2, "ownerGuid");

    lua_pushstring(L, entry->ownerName);
    lua_setfield(L, -2, "ownerName");

    lua_pushstring(L, entry->filepath);
    lua_setfield(L, -2, "filepath");

    lua_pushnumber(L, entry->x);
    lua_setfield(L, -2, "x");

    lua_pushnumber(L, entry->y);
    lua_setfield(L, -2, "y");

    lua_pushnumber(L, entry->velX);
    lua_setfield(L, -2, "velX");

    lua_pushnumber(L, entry->velY);
    lua_setfield(L, -2, "velY");

    lua_pushnumber(L, entry->rotation);
    lua_setfield(L, -2, "rotation");

    lua_pushnumber(L, entry->currentHealth);
    lua_setfield(L, -2, "currentHealth");

    lua_pushnumber(L, entry->maxHealth);
    lua_setfield(L, -2, "maxHealth");
}
static int l_entityCacheReadByEntityId(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < entityCurrentSize; i++)
    {
        EntityCacheEntry *entry = entityEntries + i;
        if (entry->entityId == idToSearch)
        {
            l_createEntityCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_entityCacheReadByNuid(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < entityCurrentSize; i++)
    {
        EntityCacheEntry *entry = entityEntries + i;
        if (entry->nuid == idToSearch)
        {
            l_createEntityCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_entityCacheDeleteByEntityId(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < entityCurrentSize; i++)
    {
        EntityCacheEntry *entry = entityEntries + i;
        if (entry->entityId == idToSearch)
        {
            memmove(entityEntries + i, entityEntries + i + 1, ((entityCurrentSize - 1) - i) * entityCacheSize);
            entityCurrentSize--;
            entityEntries = realloc(entityEntries, entityCacheSize * entityCurrentSize);
            lua_pushboolean(L, 1);
            return 1;
        };
    }
    lua_pushboolean(L, 0);
    return 1;
}

static int l_entityCacheDeleteByNuid(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < entityCurrentSize; i++)
    {
        EntityCacheEntry *entry = entityEntries + i;
        if (entry->nuid == idToSearch)
        {
            memmove(entityEntries + i, entityEntries + i + 1, ((entityCurrentSize - 1) - i) * entityCacheSize);
            entityCurrentSize--;
            entityEntries = realloc(entityEntries, entityCacheSize * entityCurrentSize);
            lua_pushboolean(L, 1);
            return 1;
        };
    }
    lua_pushboolean(L, 0);
    return 1;
}

static int l_entityCacheReadAll(lua_State *L)
{
    lua_createtable(L, 0, 4);
    for (int i = 0; i < entityCurrentSize; i++)
    {
        EntityCacheEntry *entry = entityEntries + i;
        lua_pushnumber(L, i + 1);
        l_createEntityCacheReturnTable(L, entry);
        lua_settable(L, -3);
    }
    return 1;
}

#pragma endregion
#pragma region NetworkCache
typedef struct NetworkCacheEntry
{
    unsigned int messageId;
    int peerNum;
    char *event;
    int status;
    unsigned int ackedAt;
    unsigned int sendAt;
    char *dataChecksum;
} NetworkCacheEntry;

NetworkCacheEntry *networkEntries;
int networkCurrentSize = 0;
static int l_networkCacheSize(lua_State *L)
{
    lua_pushinteger(L, networkCurrentSize);
    return 1;
}
static int l_networkCacheUsage(lua_State *L)
{
    lua_pushnumber(L, networkCurrentSize * sizeof(NetworkCacheEntry));
    return 1;
}

static int l_networkCacheWrite(lua_State *L)
{
    int peerNum = luaL_checkint(L, 1);
    int messageId = luaL_checkint(L, 2);
    int event = luaL_checkstring(L, 3);
    for (int i = 0; i < networkCurrentSize; i++)
    {
        NetworkCacheEntry *entry = networkEntries + i;
        if (entry->messageId == messageId && entry->peerNum == peerNum && entry->event == event)
        {
            entry->peerNum = peerNum;
            entry->messageId = messageId;
            entry->event = event;
            char *status = luaL_checkstring(L, 4);
            if (!strcmp(status, "ack"))
            {
                entry->status = 0;
            }
            else
            {
                entry->status = 1;
            }
            entry->ackedAt = luaL_checkint(L, 5);
            entry->sendAt = luaL_checkint(L, 6);
            entry->dataChecksum = luaL_checkstring(L, 7);
            return 0;
        };
    }
    ++networkCurrentSize;
    networkEntries = realloc(networkEntries, sizeof(NetworkCacheEntry) * networkCurrentSize);
    NetworkCacheEntry *newEntry = networkEntries + (networkCurrentSize - 1);
    newEntry->peerNum = peerNum;
    newEntry->messageId = messageId;
    newEntry->event = event;
    char *status = luaL_checkstring(L, 4);
    if (!strcmp(status, "ack"))
    {
        newEntry->status = 0;
    }
    else
    {
        newEntry->status = 1;
    }
    newEntry->ackedAt = luaL_checkint(L, 5);
    newEntry->sendAt = luaL_checkint(L, 6);
    newEntry->dataChecksum = luaL_checkstring(L, 7);
    return 0;
}

static void l_createNetworkCacheReturnTable(lua_State *L, NetworkCacheEntry *entry)
{
    lua_createtable(L, 0, 4);
    lua_pushstring(L, entry->event);
    lua_setfield(L, -2, "event");

    lua_pushinteger(L, entry->messageId);
    lua_setfield(L, -2, "messageId");

    lua_pushstring(L, entry->dataChecksum);
    lua_setfield(L, -2, "dataChecksum");

    if (entry->status == 0)
    {
        lua_pushstring(L, "ack");
        lua_setfield(L, -2, "status");
    }
    else
    {
        lua_pushstring(L, "sent");
        lua_setfield(L, -2, "status");
    }

    if (entry->ackedAt == 0)
    {
        lua_pushnil(L);
        lua_setfield(L, -2, "ackedAt");
    }
    else
    {
        lua_pushnumber(L, entry->ackedAt);
        lua_setfield(L, -2, "ackedAt");
    }

    if (entry->sendAt == 0)
    {
        lua_pushnil(L);
        lua_setfield(L, -2, "sentAt");
    }
    else
    {
        lua_pushnumber(L, entry->sendAt);
        lua_setfield(L, -2, "sentAt");
    }
}

static int l_networkCacheRead(lua_State *L)
{
    int peerToSearch = luaL_checkinteger(L, 1);
    char *eventToSearch = luaL_checkstring(L, 2);
    int idToSearch = luaL_checkinteger(L, 3);
    for (int i = 0; i < networkCurrentSize; i++)
    {
        NetworkCacheEntry *entry = networkEntries + i;
        if (entry->peerNum == peerToSearch && entry->event == eventToSearch && entry->messageId == idToSearch)
        {
            l_createNetworkCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_networkCacheReadByChecksum(lua_State *L)
{
    int peerToSearch = luaL_checkinteger(L, 1);
    char *sumToSearch = luaL_checkstring(L, 2);
    for (int i = 0; i < networkCurrentSize; i++)
    {
        NetworkCacheEntry *entry = networkEntries + i;
        if (entry->peerNum == peerToSearch && entry->dataChecksum == sumToSearch)
        {
            l_createNetworkCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_networkCacheReadAll(lua_State *L)
{
    lua_createtable(L, 0, 4);
    for (int i = 0; i < networkCurrentSize; i++)
    {
        NetworkCacheEntry *entry = networkEntries + i;
        lua_pushnumber(L, i + 1);
        l_createNetworkCacheReturnTable(L, entry);
        lua_settable(L, -3);
    }
    return 1;
}

static int l_networkCacheRemoveOldest(lua_State *L)
{
    NetworkCacheEntry *entry = networkEntries;
    lua_pushnumber(L, entry->messageId);
    memmove(networkEntries, networkEntries + 1, ((networkCurrentSize - 1)) * sizeof(NetworkCacheEntry));
    networkCurrentSize--;
    networkEntries = realloc(networkEntries, sizeof(NetworkCacheEntry) * networkCurrentSize);
    return 1;
}

static int l_networkCacheClear(lua_State *L)
{
    int peerToClear = luaL_checkinteger(L, 1);
    for (int i = 0; i < networkCurrentSize; i++)
    {
        NetworkCacheEntry *entry = networkEntries + i;
        if (entry->peerNum == peerToClear)
        {
            memmove(networkEntries + i, networkEntries + i + 1, ((networkCurrentSize - 1) - i) * sizeof(NetworkCacheEntry));
            networkCurrentSize--;
            networkEntries = realloc(networkEntries, sizeof(NetworkCacheEntry) * networkCurrentSize);
        };
    }
    return 0;
}
#pragma endregion

void register_NativeEntityMap(lua_State * L);

__declspec(dllexport) int luaopen_lua_noitamp_native(lua_State *L)
{
    static const luaL_Reg eCachelib[] =
        {
            {"set", l_entityCacheWrite},
            {"get", l_entityCacheReadByEntityId},
            {"getNuid", l_entityCacheReadByNuid},
            {"delete", l_entityCacheDeleteByEntityId},
            {"deleteNuid", l_entityCacheDeleteByNuid},
            {"size", l_entityCacheSize},
            {"usage", l_entityCacheUsage},
            {"getAll", l_entityCacheReadAll},
            {NULL, NULL}};
    luaL_register(L, "EntityCacheC", eCachelib);
    static const luaL_Reg nCachelib[] =
        {
            {"set", l_networkCacheWrite},
            {"get", l_networkCacheRead},
            {"getChecksum", l_networkCacheReadByChecksum},
            {"size", l_networkCacheSize},
            {"usage", l_networkCacheUsage},
            {"removeOldest", l_networkCacheRemoveOldest},
            {"clear", l_networkCacheClear},
            {"getAll", l_networkCacheReadAll},
            {NULL, NULL}};
    luaL_register(L, "NetworkCacheC", nCachelib);

    register_NativeEntityMap(L);

    return 1;
}