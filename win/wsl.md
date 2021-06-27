# GUI

## X11 for Windows

1. download and install [vcxsrc](https://sourceforge.net/projects/vcxsrv/)
2. double click on XLaunch to launch vcxsrc for Windows
3. put following setting to `~/.profile.fish`
```fish
set -gx DISPLAY (winip):0.0
# window size scaling factor
set -gx GDK_SCALE 0.5
# dpi scaling factor
set -gx GDK_DPI_SCALE 2
```

## PulseAudio for Windows

### Windows Part
1. download and extract [pluseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/) to your preferred location
2. append following line to `etc/default.pa`:
```
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12
```
3. append following line to `etc/daemon.conf`:
```
exit-idle-time = -1
```
4. run `bin/pulseaudio.exe` on `cmd/powershell` to start up pulaudio-server for testing
5. using `nssm` [nssm](https://nssm.cc/download) to make `pulseaudio` run as system service

### WSL Part
1. install package
```sh
sudo apt install libpulse0
```
2. setup environment variables on `~/.profile.fish`:
```fish
set -gx PULSE_SERVER tcp:(winip)
```
3. play sound using `ffplay` to test
