if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

Set-ExecutionPolicy RemoteSigned

# link config files
$dotfiles=(Get-Item $PSScriptRoot).Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\win\profile.ps1 -Path $profile -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\mpv\mpv.conf -Path $Env:APPDATA\mpv\mpv.conf -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\mpv\scripts -Path $Env:APPDATA\mpv\scripts -Force

$sshconf="D:\Nextcloud\klesh\config\ssh\config"
if (Test-Path $sshconf -PathType Leaf) {
    New-Item -ItemType SymbolicLink -Target $sshconf -Path $home\.ssh\config -Force
}

# fix Shift key toggling Cn/En fro MS wubi
$wubiAction = New-ScheduledTaskAction -Execute 'Powershell.exe' `
  -Argument "-NoProfile -WindowStyle Hidden -File $PSScriptRoot\wubi-no-shift.ps1"
$wubiTrigger = New-ScheduledTaskTrigger -AtLogOn
Register-ScheduledTask -Action $wubiAction -Trigger $wubiTrigger -TaskName "Wubi No Shift" -Description "Disable Shift key toggling CN/EN" -RunLevel Highest