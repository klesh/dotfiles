
enable power save
```
hdparm -B 127 /dev/sdX
```

set spindown time to 20min (1-240) x 5sec
```
hdparm -S 240 /dev/sdX
```

check current state
```
hdparm -C /dev/sdX
```

to persistent configuration across reboot using udev rule, please put the following content to `/etc/udev/rules.d/69-hdparm.rules`
```
ACTION=="add|change", KERNEL=="sd[a-z]", ATTRS{queue/rotational}=="1", RUN+="/usr/bin/hdparm -B 127 -S 240 /dev/%k"
```

for more detail: https://wiki.archlinux.org/title/hdparm
