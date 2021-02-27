
$dotfiles=(Get-Item $PSScriptRoot).Parent.Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\gui\mpv\mpv.conf -Path $Env:APPDATA\mpv\mpv.conf -Force
New-Item -ItemType SymbolicLink -Target $dotfiles\gui\mpv\scripts -Path $Env:APPDATA\mpv\scripts -Force
