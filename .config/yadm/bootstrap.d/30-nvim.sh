#!/bin/sh
# Update Neovim plugins if installed

if command -v nvim >/dev/null 2>&1; then
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "%b[DRY-RUN]%b nvim +PlugUpdate +PlugClean! +PlugUpdate +qall\n" "$Yellow" "$Color_Off"
    else
        nvim '+PlugUpdate' '+PlugClean!' '+PlugUpdate' '+qall'
    fi
else
    printf "%bNeovim not installed%b\n" "$Red" "$Color_Off"
fi

