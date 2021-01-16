# curl:     https://curl.se/windows/
# ag:       https://github.com/k-takata/the_silver_searcher-win32/releases
# fzf:      https://github.com/junegunn/fzf/releases/latest
Install-Module -Name PowerShellGet -Force -AllowPrerelease
Install-Module -Name posh-git
Install-Module -Name oh-my-posh
Install-Module -Name psfzf

$dotfiles=(Get-Item $PSScriptRoot).Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\win\profile.ps1 -Path $profile -Force
