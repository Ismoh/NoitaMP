#include <lua.h>
#include <lauxlib.h>
// Test function that multiplies something by 50
static int l_mult50(lua_State* L)
{
    double number = luaL_checknumber(L, 1);
    lua_pushnumber(L, number*50);
    return 1;
}

int luaopen_cache(lua_State* L)
{
    static const luaL_reg cachelib [] =
    {
         {"mult50", l_mult50}, 
         {NULL, NULL}
    };
    luaL_register(L, "cache", cachelib);
    return 1;
}