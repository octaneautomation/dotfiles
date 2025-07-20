# ~/.config/zsh/gpg.zsh

# Ensure GPG works with pinentry in terminals
export GPG_TTY=$(tty)

zinit ice atinit'~/.local/bin/load-gpg-passphrase.sh'