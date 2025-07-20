#!/bin/sh
# Cleanup unused packages on Linux (sudo or root)

system_type=$(uname -s)
CLEAN_CMD="apt -y autoremove && apt -y autoclean"

if [ "$system_type" = "Linux" ]; then
    if [ "$(id -u)" -eq 0 ]; then
        [ "$DRY_RUN" -eq 1 ] && printf "%b[DRY-RUN]%b %s\n" "$Yellow" "$Color_Off" "$CLEAN_CMD" || sh -c "$CLEAN_CMD"
    elif command -v sudo >/dev/null 2>&1; then
        [ "$DRY_RUN" -eq 1 ] && printf "%b[DRY-RUN]%b sudo %s\n" "$Yellow" "$Color_Off" "$CLEAN_CMD" || sudo sh -c "$CLEAN_CMD"
    else
        printf "%bSkipping cleanup (need root or sudo)%b\n" "$Yellow" "$Color_Off"
    fi
fi

