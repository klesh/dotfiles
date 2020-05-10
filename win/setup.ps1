Set-ExecutionPolicy RemoteSigned

$dotfiles=(Get-Item $PSScriptRoot).Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\win\profile.ps1 -Path $profile -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\mpv\mpv.conf -Path $Env:APPDATA\mpv\mpv.conf -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\config\mpv\scripts -Path $Env:APPDATA\mpv\scripts -Force

$sshconf="D:\Nextcloud\klesh\config\ssh\config"
if (Test-Path $sshconf -PathType Leaf) {
    New-Item -ItemType SymbolicLink -Target $sshconf -Path $home\.ssh\config -Force
}