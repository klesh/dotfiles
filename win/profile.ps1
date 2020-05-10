# adminstration powershell:
# Set-ExecutionPolicy RemoteSigned
# new-item -ItemType SymbolicLink -Target "D:\Nextcloud\klesh\config\win\profile.ps1" -Path $profile


Set-PSReadLineOption -EditMode Emacs

Function dp ($Word) {
  Add-Type -AssemblyName presentationCore
  $tmpPath = Join-Path -Path $env:Temp -ChildPath 'sound.mp3'
  Invoke-WebRequest -Uri "http://dict.youdao.com/dictvoice?audio=$Word&type=1" -OutFile $tmpPath
  $mediaPlayer = New-Object system.windows.media.mediaplayer
  $mediaPlayer.Open($tmpPath)
  $mediaPlayer.Play()
  Start-Sleep -Seconds 2
  $mediaPlayer.Close()
}

