function f --description='sync lf pwd to shell when exit'
    set tempfile (mktemp -t tmp.XXXXXX)
    command lf -last-dir-path $tempfile $argv
    if test -s $tempfile
        set dir (cat $tempfile)
        if test -n $dir -a -d $dir
            builtin cd -- $dir
        end
    end

    command rm -f -- $tempfile
end
