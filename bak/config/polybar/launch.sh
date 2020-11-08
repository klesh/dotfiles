#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
#polybar example &

PRIMARY=$(xrandr | grep primary | cut -d' ' -f1)
echo $PRIMARY
MONITOR=$PRIMARY polybar example -c ~/.config/polybar/config-internal &
for i in $(polybar -m | grep -v $PRIMARY | awk -F: '{print $1}'); do
  echo $i
  MONITOR=$i polybar example -c ~/.config/polybar/config &
done
nitrogen --restore
echo "Bars launched..."
