@REM setlocal enabledelayedexpansion

@REM FOR /f "tokens=2 delims==" %%d IN ('wmic logicaldisk where "drivetype=3" get name /format:value') DO (

@REM     echo %%d
@REM     cd /d %%d

@REM     for /f "tokens=* delims=" %%a in ('dir /s /b noita.exe') do set "noita_exe=%%a"
@REM     echo %%noita_exe%%=%noita_exe%

@REM     for /f "tokens=*" %%a in ('dir /s /b noita_dev.exe') do set "noita_dev_exe=%%a"
@REM     echo %%noita_dev_exe%%=%noita_dev_exe%
@REM )

@REM endlocal

start "" "C:\Program Files (x86)\Steam\steamapps\common\Noita\noita.exe"
start "" "C:\Program Files (x86)\Steam\steamapps\common\Noita\noita_dev.exe" -lua_debug