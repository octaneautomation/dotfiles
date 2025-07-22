# ~/.config/zsh/aliases.zsh
# =============================================================================
# Zsh Aliases & Helpers
# -----------------------------------------------------------------------------
# PURPOSE:
#   Define helpful aliases, functions, and shortcuts for Zsh, including:
#     ✔ Smart fallbacks for core utilities
#     ✔ fzf-powered interactive tools
#     ✔ Dotfiles (yadm) management
#     ✔ Git productivity helpers
#     ✔ Cross-platform enhancements
#
# -----------------------------------------------------------------------------
# AVAILABLE ALIASES & FUNCTIONS:
#
# [ Directory Listings ]
#   ls, ll, la, l
#
# [ Editors ]
#   vim, vi, nano
#
# [ File Viewing ]
#   cat    → Syntax-highlighted output with bat (if installed)
#   catr   → Raw file output without paging
#
# [ Zsh Reload ]
#   reload-zsh
#
# [ File/Directory Search ]
#   fd, ff → Uses fd if installed, else find
#
# [ System Utilities ]
#   myip, httpserve, df, duu
#
# [ Dotfiles (yadm) ]
#   yst, ya, yd, yds, yc, yp, ysync
#
# [ Git Productivity ]
#   gs, gl, gco, gp, gb, ga, gc, gcm, gd, gds
#
# [ fzf Tools ]
#   fdf, fdd, ffo, fcd, fo, fgb, fh
#
# [ Helpers ]
#   mkcd, rmdir, fkill
#
# [ Help ]
#   help-aliases → Show all aliases/functions (colorized)
#   hal-fzf      → Interactive fuzzy help
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Utility: Check if a command exists
# -----------------------------------------------------------------------------
command_exists() { command -v "$1" >/dev/null 2>&1; }

# -----------------------------------------------------------------------------
# 1. Directory listings
# -----------------------------------------------------------------------------
if command_exists lsd; then
    alias ls='lsd -l'        # Long format
    alias ll='lsd -alF'      # Long format with hidden files
    alias la='lsd -Al'       # All files, excluding . and ..
    alias l='lsd -CF'        # Compact columns
else
    alias ls='ls --color=auto -lh'
    alias ll='ls --color=auto -alh'
    alias la='ls --color=auto -Alh'
    alias l='ls --color=auto -CF'
fi

# -----------------------------------------------------------------------------
# 2. Preferred editor (nvim > vim > vi > nano)
# -----------------------------------------------------------------------------
if command_exists nvim; then
    export EDITOR="nvim"
elif command_exists vim; then
    export EDITOR="vim"
elif command_exists vi; then
    export EDITOR="vi"
else
    export EDITOR="nano"
fi

alias vim="$EDITOR"
alias vi="$EDITOR"
alias nano="$EDITOR"

# -----------------------------------------------------------------------------
# 3. File Viewing (bat fallback)
# -----------------------------------------------------------------------------
if command_exists bat; then
    alias cat="bat"
    alias catr='bat --plain --paging=never'
elif command_exists batcat; then
    alias cat="batcat"
    alias catr='batcat -pp'
else
    alias catr='cat'
fi

# -----------------------------------------------------------------------------
# 4. Reload Zsh
# -----------------------------------------------------------------------------
reload_zsh() {
    echo "🔄 Reloading Zsh configuration..."
    exec zsh --login
}
alias reload-zsh='reload_zsh'

# -----------------------------------------------------------------------------
# 5. File/Directory search
# -----------------------------------------------------------------------------
if command_exists fd; then
    alias fd='fd --type d'
    alias ff='fd --type f'

    # fzf-powered helpers
    fdf() { file=$(fd --type f | fzf --preview 'bat --style=numbers --color=always {} || cat {}') && $EDITOR "$file"; }
    fdd() { dir=$(fd --type d | fzf) && cd "$dir" || return; }
    ffo() { choice=$(fd | fzf --preview 'bat --style=numbers --color=always {} || cat {}') && $EDITOR "$choice"; }
else
    alias fd='find . -type d -name'
    alias ff='find . -type f -name'
fi

