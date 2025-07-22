# YADM Dotfiles Bootstrap

This repository contains a modular setup for managing and bootstrapping your system configuration using **[YADM](https://yadm.io/)** (Yet Another Dotfiles Manager). It automates applying configurations, installing packages, and setting up your environment efficiently.

---

## ✅ Features

- **Modular Scripts** – Separate scripts for tasks like installing packages, configuring apps, and restoring GPG keys.
- **Dry Run Mode** – Preview what actions will be taken without applying changes.
- **Verbose Mode** – Detailed logs for easier troubleshooting.
- **Color-Coded Output** – Readable logs with color.

---

## 🔍 Prerequisites

- **Install YADM**  
  Follow the [YADM installation instructions](https://yadm.io/docs/install) for your OS.
- Ensure **Git** is installed and available in your `PATH`.

---

## 🚀 Installation

Clone your dotfiles with YADM:

```bash
yadm clone https://github.com/octaneautomation/dotfiles.git
```

### What happens next?

- YADM initializes and sets up your dotfiles
- If the repository includes a `.yadm/bootstrap` script, it will **run automatically**
- This script can install packages, configure apps, and apply system tweaks

---

## ▶ Re-running the Bootstrap

If you want to manually re-run the bootstrap after cloning:

```bash
yadm bootstrap
```

You can pass arguments to it as needed (e.g., `--dry-run` or `--verbose` if supported by your script).

---

## 🛠 Customization

Environment variables you can adjust inside the bootstrap:

- **`GIT_HOST`**, **`GIT_USER`**, **`GIT_REPO`**  
  Change these if you use a custom dotfiles repository.

---

## 📦 Available Modules

- **20-packages.sh** – Installs required packages (Linux/macOS)
- **40-gpg.sh** – Restores GPG keys from backup if available
- **45-iterm2.sh** – Configures iTerm2 on macOS
- **46-yadm-remote.sh** – Updates YADM remote repository info

---

## ✅ Verification

After running the bootstrap, check:

- Your apps and settings are as expected
- Logs in `~/yadm_bootstrap.log` for any errors or warnings

---

## ❓ Troubleshooting

- Ensure required tools (Git, Homebrew, etc.) are installed and in your `PATH`
- Check the log file for error details
- Consult the [YADM Documentation](https://yadm.io/docs)

---

### 💡 Why YADM?

YADM is a lightweight yet powerful dotfiles manager, making it easy to maintain a single repository for all your configurations across multiple systems.

---

**Happy dotfiling!** 🎉

