#!/bin/sh


# reference: https://askubuntu.com/questions/282245/ssh-login-wakes-spun-down-storage-drives

[ ! -f /usr/lib/update-notifier/update-motd-fsck-at-reboot.bak ] && \
    sudo cp /usr/lib/update-notifier/update-motd-fsck-at-reboot /usr/lib/update-notifier/update-motd-fsck-at-reboot.bak


awk '
    $0 ~ /^now=/ {
        S=1
    }
    S==1 && $0 ~ /NEEDS_FSCK_CHECK/ {
        sub(/yes/, "")
    }
    {
        print
    }
' /usr/lib/update-notifier/update-motd-fsck-at-reboot.bak \
    | sudo tee /usr/lib/update-notifier/update-motd-fsck-at-reboot >/dev/null