# -----------------------------------------------------------------------------
# 6. System utilities
# -----------------------------------------------------------------------------
alias myip="curl -s http://ipecho.net/plain; echo"
alias zshrc="cd $ZDOTDIR && ls"
alias yadm-config="cd $HOME/.config/yadm && ls && ls .bootstrap.d"
alias edit-aliases="$EDITOR ~/.config/zsh/aliases.zsh"
alias vimrc="$EDITOR ~/.config/vim/vimrc"

if command_exists python3; then
    alias httpserve='python3 -m http.server 2182'
else
    alias httpserve='python -m SimpleHTTPServer 2182'
fi

command_exists duf && alias df="duf --only local"
command_exists ncdu && alias duu="ncdu --color dark -rr -e"

# -----------------------------------------------------------------------------
# 7. Dotfiles (yadm)
# -----------------------------------------------------------------------------
alias yst="yadm status"
alias ya="yadm add"
alias yd="yadm diff"
alias yds="yadm diff --staged"
alias yc="yadm commit"
alias yp="yadm push"

ysync() {
    echo "🔍 Current yadm status:"
    yadm status
    echo

    echo "✅ Adding tracked changes only..."
    yadm add -u

    echo
    read "?Commit message [default: 'Update configs']: " msg
    msg="${msg:-Update configs}"

    echo
    echo "📋 Commit Summary:"
    echo "Message: \"$msg\""
    echo
    yadm status

    echo
    read "?Proceed with commit and push? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && yadm commit -m "$msg" && yadm push && echo "✅ Done!" || echo "❌ Canceled."
}
alias ysync="ysync"

# yadm
function yadm_lazygit() {
    cd ~
    yadm enter lazygit
    cd -
}
alias ylaz="yadm_lazygit"
# -----------------------------------------------------------------------------
# 8. Git productivity
# -----------------------------------------------------------------------------
alias gs='git status -sb'
alias gl='git log --oneline --graph --decorate --all'
alias gco='git checkout'
alias gp='git pull --rebase'
alias gb='git branch'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gds='git diff --staged'

# -----------------------------------------------------------------------------
# 9. Helpers and safety
# -----------------------------------------------------------------------------
mkcd() { mkdir -p "$1" && cd "$1" || return; }
rmdir() { [ -d "$1" ] && read "?Delete '$1'? (y/N): " c && [[ "$c" =~ ^[Yy]$ ]] && rm -rf "$1" || echo "Canceled."; }
alias fkill='ps -ef | sed 1d | fzf | awk "{print \$2}" | xargs -r kill -9'

# -----------------------------------------------------------------------------
# 10. Clipboard (macOS/Linux)
# -----------------------------------------------------------------------------
if command_exists pbcopy; then
    alias fh="history | fzf | awk '{\$1=\"\"; print substr(\$0,2)}' | tr -d '\n' | pbcopy"
elif command_exists xclip; then
    alias fh="history | fzf | awk '{\$1=\"\"; print substr(\$0,2)}' | tr -d '\n' | xclip -selection clipboard"
fi

# -----------------------------------------------------------------------------
# 11. fzf Navigation Helpers
# -----------------------------------------------------------------------------
alias fcd='cd "$(find . -type d | fzf)"'
alias fo='${EDITOR:-vim} "$(fzf)"'
alias fgb='git branch | fzf | xargs git checkout'

