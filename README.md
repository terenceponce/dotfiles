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
make git     # Git configuration only
make tmux    # Tmux configuration only
make prompt  # Oh-My-Posh prompt only
make neovim  # Neovim configuration only
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
├── neovim/       # Neovim configuration (symlinked to ~/.config/nvim)
│   ├── init.lua  # Main configuration file (LazyVim-based)
│   └── lua/      # Lua configuration modules
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
- `make prompt` - Set up Oh-My-Posh prompt with dracula theme
- `make neovim` - Set up Neovim configuration

### Cleanup
- `make clean` - Remove all configurations
- `make clean-git` - Remove Git configuration symlinks
- `make clean-tmux` - Remove Tmux configuration symlink
- `make clean-prompt` - Remove Oh-My-Posh configuration and binary
- `make clean-neovim` - Remove Neovim configuration symlink

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

### Oh-My-Posh Prompt
- Installs Oh-My-Posh prompt engine using the official installer
- Configures dracula theme via GitHub URL (no local theme files)
- Adds initialization to ~/.bashrc automatically
- After installation, restart your shell or source ~/.bashrc to see the new prompt

### Neovim Configuration
- Installs neovim (if not present) using your system's package manager
- Symlinks `~/.config/nvim` → `neovim/`
- Based on [LazyVim](https://www.lazyvim.org/) - a modern Neovim configuration framework
- Includes Lua-based configuration with plugins and modern setup
- Ready to use after installation

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
# Example: Adding zsh configuration
zsh:
	@echo "Setting up zsh..."
	$(call install_package,zsh)
	# Add your symlinks and configuration here

# Don't forget to add to the main targets:
# all: git tmux prompt neovim zsh
# clean: clean-git clean-tmux clean-prompt clean-neovim clean-zsh
```

## Requirements

- Git (for cloning this repository and TPM)
- Make (for running the Makefile)
- curl (for Oh-My-Posh installation)
- sudo access (for package installation)

## Notes

- All operations are idempotent - safe to run multiple times
- Symlinks are only removed if they point to this repository
- Sensitive information should be stored in separate, non-tracked files