@echo off
setlocal
set "LUAROCKS_SYSCONFDIR=C:\Program Files (x86)/luarocks"
"D:\______BACKUP\NoitaMP_repo\NoitaMP\.building\luarocks-3.9.1-windows-32\luarocks.exe" --project-tree D:\______BACKUP\NoitaMP_repo\NoitaMP\mods\noita-mp/lua_modules %*
exit /b %ERRORLEVEL%
