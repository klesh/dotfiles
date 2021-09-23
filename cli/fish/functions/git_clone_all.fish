function git_clone_all
    for remote_branch in (git branch -r | awk '{print $1}')
        set local_branch (basename $remote_branch)
        if not git rev-parse --verify "$local_branch"
            git branch --track $local_branch $remote_branch
        end
    end
end
