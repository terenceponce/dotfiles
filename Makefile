# Dotfiles Makefile
.PHONY: all git tmux prompt clean clean-git clean-tmux clean-prompt

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
all: git tmux prompt

# Clean all symlinks
clean: clean-git clean-tmux clean-prompt

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

# Oh-My-Posh prompt setup
prompt:
	@echo "Setting up Oh-My-Posh prompt..."
	@# Install Oh-My-Posh (includes themes automatically)
	@if ! command -v oh-my-posh > /dev/null 2>&1; then \
		echo "  Installing Oh-My-Posh..."; \
		curl -s https://ohmyposh.dev/install.sh | bash -s; \
		echo "  Oh-My-Posh installed successfully"; \
	else \
		echo "  Oh-My-Posh already installed"; \
	fi
	@# Add Oh-My-Posh initialization to ~/.bashrc
	@if [ ! -f ~/.bashrc ]; then \
		touch ~/.bashrc; \
		echo "  Created ~/.bashrc"; \
	fi
	@if ! grep -q "oh-my-posh init" ~/.bashrc; then \
		echo "" >> ~/.bashrc; \
		echo "# Oh-My-Posh initialization" >> ~/.bashrc; \
		echo "eval \"\$$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json')\"" >> ~/.bashrc; \
		echo "  Added Oh-My-Posh initialization with dracula theme to ~/.bashrc"; \
	else \
		echo "  Oh-My-Posh initialization already exists in ~/.bashrc"; \
	fi
	@echo "Oh-My-Posh setup complete. Restart your shell or source ~/.bashrc to see the new prompt."

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

# Remove Oh-My-Posh configuration
clean-prompt:
	@echo "Removing Oh-My-Posh configuration..."
	@# Remove Oh-My-Posh initialization from ~/.bashrc
	@if [ -f ~/.bashrc ]; then \
		if grep -q "oh-my-posh init" ~/.bashrc; then \
			grep -v "oh-my-posh init" ~/.bashrc > ~/.bashrc.tmp && mv ~/.bashrc.tmp ~/.bashrc; \
			echo "  Removed Oh-My-Posh initialization from ~/.bashrc"; \
		else \
			echo "  No Oh-My-Posh initialization found in ~/.bashrc"; \
		fi; \
	else \
		echo "  ~/.bashrc not found"; \
	fi
	@# Remove Oh-My-Posh binary
	@if command -v oh-my-posh > /dev/null 2>&1; then \
		posh_path=$$(command -v oh-my-posh); \
		rm -f "$$posh_path"; \
		echo "  Removed Oh-My-Posh binary: $$posh_path"; \
	else \
		echo "  Oh-My-Posh binary not found"; \
	fi
	@echo "Oh-My-Posh cleanup complete."