# https://sourceforge.net/projects/mpv-player-windows/files/
$v = Mount-DiskImage $args[0] | Get-Volume
D:\Programs\mpv\mpv.com "$($v.DriveLetter):\\"
Dismount-DiskImage $args[0]