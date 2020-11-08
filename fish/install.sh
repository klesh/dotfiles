#!/bin/sh

DIR=$(dirname "$(readlink -f "$0")")
. "$DIR/../env.sh"

# install fish shell
echo Installing fish shell
case "$PM" in
    apt)
        ! command -v pip3 && "$PDIR/python/install.sh"
        sudo add-apt-repository ppa:fish-shell/release-3 -y
        sudo apt update
        sudo apt install fish libnotify-bin xdotool silversearcher-ag dash -y
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
        ;;
    pacman)
        sudo pacman -S --needed --needed fish xdotool fzf the_silver_searcher dash
        # prevent bash upgradation relink /bin/sh
        sudo mkdir -p /etc/pacman.d/hooks
        cat <<'        EOT' | sed 's/^ *//' | sudo tee /etc/pacman.d/sh-is-dash.hook
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
        EOT
        ;;
esac

# use dash as default shell because it much faster and will be used  vim-fugitive,
# leads to a much faster responsive speed
sudo /usr/bin/ln -sfT dash /usr/bin/sh
[ "$(awk -F':' '/^'"$USER"'/{print $7}' /etc/passwd)" != "/bin/sh" ] && chsh -s /bin/sh


# symlink config
[ -L "$XDG_CONFIG_HOME/fish" ] && rm -rf "$XDG_CONFIG_HOME/fish"

lnsf "$DIR/config/config.fish" "$XDG_CONFIG_HOME/fish/config.fish"
lnsf "$DIR/config/functions/fish_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_prompt.fish"
lnsf "$DIR/config/functions/fish_right_prompt.fish" "$XDG_CONFIG_HOME/fish/functions/fish_right_prompt.fish"
lnsf "$DIR/config/functions/fisher.fish" "$XDG_CONFIG_HOME/fish/functions/fisher.fish"

# install plugins
# for better keybinding: C-o open file with $EDITOR / C-r search history / C-g open with xdg-open
fish -c "fisher add jethrokuan/fzf"

