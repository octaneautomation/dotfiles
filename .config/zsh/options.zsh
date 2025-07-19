# ~/.config/zsh/options.zsh

# History & completion tweaks
setopt hist_ignore_dups       # Don't store duplicates
setopt share_history          # Share history across sessions
setopt autocd                 # cd into dir without typing cd
setopt correct                # Auto-correct minor typos in commands

autoload -Uz compinit && compinit
