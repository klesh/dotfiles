#!/bin/fish

if status is-interactive
    # === default programs
    set -gx EDITOR nvim
    set -gx GOPROXY https://goproxy.io,direct

    # === fzf configuration
    set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
    set -gx FZF_COMPLETE 0
    set -gx FZF_FIND_FILE_COMMAND 'ag -g ""'
    set -gx FZF_OPEN_COMMAND 'ag -g ""'
    set -gx FZF_DEFAULT_OPTS '--height 40% --preview "bat --style=numbers --color=always --line-range :500 {}"'

    # === less configuration
    # no line-wrapping, good for `docker ps`
    #set -gx LESS "-SRXF"
    set -gx LESS "-SRX" # for nnn help to how, remove F

    # === nvm configuration
    set -gx nvm_mirror http://npm.taobao.org/mirrors/node

    # === `ls` configuration
    # change OTHER-WRITABLE color for `ls` command
    set -gx LS_COLORS 'ow=34;42;40'

    # === nnn configuration
    set -gx NNN_PLUG 'c:fzcd;m:nmount;x:!chmod +x $nnn;X:!chmod -x $nnn;d:dragdrop;p:preview-tui'
    set -gx NNN_FIFO /tmp/nnn.fifo
    set -gx NNN_ARCHIVE '\.(7z|a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)$'

    # === bat configuration
    set -gx BAT_THEME 'OneHalfDark'
    #set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

    # === dict.sh configuration
    set -gx D_SELECTOR 'plainsel'

    # === fish git prompt configuration
    # tune git icon for nerdfont
    set -g __fish_git_prompt_char_upstream_ahead '>'
    set -g __fish_git_prompt_char_upstream_behind '<'
    set -g __fish_git_prompt_char_upstream_prefix ''
    set -g __fish_git_prompt_char_stagedstate '●'
    set -g __fish_git_prompt_char_dirtystate '*'
    set -g __fish_git_prompt_char_untrackedfiles '+'
    set -g __fish_git_prompt_char_conflictedstate 'x'
    set -g __fish_git_prompt_char_cleanstate '✔ '

    # === alias
    alias k="kubectl"
    alias kcc="k config get-contexts"
    alias kcu="k config use-context"
    alias kgd="k get deployment"
    alias ked="k edit deployment"
    alias kgp="k get pod -o 'custom-columns=NAME:.metadata.name,IMG:.spec.containers[*].image,STATUS:.status.phase'"
    alias kl="k logs -f --all-containers"
    alias issh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
    alias iscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
    alias dt='date "+%Y%m%d-%H%M%S"'
    alias cnpm="npm --registry=https://registry.npmmirror.com \
            --cache=$HOME/.npm/.cache/cnpm \
            --disturl=https://npmmirror.com/dist \
            --userconfig=$HOME/.cnpmrc"

    # === PATH and file sourcing
    append_paths ~/go/bin \
        ~/bin \
        ~/.local/bin \
        ~/.yarn/bin \
        ~/.config/yarn/global/node_modules/.bin \
        ~/dotfiles/bin \
        ~/dotfiles/devops/bin \
        ~/Nextcloud/bin \
        /usr/local/go/bin
    source_files /usr/share/autojump/autojump.fish /usr/local/share/autojump/autojump.fish \
        ~/.jabba/jabba.fish \
        ~/.asdf/asdf.fish \
        ~/.profile.fish

    # === auto cd into last activated directory
    test "$PWD" = "$HOME" && cd $last_pwd

    function loadenv
        while read -l line
            set -l line (string trim $line)
            if [ -z "$line" ]
                continue
            end
            if string match -q '#*' $line
                continue
            end
            set pair (string split -m 1 '=' -- $line)
            if string match -q "'*" $pair[2]; or string match -q '"*' $pair[2]
                eval "set -gx $pair[1] $pair[2]"
            else
                if not eval "export $pair[1]=\"$pair[2]\""
                   echo failed to export pair $pair
                   return
                end
            end
        end < $argv[1]
    end

    #function readenv --on-variable PWD
       #if test -r .env
            #loadenv .env
       #end
    #end
    #readenv
end

