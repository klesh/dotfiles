#!/bin/sh

set -e
DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

log 'Setting up shell'

case "$PM" in
    apt)
        ! command -v pip3 && "$PDIR/python/install.sh"
        sudo add-apt-repository ppa:fish-shell/release-3 -y
        sudo apt update
        sudo apt install fish silversearcher-ag dash bat -y
        lnsf /usr/bin/batcat "$HOME/.local/bin/bat"
        intorepo https://github.com/junegunn/fzf.git "$HOME/.fzf"
        ./install --all
        exitrepo
        ;;
    pacman)
        sudo pacman -S  --noconfirm --needed fish the_silver_searcher dash bat fzf
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

log 'Setting up bat'
BAT_THEMES="$(bat --config-dir)/themes"
BAT_GRUVBOX="$BAT_THEMES/gruvbox"
if [ ! -d "$BAT_GRUVBOX" ]; then
    mkdir -p "$BAT_THEMES"
    git_clone https://github.com/peaceant/gruvbox.git "$BAT_GRUVBOX"
fi

log 'Setting up dash as default shell'
sudo /usr/bin/ln -sfT dash /usr/bin/sh
[ "$(awk -F':' '/^'"$USER"'/{print $7}' /etc/passwd)" != "/bin/sh" ] && chsh -s /bin/sh


log 'Setting up fish'
lnsf "$DIR/fish/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
lnsf "$DIR/fish/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
lnsf "$DIR/fish/functions/fish_right_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_right_prompt.fish"
lnsf "$DIR/fish/functions/fisher.fish" "$XDG_CONFIG_HOME/fish/functions/fisher.fish"
lnsf "$DIR/fish/functions/r.fish" "$XDG_CONFIG_HOME/fish/functions/r.fish"
lnsf "$DIR/fish/functions/append_paths.fish" "$XDG_CONFIG_HOME/fish/functions/append_paths.fish"
lnsf "$DIR/fish/functions/source_files.fish" "$XDG_CONFIG_HOME/fish/functions/source_files.fish"

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
