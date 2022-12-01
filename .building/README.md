# Install luarocks on Windows

1. Open cmd.exe as administrator
2. Change directory to .building/luarocks-3.9.1-win32
3. Run the following command as administrator in cmd.exe:
   ```cmd
   set REL_PATH=..\..\
   set ABS_PATH=
   rem // Save current directory and change to target directory
   pushd %REL_PATH%
   rem // Save value of CD variable (current directory)
   set ABS_PATH=%CD%
   rem // Restore original directory
   popd   
   echo Relative path: %REL_PATH%
   echo Maps to path: %ABS_PATH%
   
   SET PREFIX=%ABS_PATH%\luarocks
   echo %PREFIX%
   INSTALL /P %PREFIX% /SELFCONTAINED /LV 5.1 /L /FORCECONFIG /F
   ```
   [source](https://stackoverflow.com/questions/1645843/resolve-absolute-path-from-relative-path-and-or-file-name)