# Install luarocks on Windows

1. Open `cmd.exe` as *administrator*
2. Change directory to `NoitaMP\mods\noita-mp`, like `cd fullPathTo\NoitaMP\mods\noita-mp`.
3. Run the following command as *administrator* in `cmd.exe`:
   ```cmd
   REM // cd fullPathTo\NoitaMP\mods\noita-mp
   
   REM // resolve absolute path
   set REL_PATH=..\.building\luarocks-3.9.1-windows-32
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
   %ABS_PATH%\luarocks init -help
   ```
   [source](https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name)