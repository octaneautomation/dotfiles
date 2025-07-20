# ~/.config/zsh/aliases.zsh
# =============================================================================
# Zsh Aliases & Helpers
# -----------------------------------------------------------------------------
# PURPOSE:
#   This file defines helpful aliases, functions, and shortcuts for Zsh.
#   It provides:
#     ✔ Smart fallbacks for tools (ls, cat, editors)
#     ✔ Quick directory navigation
#     ✔ Safer file operations
#     ✔ fzf-powered fuzzy finders (if installed)
#     ✔ yadm (dotfiles) shortcuts
#
# -----------------------------------------------------------------------------
# AVAILABLE ALIASES & FUNCTIONS:
#
# [ Directory Listings ]
#   ls      → List files (colorized, long format if possible)
#   ll      → Long list with hidden files
#   la      → Long list excluding . and ..
#   l       → Column view
#
# [ Editors ]
#   vim, vi, nano → Open preferred editor (auto-selected: nvim > vim > vi > nano)
#
# [ File Viewing ]
#   cat     → Syntax-highlighted view with bat (if available)
#
# [ Zsh Reloading ]
#   reload-zsh → Restart Zsh (keeps PWD)
#   rz         → Reload Zsh config in-place
#
# [ System Info ]
#   myip    → Show public IP address
#
# [ Config Shortcuts ]
#   zshrc   → Open Zsh config
#   vimrc   → Open Vim config
#
# [ Quick Utilities ]
#   httpserve → Start a simple HTTP server on port 2182
#   fd        → Find directories (uses fd-find if available)
#   ff        → Find files (uses fd-find if available)
#
# [ fzf-enhanced Shortcuts ] (requires fzf, fd, bat)
#   fdf      → Fuzzy find a file and open in $EDITOR
#   fdd      → Fuzzy find a directory and cd into it
#   ffo      → Fuzzy find any file/dir and open in $EDITOR
#   fh       → Search history and copy to clipboard
#   fkill    → Fuzzy kill processes
#   fo       → Fuzzy find a file and open in $EDITOR
#   fgb      → Fuzzy select git branch and switch
#
# [ Dotfiles (yadm) ]
#   yst      → yadm status
#   ya       → yadm add
#   yd       → yadm diff
#   yds      → yadm diff --staged
#   yc       → yadm commit
#   yp       → yadm push
#
# [ Helpers ]
#   mkcd     → Create a directory and cd into it
#   rmdir    → Safely remove a directory (asks for confirmation)
#
# =============================================================================

# -----------------------------------------------------------------------------
# Utility: Check if a command exists
# -----------------------------------------------------------------------------
command_exists() { command -v "$1" >/dev/null 2>&1; }

# -----------------------------------------------------------------------------
# 1. Directory listing (prefer 'lsd' if available)
# -----------------------------------------------------------------------------
if command_exists lsd; then
    alias ls='lsd -l'
    alias ll='lsd -alF'
    alias la='lsd -Al'
    alias l='lsd -CF'
else
    alias ls='ls --color=auto -lh'
    alias ll='ls --color=auto -alh'
    alias la='ls --color=auto -Alh'
    alias l='ls --color=auto -CF'
fi

# -----------------------------------------------------------------------------
# 2. Preferred text editor (nvim > vim > vi > nano)
# -----------------------------------------------------------------------------
if command_exists nvim; then
    export EDITOR="nvim"
elif command_exists vim; then
    export EDITOR="vim"
elif command_exists vi; then
    export EDITOR="vi"
elif command_exists nano; then
    export EDITOR="nano"
else
    export EDITOR="vi"
fi

# Editor aliases
alias vim="$EDITOR"
alias vi="$EDITOR"
alias nano="$EDITOR"

# -----------------------------------------------------------------------------
# 3. 'cat' → 'bat' (or 'batcat') if available
# -----------------------------------------------------------------------------
if command_exists bat; then
    alias cat="bat"
