#!/bin/bash
# Bootstrap script for yadm: restore GPG keys if backups exist

BACKUP_DIR="$HOME/.gpg-backups"
GNUPG_DIR="$HOME/.gnupg"

echo -e "${BBlue}🔍 Checking for GPG backups...${Color_Off}"

if [[ -f "$BACKUP_DIR/secrets.asc" && -f "$BACKUP_DIR/public.asc" ]]; then
    echo -e "${BCyan}Restoring GPG keys...${Color_Off}"
    gpg --import "$BACKUP_DIR/public.asc"
    gpg --import "$BACKUP_DIR/secrets.asc"

    if [[ -f "$BACKUP_DIR/ownertrust.txt" ]]; then
        echo -e "${BBlue}Importing owner trust...${Color_Off}"
        gpg --import-ownertrust "$BACKUP_DIR/ownertrust.txt"
    fi

    # Fix permissions
    chmod 700 "$GNUPG_DIR"
    chmod 600 "$GNUPG_DIR"/*
    echo -e "${BIGreen}✔ GPG keys restored and permissions fixed.${Color_Off}"

    # Set trust model
    echo "trust-model always" > "$GNUPG_DIR/gpg.conf"
    echo -e "${BIPurple}Trust model set to 'always'.${Color_Off}"
else
    echo -e "${BIYellow}⚠ No GPG backup files found. Skipping.${Color_Off}"
fi