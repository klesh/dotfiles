# curl:             https://curl.se/windows/
# ag:               https://github.com/k-takata/the_silver_searcher-win32/releases
# fzf:              https://github.com/junegunn/fzf/releases/latest     (2.7.2 not working with psfzf)
# utf-8 for i18n:   Settings and then: All Settings -> Time & Language -> Language -> "Administrative Language Settings"
$PSDefaultParameterValues = @{ "*:Proxy"="http://localhost:2021" }
#Install-Module -Name PowerShellGet -Force -AllowPrerelease
Register-PSRepository -Default -InstallationPolicy Trusted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted
Install-Module -Name posh-git
Install-Module -Name oh-my-posh
Install-Module -Name psfzf

$dotfiles=(Get-Item $PSScriptRoot).Parent.Parent.FullName
New-Item -ItemType SymbolicLink -Target $dotfiles\win\profile.ps1 -Path $profile -Force
