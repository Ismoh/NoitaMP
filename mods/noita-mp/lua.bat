@echo off
setlocal
IF "%*"=="" (set I=-i) ELSE (set I=)
set "LUAROCKS_SYSCONFDIR=C:\Program Files (x86)/luarocks"
"D:\______BACKUP\NoitaMP_repo\NoitaMP\LuaJIT-2.0.4\bin\luajit.exe" -e "package.path=\"D:\\______BACKUP\\NoitaMP_repo\\NoitaMP\\mods\\noita-mp/./lua_modules/share/lua/5.1/?.lua;D:\\______BACKUP\\NoitaMP_repo\\NoitaMP\\mods\\noita-mp/./lua_modules/share/lua/5.1/?/init.lua;C:\\Users\\Ismoh-PC\\AppData\\Roaming/luarocks/share/lua/5.1/?.lua;C:\\Users\\Ismoh-PC\\AppData\\Roaming/luarocks/share/lua/5.1/?/init.lua;\"..package.path;package.cpath=\"D:\\______BACKUP\\NoitaMP_repo\\NoitaMP\\mods\\noita-mp/./lua_modules/lib/lua/5.1/?.dll;C:\\Users\\Ismoh-PC\\AppData\\Roaming/luarocks/lib/lua/5.1/?.dll;\"..package.cpath" %I% %*
exit /b %ERRORLEVEL%