elif command_exists batcat; then
    alias cat="batcat"
fi

# -----------------------------------------------------------------------------
# 4. Reload Zsh configuration
# -----------------------------------------------------------------------------
reload_zsh() {
    echo "🔄 Reloading Zsh configuration..."
    exec zsh --login
}
alias reload-zsh='reload_zsh'
alias rz='source "$ZDOTDIR/.zshrc" && echo "✅ Reloaded Zsh config"'

# -----------------------------------------------------------------------------
# 5. File/Directory search (prefer fd-find if available)
# -----------------------------------------------------------------------------
if command_exists fd; then
    alias fd='fd --type d'   # Search directories
    alias ff='fd --type f'   # Search files

    # fzf-enhanced search helpers
    fdf() {  # Fuzzy select file, open in $EDITOR
        local file
        file=$(fd --type f | fzf --preview 'bat --style=numbers --color=always {} || cat {}') && \
        ${EDITOR:-vim} "$file"
    }

    fdd() {  # Fuzzy select directory, cd into it
        local dir
        dir=$(fd --type d | fzf) && cd "$dir" || return
    }

    ffo() {  # Fuzzy select *anything* and open in $EDITOR
        local choice
        choice=$(fd | fzf --preview 'bat --style=numbers --color=always {} || cat {}') && \
        ${EDITOR:-vim} "$choice"
    }
else
    alias fd='find . -type d -name'
    alias ff='find . -type f -name'
fi

# -----------------------------------------------------------------------------
# 6. Utility aliases
# -----------------------------------------------------------------------------
alias myip="curl -s http://ipecho.net/plain; echo"
alias zshrc="$EDITOR $ZDOTDIR/.zshrc"
alias vimrc="$EDITOR ~/.config/vim/vimrc"
alias httpserve='python3 -m http.server 2182'

# -----------------------------------------------------------------------------
# 7. yadm (dotfiles manager) shortcuts
# -----------------------------------------------------------------------------
alias yst="yadm status"
alias ya="yadm add"
alias yd="yadm diff"
alias yds="yadm diff --staged"
alias yc="yadm commit"
alias yp="yadm push"

# -----------------------------------------------------------------------------
# 8. mkcd: create directory & cd into it
# -----------------------------------------------------------------------------
mkcd() {
    [ -z "$1" ] && { echo "Usage: mkcd <directory>"; return 1; }
    mkdir -p "$1" && cd "$1" || return
}

