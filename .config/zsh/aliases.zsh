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
#     ✔ System maintenance commands (APT, Homebrew)
#     ✔ Systemd shortcuts with interactive controls and fzf Tab completion
#
# -----------------------------------------------------------------------------
# AVAILABLE ALIASES & FUNCTIONS:
#
# [ Help ]
#   help-aliases → Show all aliases/functions (colorized)
#   hal          → Shortcut for help-aliases
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
# [ System Maintenance ]
#   apt-update, apt-full-update, brew-update, sys-update
#
# [ Systemd Shortcuts ]
#   sc, scu, sce, scd, scr, scs, scstart, scstop, scl, scj, sclo, jctl, jctlf, jctlu
#
# [ Systemd fzf Helpers ]
#   scfzr, scfzs, scfzp, scfzl
#
# [ Systemd fzf Tab Completion ]
#   scr<Tab>, scstart<Tab>, scstop<Tab>, scs<Tab> → Select service via fzf
#
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Help system
# -----------------------------------------------------------------------------
help-aliases() {
    : "${Blue:='\033[0;34m'}"
    : "${Green:='\033[0;32m'}"
    : "${Cyan:='\033[0;36m'}"
    : "${Color_Off:='\033[0m'}"

    echo -e "${Blue}📜 Available Aliases & Functions:${Color_Off}\n"

    echo -e "${Cyan}=== Directory Listings ===${Color_Off}"
    echo -e "  ${Green}ls${Color_Off}, ${Green}ll${Color_Off}, ${Green}la${Color_Off}, ${Green}l${Color_Off} → Various ls styles"
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
    echo -e "  ${Green}fd${Color_Off}, ${Green}ff${Color_Off} → Find directories/files"
    echo -e "  ${Green}fdf${Color_Off}    → fzf: Open file in \$EDITOR (with preview)"
    echo -e "  ${Green}fdd${Color_Off}    → fzf: cd into directory"
    echo -e "  ${Green}ffo${Color_Off}    → fzf: Find any file/dir & open"
    echo

    echo -e "${Cyan}=== System Utilities ===${Color_Off}"
    echo -e "  ${Green}myip${Color_Off}   → Show public IP address"
    echo -e "  ${Green}httpserve${Color_Off} → Start Python HTTP server (port 2182)"
    echo -e "  ${Green}df${Color_Off}, ${Green}duu${Color_Off} → Disk usage (duf/ncdu if installed)"
    echo

    echo -e "${Cyan}=== Dotfiles (yadm) ===${Color_Off}"
    echo -e "  ${Green}yst${Color_Off}, ${Green}ya${Color_Off}, ${Green}yd${Color_Off}, ${Green}yds${Color_Off}, ${Green}yc${Color_Off}, ${Green}yp${Color_Off}"
    echo -e "  ${Green}ysync${Color_Off}  → Interactive commit & push"
    echo

    echo -e "${Cyan}=== Git Productivity ===${Color_Off}"
    echo -e "  ${Green}gs${Color_Off}, ${Green}gl${Color_Off}, ${Green}gco${Color_Off}, ${Green}gp${Color_Off}, ${Green}gb${Color_Off}"
    echo -e "  ${Green}ga${Color_Off}, ${Green}gc${Color_Off}, ${Green}gcm${Color_Off}, ${Green}gd${Color_Off}, ${Green}gds${Color_Off}"
    echo

    echo -e "${Cyan}=== Helpers ===${Color_Off}"
    echo -e "  ${Green}mkcd${Color_Off}             → Create directory and cd"
    echo -e "  ${Green}rmdir${Color_Off}            → Remove directory (with confirmation)"
    echo -e "  ${Green}fkill${Color_Off}            → fzf: Kill selected process"
    echo

    echo -e "${Cyan}=== Clipboard ===${Color_Off}"
    echo -e "  ${Green}fh${Color_Off}               → fzf: Search history & copy to clipboard"
    echo

    echo -e "${Cyan}=== fzf Navigation ===${Color_Off}"
    echo -e "  ${Green}fcd${Color_Off}              → fzf: cd into directory"
    echo -e "  ${Green}fo${Color_Off}               → fzf: Open file in \$EDITOR"
    echo -e "  ${Green}fgb${Color_Off}              → fzf: Git branch checkout"
    echo

    echo -e "${Cyan}=== System Maintenance ===${Color_Off}"
    echo -e "  ${Green}apt-update${Color_Off}       → APT: update, upgrade, autoremove, autoclean"
    echo -e "  ${Green}apt-full-update${Color_Off}  → APT: full-upgrade (kernel too)"
    echo -e "  ${Green}brew-update${Color_Off}      → Homebrew: update, upgrade, cleanup"
    echo -e "  ${Green}sys-update${Color_Off}       → Combined APT + Homebrew updates (with prompt)"
    echo

    echo -e "${Cyan}=== Systemd Shortcuts (Linux Only) ===${Color_Off}"
    echo -e "  ${Green}sc${Color_Off}               → sudo systemctl"
    echo -e "  ${Green}scu${Color_Off}              → systemctl --user"
    echo -e "  ${Green}sce${Color_Off}              → Enable a service"
    echo -e "  ${Green}scd${Color_Off}              → Disable a service"
    echo -e "  ${Green}scr${Color_Off}              → Restart a service"
    echo -e "  ${Green}scs${Color_Off}              → Show service status"
    echo -e "  ${Green}scstart${Color_Off}          → Start a service"
    echo -e "  ${Green}scstop${Color_Off}           → Stop a service"
    echo -e "  ${Green}scl${Color_Off}              → List active services"
    echo -e "  ${Green}scj${Color_Off}              → List systemd jobs"
    echo -e "  ${Green}sclo${Color_Off}             → List timers"
    echo -e "  ${Green}jctl${Color_Off}             → journalctl (errors)"
    echo -e "  ${Green}jctlf${Color_Off}            → Follow logs (journalctl -f)"
    echo -e "  ${Green}jctlu${Color_Off}            → User logs"
    echo

    echo -e "${Cyan}=== Systemd (fzf Helpers) ===${Color_Off}"
    echo -e "  ${Green}scfzr${Color_Off}            → fzf: Restart a service"
    echo -e "  ${Green}scfzs${Color_Off}            → fzf: Start a service"
    echo -e "  ${Green}scfzp${Color_Off}            → fzf: Stop a running service"
    echo -e "  ${Green}scfzl${Color_Off}            → fzf: View live logs for a service"
    echo

    echo -e "${Cyan}=== Systemd (Tab Completion) ===${Color_Off}"
    echo -e "  ${Green}scr<Tab>, scstart<Tab>, scstop<Tab>, scs<Tab>${Color_Off} → fzf menu of services"
    echo
}
alias help-aliases='help-aliases | less -R'
alias hal='help-aliases'

