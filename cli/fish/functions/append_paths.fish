
function append_paths
    for f in $argv
        test -e $f && ! contains $f $PATH && set -gx PATH $f $PATH
    end
end
