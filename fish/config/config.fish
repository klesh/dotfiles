#!/usr/bin/env fish

set -gx EDITOR nvim

# enable fzf completion hotkey
set -U FZF_COMPLETE 0
# no line-wrapping, good for `docker ps`
set -gx LESS "-SRXF"
# nvm plugin
set -gx nvm_mirror http://npm.taobao.org/mirrors/node
# change OTHER-WRITABLE color for `ls` command
set -gx LS_COLORS 'ow=34;42;40'
# ranger highlighting color theme
set -gx HIGHLIGHT_OPTIONS --style=solarized-dark

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
    if test -e $argv
        source $argv
  end
end

source-file-if-exists /usr/share/autojump/autojump.fish
source-file-if-exists /usr/local/share/autojump/autojump.fish
source-file-if-exists ~/.cargo/env

append-path-if-exists /usr/local/bin
append-path-if-exists ~/.local/bin
append-path-if-exists ~/.yarn/bin
append-path-if-exists /snap/bin


# datetime in filename format
function dt
    date "+%Y%m%d-%H%M%S"
end

# translation
function d
    set meta (
        curl -SsLG "http://cn.bing.com/dict/search" --data-urlencode "q=$argv" | \
        string match -r '<meta name="description" content="必应词典为您提供.+的释义，(.+?)" />'
    )
    set trans (string replace -ra '\W(?=(\w+\.|网络释义：))' \n $meta[2])
    string join \n $trans
end

# pronounciation
function dp
    set play afplay
    if not which $play 2>/dev/null
        set play ffplay -nodisp -autoexit
    end
    wget -O /tmp/sound.mp3 "http://dict.youdao.com/dictvoice?audio=$argv[1]&type=1" &>/dev/null
    and eval $play /tmp/sound.mp3 1>/dev/null 2>/dev/null
end

function clean-taobao-link
    echo "$argv" | sed 's/^\(.*\)?\(.*&\)\?\(id=[^&]\+\).*$/\1?\3/g' | xsel -sb
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

# auto startx
if test -z "$STARTED" -a -z "$DISPLAY" -a -n "$XDG_VTNR" -a "$XDG_VTNR" -eq "1"
    set -gx STARTED true
    startx
end

if status is-interactive
    alias k="kubectl"
    alias kcc="k config get-contexts"
    alias kcu="k config use-context"
    alias kgd="k get deployment"
    alias ked="k edit deployment"
    alias kgp="k get pod -o 'custom-columns=NAME:.metadata.name,IMG:.spec.containers[*].image,STATUS:.status.phase'"
    alias kl="k logs -f --all-containers"
    alias issh='ssh -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
    alias iscp='scp -o "StrictHostKeyChecking=no" -o "UserKnownHostsFile=/dev/null"'
    set -q virtualfish || set -U virtualfish (
        which pip &>/dev/null && pip show virtualfish &>/dev/null && \
        python -m virtualfish auto_activation
    )
    test -n $virtualfish && eval $virtualfish
    cd $last_pwd
    source-file-if-exists ~/.profile.fish
end

