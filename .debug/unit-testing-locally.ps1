cd "D:\______BACKUP\NoitaMP_repo\NoitaMP\.debug\"

$message1 = "Do you want to test if LuaJIT-2.0.4 is installed? [y/n]"
$no1 = New-Object System.Management.Automation.Host.ChoiceDescription "&n"
$yes1 = New-Object System.Management.Automation.Host.ChoiceDescription "&y"
$options1 = [System.Management.Automation.Host.ChoiceDescription[]]($no1, $yes1)
Write-Output $message1
$result1 = $host.ui.PromptForChoice($title1, $message1, $options1, 0)
switch ($result1)
{
    0 {
        "LuaJIT-2.0.4 might be installed?! User chose: $result1"
    }
    1 {
        "Yes please install LuaJIT-2.0.4. User chose: $result1"
    }
}

if ($result1 -eq 1)
{
    Start-Process -FilePath "C:\Program Files (x86)\LuaJIT-2.0.4\bin\luajit.exe" -Wait
    if ($LASTEXITCODE -eq 0)
    {
        Write-Output "luajit is installed. Nothing to do."
    }
    else
    {
        Write-Output "luajit is not installed. Read further steps."

        $message = "Do you want to install LuaJIT-2.0.4? [y/n]"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&n"
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&y"
        $options = [System.Management.Automation.Host.ChoiceDescription[]]($no, $yes)
        Write-Output $message
        $result = $host.ui.PromptForChoice($title, $message, $options, 0)
        switch ($result)
        {
            0 {
                "You selected No."
            }
            1 {
                "You selected Yes."
            }
        }

        if ($result -eq 1)
        {
            ### Build
            robocopy "..\.building\LuaJIT-2.0.4\" "..\temp\LuaJIT-2.0.4" /s /e
            cd "..\temp\LuaJIT-2.0.4"
            mingw32-make PLAT = mingw

            ### Install
            ### binaries
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\bin" luajit.exe
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\bin" lua51.dll

            ### modules written in lua
            robocopy "src\jit\" "C:\Program Files (x86)\LuaJIT-2.0.4\jit" /s /e

            ### includes
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\include" luaconf.h
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\include" lua.h
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\include" lualib.h
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\include" lauxlib.h
            robocopy "src\" "C:\Program Files (x86)\LuaJIT-2.0.4\include" lua.hpp

            Write-Output "LuaJIT-2.0.4 is installed."
            Write-Output "Executing luajit.exe -v"
            Start-Process -FilePath "C:\Program Files (x86)\LuaJIT-2.0.4\bin\luajit.exe" -ArgumentList " -v" -Wait -NoNewWindow
            Write-Output "Executing luajit.exe -e `"print(_VERSION)`""
            Start-Process -FilePath "C:\Program Files (x86)\LuaJIT-2.0.4\bin\luajit.exe" -ArgumentList " -e `"print(_VERSION)`"" -Wait -NoNewWindow
        }
    }
}

$message3 = "Do you want to adjust/extend LUA_PATH and LUA_CPATH? [y/n]"
$no3 = New-Object System.Management.Automation.Host.ChoiceDescription "&n"
$yes3 = New-Object System.Management.Automation.Host.ChoiceDescription "&y"
$options3 = [System.Management.Automation.Host.ChoiceDescription[]]($no3, $yes3)
Write-Output $message3
$result3 = $host.ui.PromptForChoice($title3, $message3, $options3, 0)
switch ($result3)
{
    0 {
        "Never touch my LUA_PATH and LUA_CPATH! User chose: $result1"
    }
    1 {
        "Yes please adjust my LUA_PATH and LUA_CPATH. User chose: $result1"
    }
}

if ($result3 -eq 1)
{
    Write-Output "Executing D:\______BACKUP\NoitaMP_repo\NoitaMP\mods\noita-mp\files\scripts\init\init_.lua, D:\______BACKUP\NoitaMP_repo\NoitaMP, D:\______BACKUP\NoitaMP_repo\NoitaMP -Wait -NoNewWindow"
    Start-Process -FilePath "C:\Program Files (x86)\LuaJIT-2.0.4\bin\luajit.exe" -ArgumentList "D:\______BACKUP\NoitaMP_repo\NoitaMP\mods\noita-mp\files\scripts\init\init_.lua", "D:\______BACKUP\NoitaMP_repo\NoitaMP", "D:\______BACKUP\NoitaMP_repo\NoitaMP" -Wait -NoNewWindow

    $luaPath = Get-Content D:\______BACKUP\NoitaMP_repo\NoitaMP\lua_path.txt -Raw
    [Environment]::SetEnvironmentVariable("LUA_PATH", $env:LUA_PATH + ";" + $luaPath, "Machine")

    $luacPath = Get-Content D:\______BACKUP\NoitaMP_repo\NoitaMP\lua_cpath.txt -Raw
    [Environment]::SetEnvironmentVariable("LUA_CPATH", $env:LUA_CPATH + ";" + $luacPath, "Machine")
}

$files = Get-ChildItem -Path "D:\______BACKUP\NoitaMP_repo\NoitaMP\.testing\tests" -Filter *.lua -Recurse
foreach ($file in $files) # https://stackoverflow.com/a/11568420/3493998
{
    Write-Host "Running lua file $file"
    Start-Process -FilePath "C:\Program Files (x86)\LuaJIT-2.0.4\bin\luajit.exe" -ArgumentList $file.FullName,"-o","text","--verbose","D:\______BACKUP\NoitaMP_repo\NoitaMP" -Wait -NoNewWindow
    # https://stackoverflow.com/a/45330000/3493998
    # & 'C:\Program Files (x86)\LuaJIT-2.0.4\bin\luajit.exe' $file.FullName -o text --verbose >> "D:\______BACKUP\NoitaMP_repo\NoitaMP\.testing\testresult.log"
    type ..\\.testing\testresult.log
}
