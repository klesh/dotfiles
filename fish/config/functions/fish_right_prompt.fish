
function fish_right_prompt
    set s $status
    test -z $CMD_DURATION -o \( $CMD_DURATION -lt 3000 \) && return
    test -z $WINDOWID && return
    set active_window (xdotool getactivewindow 2>/dev/null)
    test $active_window -eq $WINDOWID && return
    set duration (math $CMD_DURATION / 1000)s
    set message (history --max=1) [$duration]
    notify-send (test "$s" -ne 0 && echo '--icon' error) $message
end
