# adminstration powershell:
# Set-ExecutionPolicy RemoteSigned
# new-item -ItemType SymbolicLink -Target "D:\Nextcloud\klesh\config\win\profile.ps1" -Path $profile

#$env:POSH_GIT_ENABLED = $true

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

Import-Module posh-git
Import-Module oh-my-posh


$Dir = (Get-Item (Get-Item $PSCommandPath).Target).Directory.FullName
$Env:Path += ";$Dir\bin"
$Env:PSModulePath += ";$Dir\Modules"
$Env:KUBE_EDITOR = 'nvim'
$Env:EDITOR = 'nvim'
$Env:VIM_MODE = 'enhanced'
$Env:hosts = 'C:\Windows\System32\drivers\etc\hosts'
Set-Alias -Name k kubectl
Set-Alias -Name bm Open-Bookmark
Set-Alias -Name v nvim
$isPs7 = $host.Version.Major -ge 7
if ( $isPs7 ) {
    $GitPromptSettings.EnableFileStatus = $false
    if ((Get-Module oh-my-posh).Version.Major -eq 3) {
        Set-PoshPrompt -Theme fish
    } else {
        Set-Prompt -Theme fish
    }
}

function kcc { k config get-contexts $args }
function kcu { k config use-context $args}
function kgd { k get deployment $args}
function ked { k edit deployment $args}
function kgp { k get pod -o 'custom-columns=NAME:.metadata.name,IMG:.spec.containers[*].image,STATUS:.status.phase' $args}
function kl { k logs -f --all-containers $args}
function issh { ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null" $args }
function rf { ri -Recurse -Force $args }


function dp {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true,ValueFromRemainingArguments)]
      [String[]]
      $words
  )
  $word = $words | Join-String -Separator ' '
  Add-Type -AssemblyName presentationCore
  $tmpPath = Join-Path -Path $env:Temp -ChildPath 'sound.mp3'
  Invoke-WebRequest -Uri "http://dict.youdao.com/dictvoice?audio=$Word&type=1" -OutFile $tmpPath
  $mediaPlayer = New-Object system.windows.media.mediaplayer
  $mediaPlayer.Open($tmpPath)
  $mediaPlayer.Play()
  Start-Sleep -Seconds 2
  $mediaPlayer.Close()
}

function d {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory=$true,ValueFromRemainingArguments)]
      [String[]]
      $words
  )
  $word = $words | Join-String -Separator ' '
  $res = Invoke-WebRequest -Uri "https://cn.bing.com/dict/search" -Method GET -Body @{q=$word}
  if ($res.Content -match '<meta name="description" content="(.+?)" />') {
    $explain = $Matches[1] -replace '必应词典为您提供.+的释义，(.+)','$1'
    $explain = $explain -replace ' 网络释义',"`r`n网络释义"
    $explain = $explain -replace '，',"`r`n"
    Write-Host $explain
  } else {
    throw 'meta description not found'
  }
}

function vsbuild {
  Import-Module "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
  Enter-VsDevShell 56e7bf1c
}

function ssh-copy-id {
  [Cmdletbinding()]
  param (
    [Parameter()]
    [String]
    $IdentityFile="~/.ssh/id_rsa.pub",
    [Parameter(Mandatory=$true, Position=0)]
    [String]
    $UserHost
  )

  Get-Content $IdentityFile | ssh $UserHost "umask 077; mkdir -p .ssh ; cat >> .ssh/authorized_keys"
}

function f {
    [Cmdletbinding()]

    $tmpfile = New-TemporaryFile
    lf -last-dir-path $tmpfile
    $lastdir = Get-Content $tmpfile
    Remove-Item $tmpfile
    cd $lastdir
}