# -----------------------------------------------------------------------------
# 12. Help system
# -----------------------------------------------------------------------------
help-aliases() {
: "${Blue:='\033[0;34m'}"
    : "${Green:='\033[0;32m'}"
    : "${Cyan:='\033[0;36m'}"
    : "${Yellow:='\033[0;33m'}"
    : "${Color_Off:='\033[0m'}"

    echo -e "${Blue}📜 Available Aliases & Functions:${Color_Off}\n"

    echo -e "${Cyan}=== Directory Listings ===${Color_Off}"
    echo -e "  ${Green}ls${Color_Off}    → List files (colorized, long format)"
    echo -e "  ${Green}ll${Color_Off}    → Long list including hidden files"
    echo -e "  ${Green}la${Color_Off}    → Long list excluding '.' and '..'"
    echo -e "  ${Green}l${Color_Off}     → Compact columns"
    echo

    echo -e "${Cyan}=== Editors ===${Color_Off}"
    echo -e "  ${Green}vim, vi, nano${Color_Off} → Open preferred editor (\$EDITOR)"
    echo

    echo -e "${Cyan}=== File Viewing ===${Color_Off}"
    echo -e "  ${Green}cat${Color_Off}    → Syntax-highlighted (bat if installed)"
    echo -e "  ${Green}catr${Color_Off}   → Raw output (no paging, no colors)"
    echo

    echo -e "${Cyan}=== Zsh Reload ===${Color_Off}"
    echo -e "  ${Green}reload-zsh${Color_Off} → Restart Zsh session"
    echo

    echo -e "${Cyan}=== Search Helpers ===${Color_Off}"
    echo -e "  ${Green}fd${Color_Off}     → Find directories (fd/find)"
    echo -e "  ${Green}ff${Color_Off}     → Find files"
    echo -e "  ${Green}fdf${Color_Off}    → fzf: Fuzzy find file & open in \$EDITOR"
    echo -e "  ${Green}fdd${Color_Off}    → fzf: Fuzzy find directory & cd"
    echo -e "  ${Green}ffo${Color_Off}    → fzf: Fuzzy find any file/dir & open"
    echo

    echo -e "${Cyan}=== System Utilities ===${Color_Off}"
    echo -e "  ${Green}myip${Color_Off}   → Show public IP address"
    echo -e "  ${Green}httpserve${Color_Off} → Start Python HTTP server (port 2182)"
    echo -e "  ${Green}df${Color_Off}     → Disk usage (duf if installed)"
    echo -e "  ${Green}duu${Color_Off}    → Disk usage (ncdu if installed)"
    echo

    echo -e "${Cyan}=== Dotfiles (yadm) ===${Color_Off}"
    echo -e "  ${Green}yst${Color_Off}    → yadm status"
    echo -e "  ${Green}ya${Color_Off}     → yadm add"
    echo -e "  ${Green}yd${Color_Off}     → yadm diff"
    echo -e "  ${Green}yds${Color_Off}    → yadm diff staged"
    echo -e "  ${Green}yc${Color_Off}     → yadm commit"
    echo -e "  ${Green}yp${Color_Off}     → yadm push"
    echo -e "  ${Green}ysync${Color_Off}  → Interactive yadm sync (status → commit → push)"
    echo

    echo -e "${Cyan}=== Git Productivity ===${Color_Off}"
    echo -e "  ${Green}gs${Color_Off}     → git status (short)"
    echo -e "  ${Green}gl${Color_Off}     → git log (graph)"
    echo -e "  ${Green}gco${Color_Off}    → git checkout"
    echo -e "  ${Green}gp${Color_Off}     → git pull --rebase"
    echo -e "  ${Green}gb${Color_Off}     → git branch"
    echo -e "  ${Green}ga${Color_Off}     → git add"
    echo -e "  ${Green}gc${Color_Off}     → git commit"
    echo -e "  ${Green}gcm${Color_Off}    → git commit -m"
    echo -e "  ${Green}gd${Color_Off}     → git diff"
    echo -e "  ${Green}gds${Color_Off}    → git diff staged"
    echo

    echo -e "${Cyan}=== Helpers ===${Color_Off}"
    echo -e "  ${Green}mkcd${Color_Off}   → Create directory and cd"
    echo -e "  ${Green}rmdir${Color_Off}  → Remove directory (confirmation)"
    echo -e "  ${Green}fkill${Color_Off}  → fzf: Kill selected process"
    echo

    echo -e "${Cyan}=== Clipboard ===${Color_Off}"
    echo -e "  ${Green}fh${Color_Off}     → fzf: Search history & copy to clipboard"
    echo

    echo -e "${Cyan}=== fzf Navigation ===${Color_Off}"
    echo -e "  ${Green}fcd${Color_Off}    → fzf: cd into directory"
    echo -e "  ${Green}fo${Color_Off}     → fzf: Open file in \$EDITOR"
    echo -e "  ${Green}fgb${Color_Off}    → fzf: Git branch checkout"
    echo
}
alias help-aliases='help-aliases'
alias hal='help-aliases'

