# Terence's Dotfiles

Personal dotfiles repository for managing development environment configuration files using symlinks.

## Quick Start

```bash
# Clone the repository
git clone <repository-url> ~/Workspace/Personal/dotfiles
cd ~/Workspace/Personal/dotfiles

# Install everything
make

# Or install specific components
make git   # Git configuration only
make tmux  # Tmux configuration only
```

## Features

- **Idempotent Operations**: Safe to run multiple times - checks before modifying
- **Cross-Platform Support**: Automatically detects and uses your system's package manager
- **Modular Design**: Install only what you need
- **Easy Cleanup**: Remove configurations with `make clean`

## Structure

```
dotfiles/
├── git/
│   ├── config    # Git configuration
│   └── ignore    # Global gitignore
├── tmux/
│   └── conf      # Tmux configuration with TPM support
├── Makefile      # Automated setup and cleanup
└── README.md     # This file
```

## Available Commands

### Installation
- `make` or `make all` - Install all configurations
- `make git` - Set up Git configuration
- `make tmux` - Set up Tmux with TPM (Tmux Plugin Manager)

### Cleanup
- `make clean` - Remove all symlinks
- `make clean-git` - Remove Git configuration symlinks
- `make clean-tmux` - Remove Tmux configuration symlink

## What Gets Installed

### Git Configuration
- Symlinks `~/.gitconfig` → `git/config`
- Symlinks `~/.gitignore` → `git/ignore`
- Includes color settings, aliases, and sensible defaults

### Tmux Configuration
- Installs tmux (if not present) using your system's package manager
- Installs [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm)
- Symlinks `~/.tmux.conf` → `tmux/conf`
- Includes vim key bindings and mouse support
- After installation, enter tmux and press `<prefix> + I` to install plugins

## Supported Package Managers

The Makefile automatically detects and uses:
- `apt/apt-get` (Debian/Ubuntu)
- `yum/dnf` (RedHat/Fedora/CentOS)
- `pacman` (Arch Linux)
- `brew` (macOS/Linux)
- `apk` (Alpine Linux)

## Extending the Configuration

The Makefile includes a reusable `install_package` function for easy extension:

```makefile
# Example: Adding neovim configuration
neovim:
	@echo "Setting up neovim..."
	$(call install_package,neovim)
	# Add your symlinks and configuration here
```

## Requirements

- Git (for cloning this repository and TPM)
- Make (for running the Makefile)
- sudo access (for package installation)

## Notes

- All operations are idempotent - safe to run multiple times
- Symlinks are only removed if they point to this repository
- Sensitive information should be stored in separate, non-tracked files