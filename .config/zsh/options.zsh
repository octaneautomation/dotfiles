# ~/.config/zsh/options.zsh
# ------------------------------------------------------------------
# Description:
#   Zsh core options + completion settings with full fzf-tab integration
#   Features:
#     ✔ Modern fzf-tab menu with colors and layout
#     ✔ Alias expansion preview
#     ✔ Directory preview with lsd (fallback to ls)
#     ✔ Group labels inside fzf (no weird · markers)
#     ✔ Best practices for menu handling and sorting
# ------------------------------------------------------------------

# 1. Core Shell Behavior
# ------------------------------------------------------------------
setopt autocd                  # Allow `cd` by typing dir name
setopt correct                 # Correct small typos in commands
setopt extendedglob            # Enable advanced globbing
setopt nocaseglob              # Case-insensitive glob matching
setopt interactivecomments     # Allow # comments in interactive mode
setopt completeinword          # Complete from middle of word
setopt always_to_end           # Move cursor to end after completion
setopt no_beep                 # Disable error beeps
setopt extended_history        # Add timestamp to history entries

# 2. History Settings
# ------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000
setopt hist_ignore_dups        # Skip duplicates
setopt hist_ignore_space       # Skip commands starting with space
setopt hist_reduce_blanks      # Remove extra blanks
setopt share_history           # Sync history across sessions
setopt inc_append_history      # Write history immediately

# 3. Completion System
# ------------------------------------------------------------------
autoload -Uz compinit
compinit -u  # Use -u for faster init (skip security warnings)

# 4. Completion Styles (Base Zsh)
# ------------------------------------------------------------------
unsetopt menu_complete          # Don’t auto-complete first match
unsetopt auto_menu              # Disable Zsh menu (fzf-tab will handle it)
setopt auto_list                # Show list on ambiguity
setopt list_ambiguous           # Show list immediately when ambiguous

# Matching and descriptions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive
zstyle ':completion:*:descriptions' format '[%d]'          # No color codes (fzf-tab ignores them)
zstyle ':completion:*' group-name ''                       # Group by type
zstyle ':completion:*' verbose yes                         # Show detailed info
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}      # LS_COLORS for file colors

# Git tweak: prevent alphabetical sort for branches
zstyle ':completion:*:git-checkout:*' sort false

# 5. fzf-tab Integration (Core)
# ------------------------------------------------------------------
# Disable default Zsh menu so fzf-tab can take full control
zstyle ':completion:*' menu no

# Show group labels (like [alias], [external command]) inside fzf
zstyle ':fzf-tab:*' show-group-label yes
zstyle ':fzf-tab:*' group-label-position right

# Allow fzf-tab to use FZF_DEFAULT_OPTS for colors/layout
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Navigation inside fzf
zstyle ':fzf-tab:*' fzf-bindings 'tab:down,shift-tab:up'

# Switch completion groups using < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

# 6. Previews
# ------------------------------------------------------------------
# Directory preview for cd (eza if available, fallback to ls)
if (( $+commands[lsd] )); then
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
else
  zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=auto $realpath 2>/dev/null'
fi

# Global preview for files
zstyle ':fzf-tab:*' fzf-preview 'ls --color=auto $realpath 2>/dev/null'

# Alias expansion preview (e.g., "Alias → cat='batcat'")
zstyle ':fzf-tab:complete:alias:*' fzf-preview \
  'printf "Alias → %s\n" "$(alias $word 2>/dev/null | sed "s/^alias //g")"'

# 7. FZF Default Options (fzf-tab honors these)
# ------------------------------------------------------------------
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --info=inline
  --color=fg:#d0d0d0,bg:#1c1c1c,hl:#ffaf00,label:#00afff
  --bind=tab:accept
'

# 8. Tab Key Binding
# ------------------------------------------------------------------
bindkey '^I' expand-or-complete  # First TAB: normal completion; second TAB: fzf menu

# 9. Alias Completion
# ------------------------------------------------------------------
setopt complete_aliases  # Expand aliases during completion

# ------------------------------------------------------------------
# End of config
# Highlights:
#   ✔ No weird fg=cyan or · markers
#   ✔ Labels on the right in fzf menu ([alias], [command])
#   ✔ Alias preview shows what the alias expands to
#   ✔ Directory preview with icons (if eza is installed)
#   ✔ Full color control via FZF_DEFAULT_OPTS
# ------------------------------------------------------------------

