# ~/.config/zsh/plugins.zsh
# --------------------------------------------
# File: plugins.zsh
# Description: Load Zsh plugins and external enhancements
#              using Zinit for performance and modularity.
# --------------------------------------------

# Syntax highlighting, autosuggestions, completions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# Prompt: Starship (cross-shell prompt written in Rust)
zinit light starship/starship

# Initialize Starship
eval "$(starship init zsh)"
