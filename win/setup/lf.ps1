# https://github.com/gokcehan/lf/releases/latest

$dotfiles=(Get-Item $PSScriptRoot).Parent.Parent.FullName
New-Item -Force -ItemType SymbolicLink -Target $dotfiles\cli\lf\lfrc.win -Path $Env:LOCALAPPDATA\lf\lfrc
