#include ".building/LuaJIT-2.0.4/src/lua.h"
#include  ".building/LuaJIT-2.0.4/src/lauxlib.h"
static int l_mult50(lua_State* L)
{
    double number = luaL_checknumber(L, 1);
    lua_pushnumber(L, number * 50);
    return 1;
}

__declspec(dllexport) int luaopen_cache(lua_State* L)
{
    static const luaL_reg cachelib[] =
    {
         {"mult50", l_mult50},
         {NULL, NULL}
    };
    luaL_openlib(L, "cache", cachelib, 0);
    return 1;
}