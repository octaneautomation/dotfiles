#!/bin/bash
# ---------------------------------------------------------------------------
# File: 40-gpg.sh
# Description:
#   Bootstrap helper script for YADM to restore GPG keys from a backup
#   directory if backup files exist. It also fixes permissions and sets
#   a trust model for non-interactive environments.
#
# Requirements:
#   - gpg must be installed and available in PATH
#   - Environment must define color variables: Yellow, Red, Green, Blue,
#     Purple, Cyan, Color_Off (consistent with other scripts)
#
# Usage:
#   ./40-gpg.sh
#
# Notes:
#   Backup directory defaults to ~/.gpg-backups
# ---------------------------------------------------------------------------

BACKUP_DIR="$HOME/.gpg-backups"
GNUPG_DIR="$HOME/.gnupg"

# Inform the user we are checking for GPG backup files
echo -e "${Blue}🔍 Checking for GPG backups...${Color_Off}"

# If required backup files exist, proceed with restore
if [[ -f "$BACKUP_DIR/secrets.asc" && -f "$BACKUP_DIR/public.asc" ]]; then
    echo -e "${Cyan}Restoring GPG keys...${Color_Off}"

    # Import public and secret keys
    gpg --import "$BACKUP_DIR/public.asc"
    gpg --import "$BACKUP_DIR/secrets.asc"

    # Import trust settings if available
    if [[ -f "$BACKUP_DIR/ownertrust.txt" ]]; then
        echo -e "${Blue}Importing owner trust...${Color_Off}"
        gpg --import-ownertrust "$BACKUP_DIR/ownertrust.txt"
    fi

    # Secure GPG directory permissions
    chmod 700 "$GNUPG_DIR"
    chmod 600 "$GNUPG_DIR"/*
    echo -e "${Green}✔ GPG keys restored and permissions fixed.${Color_Off}"

    # Set trust model to always for non-interactive environments
    echo "trust-model always" > "$GNUPG_DIR/gpg.conf"
    echo -e "${Blue}Trust model set to 'always'.${Color_Off}"
else
    echo -e "${Yellow}⚠ No GPG backup files found. Skipping.${Color_Off}"
fi
