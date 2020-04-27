#!/usr/bin/env fish

if pgrep -x picom > /dev/null
  killall -q picom
else
  set dir (dirname (status --current-filename))
  $dir/launch.sh
end
