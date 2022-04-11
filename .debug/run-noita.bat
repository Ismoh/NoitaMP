
set noita-exe=""
set noita-dev-exe=""

FOR /f "tokens=2 delims==" %%d IN ('wmic logicaldisk where "drivetype=3" get name /format:value') DO (
    echo %%d

    set %noita-exe% = CALL where /r %%d noita.exe
    echo %noita-exe%

    set %noita-dev-exe% = CALL where /r %%d noita_dev.exe
    echo %noita-dev-exe%
)

exec %noita-exe%
exec %noita-dev-exe%

pause