# -----------------------------------------------------------------------------
# Utility: Check if a command exists
# -----------------------------------------------------------------------------
command_exists() { command -v "$1" >/dev/null 2>&1; }

# -----------------------------------------------------------------------------
# 1. Directory listings
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
# 2. Preferred editor
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
reload_zsh() { echo "🔄 Reloading Zsh configuration..."; exec zsh --login; }
alias reload-zsh='reload_zsh'

# -----------------------------------------------------------------------------
# 5. File/Directory search
# -----------------------------------------------------------------------------
if command_exists fd; then
    alias fd='fd --type d'
    alias ff='fd --type f'
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
alias edit-aliases="$EDITOR ~/.config/zsh/aliases.zsh"
alias vimrc="$EDITOR ~/.config/vim/vimrc"
command_exists duf && alias df="duf --only local"
command_exists ncdu && alias duu="ncdu --color dark -rr -e"
if command_exists python3; then alias httpserve='python3 -m http.server 2182'; else alias httpserve='python -m SimpleHTTPServer 2182'; fi

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
    echo "🔍 Current yadm status:"; yadm status; echo
    echo "✅ Adding tracked changes only..."; yadm add -u; echo
    read "?Commit message [default: 'Update configs']: " msg
    msg="${msg:-Update configs}"
    echo; echo "📋 Commit Summary:"; echo "Message: \"$msg\""; echo; yadm status
    echo; read "?Proceed with commit and push? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] && yadm commit -m "$msg" && yadm push && echo "✅ Done!" || echo "❌ Canceled."
}
alias ysync="ysync"

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
# 9. Helpers
# -----------------------------------------------------------------------------
mkcd() { mkdir -p "$1" && cd "$1" || return; }
rmdir() { [ -d "$1" ] && read "?Delete '$1'? (y/N): " c && [[ "$c" =~ ^[Yy]$ ]] && rm -rf "$1" || echo "Canceled."; }
alias fkill='ps -ef | sed 1d | fzf | awk "{print \$2}" | xargs -r kill -9'

# -----------------------------------------------------------------------------
# 10. Clipboard
# -----------------------------------------------------------------------------
if command_exists pbcopy; then alias fh="history | fzf | awk '{\$1=\"\"; print substr(\$0,2)}' | tr -d '\n' | pbcopy"
elif command_exists xclip; then alias fh="history | fzf | awk '{\$1=\"\"; print substr(\$0,2)}' | tr -d '\n' | xclip -selection clipboard"; fi

