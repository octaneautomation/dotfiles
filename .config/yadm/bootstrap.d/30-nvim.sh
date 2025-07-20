#!/bin/sh
# Ensure Vim-Plug exists and update Neovim plugins

PLUG_VIM="$HOME/.config/nvim/autoload/plug.vim"
PLUG_URL="https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

if command -v nvim >/dev/null 2>&1; then
    # Install vim-plug if missing
    if [ ! -f "$PLUG_VIM" ]; then
        printf "%b[INFO]%b Installing vim-plug to %s...\n" "$Yellow" "$Color_Off" "$PLUG_VIM"
        mkdir -p "$(dirname "$PLUG_VIM")"
        if curl -fLo "$PLUG_VIM" --create-dirs "$PLUG_URL"; then
            printf "%b[SUCCESS]%b vim-plug installed.\n" "$Green" "$Color_Off"
        else
            printf "%b[ERROR]%b Failed to download vim-plug from %s\n" "$Red" "$Color_Off" "$PLUG_URL"
            exit 1
        fi
    fi

    # Update and clean plugins
    if [ "${DRY_RUN:-0}" -eq 1 ]; then
        printf "%b[DRY-RUN]%b nvim +PlugUpdate +PlugClean! +PlugUpdate +qall\n" "$Yellow" "$Color_Off"
    else
        nvim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
    fi
else
    printf "%bNeovim not installed%b\n" "$Red" "$Color_Off"
fi
