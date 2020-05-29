# adminstration powershell:
# Set-ExecutionPolicy RemoteSigned
# new-item -ItemType SymbolicLink -Target "D:\Nextcloud\klesh\config\win\profile.ps1" -Path $profile


Set-PSReadLineOption -EditMode Emacs
$Env:Path += ";$PSScriptRoot\bin"

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