# -----------------------------------------------------------------------------
# 11. fzf Navigation
# -----------------------------------------------------------------------------
alias fcd='cd "$(find . -type d | fzf)"'
alias fo='${EDITOR:-vim} "$(fzf)"'
alias fgb='git branch | fzf | xargs git checkout'

# -----------------------------------------------------------------------------
# 12. System Maintenance
# -----------------------------------------------------------------------------
alias apt-update='sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt -y autoclean'
alias apt-full-update='sudo apt update && sudo apt -y full-upgrade && sudo apt -y autoremove && sudo apt -y autoclean'
alias brew-update='brew update && brew upgrade && brew cleanup'
sys-update() {
    echo "🔄 System update in progress..."
    echo "This will run:"
    echo "  - APT update, upgrade, autoremove, autoclean (if available)"
    echo "  - Homebrew update, upgrade, cleanup (if available)"
    echo; read "?Proceed? (y/N): " confirm
    [[ "$confirm" =~ ^[Yy]$ ]] || { echo "❌ Canceled."; return 1; }
    if command -v apt >/dev/null; then echo "➡ APT maintenance..."; sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove && sudo apt -y autoclean; fi
    if command -v brew >/dev/null; then echo "➡ Brew maintenance..."; brew update && brew upgrade && brew cleanup; fi
    echo "✅ All updates complete!"
}
alias sys-update='sys-update'

# -----------------------------------------------------------------------------
# 13. Systemd Shortcuts (Linux only)
# -----------------------------------------------------------------------------
if [[ "$(uname)" == "Linux" ]]; then
    # Basic systemctl aliases
    alias sc='sudo systemctl'
    alias scu='systemctl --user'
    alias sce='sc enable'
    alias scd='sc disable'
    alias scr='sc restart'
    alias scs='sc status'
    alias scstart='sc start'
    alias scstop='sc stop'
    alias scl='sc list-units --type=service'
    alias scj='sc list-jobs'
    alias sclo='sc list-timers'
    alias jctl='journalctl -xe'
    alias jctlf='journalctl -f'       # Follow logs
    alias jctlu='journalctl --user'   # User logs

    # -----------------------------------------------------------------------------
    # fzf-powered helpers for Systemd
    # -----------------------------------------------------------------------------
    scfz_restart() {
        local service
        service=$(systemctl list-units --type=service --no-legend --no-pager | awk '{print $1}' | fzf --prompt="Restart service: ")
        [[ -n "$service" ]] && sc restart "$service" && echo "✅ Restarted $service"
    }

    scfz_start() {
        local service
        service=$(systemctl list-unit-files --type=service --no-legend | awk '{print $1}' | fzf --prompt="Start service: ")
        [[ -n "$service" ]] && sc start "$service" && echo "✅ Started $service"
    }

    scfz_stop() {
        local service
        service=$(systemctl list-units --type=service --state=running --no-legend --no-pager | awk '{print $1}' | fzf --prompt="Stop service: ")
        [[ -n "$service" ]] && sc stop "$service" && echo "✅ Stopped $service"
    }

    scfz_logs() {
        local service
        service=$(systemctl list-units --type=service --no-legend --no-pager | awk '{print $1}' | fzf --prompt="View logs for: ")
        [[ -n "$service" ]] && journalctl -u "$service" -f
    }

    alias scfzr='scfz_restart'
    alias scfzs='scfz_start'
    alias scfzp='scfz_stop'
    alias scfzl='scfz_logs'

    # -----------------------------------------------------------------------------
    # Interactive fzf Tab Completion for Systemd Aliases
    # -----------------------------------------------------------------------------
    _fzf_systemd_services() {
        local services
        services=($(systemctl list-unit-files --type=service --no-legend | awk '{print $1}'))

        # Apply filter if user typed part of the name
        local cur_word="${words[-1]}"
        if [[ -n "$cur_word" ]]; then
            services=($(printf '%s\n' "${services[@]}" | grep -i "$cur_word"))
        fi

        local selected
        selected=$(printf '%s\n' "${services[@]}" | fzf --prompt="Select systemd service: " --height 40% --reverse)

        if [[ -n "$selected" ]]; then
            LBUFFER="$LBUFFER$selected"
        fi

        zle redisplay
    }

    # Register ZLE widget for fzf completion
    zle -N fzf-systemd-complete _fzf_systemd_services

    # Ensure Zsh completion system is active
    autoload -Uz compinit
    compinit

    # Override completion for specific aliases with fzf widget
    zstyle ':completion:*:*:scr:*' completer _fzf_systemd_services
    zstyle ':completion:*:*:scstart:*' completer _fzf_systemd_services
    zstyle ':completion:*:*:scstop:*' completer _fzf_systemd_services
    zstyle ':completion:*:*:scs:*' completer _fzf_systemd_services
fi

