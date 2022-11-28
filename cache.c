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
static int l_cacheSave(lua_State* L)
{
    currentSize = currentSize + 1;
    entries = realloc(entries, cacheSize * currentSize);
    CacheEntry newEntry;
    newEntry.entityId = luaL_checkint(L, 1);
    newEntry.nuid = luaL_checkint(L, 2);
    newEntry.ownerGuid = luaL_checkint(L, 3);
    newEntry.ownerName = luaL_checkstring(L, 4);
    newEntry.filepath = luaL_checkstring(L, 5);
    newEntry.x = luaL_checknumber(L, 6);
    newEntry.y = luaL_checknumber(L, 7);
    newEntry.health = luaL_checknumber(L, 8);
    memmove(entries+(currentSize-1), &newEntry, cacheSize);
    return 0;
}


__declspec(dllexport) int luaopen_cache(lua_State* L)
{
    static const luaL_reg cachelib[] =
    {
         {"setCache", l_cacheSave},
         {NULL, NULL}
    };
    luaL_openlib(L, "cache", cachelib, 0);
    return 1;
}