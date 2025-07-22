# YADM Dotfiles Bootstrap

This repository contains a modular script for bootstrapping your system configuration using [YADM](https://yadm.io/) (Yet Another Dotfiles Manager). The scripts are designed to apply various configurations, install necessary packages, and set up your environment efficiently.

## Main Features

- **Modular Scripts**: Individual scripts handle different tasks, such as installing packages, configuring applications, or restoring GPG keys.
- **Dry Run Mode**: Execute the bootstrap without making changes to preview what actions will be taken.
- **Verbose Mode**: Provides detailed logs of each step being executed for easier troubleshooting.
- **Colorful Logging**: Enhanced readability of logs through color-coded output.

## Prerequisites

Ensure that you have `yadm` installed to manage your dotfiles. You can install it following the instructions on the [YADM installation page](https://yadm.io/#installation).

## Installation Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/octaneautomation/dotfiles.git
cd dotfiles
```

### Step 2: Set Up YADM

Set up your YADM repository and initialize it:

```bash
yadm init
```

Now add the cloned dotfiles as the remote:

```bash
yadm remote add origin https://github.com/octaneautomation/dotfiles.git
```

### Step 3: Run the Bootstrap Script

You can run the bootstrap script to set up your environment. The script will create symlinks for your configuration files, install necessary software, and apply other configurations.

```bash
./bootstrap.sh
```

- **Options**:
  - `--dry-run`: Run the script in dry-run mode to see what actions will be taken without making changes.
  - `--verbose`: Enable verbose logging for detailed output.

### Step 4: Verify Configuration

After running the script, verify that your preferred applications and settings are configured as expected. Check the log file located at `~/$HOME/yadm_bootstrap.log` for any errors or important messages.

## Customization

The default environment variables can be modified in the script:

- `GIT_HOST`, `GIT_USER`, and `GIT_REPO`: Change these values to point to your own dotfiles repository if different.

## Available Modules

1. **Package installation** (`20-packages.sh`): Installs required software on Linux and macOS.
2. **GPG Setup** (`40-gpg.sh`): Restores GPG keys from backup if available.
3. **iTerm2 Configuration** (`45-iterm2.sh`): Configures iTerm2 preferences on macOS.
4. **YADM Remote Setup** (`46-yadm-remote.sh`): Updates the YADM remote repository information.

## Troubleshooting

- If you encounter any issues, check the log file specified in the bootstrap script for details on what may have gone wrong.
- Ensure that any required applications or services (like Git, Homebrew, etc.) are installed and available in your `PATH`.

For further assistance, please consult the [YADM documentation](https://yadm.io/) or raise an issue in this repository.

---

This bootstrap kit aims to simplify your setup by automating the configuration of dotfiles and essential applications tailored to your needs. Happy dotfiling!


