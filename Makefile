# Dotfiles Makefile
.PHONY: all git tmux clean clean-git clean-tmux

# Package manager detection and installation function
# Usage: $(call install_package,package_name)
define install_package
	@if ! command -v $(1) > /dev/null 2>&1; then \
		echo "  $(1) not found, installing..."; \
		if [ -x "$$(command -v apt-get)" ]; then \
			sudo apt-get update && sudo apt-get install -y $(1); \
		elif [ -x "$$(command -v apt)" ]; then \
			sudo apt update && sudo apt install -y $(1); \
		elif [ -x "$$(command -v yum)" ]; then \
			sudo yum install -y $(1); \
		elif [ -x "$$(command -v dnf)" ]; then \
			sudo dnf install -y $(1); \
		elif [ -x "$$(command -v pacman)" ]; then \
			sudo pacman -S --noconfirm $(1); \
		elif [ -x "$$(command -v brew)" ]; then \
			brew install $(1); \
		elif [ -x "$$(command -v apk)" ]; then \
			sudo apk add $(1); \
		else \
			echo "  ERROR: Could not detect package manager to install $(1)"; \
			echo "  Please install $(1) manually and run make again"; \
			exit 1; \
		fi; \
		echo "  $(1) installed successfully"; \
	else \
		echo "  $(1) already installed"; \
	fi
endef

# Default target - runs all configuration
all: git tmux

# Clean all symlinks
clean: clean-git clean-tmux

# Git configuration symlinks
git:
	@echo "Setting up git configuration..."
	@if [ -L ~/.gitconfig ] && [ "$$(readlink ~/.gitconfig)" = "$(PWD)/git/config" ]; then \
		echo "  ~/.gitconfig already linked correctly"; \
	else \
		ln -sfn $(PWD)/git/config ~/.gitconfig; \
		echo "  Linked ~/.gitconfig -> $(PWD)/git/config"; \
	fi
	@if [ -L ~/.gitignore ] && [ "$$(readlink ~/.gitignore)" = "$(PWD)/git/ignore" ]; then \
		echo "  ~/.gitignore already linked correctly"; \
	else \
		ln -sfn $(PWD)/git/ignore ~/.gitignore; \
		echo "  Linked ~/.gitignore -> $(PWD)/git/ignore"; \
	fi
	@echo "Git configuration complete."

# Tmux configuration and setup
tmux:
	@echo "Setting up tmux..."
	$(call install_package,tmux)
	@# Install TPM (Tmux Plugin Manager)
	@if [ ! -d ~/.tmux/plugins/tpm ]; then \
		echo "  Installing TPM (Tmux Plugin Manager)..."; \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
		echo "  TPM installed successfully"; \
	else \
		echo "  TPM already installed"; \
	fi
	@# Symlink tmux config
	@if [ -L ~/.tmux.conf ] && [ "$$(readlink ~/.tmux.conf)" = "$(PWD)/tmux/conf" ]; then \
		echo "  ~/.tmux.conf already linked correctly"; \
	else \
		ln -sfn $(PWD)/tmux/conf ~/.tmux.conf; \
		echo "  Linked ~/.tmux.conf -> $(PWD)/tmux/conf"; \
	fi
	@echo "Tmux setup complete. Enter tmux and press <prefix> + I to install plugins."

# Remove git symlinks
clean-git:
	@echo "Removing git configuration symlinks..."
	@if [ -L ~/.gitconfig ] && [ "$$(readlink ~/.gitconfig)" = "$(PWD)/git/config" ]; then \
		rm -f ~/.gitconfig; \
		echo "  Removed ~/.gitconfig symlink"; \
	else \
		echo "  ~/.gitconfig not linked to this repository"; \
	fi
	@if [ -L ~/.gitignore ] && [ "$$(readlink ~/.gitignore)" = "$(PWD)/git/ignore" ]; then \
		rm -f ~/.gitignore; \
		echo "  Removed ~/.gitignore symlink"; \
	else \
		echo "  ~/.gitignore not linked to this repository"; \
	fi
	@echo "Git configuration cleanup complete."

# Remove tmux symlinks
clean-tmux:
	@echo "Removing tmux configuration symlinks..."
	@if [ -L ~/.tmux.conf ] && [ "$$(readlink ~/.tmux.conf)" = "$(PWD)/tmux/conf" ]; then \
		rm -f ~/.tmux.conf; \
		echo "  Removed ~/.tmux.conf symlink"; \
	else \
		echo "  ~/.tmux.conf not linked to this repository"; \
	fi
	@echo "Tmux configuration cleanup complete."