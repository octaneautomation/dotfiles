#!/bin/bash
# ---------------------------------------------------------------------------
# File: 40-gpg.sh
# Description:
#   Bootstrap helper script for YADM to restore GPG keys from a backup
#   directory if backup files exist. It also fixes permissions, sets
#   a trust model, and restarts the GPG agent for the session.
#
# Requirements:
#   - gpg and gpgconf must be installed
#   - Color variables should be defined by the bootstrap driver
#
# Usage:
#   ./40-gpg.sh
#
# Notes:
#   Backup directory defaults to ~/.gpg-backups
# ---------------------------------------------------------------------------

BACKUP_DIR="$HOME/.gpg-backups"
GNUPG_DIR="$HOME/.gnupg"

echo -e "${Blue}🔍 Checking for GPG backups...${Color_Off}"

if [[ -f "$BACKUP_DIR/secrets.asc" && -f "$BACKUP_DIR/public.asc" ]]; then
    echo -e "${Cyan}Restoring GPG keys...${Color_Off}"

    # Import keys
    gpg --import "$BACKUP_DIR/public.asc"
    gpg --import "$BACKUP_DIR/secrets.asc"

    # Import trust if available
    if [[ -f "$BACKUP_DIR/ownertrust.txt" ]]; then
        echo -e "${Blue}Importing owner trust...${Color_Off}"
        gpg --import-ownertrust "$BACKUP_DIR/ownertrust.txt"
    fi

    # Secure GPG directory
    chmod 700 "$GNUPG_DIR"
    chmod 600 "$GNUPG_DIR"/*
    echo -e "${Green}✔ GPG keys restored and permissions fixed.${Color_Off}"

    # Set trust model
    echo "trust-model always" > "$GNUPG_DIR/gpg.conf"
    echo -e "${Blue}Trust model set to 'always'.${Color_Off}"

    # Restart GPG agent
    if command -v gpgconf >/dev/null 2>&1; then
        echo -e "${Cyan}Restarting GPG agent...${Color_Off}"
        gpgconf --kill gpg-agent
        gpgconf --launch gpg-agent
        echo -e "${Green}✔ GPG agent restarted successfully.${Color_Off}"
    else
        echo -e "${Yellow}⚠ gpgconf not found; skipping agent restart.${Color_Off}"
    fi
else
    echo -e "${Yellow}⚠ No GPG backup files found. Skipping.${Color_Off}"
fi