# -----------------------------------------------------------------------------
# 9. Safer rmdir with confirmation
# -----------------------------------------------------------------------------
rmdir() {
    [ $# -eq 0 ] && { echo "Usage: rmdir <directory>"; return 1; }
    local dir="$1"
    [ ! -d "$dir" ] && { echo "Error: '$dir' is not a directory."; return 1; }
    read -p "Are you sure you want to delete '$dir'? [y/N]: " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && rm -rf "$dir" && echo "'$dir' removed." || echo "Canceled."
}

# -----------------------------------------------------------------------------
# 10. Conditional aliases for extra tools
# -----------------------------------------------------------------------------
command_exists duf && alias df="duf --only local"
command_exists ncdu && alias duu="ncdu --color dark -rr -e"

# -----------------------------------------------------------------------------
# 11. fzf Power Aliases
# -----------------------------------------------------------------------------
alias fh="history | fzf | awk '{\$1=\"\"; print substr(\$0,2)}' | tr -d '\n' | pbcopy"
alias fcd='cd "$(find . -type d | fzf)"'
alias fo='${EDITOR:-vim} "$(fzf)"'
alias fkill='ps -ef | sed 1d | fzf | awk "{print \$2}" | xargs kill -9'
alias fgb='git branch | fzf | xargs git checkout'

# -----------------------------------------------------------------------------
# 12. Show all aliases & functions with descriptions
# -----------------------------------------------------------------------------
help-aliases() {
    echo "📜 Available Aliases & Functions:"
    echo
    echo "=== Directory Listings ==="
    echo "  ls      → List files (colorized, long format if possible)"
    echo "  ll      → Long list including hidden files"
    echo "  la      → Long list excluding '.' and '..'"
    echo "  l       → Column view"
    echo
    echo "=== Editors & Config Shortcuts ==="
    echo "  vim, vi, nano  → Open preferred editor (\$EDITOR)"
    echo "  zshrc          → Edit Zsh config"
    echo "  vimrc          → Edit Vim config"
    echo
    echo "=== File Viewing ==="
    echo "  cat            → Syntax-highlighted viewer (bat if available)"
    echo "  catr           → Raw file output (no color, no paging)"
    echo
    echo "=== Zsh Config Reloading ==="
    echo "  reload-zsh     → Restart Zsh (preserves PWD)"
    echo "  rz             → Reload config in current shell"
    echo
    echo "=== System Utilities ==="
    echo "  myip           → Show public IP"
    echo "  httpserve      → Start Python HTTP server on port 2182"
    echo "  df             → Disk usage via duf (if installed)"
    echo "  duu            → Disk usage via ncdu (if installed)"
    echo
    echo "=== Search Shortcuts ==="
    echo "  fd <pattern>   → Find directories (fd-find if available, else find)"
    echo "  ff <pattern>   → Find files"
    echo
    echo "=== fzf + fd Power Tools ==="
    echo "  fdf            → Fuzzy find file & open in editor"
    echo "  fdd            → Fuzzy find directory & cd into it"
    echo "  ffo            → Fuzzy find any file/dir & open in editor"
    echo
    echo "=== fzf Utilities ==="
    echo "  fh             → Search history & copy to clipboard"
    echo "  fkill          → Fuzzy kill processes"
    echo "  fgb            → Fuzzy select git branch & switch"
    echo "  fo             → Fuzzy open file in editor"
    echo "  fcd            → Fuzzy cd into directory"
    echo
    echo "=== Dotfiles Shortcuts (yadm) ==="
    echo "  yst            → yadm status"
    echo "  ya             → yadm add"
    echo "  yd             → yadm diff"
    echo "  yds            → yadm diff --staged"
    echo "  yc             → yadm commit"
    echo "  yp             → yadm push"
    echo "  ysync          → Interactive yadm sync: show status, prompt for untracked, confirm, commit & push"
    echo
    echo "=== Helper Functions ==="
    echo "  mkcd <dir>     → Create a directory and cd into it"
    echo "  rmdir <dir>    → Safely remove directory (confirmation required)"
    echo
}

alias help-aliases="help-aliases"

# -----------------------------------------------------------------------------
# 13. Raw cat output (even if cat is bat)
# -----------------------------------------------------------------------------
if command_exists bat; then
    alias catr='bat --plain --paging=never'
elif command_exists batcat; then
    alias catr='batcat --plain --paging=never'
else
    alias catr='cat'
fi

# -----------------------------------------------------------------------------
# 14. yadm-sync: Safely commit and push tracked changes only
# -----------------------------------------------------------------------------
ysync() {
    echo "🔍 Current yadm status:"
    yadm status
    echo

    # Stage tracked changes only
    echo "✅ Adding tracked changes (no untracked files)..."
    yadm add -u

    # Prompt for commit message
    echo
    echo "Enter commit message (default: 'Update configs'):"
    read -r msg
    msg="${msg:-Update configs}"

    # Show summary
    echo
    echo "📋 Commit Summary:"
    echo "  → Commit message: \"$msg\""
    echo
    yadm status

    # Confirm before committing
    echo
    echo "Proceed with commit and push? (y/N)"
    read -r confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        yadm commit -m "$msg"
        yadm push
        echo "✅ Changes committed and pushed!"
    else
        echo "❌ Operation canceled."
    fi
}

alias ysync="ysync"

