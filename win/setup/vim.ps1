
$dotfiles=(Get-Item $PSScriptRoot).Parent.Parent.FullName
if ( ! (Test-Path $Env:LOCALAPPDATA\nvim) ) {
    New-Item -ItemType Directory -Path $Env:LOCALAPPDATA\nvim
}
New-Item -Force -ItemType SymbolicLink -Target $dotfiles\cli\vim\init.vim -Path $Env:LOCALAPPDATA\nvim\init.vim
New-Item -Force -ItemType SymbolicLink -Target $dotfiles\cli\vim\coc-settings.json -Path $Env:LOCALAPPDATA\nvim\coc-settings.json
