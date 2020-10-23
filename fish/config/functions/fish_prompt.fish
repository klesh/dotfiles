set -g __fish_git_prompt_show_informative_status 1

# Defined in /tmp/fish.hyt5lE/fish_prompt.fish @ line 2
function fish_prompt --description 'Write out the prompt'
    set -U last_pwd $PWD
    set -l color_cwd
    set -l suffix
    switch "$USER"
        case root toor
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            else
                set color_cwd $fish_color_cwd
            end
            set suffix '#'
        case '*'
            set color_cwd $fish_color_cwd
            set suffix '>'
    end

    echo -n -s "["(set_color blue) "$USER" (set_color normal) @ (set_color brmagenta) (prompt_hostname) (set_color normal) '] ' (set_color $color_cwd) (prompt_pwd) (set_color normal)
    if set -q VIRTUAL_ENV
        echo -n -s (set_color -b blue white) "(" (basename "$VIRTUAL_ENV") ")" (set_color normal)
    end
    echo -n -s (fish_git_prompt)
    echo -n -s "$suffix "
end
