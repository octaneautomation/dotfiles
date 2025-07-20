#!/bin/sh
# Make shell_colors.sh available in ~/.local/bin for reuse

COLORS_SRC="$(dirname "$0")/10-colors.sh"
LOCAL_DIR="$HOME/.local/bin"
LOCAL_TARGET="$LOCAL_DIR/shell_colors.sh"

# Ensure ~/.local/bin exists
if [ "$DRY_RUN" -eq 1 ]; then
    printf "%b[DRY-RUN]%b mkdir -p %s\n" "$Yellow" "$Color_Off" "$LOCAL_DIR"
else
    mkdir -p "$LOCAL_DIR"
fi

# Create symlink (or copy if symlink fails)
if [ "$DRY_RUN" -eq 1 ]; then
    printf "%b[DRY-RUN]%b ln -sf %s %s\n" "$Yellow" "$Color_Off" "$COLORS_SRC" "$LOCAL_TARGET"
else
    ln -sf "$COLORS_SRC" "$LOCAL_TARGET" || cp "$COLORS_SRC" "$LOCAL_TARGET"
fi

# Warn if ~/.local/bin not in PATH
case ":$PATH:" in
    *":$LOCAL_DIR:"*) : ;;
    *)
        printf "%bWarning:%b %s is not in PATH. Add it to your shell profile.\n" \
            "$Yellow" "$Color_Off" "$LOCAL_DIR"
        ;;
esac

