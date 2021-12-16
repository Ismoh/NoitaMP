#!/bin/bash
# luaJIT-2.0.4 is used for Noita.
# busted is used and installed by luarocks, therefore the lua packages paths are incorrect.
# Let's fix this by extending the paths with the luarocks-paths
# Note: ;; represents the default values provided by the Lua runtime (which is luaJIT-2.0.4)
# https://leafo.net/guides/customizing-the-luarocks-tree.html#how-lua-finds-packages/setting-the-path-with-luarocks
LUA_PATH=";;"
LUA_PATH="${LUA_PATH}/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?.lua;"
LUA_PATH="${LUA_PATH}/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?/init.lua;"
LUA_PATH="${LUA_PATH}/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?/?.lua;"
LUA_PATH="${LUA_PATH}/home/runner/work/NoitaMP/NoitaMP/luarocks/share/lua/5.1/?/?/init.lua" # wrong?
export LUA_PATH

LUA_CPATH=';;'
LUA_CPATH="${LUA_CPATH}/home/runner/work/NoitaMP/NoitaMP/luarocks/lib/lua/5.1/?.so"
export LUA_CPATH

# Custom environment variables need to pass to githubs environment variables
# https://stackoverflow.com/questions/57968497/how-do-i-set-an-env-var-with-a-bash-expression-in-github-actions
echo "LUA_PATH=${LUA_PATH}" >> $GITHUB_ENV
echo "LUA_CPATH=${LUA_CPATH}" >> $GITHUB_ENV

printenv