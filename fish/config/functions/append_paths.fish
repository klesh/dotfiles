
function append_paths
    for f in $argv
        test -e $f && set -gx PATH $f $PATH
    end
end
