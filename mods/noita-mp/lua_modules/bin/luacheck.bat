@echo off
setlocal
set "LUAROCKS_SYSCONFDIR=C:\Program Files (x86)/luarocks"
"D:\______BACKUP\NoitaMP_repo\NoitaMP\LuaJIT-2.0.4\bin\luajit.exe" -e "package.path=\"D:\\______BACKUP\\NoitaMP_repo\\NoitaMP\\mods\\noita-mp/lua_modules/share/lua/5.1/?.lua;D:\\______BACKUP\\NoitaMP_repo\\NoitaMP\\mods\\noita-mp/lua_modules/share/lua/5.1/?/init.lua;\"..package.path;package.cpath=\"D:\\______BACKUP\\NoitaMP_repo\\NoitaMP\\mods\\noita-mp/lua_modules/lib/lua/5.1/?.dll;\"..package.cpath;local k,l,_=pcall(require,'luarocks.loader') _=k and l.add_context('luacheck','1.1.1-1')" "D:\______BACKUP\NoitaMP_repo\NoitaMP\mods\noita-mp\lua_modules\lib\luarocks\rocks-5.1\luacheck\1.1.1-1\bin\luacheck" %*
exit /b %ERRORLEVEL%
