#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# File: 45-iterm2.sh
# Description:
#   Configures iTerm2 preferences on macOS by setting:
#   - Custom folder for preferences
#   - Enable "Load preferences from custom folder"
#   Optionally installs iTerm2 using Homebrew if missing.
#
# Requirements:
#   - macOS only (Darwin)
#   - Color variables and log functions provided by bootstrap driver
#
# Usage:
#   ./45-iterm2.sh
# ---------------------------------------------------------------------------

system_type=$(uname -s)

if [ "$system_type" = "Darwin" ]; then
    log_section "Configuring iTerm2 Preferences"

    # Check if iTerm2 is installed, install if missing
    if ! brew list --cask iterm2 >/dev/null 2>&1; then
        if [ "${DRY_RUN:-0}" -eq 1 ]; then
            log "${Yellow}[DRY-RUN]${Color_Off} Would install iTerm2 via Homebrew Cask"
        else
            if command -v brew >/dev/null 2>&1; then
                log "${Blue}Installing iTerm2 via Homebrew Cask...${Color_Off}"
                brew install --cask iterm2
            else
                log "${Red}Error:${Color_Off} Homebrew not found. Cannot install iTerm2."
                exit 1
            fi
        fi
    else
        log "${Green}✔ iTerm2 already installed.${Color_Off}"
    fi

    # Configure custom preference folder if it exists
    if [ -d "$HOME/.iterm2" ]; then
        if [ "${DRY_RUN:-0}" -eq 1 ]; then
            log "${Yellow}[DRY-RUN]${Color_Off} Would set iTerm2 PrefsCustomFolder to $HOME/.iterm2"
            log "${Yellow}[DRY-RUN]${Color_Off} Would enable LoadPrefsFromCustomFolder"
        else
            log "${Blue}Setting iTerm2 PrefsCustomFolder to:${Color_Off} $HOME/.iterm2"
            defaults write com.googlecode.iterm2 PrefsCustomFolder "$HOME/.iterm2"

            log "${Blue}Enabling LoadPrefsFromCustomFolder in iTerm2${Color_Off}"
            defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
        fi
    else
        log "${Yellow}⚠ No custom iTerm2 folder found at $HOME/.iterm2. Skipping.${Color_Off}"
    fi
fi

