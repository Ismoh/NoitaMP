# Introduction to build enet + lua-enet with msys2

## MINGW32

1. start MINGW32 by msys2
2. make sure configure is installed:
    - go to your msys2 installation (C:\msys64\)
    - use windump search and search for "configure"
    - found it in msys64\usr\share\libtool

## ENet

3. download (latest) source code: <https://github.com/lsalzman/enet/releases/tag/v1.3.17>
4. go to your ENet source code download zip and extract to enet-1.3.17

## MINGW32 again

5. in MINGW32 go to that extracted folder (cd "D:\______BACKUP\NoitaMP_repo\NoitaMP\dll building\enet-1.3.17")
6. look into README [and Makefile.am if you are interested] (cat README)
7. run "autoreconf -vfi" in MINGW32 inside of enet-1.3.17 folder
8. run "./configure && make && make install" in MINGW32 inside of enet-1.3.17 folder

## lua-enet

9. download latest version which looks like to be master branch, so download the master branch and keep the date in mind: https://github.com/leafo/lua-enet
10. extract that zip to lua-enet-master_21-10-2015
11. take a look here to know how to build the lua lib, but let me explain in a sec: https://github.com/leafo/lua-enet/issues/1#issuecomment-1960709
12. do not use lua51.dll which is provided by lua installation, use Noitas lua51.dll! See Noitas root installation path.
13. rename lua-enet-master_21-10-2015 to lua-enet-master_21-10-2015_ENet1-3-17_Noita-lua51-dll
14. copy those files
    - ..\enet-1.3.17\.libs\libenet.a
    - ..\enet-1.3.17\include\enet\*
    - ..\Noita\lua51.dll and rename it to noitalua51.dll
        into lua-enet-master_21-10-2015_ENet1-3-17_Noita-lua51-dll
15. download luajit 2.0.4 (because mod community verifed that noita dev team used 2.0.4)
16. copy those files (D:\______BACKUP\NoitaMP_repo\NoitaMP\dll building\LuaJIT-2.0.4)
    - ..\src\lua.h
    - ..\src\luaconf.h
    - ..\src\lualib.h
    - ..\src\lauxlib.h
        into lua-enet-master_21-10-2015_ENet1-3-17_Noita-lua51-dll

## MINGW32 building lua-enet.dll

16. go to your lua-enet-master_21-10-2015_ENet1-3-17_Noita-lua51-dll directory inside of MINGW32 (cd "D:\______BACKUP\NoitaMP_repo\NoitaMP\dll building\lua-enet-master_21-10-2015_ENet1-3-17_Noita-lua51-dll")
17. run "gcc -O -shared -o enet.dll enet.c -lenet -lws2_32 -lwinmm -mwindows -m32 -L /D/______BACKUP/NoitaMP_repo/NoitaMP/dll_building/lua-enet-master_21-10-2015_ENet1-3-17_Noita-lua51-dll/lib -lnoitalua51 --verbose"
18. copy enet.dll into your mods folder. i.e. Noita\mods\noita-mp\files\libs\enet.dll