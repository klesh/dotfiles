
$dotfiles=(Get-Item $PSScriptRoot).Parent.FullName
New-Item -Force -ItemType SymbolicLink -Target $dotfiles\win\WindowsTerminal\settings.json -Path $Env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
