
function fish_right_prompt
  set s $status
  if test $CMD_DURATION -a -n "$WINDOWID"
    # Check if terminal window is hidden
    set active_window (xdotool getactivewindow 2>/dev/null)
    if [ "$active_window" !=  "$WINDOWID" ]
      # Show notification if dration is more than 30 seconds
      if test $CMD_DURATION -gt 3000
        # Show duration of the last command in seconds
        set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
        eval notify-send (test "$s" -ne "0" && echo '--icon' error) "(echo (history | head -1) [$duration])"
      end
    end
  end
end
