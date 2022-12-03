# Install luarocks on Windows

1. Open `cmd.exe` as *administrator*
2. Change directory to `NoitaMP\mods\noita-mp`, like `cd fullPathTo\NoitaMP\mods\noita-mp`.
3. Run the following command as *administrator* in `cmd.exe`:
   ```cmd
   REM // cd fullPathTo\NoitaMP\mods\noita-mp
   set INIT_PATH=%CD%
   
   REM // resolve absolute path
   set REL_PATH=..\..\.building\luarocks-3.9.1-windows-32
   set ABS_PATH=
   rem // Save current directory and change to target directory
   pushd %REL_PATH%
   rem // Save value of CD variable (current directory)
   set ABS_PATH=%CD%
   rem // Restore original directory
   popd   
   echo Relative path: %REL_PATH%
   echo Maps to path: %ABS_PATH%
   
   REM // init luarocks
   %ABS_PATH%\luarocks --lua-version="5.1" init noita-mp --output="%INIT_PATH%" --homepage="https://github.com/Ismoh/NoitaMP" --lua-versions="5.1" --license="GNU GPL v3"
   ```
   [source](https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name)
4. Result should look like this:
   ```cmd
   Initializing project 'noita-mp' for Lua 5.1 ...
   -----------------------------------------------
   
   Checking your Lua installation ...
   
   Wrote template at D:\______BACKUP\NoitaMP_repo\NoitaMP\mods\noita-mp -- you should now edit and finish it.
   
   Adding entries to .gitignore ...
   Preparing ./.luarocks/ ...
   Wrote .luarocks/config-5.1.lua
   Preparing ./lua_modules/ ...
   Preparing ./luarocks.bat ...
   Preparing ./lua.bat for version 5.1...
   ```
5. If you run `luarocks` in `\NoitaMP\mods\noita-mp` directory, it should work now.

## Create a rockspec
luarocks write_rockspec --license="GNU GPL v3" --lua-versions="5.1" --rockspec-format="3.0"

## Run unit test
luarocks test