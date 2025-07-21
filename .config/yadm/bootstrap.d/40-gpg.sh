#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# File: 40-gpg.sh
# Description:
#   Bootstrap helper for YADM: restores GPG keys from backup if available.
#   - Checks for existing keys
#   - Fixes permissions
#   - Sets trust model for non-interactive use
#   - Restarts GPG agent
#   - Supports DRY_RUN and VERBOSE
#
# Requirements:
#   - gpg and gpgconf installed
#   - Color variables and log functions provided by bootstrap driver
#
# Usage:
#   ./40-gpg.sh
# ---------------------------------------------------------------------------

BACKUP_DIR="$HOME/.gpg-backups"
GNUPG_DIR="$HOME/.gnupg"

log_section "🔐 GPG Key Restoration"

if [ "${VERBOSE:-0}" -eq 1 ]; then
    log "${Blue}Checking for backup files in $BACKUP_DIR${Color_Off}"
fi

# Check for backup files
if [ -f "$BACKUP_DIR/secrets.asc" ] && [ -f "$BACKUP_DIR/public.asc" ]; then
    # Check if keys already exist
    if gpg --list-secret-keys >/dev/null 2>&1 && [ -s "$GNUPG_DIR/pubring.kbx" ]; then
        log "${Yellow}GPG keys already exist; skipping import.${Color_Off}"
    else
        if [ "${DRY_RUN:-0}" -eq 1 ]; then
            log "${Yellow}[DRY-RUN]${Color_Off} Would import GPG keys from $BACKUP_DIR"
        else
            log "${Cyan}Restoring GPG keys...${Color_Off}"

            # Import keys
            if ! gpg --import "$BACKUP_DIR/public.asc"; then
                log "${Red}Failed to import public keys.${Color_Off}"
                exit 1
            fi

            if ! gpg --import "$BACKUP_DIR/secrets.asc"; then
                log "${Red}Failed to import secret keys.${Color_Off}"
                exit 1
            fi

            # Import trust if available
            if [ -f "$BACKUP_DIR/ownertrust.txt" ]; then
                log "${Blue}Importing owner trust...${Color_Off}"
                gpg --import-ownertrust "$BACKUP_DIR/ownertrust.txt"
            fi

            # Secure permissions
            chmod 700 "$GNUPG_DIR"
            find "$GNUPG_DIR" -type f -exec chmod 600 {} \;
            log "${Green}✔ GPG keys restored and permissions fixed.${Color_Off}"

            # Configure trust model
            echo "trust-model always" > "$GNUPG_DIR/gpg.conf"
            log "${Blue}Trust model set to 'always'.${Color_Off}"

            # Restart GPG agent
            if command -v gpgconf >/dev/null 2>&1; then
                log "${Cyan}Restarting GPG agent...${Color_Off}"
                gpgconf --kill gpg-agent
                gpgconf --launch gpg-agent
                log "${Green}✔ GPG agent restarted successfully.${Color_Off}"
            else
                log "${Yellow}⚠ gpgconf not found; skipping agent restart.${Color_Off}"
            fi
        fi
    fi
else
    log "${Yellow}⚠ No GPG backup files found in $BACKUP_DIR. Skipping.${Color_Off}"
fi

