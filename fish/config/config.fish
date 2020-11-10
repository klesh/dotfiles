#!/usr/bin/env fish

# datetime in filename format
function dt
    date "+%Y%m%d-%H%M%S"
end

function clean-taobao-link
    xsel -ob | sed 's/^\(.*\)?\(.*&\)\?\(id=[^&]\+\).*$/\1?\3/g' | xsel -b
end

# for WSL
function sync-ssh-config
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

function swap-caps-esc
    setxkbmap -option caps:swapescape
end

function caps-to-grave
    xmodmap -e "clear Lock"
    xmodmap -e "keycode 66 = grave asciitilde"
end

# print out all colors with their index
function show-colors
    bash -c '(x=`tput op` y=`printf %76s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)'
end

if status is-interactive
    set -gx EDITOR nvim

    # enable fzf completion hotkey
    set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
    set -U FZF_COMPLETE 0
    set -U FZF_FIND_FILE_COMMAND 'ag -g ""'
    set -U FZF_OPEN_COMMAND 'ag -g ""'
    # no line-wrapping, good for `docker ps`
    set -gx LESS "-SRXF"
    # nvm plugin
    set -gx nvm_mirror http://npm.taobao.org/mirrors/node
    # change OTHER-WRITABLE color for `ls` command
    set -gx LS_COLORS 'ow=34;42;40'
    # ranger highlighting color theme
    set -gx HIGHLIGHT_OPTIONS --style=solarized-dark
    # dict.sh
    set -gx D_SELECTOR 'plainsel'

    # tune git icon for nerdfont
    set -g __fish_git_prompt_char_upstream_ahead '>'
    set -g __fish_git_prompt_char_upstream_behind '<'
    set -g __fish_git_prompt_char_upstream_prefix ''

    set -g __fish_git_prompt_char_stagedstate '●'
    set -g __fish_git_prompt_char_dirtystate '*'
    set -g __fish_git_prompt_char_untrackedfiles '+'
    set -g __fish_git_prompt_char_conflictedstate 'x'
    set -g __fish_git_prompt_char_cleanstate '✔ '

    function append-path-if-exists
        if test -e $argv
            set -gx PATH $argv $PATH
      end
    end

    function source-file-if-exists
        for f in $argv
            test -e $f && source $f && return
        end
    end

    function r --description='sync ranger pwd to shell when exit'
        set tempfile (mktemp -t tmp.XXXXXX)
        command ranger --choosedir=$tempfile $argv
        if test -s $tempfile
            set ranger_pwd (cat $tempfile)
            if test -n $ranger_pwd -a -d $ranger_pwd
                builtin cd -- $ranger_pwd
            end
        end

        command rm -f -- $tempfile
    end

    append-path-if-exists ~/.yarn/bin
    alias k="kubectl"
    alias kcc="k config get-contexts"
    alias kcu="k config use-context"
    alias kgd="k get deployment"
    alias ked="k edit deployment"
    alias kgp="k get pod -o 'custom-columns=NAME:.metadata.name,IMG:.spec.containers[*].image,STATUS:.status.phase'"
    alias kl="k logs -f --all-containers"
    alias issh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
    alias iscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
    cd $last_pwd
    source-file-if-exists /usr/share/autojump/autojump.fish /usr/local/share/autojump/autojump.fish
    source-file-if-exists ~/.profile.fish
end

