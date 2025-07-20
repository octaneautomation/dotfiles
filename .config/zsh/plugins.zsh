# =====================================================================
# Zinit Zsh Plugin Configuration – Complete Guide (macOS & Debian Compatible)
# =====================================================================
#
# This Zsh configuration transforms your terminal into a fast, modern,
# and productive environment with fuzzy search, smart history navigation,
# syntax highlighting, and a minimal but informative prompt.
#
# ─── What This Setup Provides ─────────────────────────────────────────────
#
# ✔ Informative Prompt (Starship):
#   • Displays useful info like Git branch, exit status, and system info.
#   • Optimized for speed using precompiled binaries.
#
# ✔ Smarter Command Line:
#   • Syntax highlighting (mistakes are obvious).
#   • Autosuggestions from history (press → to accept).
#   • Extended completions for many tools.
#
# ✔ Fuzzy Search Everywhere (powered by fzf):
#   **What is fzf?**
#     fzf is an interactive search tool. Type a few letters, see matches,
#     and select with arrow keys. It’s extremely fast and powerful.
#
#   **Where it works in this setup:**
#     • Ctrl+R → Search command history.
#     • Ctrl+T → Search files in the current directory (with preview).
#
#   **Features:**
#     • Syntax-highlighted previews using bat (or batcat).
#     • Uses fd for fast file/directory searches (if installed).
#     • Mac-friendly shortcuts (Ctrl-based, no Alt required).
#
# ✔ Fuzzy Tab Completion (fzf-tab):
#   • Replaces boring Tab completion with an interactive fuzzy menu.
#   • Example: type `ssh` + Tab → Choose a host from ~/.ssh/config.
#
# ✔ Universal Launcher (Ctrl+Space):
#   • A quick menu for common actions:
#       History     → Browse command history
#       Files       → Pick a file to open
#       Directories → Jump to a folder
#       Git Branches→ Switch branches
#       Processes   → Kill a running process
#       SSH         → Connect to a host in ~/.ssh/config
#
# ✔ Smart History Navigation (Up/Down Arrows):
#   • Type a prefix (e.g., `vi`) then press ↑ → Show only commands starting with `vi`.
#   • If no text is typed, behaves like normal history navigation.
#
# ─── Key Bindings ─────────────────────────────────────────────────────────
#   Ctrl+R        → Fuzzy search command history
#   Ctrl+T        → Fuzzy search files (with preview)
#   Ctrl+Space    → Universal Launcher (History / Files / Dirs / Git / SSH / Kill)
#   ↑ / ↓         → Prefix-based history search
#
#   Inside fzf menus:
#     Ctrl+J / K  → Move down/up
#     Ctrl+H / L  → Page up/down
#     Ctrl+D / U  → Half-page scroll
#     Ctrl+G / G  → Jump to first/last
#     Ctrl+S      → Toggle sort
#     Ctrl+V / Esc→ Toggle preview pane
#
# ─── Notes ───────────────────────────────────────────────────────────────
# • Works on macOS and Debian.
# • SSH menu reads from ~/.ssh/config.
# • Previews use bat or batcat if available (fallback: cat).
# • fd used for super-fast file/directory search (fallback: ripgrep).
#
# =====================================================================

# --- 1. Language & Locale ---
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8

# =====================================================================
# 2. Starship Prompt (Optimized Loading)
# =====================================================================
zinit ice from"gh-r" as"command" atload'eval "$(starship init zsh)"'
zinit load starship/starship

# =====================================================================
# 3. Core Zsh Enhancements
# =====================================================================
zinit for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    zdharma-continuum/fast-syntax-highlighting

# =====================================================================
# 4. fzf Integration
# =====================================================================
export PATH="$HOME/.fzf/bin:$PATH" # Add if installed manually
zinit light junegunn/fzf
zinit ice lucid wait"0a"
zinit light Aloxaf/fzf-tab
zinit snippet "https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh"

# =====================================================================
# 5. fzf Settings
# =====================================================================
export FZF_DEFAULT_OPTS="
  --height 40%
  --reverse
  --border
  --bind 'ctrl-j:down,ctrl-k:up'
  --bind 'ctrl-h:page-up,ctrl-l:page-down'
  --bind 'ctrl-g:first,ctrl-G:last'
  --bind 'ctrl-d:half-page-down,ctrl-u:half-page-up'
  --bind 'ctrl-s:toggle-sort'
  --bind 'ctrl-v:toggle-preview,esc:toggle-preview'
"

# Previews for history and directories
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap"

# File preview (bat > batcat > cat)
if command -v batcat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'batcat --style=numbers --color=always {} || cat {}'"
elif command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} || cat {}'"
else
  export FZF_CTRL_T_OPTS="--preview 'cat {}'"
fi

# Use fd for speed, fallback to ripgrep
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
fi

# =====================================================================
# 6. fzf-tab Settings
# =====================================================================
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group 'ctrl-/'

# =====================================================================
# 7. Debian fzf Examples (Required on Debian)
# =====================================================================
[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh

# =====================================================================
# 8. Universal Launcher (Ctrl+Space)
# =====================================================================
fzf_launcher() {
  local choice
  choice=$(printf "History\nFiles\nDirectories\nGit Branches\nProcesses\nSSH" |
    fzf --prompt="Launcher > " --height=40% --border --reverse)

  case "$choice" in
    History) zle fzf-history-widget ;;
    Files) zle fzf-file-widget ;;
    Directories) zle fzf-cd-widget ;;
    "Git Branches") zle fzf-git-branches-widget ;;
    Processes)
      local pid
      pid=$(ps -ef | sed 1d | fzf --header="Select process to kill" | awk '{print $2}')
      [[ -n "$pid" ]] && kill -9 "$pid"
      ;;
    SSH)
      local host
      host=$(awk '/^Host / {print $2}' ~/.ssh/config 2>/dev/null | fzf --prompt="SSH > ")
      [[ -n "$host" ]] && ssh "$host"
      ;;
  esac
}
zle -N fzf_launcher
bindkey '^ ' fzf_launcher  # Bind Ctrl+Space to launcher

# =====================================================================
# 9. Prefix-based history search (Up/Down)
# =====================================================================
bindkey -e  # Ensure emacs keymap
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Explicit bindings
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Terminfo-based bindings for portability
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
