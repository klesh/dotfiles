#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up shell'

case "$PM" in
    apt)
        if ! has_cmd fish; then
            sudo add-apt-repository ppa:fish-shell/release-3 -y -n
            pm_update
            sudo apt install fish
        fi
        sudo apt install silversearcher-ag -y
        echo DISTRIB_RELEASE_MAJOR: $DISTRIB_RELEASE_MAJOR
        echo DISTRIB_RELEASE: $DISTRIB_RELEASE
        if [ "$DISTRIB_RELEASE_MAJOR" -gt 19 ] || [ "$DISTRIB_RELEASE" = "19.10" ]; then
            sudo apt install dash bat  -y
        fi
        sudo ln -sf /usr/bin/batcat /usr/bin/bat
        intorepo https://github.com/junegunn/fzf.git "$HOME/.fzf"
        ./install --all
        exitrepo
        ;;
    pacman)
        sudo pacman -S --noconfirm --needed fish the_silver_searcher dash bat fzf
        # prevent bash upgradation relink /bin/sh
        sudo mkdir -p /etc/pacman.d/hooks
        echo "
        [Trigger]
        Type = Package
        Operation = Install
        Operation = Upgrade
        Target = bash

        [Action]
        Description = Re-pointing /bin/sh symlink to dash...
        When = PostTransaction
        Exec = /usr/bin/ln -sfT dash /usr/bin/sh
        Depends = dash
        " | sed 's/^ *//' | sudo tee /etc/pacman.d/sh-is-dash.hook >/dev/null
        ;;
esac

# xclip/xsel for wsl
if [ -n "$WSL" ]; then
    lnsf "$PDIR/bin/x-clip" "$HOME/.local/bin/xsel"
    lnsf "$PDIR/bin/x-clip" "$HOME/.local/bin/xclip"
fi


# only for local machine with gui
if [ -z "$SSH_CLIENT" ] && [ -n "$DISPLAY" ] && has_cmd dash; then
    log 'Setting up dash as default shell'
    sudo /usr/bin/ln -sfT dash /usr/bin/sh

    if [ "$(awk -F':' '/^'"$USER"'/{print $7}' /etc/passwd)" != "/bin/sh" ]; then
        chsh -s /bin/sh
    fi
fi


log 'Setting up fish'
lnsf "$DIR/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
lnsf "$DIR/fish/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
lnsf "$DIR/fish/functions/fish_right_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_right_prompt.fish"
lnsf "$DIR/fish/functions/fisher.fish" "$XDG_CONFIG_HOME/fish/functions/fisher.fish"
lnsf "$DIR/fish/functions/r.fish" "$XDG_CONFIG_HOME/fish/functions/r.fish"
lnsf "$DIR/fish/functions/f.fish" "$XDG_CONFIG_HOME/fish/functions/f.fish"
lnsf "$DIR/fish/functions/append_paths.fish" "$XDG_CONFIG_HOME/fish/functions/append_paths.fish"
lnsf "$DIR/fish/functions/source_files.fish" "$XDG_CONFIG_HOME/fish/functions/source_files.fish"
lnsf "$DIR/fish/functions/git_clone_all.fish" "$XDG_CONFIG_HOME/fish/functions/git_clone_all.fish"

# install plugins
# for better keybinding: C-o open file with $EDITOR / C-r search history / C-g open with xdg-open
fish -c "fisher add jethrokuan/fzf"

# set color theme: Old School
fish -c '
set -L
set -U fish_color_normal normal
set -U fish_color_command 00FF00
set -U fish_color_quote 44FF44
set -U fish_color_redirection 7BFF7B
set -U fish_color_end FF7B7B
set -U fish_color_error A40000
set -U fish_color_param 30BE30
set -U fish_color_comment 30BE30
set -U fish_color_match --background=brblue
set -U fish_color_selection white --bold --background=brblack
set -U fish_color_search_match bryellow --background=brblack
set -U fish_color_history_current --bold
set -U fish_color_operator 00a6b2
set -U fish_color_escape 00a6b2
set -U fish_color_cwd green
set -U fish_color_cwd_root red
set -U fish_color_valid_path --underline
set -U fish_color_autosuggestion 777777
set -U fish_color_user brgreen
set -U fish_color_host normal
set -U fish_color_cancel -r
set -U fish_pager_color_completion normal
set -U fish_pager_color_description B3A06D yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brwhite --background=cyan
' > /dev/null
