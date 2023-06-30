@echo off
setlocal
IF "%*"=="" (set I=-i) ELSE (set I=)
set "LUAROCKS_SYSCONFDIR=C:\Program Files (x86)/luarocks"
"D:\a\NoitaMP\NoitaMP\LuaJIT-2.0.4\bin\luajit.exe" -e "package.path=\"D:\\a\\NoitaMP\\NoitaMP\\mods\\noita-mp/./lua_modules/share/lua/5.1/?.lua;D:\\a\\NoitaMP\\NoitaMP\\mods\\noita-mp/./lua_modules/share/lua/5.1/?/init.lua;C:\\Users\\runneradmin\\AppData\\Roaming/luarocks/share/lua/5.1/?.lua;C:\\Users\\runneradmin\\AppData\\Roaming/luarocks/share/lua/5.1/?/init.lua;\"..package.path;package.cpath=\"D:\\a\\NoitaMP\\NoitaMP\\mods\\noita-mp/./lua_modules/lib/lua/5.1/?.dll;C:\\Users\\runneradmin\\AppData\\Roaming/luarocks/lib/lua/5.1/?.dll;\"..package.cpath" %I% %*
exit /b %ERRORLEVEL%
