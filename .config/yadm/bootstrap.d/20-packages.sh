#!/bin/sh
# Install prerequisites (Linux and macOS)
# Expects: DRY_RUN, VERBOSE, LOG_FILE, color vars (exported by driver)

system_type=$(uname -s)
PREREQUISITES="python3 curl nvim lsd gpg command-not-found git-delta lazygit fzf ripgrep fd-find bat duf ncdu"
SUDO_CMD=""

# Detect sudo or root for Linux
if [ "$(id -u)" -eq 0 ]; then
    SUDO_CMD=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO_CMD="sudo"
else
    SUDO_CMD=""
fi

printf "%bChecking system type: %s%b\n" "$Blue" "$system_type" "$Color_Off"

# ---------- Linux: Update and upgrade ----------
if [ "$system_type" = "Linux" ]; then
    if [ -n "$SUDO_CMD" ] || [ "$(id -u)" -eq 0 ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            printf "%b[DRY-RUN]%b apt update && apt -y upgrade\n" "$Yellow" "$Color_Off"
        else
            ${SUDO_CMD:+$SUDO_CMD} apt update
            ${SUDO_CMD:+$SUDO_CMD} apt -y upgrade
        fi
    else
        printf "%bSkipping apt update/upgrade (need sudo or root)%b\n" "$Yellow" "$Color_Off"
    fi

# ---------- macOS: Homebrew update ----------
elif [ "$system_type" = "Darwin" ]; then
    if command -v brew >/dev/null 2>&1; then
        if [ "$DRY_RUN" -eq 1 ]; then
            printf "%b[DRY-RUN]%b brew update && brew upgrade\n" "$Yellow" "$Color_Off"
        else
            brew update
            brew upgrade
        fi
    else
        if [ "$DRY_RUN" -eq 1 ]; then
            printf "%b[DRY-RUN]%b Install Homebrew\n" "$Yellow" "$Color_Off"
        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
    fi
fi

# ---------- Install packages ----------
install_pkg() {
    pkg="$1"
    if [ "$system_type" = "Linux" ]; then
        if [ -n "$SUDO_CMD" ] || [ "$(id -u)" -eq 0 ]; then
            if [ "$DRY_RUN" -eq 1 ]; then
                printf "%b[DRY-RUN]%b apt install %s\n" "$Yellow" "$Color_Off" "$pkg"
            else
                ${SUDO_CMD:+$SUDO_CMD} apt -y install "$pkg"
            fi
        else
            printf "%bSkipping%b %s (need sudo or root)\n" "$Yellow" "$Color_Off" "$pkg"
        fi
    elif [ "$system_type" = "Darwin" ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            printf "%b[DRY-RUN]%b brew install %s\n" "$Yellow" "$Color_Off" "$pkg"
        else
            brew install "$pkg"
        fi
    fi
}

printf "%bInstalling prerequisites%b\n" "$Blue" "$Color_Off"
for cmd in $PREREQUISITES; do
    if command -v "$cmd" >/dev/null 2>&1; then
        printf "%b%s already installed%b\n" "$Green" "$cmd" "$Color_Off"
    else
        printf "%bInstalling%b %s\n" "$Blue" "$Color_Off" "$cmd"
        install_pkg "$cmd"
    fi
done

# ---------- macOS cleanup ----------
if [ "$system_type" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "%b[DRY-RUN]%b brew cleanup\n" "$Yellow" "$Color_Off"
    else
        brew cleanup
    fi
fi

# ---------- Locale Setup ----------
printf "%bConfiguring locale%b\n" "$Blue" "$Color_Off"
if [ "$system_type" = "Linux" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "%b[DRY-RUN]%b Install and configure en_GB.UTF-8 locale\n" "$Yellow" "$Color_Off"
    else
        ${SUDO_CMD:+$SUDO_CMD} apt -y install locales
        # Ensure en_GB.UTF-8 exists in /etc/locale.gen
        if ! grep -q '^en_GB.UTF-8 UTF-8' /etc/locale.gen; then
            echo "en_GB.UTF-8 UTF-8" | ${SUDO_CMD:+$SUDO_CMD} tee -a /etc/locale.gen
        fi
        ${SUDO_CMD:+$SUDO_CMD} locale-gen
        ${SUDO_CMD:+$SUDO_CMD} update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
    fi
elif [ "$system_type" = "Darwin" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "%b[DRY-RUN]%b Configure shell locale\n" "$Yellow" "$Color_Off"
    else
        printf "%bmacOS uses system preferences for locale, exporting LANG/LC_ALL for shell%b\n" "$Blue" "$Color_Off"
    fi
fi

# Export for current session
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# ---------- Install Starship ----------
printf "%bInstalling Starship prompt%b\n" "$Blue" "$Color_Off"

if command -v starship >/dev/null 2>&1; then
    printf "%bStarship already installed%b\n" "$Green" "$Color_Off"
else
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "%b[DRY-RUN]%b curl -fsSL https://starship.rs/install.sh | bash\n" "$Yellow" "$Color_Off"
    else
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
    fi
fi
