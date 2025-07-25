# ~/.config/zsh/init.zsh

# Start ssh-agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval "$(ssh-agent -s)"
fi

# Zinit (lightweight, fast) for plugin management
if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/bin" ]]; then
    echo "Installing Zinit..."
    mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zinit"
    git clone https://github.com/zdharma-continuum/zinit.git "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/bin"
fi

source "${XDG_DATA_HOME:-$HOME/.local/share}/zinit/bin/zinit.zsh"
