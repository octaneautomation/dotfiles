# ~/.config/zsh/path.zsh

# Prepend custom paths
path=(
    "$HOME/.local/bin"
    "/usr/local/bin"
    $path
)

export PATH
