#include ".building/LuaJIT-2.0.4/src/lua.h"
#include ".building/LuaJIT-2.0.4/src/lauxlib.h"

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
            l_createCacheReturnTable(L, entry);
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
            l_createCacheReturnTable(L, entry);
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
            memmove(entityEntries + i + 1, entityEntries + i, ((entityCurrentSize - 1) - i) * entityCacheSize);
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
            memmove(entityEntries + i + 1, entityEntries + i, ((entityCurrentSize - 1) - i) * entityCacheSize);
            entityCurrentSize--;
            entityEntries = realloc(entityEntries, entityCacheSize * entityCurrentSize);
            lua_pushboolean(L, 1);
            return 1;
        };
    }
    lua_pushboolean(L, 0);
    return 1;
}
#pragma endregion
#pragma region NetworkCache
#pragma endregion

__declspec(dllexport) int luaopen_noitamp_cache(lua_State *L)
{
    static const luaL_reg eCachelib[] =
        {
            {"set", l_entityCacheWrite},
            {"get", l_entityCacheReadByEntityId},
            {"getNuid", l_entityCacheReadByNuid},
            {"delete", l_entityCacheDeleteByEntityId},
            {"deleteNuid", l_entityCacheDeleteByNuid},
            {"size", l_entityCacheSize},
            {"usage", l_entityCacheUsage},
            {NULL, NULL}};
    luaL_openlib(L, "EntityCache", eCachelib, 0);
    return 1;
}

