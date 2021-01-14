# adminstration powershell:
# Set-ExecutionPolicy RemoteSigned
# new-item -ItemType SymbolicLink -Target "D:\Nextcloud\klesh\config\win\profile.ps1" -Path $profile


Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'


$Env:Path += ";$PSScriptRoot\bin"
$Env:KUBE_EDITOR = 'nvim'
$Env:EDITOR = 'nvim'
Set-Alias -Name k kubectl
$isPs7 = $host.Version.Major -ge 7
if ( $isPs7 ) {
    Set-Prompt
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

function pass-edit {
  param (
    [Parameter()]
    [String]
    $Path
  )

  $tmpfile = New-TemporaryFile
  gpg --decrypt $Path > $tmpfile.FullName
  nvim $tmpfile.FullName
  if ($? && ((gpg --list-secret-keys | findstr uid) -match '<(.*?)>')) {
    $uid=$matches[1]
    gpg -r $uid -o "${tmpfile.FullName}.gpg" --encrypt $tmpfile.FullName
    Move-Item -Path "${tmpfile.FullName}.gpg" -Destination "$Path" -Force
    Remove-Item $tmpfile.FullName -Force
  }
}