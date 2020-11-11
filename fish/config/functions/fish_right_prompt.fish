
function fish_right_prompt
    set s $status
    set duration (math $CMD_DURATION / 1000)s
    test $s -ne 0 && echo -n (set_color red) '✗' (set_color normal)
    test $CMD_DURATION -gt 100 && echo -n $duration

    # send desktop notification if duration greater than 3s when window is inactive
    test -z $CMD_DURATION -o \( $CMD_DURATION -lt 3000 \) && return
    test -z $WINDOWID && return
    set active_window (xdotool getactivewindow 2>/dev/null)
    test $active_window -eq $WINDOWID && return
    set message (history --max=1) [$duration]
    notify-send (test "$s" -ne 0 && echo '--icon=dialog-warning') $message
end
