#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# File: 46-yadm-remote.sh
# Description:
#   Updates the YADM remote origin URL using GIT_HOST, GIT_USER, and GIT_REPO
#   variables from the bootstrap driver.
#
# Requirements:
#   - yadm must be installed and configured
#   - Bootstrap driver must export: GIT_HOST, GIT_USER, GIT_REPO
# ---------------------------------------------------------------------------

REMOTE_NAME="origin"
REMOTE_URL="git@${GIT_HOST}:${GIT_USER}/${GIT_REPO}.git"

log_section "Configuring YADM Remote"

# Validate environment variables
if [ -z "$GIT_HOST" ] || [ -z "$GIT_USER" ] || [ -z "$GIT_REPO" ]; then
    log "${Red}Error:${Color_Off} Missing one or more required environment variables (GIT_HOST, GIT_USER, GIT_REPO)."
    exit 1
fi

# Check if yadm is installed
if ! command -v yadm >/dev/null 2>&1; then
    log "${Red}Error:${Color_Off} yadm command not found."
    exit 1
fi

# Get current remote (if any)
current_remote=$(yadm remote get-url "$REMOTE_NAME" 2>/dev/null || true)

if [ -n "$current_remote" ]; then
    if [ "$current_remote" = "$REMOTE_URL" ]; then
        log "${Green}✔ YADM remote is already set correctly:${Color_Off} $REMOTE_URL"
    else
        if [ "$DRY_RUN" -eq 1 ]; then
            log "${Yellow}[DRY-RUN]${Color_Off} Would update YADM remote from $current_remote to $REMOTE_URL"
        else
            log "${Blue}Updating YADM remote:${Color_Off} $current_remote → $REMOTE_URL"
            yadm remote set-url "$REMOTE_NAME" "$REMOTE_URL"
        fi
    fi
else
    if [ "$DRY_RUN" -eq 1 ]; then
        log "${Yellow}[DRY-RUN]${Color_Off} Would add YADM remote $REMOTE_NAME with $REMOTE_URL"
    else
        log "${Blue}Adding YADM remote:${Color_Off} $REMOTE_URL"
        yadm remote add "$REMOTE_NAME" "$REMOTE_URL"
    fi
fi

