# ~/.config/zsh/aliases.zsh
# --------------------------------------------
# File: aliases.zsh
# Description: Define shell command aliases for convenience.
#              Uses `lsd` as a modern replacement for `ls`.
# --------------------------------------------

# Replace ls with lsd (colorful, icon-enhanced ls alternative)
alias ls='lsd'
alias ll='lsd -alF'
alias la='lsd -A'
alias l='lsd -CF'
