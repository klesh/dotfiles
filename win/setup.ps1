# execute this first: Set-ExecutionPolicy RemoteSigned

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -Verb RunAs "-NoProfile -ExecutionPolicy Bypass -Command `"cd '$pwd'; & '$PSCommandPath';`"";
    exit;
}

# link config files
$dotfiles=(Get-Item $PSScriptRoot).Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\win\profile.ps1 -Path $profile -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\mpv\mpv.conf -Path $Env:APPDATA\mpv\mpv.conf -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\mpv\scripts -Path $Env:APPDATA\mpv\scripts -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\nvim -Path $Env:LOCALAPPDATA\nvim -Force
Remove-Item -Force -Recurse $Env:APPDATA\pip
New-Item -ItemType Directory -Path $Env:APPDATA\pip
New-Item -ItemType SymbolicLink -Target $dotfiles\pip\pip.conf -Path $Env:APPDATA\pip\pip.ini -Force

# fix Shift key toggling Cn/En fro MS wubi
#if (-not (Get-ScheduledTask -TaskName "Wubi No Shift")) {
  #$wubiAction = New-ScheduledTaskAction -Execute 'Powershell.exe' `
    #-Argument "-NoProfile -WindowStyle Hidden -File $PSScriptRoot\wubi-no-shift.ps1"
  #$wubiTrigger = New-ScheduledTaskTrigger -AtLogOn
  #Register-ScheduledTask -Action $wubiAction -Trigger $wubiTrigger -TaskName "Wubi No Shift" -Description "Disable Shift key toggling CN/EN" -RunLevel Highest
#}

Install-Module -Name PowerShellGet -Force -AllowPrerelease
Install-Module -Name posh-git
Install-Module -Name oh-my-posh

# replace notepad with nvim-qt
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\notepad.exe" /v "Debugger" /t REG_SZ /d "${dotfiles}\win\npd.vbs" /f

