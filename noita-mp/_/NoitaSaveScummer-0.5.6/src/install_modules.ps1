if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process -Wait powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs; exit }

Write-Output "Installing packages: {$args}`n"
Start-Sleep -s 1
python -m pip install $args

Write-Host -NoNewLine "`nPress any key to exit";
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');