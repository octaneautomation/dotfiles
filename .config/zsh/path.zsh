# ~/.config/zsh/path.zsh
# ------------------------------------------------------------
# File: path.zsh
# Purpose: Configure and customize PATH for Zsh
# Details:
#   - Prepends user-specific and common directories to PATH
#   - Conditionally includes Linuxbrew binaries if installed
# ------------------------------------------------------------

export DOCKER_HOST=unix:///run/docker.sock

# Prepend custom paths
path=(
    "$HOME/.local/bin"
    "/usr/local/bin"
    $path
)

# Add Linuxbrew bin if it exists
if [[ -d "/home/linuxbrew/.linuxbrew/bin" ]]; then
    path=("/home/linuxbrew/.linuxbrew/bin" $path)
fi

export PATH

