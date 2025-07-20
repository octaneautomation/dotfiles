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

# -----------------------------------------------------------------------------
# 5. File/Directory search (prefer fd if available)
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
    [ $# -eq 0 ] && {
        echo "Usage: rmdir <directory>"
        return 1
    }
    local dir="$1"
    [ ! -d "$dir" ] && {
        echo "Error: '$dir' is not a directory."
        return 1
    }
    read "?Are you sure you want to delete '$dir'? [y/N]: " confirm
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
# 12. help-aliases: Show all aliases & functions with descriptions
# -----------------------------------------------------------------------------
help-aliases() {
    local BOLD="\033[1m"
    local GREEN="\033[32m"
    local CYAN="\033[36m"
    local YELLOW="\033[33m"
    local RESET="\033[0m"

    echo -e "${BOLD}${CYAN}📜 Available Aliases & Functions:${RESET}\n"

    echo -e "${BOLD}${CYAN}=== Directory Listings ===${RESET}"
    echo -e "  ${GREEN}ls${RESET}    ${YELLOW}→${RESET} List files (colorized, long format if possible)"
    echo -e "  ${GREEN}ll${RESET}    ${YELLOW}→${RESET} Long list including hidden files"
    echo -e "  ${GREEN}la${RESET}    ${YELLOW}→${RESET} Long list excluding '.' and '..'"
    echo -e "  ${GREEN}l${RESET}     ${YELLOW}→${RESET} Column view"
    echo

    echo -e "${BOLD}${CYAN}=== Editors & Config Shortcuts ===${RESET}"
    echo -e "  ${GREEN}vim, vi, nano${RESET}  ${YELLOW}→${RESET} Open preferred editor (\$EDITOR)"
    echo -e "  ${GREEN}zshrc${RESET}          ${YELLOW}→${RESET} Edit Zsh config"
    echo -e "  ${GREEN}vimrc${RESET}          ${YELLOW}→${RESET} Edit Vim config"
    echo

    echo -e "${BOLD}${CYAN}=== File Viewing ===${RESET}"
    echo -e "  ${GREEN}cat${RESET}            ${YELLOW}→${RESET} Syntax-highlighted viewer (bat if available)"
    echo -e "  ${GREEN}catr${RESET}           ${YELLOW}→${RESET} Raw file output (no color, no paging)"
    echo

    echo -e "${BOLD}${CYAN}=== Zsh Config Reloading ===${RESET}"
    echo -e "  ${GREEN}reload-zsh${RESET}     ${YELLOW}→${RESET} Restart Zsh (preserves PWD)"
    echo -e "  ${GREEN}rz${RESET}             ${YELLOW}→${RESET} Reload config in current shell"
    echo

    echo -e "${BOLD}${CYAN}=== System Utilities ===${RESET}"
    echo -e "  ${GREEN}myip${RESET}           ${YELLOW}→${RESET} Show public IP"
    echo -e "  ${GREEN}httpserve${RESET}      ${YELLOW}→${RESET} Start Python HTTP server on port 2182"
    echo -e "  ${GREEN}df${RESET}             ${YELLOW}→${RESET} Disk usage via duf (if installed)"
    echo -e "  ${GREEN}duu${RESET}            ${YELLOW}→${RESET} Disk usage via ncdu (if installed)"
    echo

    echo -e "${BOLD}${CYAN}=== Search Shortcuts ===${RESET}"
    echo -e "  ${GREEN}fd <pattern>${RESET}   ${YELLOW}→${RESET} Find directories (fd-find if available, else find)"
    echo -e "  ${GREEN}ff <pattern>${RESET}   ${YELLOW}→${RESET} Find files"
    echo

    echo -e "${BOLD}${CYAN}=== fzf + fd Power Tools ===${RESET}"
    echo -e "  ${GREEN}fdf${RESET}            ${YELLOW}→${RESET} Fuzzy find file & open in editor"
    echo -e "  ${GREEN}fdd${RESET}            ${YELLOW}→${RESET} Fuzzy find directory & cd into it"
    echo -e "  ${GREEN}ffo${RESET}            ${YELLOW}→${RESET} Fuzzy find any file/dir & open in editor"
    echo

    echo -e "${BOLD}${CYAN}=== fzf Utilities ===${RESET}"
    echo -e "  ${GREEN}fh${RESET}             ${YELLOW}→${RESET} Search history & copy to clipboard"
    echo -e "  ${GREEN}fkill${RESET}          ${YELLOW}→${RESET} Fuzzy kill processes"
    echo -e "  ${GREEN}fgb${RESET}            ${YELLOW}→${RESET} Fuzzy select git branch & switch"
    echo -e "  ${GREEN}fo${RESET}             ${YELLOW}→${RESET} Fuzzy open file in editor"
    echo -e "  ${GREEN}fcd${RESET}            ${YELLOW}→${RESET} Fuzzy cd into directory"
    echo

    echo -e "${BOLD}${CYAN}=== Dotfiles Shortcuts (yadm) ===${RESET}"
    echo -e "  ${GREEN}yst${RESET}            ${YELLOW}→${RESET} yadm status"
    echo -e "  ${GREEN}ya${RESET}             ${YELLOW}→${RESET} yadm add"
    echo -e "  ${GREEN}yd${RESET}             ${YELLOW}→${RESET} yadm diff"
    echo -e "  ${GREEN}yds${RESET}            ${YELLOW}→${RESET} yadm diff --staged"
    echo -e "  ${GREEN}yc${RESET}             ${YELLOW}→${RESET} yadm commit"
    echo -e "  ${GREEN}yp${RESET}             ${YELLOW}→${RESET} yadm push"
    echo -e "  ${GREEN}ysync${RESET}          ${YELLOW}→${RESET} Interactive yadm sync: show status, prompt, commit & push"
    echo

    echo -e "${BOLD}${CYAN}=== Helper Functions ===${RESET}"
    echo -e "  ${GREEN}mkcd <dir>${RESET}     ${YELLOW}→${RESET} Create a directory and cd into it"
    echo -e "  ${GREEN}rmdir <dir>${RESET}    ${YELLOW}→${RESET} Safely remove directory (confirmation required)"
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

