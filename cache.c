#include ".building/LuaJIT-2.0.4/src/lua.h"
#include ".building/LuaJIT-2.0.4/src/lauxlib.h"
#define cacheSize sizeof(CacheEntry)
#define false 0
#define true 1
typedef struct CacheEntry
{
    int entityId;
    int nuid;
    int ownerGuid;
    double rotation;
    char *ownerName;
    char *filepath;
    double x;
    double y;
    double velX;
    double velY;
    double currentHealth;
    double maxHealth;
} CacheEntry;

CacheEntry *entries;
int currentSize = 0;
static int l_cacheWrite(lua_State *L)
{
    int entityId = luaL_checkint(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry *entry = entries + i;
        if (entry->entityId == entityId)
        {
            entry->entityId = entityId;
            entry->nuid = luaL_checkint(L, 2);
            entry->ownerGuid = luaL_checkint(L, 3);
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
    ++currentSize;
    entries = realloc(entries, cacheSize * currentSize);
    CacheEntry *newEntry = entries + (currentSize - 1);
    newEntry->entityId = entityId;
    newEntry->nuid = luaL_checkint(L, 2);
    newEntry->ownerGuid = luaL_checkint(L, 3);
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

static void l_createCacheReturnTable(lua_State *L, CacheEntry *entry)
{
    lua_createtable(L, 0, 4);
    lua_pushinteger(L, entry->entityId);
    lua_setfield(L, -2, "entityId");
    lua_pushinteger(L, entry->nuid);
    lua_setfield(L, -2, "nuid");

    lua_pushinteger(L, entry->ownerGuid);
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

    lua_pushnumber(L, entry->currentHealth);
    lua_setfield(L, -2, "currentHealth");

    lua_pushnumber(L, entry->maxHealth);
    lua_setfield(L, -2, "maxHealth");
}
static int l_cacheReadByEntityId(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry *entry = entries + i;
        if (entry->entityId == idToSearch)
        {
            l_createCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_cacheReadByNuid(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry *entry = entries + i;
        if (entry->nuid == idToSearch)
        {
            l_createCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_cacheDeleteByEntityId(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry *entry = entries + i;
        if (entry->entityId == idToSearch)
        {
            memmove(entries + i + 1, entries + i, ((currentSize - 1) - i) * cacheSize);
            currentSize--;
            realloc(entries, cacheSize * currentSize);
        };
    }
    return 0;
}

static int l_cacheDeleteByNuid(lua_State *L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry *entry = entries + i;
        if (entry->nuid == idToSearch)
        {
            memmove(entries + i + 1, entries + i, ((currentSize - 1) - i) * cacheSize);
            currentSize--;
            realloc(entries, cacheSize * currentSize);
        };
    }
    return 0;
}

__declspec(dllexport) int luaopen_noitamp_cache(lua_State *L)
{
    static const luaL_reg cachelib[] =
        {
            {"set", l_cacheWrite},
            {"get", l_cacheReadByEntityId},
            {"getNuid", l_cacheReadByNuid},
            {"delete", l_cacheDeleteByEntityId},
            {"deleteNuid", l_cacheDeleteByNuid},
            {NULL, NULL}};
    luaL_openlib(L, "cache", cachelib, 0);
    return 1;
}