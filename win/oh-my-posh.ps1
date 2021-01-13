# Install-Module -Name PowerShellGet -Force -AllowPrerelease
# Install-Module -Name posh-git
# Install-Module -Name oh-my-posh

$dotfiles=(Get-Item $PSScriptRoot).Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\win\profile.ps1 -Path $profile -Force
