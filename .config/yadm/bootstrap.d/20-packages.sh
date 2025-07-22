#!/bin/bash
# ---------------------------------------------------------------------------
# File: 20-packages.sh
# Description:
#   Install system prerequisites for Linux and macOS.
#   Supports OS-specific packages using markers:
#     (L)pkg → Linux only (via apt)
#     (M)pkg → macOS only (via brew)
#     (B)pkg → Homebrew only (on any OS)
#
# Environment Variables:
#   DRY_RUN     : If set to 1, print commands without running them
#   FORCE_ROOT  : If set to 1, allow Homebrew install as root (/usr/local/homebrew)
#
# Usage:
#   export DRY_RUN=1        # optional
#   export FORCE_ROOT=1     # optional for root Homebrew install
#   ./20-packages.sh
# ---------------------------------------------------------------------------

system_type=$(uname -s)
PREREQUISITES="
    python3
    curl
    nvim
    lsd
    gpg
    (L)command-not-found
    git-delta
    (B)gh
    (B)node
    lazygit
    fzf
    ripgrep
    fd-find
    bat
    duf
    ncdu
    (M)mas
    (B)llm
"

# Use exported variables or defaults
DRY_RUN=${DRY_RUN:-0}
FORCE_ROOT=${FORCE_ROOT:-0}

SUDO_CMD=""
if [ "$(id -u)" -eq 0 ]; then
    SUDO_CMD=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO_CMD="sudo"
fi

printf "%bChecking system type:%b %s\n" "$Blue" "$Color_Off" "$system_type"

# ---------- Install Homebrew ----------
install_homebrew() {
    if [ "$(id -u)" -eq 0 ]; then
        if [ "$FORCE_ROOT" -ne 1 ]; then
            printf "%bERROR:%b Do NOT run as root unless FORCE_ROOT=1 is set.\n" "$Red" "$Color_Off"
            exit 1
        else
            printf "%bWARNING:%b Installing Homebrew as root (unsupported).\n" "$Yellow" "$Color_Off"
            HOMEBREW_PREFIX="/usr/local/homebrew"
        fi
    else
        HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
    fi

    if [ "$DRY_RUN" -eq 1 ]; then
        printf "[DRY-RUN] Install Homebrew to %s\n" "$HOMEBREW_PREFIX"
    else
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Configure PATH immediately
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"

    # Persist PATH
    if [ "$FORCE_ROOT" -eq 1 ]; then
        echo "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\"" >/etc/profile.d/homebrew.sh
    else
        echo "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\"" >>"$HOME/.bashrc"
    fi
}

# ---------- System update ----------
if [ "$system_type" = "Linux" ]; then
    if ! command -v brew >/dev/null 2>&1; then
        printf "%bHomebrew not found on Linux; installing...%b\n" "$Blue" "$Color_Off"
        install_homebrew
    fi

    # Update apt
    if [ -n "$SUDO_CMD" ] || [ "$(id -u)" -eq 0 ]; then
        if [ "$DRY_RUN" -eq 1 ]; then
            printf "[DRY-RUN] apt update && apt -y upgrade\n"
        else
            ${SUDO_CMD:+$SUDO_CMD} apt update
            ${SUDO_CMD:+$SUDO_CMD} apt -y upgrade
        fi
    else
        printf "%bSkipping apt update/upgrade (need sudo or root)%b\n" "$Yellow" "$Color_Off"
    fi
fi

# ---------- Update Homebrew everywhere ----------
if command -v brew >/dev/null 2>&1; then
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "[DRY-RUN] brew update && brew upgrade && brew cleanup\n"
    else
        brew update
        brew upgrade
        brew cleanup
    fi
fi

# ---------- Install package ----------
install_pkg() {
    pkg="$1"
    mode="$2"

    if [ "$system_type" = "Darwin" ] && [ "$pkg" = "fd-find" ]; then
        pkg="fd"
    fi

    case "$mode" in
        brew)
            if ! command -v brew >/dev/null 2>&1; then
                printf "%bHomebrew required for %s; installing...%b\n" "$Blue" "$pkg" "$Color_Off"
                install_homebrew
            fi
            if [ "$DRY_RUN" -eq 1 ]; then
                printf "[DRY-RUN] brew install %s\n" "$pkg"
            else
                brew install "$pkg"
            fi
            ;;
        apt)
            if [ "$system_type" = "Linux" ]; then
                if [ -n "$SUDO_CMD" ] || [ "$(id -u)" -eq 0 ]; then
                    if [ "$DRY_RUN" -eq 1 ]; then
                        printf "[DRY-RUN] apt install %s\n" "$pkg"
                    else
                        ${SUDO_CMD:+$SUDO_CMD} apt -y install "$pkg"
                    fi
                else
                    printf "%bSkipping%b %s (need sudo or root)\n" "$Yellow" "$Color_Off" "$pkg"
                fi
            fi
            ;;
        auto)
            if command -v brew >/dev/null 2>&1 && [ "$system_type" != "Linux" ]; then
                brew install "$pkg"
            else
                ${SUDO_CMD:+$SUDO_CMD} apt -y install "$pkg"
            fi
            ;;
    esac
}

# ---------- Process PREREQUISITES ----------
printf "%bInstalling prerequisites%b\n" "$Blue" "$Color_Off"
for raw_pkg in $PREREQUISITES; do
    case "$raw_pkg" in
        \(L\)*)
            [ "$system_type" != "Linux" ] && continue
            pkg="${raw_pkg#(L)}"
            mode="apt"
            ;;
        \(M\)*)
            [ "$system_type" != "Darwin" ] && continue
            pkg="${raw_pkg#(M)}"
            mode="brew"
            ;;
        \(B\)*)
            pkg="${raw_pkg#(B)}"
            mode="brew"
            ;;
        *)
            pkg="$raw_pkg"
            mode="auto"
            ;;
    esac

    if command -v "$pkg" >/dev/null 2>&1; then
        printf "%b%s already installed%b\n" "$Green" "$pkg" "$Color_Off"
    else
        printf "%bInstalling%b %s via %s\n" "$Blue" "$Color_Off" "$pkg" "$mode"
        install_pkg "$pkg" "$mode"
    fi
done

# ---------- Locale setup ----------
printf "%bConfiguring locale%b\n" "$Blue" "$Color_Off"
if [ "$system_type" = "Linux" ]; then
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "[DRY-RUN] Configure en_GB.UTF-8 locale\n"
    else
        ${SUDO_CMD:+$SUDO_CMD} apt -y install locales
        if ! grep -q '^en_GB.UTF-8 UTF-8' /etc/locale.gen; then
            echo "en_GB.UTF-8 UTF-8" | ${SUDO_CMD:+$SUDO_CMD} tee -a /etc/locale.gen
        fi
        ${SUDO_CMD:+$SUDO_CMD} locale-gen
        ${SUDO_CMD:+$SUDO_CMD} update-locale LANG=en_GB.UTF-8 LC_ALL=en_GB.UTF-8
    fi
elif [ "$system_type" = "Darwin" ]; then
    printf "%bmacOS uses system preferences for locale; exporting LANG/LC_ALL for shell%b\n" "$Blue" "$Color_Off"
fi

export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# ---------- Install Starship ----------
printf "%bInstalling Starship prompt%b\n" "$Blue" "$Color_Off"
if command -v starship >/dev/null 2>&1; then
    printf "%bStarship already installed%b\n" "$Green" "$Color_Off"
else
    if [ "$DRY_RUN" -eq 1 ]; then
        printf "[DRY-RUN] curl -fsSL https://starship.rs/install.sh | bash\n"
    else
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
    fi
fi

