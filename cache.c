#include ".building/LuaJIT-2.0.4/src/lua.h"
#include  ".building/LuaJIT-2.0.4/src/lauxlib.h"
#define cacheSize sizeof(CacheEntry)
typedef struct CacheEntry
{
    int entityId;
    int nuid;
    int ownerGuid;
    char *ownerName;
    char *filepath;
    double x;
    double y;
    double velocity;
    double health;
} CacheEntry;

CacheEntry* entries; 
int currentSize = 0;
static int l_cacheWrite(lua_State* L)
{
    ++currentSize;
    entries = realloc(entries, cacheSize * currentSize);
    CacheEntry* newEntry = entries + (currentSize-1);
    newEntry->entityId = luaL_checkint(L, 1);
    newEntry->nuid = luaL_checkint(L, 2);
    newEntry->ownerGuid = luaL_checkint(L, 3);
    newEntry->ownerName = luaL_checkstring(L, 4);
    newEntry->filepath = luaL_checkstring(L, 5);
    newEntry->x = luaL_checknumber(L, 6);
    newEntry->y = luaL_checknumber(L, 7);
    newEntry->health = luaL_checknumber(L, 8);
    return 0;
}

static void l_createCacheReturnTable(lua_State* L, CacheEntry* entry) {
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

    lua_pushnumber(L, entry->health);
    lua_setfield(L, -2, "health");

    lua_pushnumber(L, entry->velocity);
    lua_setfield(L, -2, "velocity");

    lua_pushnumber(L, entry->x);
    lua_setfield(L, -2, "x");

    lua_pushnumber(L, entry->y);
    lua_setfield(L, -2, "y");
}
static int l_cacheReadByEntityId(lua_State* L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry* entry = entries+i;
        if (entry->entityId == idToSearch) {
            l_createCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_cacheReadByNuid(lua_State* L) 
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry* entry = entries+i;
        if (entry->nuid == idToSearch) {
            l_createCacheReturnTable(L, entry);
            return 1;
        };
    }
    lua_pushnil(L);
    return 1;
}

static int l_cacheDeleteByEntityId(lua_State* L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry* entry = entries+i;
        if (entry->entityId == idToSearch) {
            memmove(entries+i+1, entries+i, ((currentSize-1) - i) * cacheSize);
            currentSize--;
            realloc(entries, cacheSize * currentSize);
        };
    }
}

static int l_cacheDeleteByNuid(lua_State* L)
{
    int idToSearch = luaL_checkinteger(L, 1);
    for (int i = 0; i < currentSize; i++)
    {
        CacheEntry* entry = entries+i;
        if (entry->nuid == idToSearch) {
            memmove(entries+i+1, entries+i, ((currentSize-1) - i) * cacheSize);
            currentSize--;
            realloc(entries, cacheSize * currentSize);
        };
    }
}

__declspec(dllexport) int luaopen_cache(lua_State* L)
{
    static const luaL_reg cachelib[] =
    {
        {"set", l_cacheWrite},
        {"get", l_cacheReadByEntityId},
        {"getNuid", l_cacheReadByNuid},
        {"delete", l_cacheDeleteByEntityId},
        {"deleteNuid", l_cacheDeleteByNuid},
        {NULL, NULL}
    };
    luaL_openlib(L, "cache", cachelib, 0);
    return 1;
}