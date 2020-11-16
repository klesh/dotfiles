
function print_colors -d 'print out all terminal colors'
    set x (tput op)
    set y (printf '%76s')
    for i in (seq 256)
        printf "%3s %s%s%s%s\n" $i (tput setaf $i) (tput setab $i) $y $x
    end
end
