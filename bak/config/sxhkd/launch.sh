#!/bin/bash

# Terminate already running bar instances
killall -q sxhkd

# Wait until the processes have been shut down
while pgrep -x axhkd >/dev/null; do sleep 1; done

# Start daemon
sxhkd &
