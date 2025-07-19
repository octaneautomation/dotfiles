# ~/.config/zsh/.zshrc

# Ensure $ZDOTDIR is set
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# Load order
for file in "$ZDOTDIR/init.zsh" \
            "$ZDOTDIR/path.zsh" \
            "$ZDOTDIR/options.zsh" \
            "$ZDOTDIR/gpg.zsh" \
            "$ZDOTDIR/aliases.zsh" \
            "$ZDOTDIR/plugins.zsh"; do
    [[ -r "$file" ]] && source "$file"
done
