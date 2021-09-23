function winip
    grep nameserver /etc/resolv.conf | awk '{print $2}'
end
