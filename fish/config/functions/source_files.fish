
function source_files
    for f in $argv
        test -e $f && source $f && return
    end
end
