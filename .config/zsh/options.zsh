# ~/.config/zsh/options.zsh
# --------------------------------------------
# Description:
#   Zsh core options and completion settings.
#   Optimized for fzf-tab integration and smooth completion experience.
# --------------------------------------------

# 1. Core Behavior
setopt autocd                  # Allow changing dir by typing its name
setopt correct                 # Correct small typos in commands
setopt extendedglob            # Enable extended pattern matching
setopt nocaseglob              # Case-insensitive globbing
setopt interactivecomments     # Allow # comments in interactive shell
setopt completeinword          # Complete from the middle of a word
setopt always_to_end           # Move cursor to end after completion
setopt no_beep                 # Disable beep on error
setopt extended_history        # record timestamp of command in HISTFILE

# 2. History Settings (Large and Clean)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt hist_ignore_dups        # Ignore duplicate commands
setopt hist_ignore_space       # Ignore commands starting with space
setopt hist_reduce_blanks      # Remove extra spaces before saving
setopt share_history           # Share history across sessions
setopt inc_append_history      # Append history immediately

# 3. Completion System Initialization
autoload -Uz compinit
compinit -u   # Use -u to skip security checks for faster loading

# 4. Completion Behavior
unsetopt menu_complete         # Don’t auto-complete the first match
unsetopt auto_menu             # Don't open menu until second TAB
setopt auto_list               # Show completion list when ambiguous
setopt list_ambiguous          # Immediately show list when ambiguous

# 5. Styles for Better UX
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive
zstyle ':completion:*' group-name ''                      # Group results by type
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select                        # Enable menu selection with arrows
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*:messages' format '%F{green}%d%f'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}     # Use LS_COLORS for coloring

# 6. fzf-tab Integration (for fuzzy TAB completion)
zstyle ':fzf-tab:*' fzf-preview 'ls --color=auto $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':fzf-tab:*' fzf-bindings 'tab:down,shift-tab:up'
zstyle ':fzf-tab:*' command-line 'fg=cyan'
zstyle ':fzf-tab:*' prefix 'fg=green'

# Make TAB behave like:
#  - 1st TAB: Normal completion
#  - 2nd TAB: fzf menu
bindkey '^I' expand-or-complete

# 7. Enable completion for aliases
setopt complete_aliases

