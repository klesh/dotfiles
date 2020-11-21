
function sync_ssh_config -d 'sync ssh config file for wsl'
    # sshconfig has a restricted file permission requirement which normally hard to
    # be met on Window (i.e., syncing your config by Nextcloud on drive D).
    # this function pours contents of files within ~/.ssh/config.d to ~/.ssh/config
    if test -d ~/.ssh/config.d
        rm -rf ~/.ssh/config
        for cfg in (ls ~/.ssh/config.d)
            cat ~/.ssh/config.d/$cfg >> ~/.ssh/config
        end
        chmod 600 ~/.ssh/config
    end
end
