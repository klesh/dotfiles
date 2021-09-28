# Adjust speed, scrolling direction

1. install `xinput`
2. `xinput list` to find out your touchpad id
3. `xinput list-props <device_id>` to find settings
   ```sh
   libinput Natural Scrolling Enabled (298):       0
   libinput Natural Scrolling Enabled Default (299):       0
   ```
4. `xinput set-prop 298 1` to set Natural Scrolling
5. `xinput set-prop 299 1` to set Natural Scrolling

id can be replaced by name

```bash
#!/bin/sh

xinput set-prop "06CB0001:00 06CB:CE78 Touchpad" "libinput Natural Scrolling Enabled" 1
xinput set-prop "06CB0001:00 06CB:CE78 Touchpad" "libinput Accel Speed" 0.4
```

