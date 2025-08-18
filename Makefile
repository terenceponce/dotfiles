# Dotfiles Makefile
.PHONY: all git tmux prompt neovim clean clean-git clean-tmux clean-prompt clean-neovim

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
all: git tmux prompt neovim

# Clean all symlinks
clean: clean-git clean-tmux clean-prompt clean-neovim

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

# Prompt setup with ble.sh and Oh-My-Posh
prompt:
	@echo "Setting up prompt with ble.sh and Oh-My-Posh..."
	@# Install dependencies for ble.sh
	$(call install_package,git)
	$(call install_package,make)
	$(call install_package,gawk)
	@# Install ble.sh
	@if [ ! -f ~/.local/share/blesh/ble.sh ]; then \
		echo "  Installing ble.sh..."; \
		git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git /tmp/ble.sh; \
		make -C /tmp/ble.sh install PREFIX=$$HOME/.local; \
		rm -rf /tmp/ble.sh; \
		echo "  ble.sh installed successfully"; \
	else \
		echo "  ble.sh already installed"; \
	fi
	@# Install Oh-My-Posh (includes themes automatically)
	@if ! command -v oh-my-posh > /dev/null 2>&1; then \
		echo "  Installing Oh-My-Posh..."; \
		curl -s https://ohmyposh.dev/install.sh | bash -s; \
		echo "  Oh-My-Posh installed successfully"; \
	else \
		echo "  Oh-My-Posh already installed"; \
	fi
	@# Configure ~/.bashrc with proper ordering
	@if [ ! -f ~/.bashrc ]; then \
		touch ~/.bashrc; \
		echo "  Created ~/.bashrc"; \
	fi
	@# Remove existing prompt configurations to rebuild in correct order
	@if grep -q "ble.sh\|oh-my-posh init\|set -o vi\|ble-bind" ~/.bashrc; then \
		grep -v "source.*blesh/ble.sh\|oh-my-posh init\|set -o vi\|ble-bind\|BLE_VERSION.*ble-attach" ~/.bashrc > ~/.bashrc.tmp && mv ~/.bashrc.tmp ~/.bashrc; \
		sed -i '/^# ble\.sh configuration$$/d; /^# Oh-My-Posh initialization$$/d; /^# Enable vim mode$$/d; /^# ble\.sh customizations$$/d' ~/.bashrc; \
		echo "  Removed existing prompt configurations for rebuild"; \
	fi
	@# Add ble.sh configuration first
	@echo "" >> ~/.bashrc
	@echo "# ble.sh configuration" >> ~/.bashrc
	@echo "source -- ~/.local/share/blesh/ble.sh" >> ~/.bashrc
	@echo "" >> ~/.bashrc
	@echo "# Enable vim mode" >> ~/.bashrc
	@echo "set -o vi" >> ~/.bashrc
	@echo "" >> ~/.bashrc
	@echo "# ble.sh customizations" >> ~/.bashrc
	@echo "ble-bind -f 'C-y' 'accept-line'" >> ~/.bashrc
	@echo "ble-bind -f 'C-j' ''" >> ~/.bashrc
	@echo "" >> ~/.bashrc
	@# Add Oh-My-Posh initialization last
	@echo "# Oh-My-Posh initialization (must be last)" >> ~/.bashrc
	@echo "eval \"\$$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/dracula.omp.json')\"" >> ~/.bashrc
	@echo "" >> ~/.bashrc
	@echo "[[ \$${BLE_VERSION-} ]] && ble-attach" >> ~/.bashrc
	@echo "  Added ble.sh and Oh-My-Posh configuration to ~/.bashrc"
	@echo "Prompt setup complete. Restart your shell to use ble.sh with vim mode and Oh-My-Posh."

# Neovim configuration symlinks
neovim:
	@echo "Setting up neovim configuration..."
	$(call install_package,neovim)
	@# Create ~/.config directory if it doesn't exist
	@mkdir -p ~/.config
	@# Symlink neovim config
	@if [ -L ~/.config/nvim ] && [ "$$(readlink ~/.config/nvim)" = "$(PWD)/neovim" ]; then \
		echo "  ~/.config/nvim already linked correctly"; \
	else \
		ln -sfn $(PWD)/neovim ~/.config/nvim; \
		echo "  Linked ~/.config/nvim -> $(PWD)/neovim"; \
	fi
	@echo "Neovim configuration complete."

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

# Remove prompt configuration (ble.sh and Oh-My-Posh)
clean-prompt:
	@echo "Removing prompt configuration..."
	@# Remove ble.sh and Oh-My-Posh configuration from ~/.bashrc
	@if [ -f ~/.bashrc ]; then \
		if grep -q "ble.sh\|oh-my-posh init\|set -o vi\|ble-bind" ~/.bashrc; then \
			grep -v "source.*blesh/ble.sh\|oh-my-posh init\|set -o vi\|ble-bind\|BLE_VERSION.*ble-attach" ~/.bashrc > ~/.bashrc.tmp && mv ~/.bashrc.tmp ~/.bashrc; \
			sed -i '/^# ble\.sh configuration$$/d; /^# Oh-My-Posh initialization.*$$/d; /^# Enable vim mode$$/d; /^# ble\.sh customizations$$/d' ~/.bashrc; \
			echo "  Removed prompt configuration from ~/.bashrc"; \
		else \
			echo "  No prompt configuration found in ~/.bashrc"; \
		fi; \
	else \
		echo "  ~/.bashrc not found"; \
	fi
	@# Remove ble.sh installation
	@if [ -f ~/.local/share/blesh/ble.sh ]; then \
		rm -rf ~/.local/share/blesh; \
		echo "  Removed ble.sh installation"; \
	else \
		echo "  ble.sh not installed"; \
	fi
	@# Remove Oh-My-Posh binary
	@if command -v oh-my-posh > /dev/null 2>&1; then \
		posh_path=$$(command -v oh-my-posh); \
		rm -f "$$posh_path"; \
		echo "  Removed Oh-My-Posh binary: $$posh_path"; \
	else \
		echo "  Oh-My-Posh binary not found"; \
	fi
	@echo "Prompt cleanup complete."

# Remove neovim symlinks
clean-neovim:
	@echo "Removing neovim configuration symlinks..."
	@if [ -L ~/.config/nvim ] && [ "$$(readlink ~/.config/nvim)" = "$(PWD)/neovim" ]; then \
		rm -f ~/.config/nvim; \
		echo "  Removed ~/.config/nvim symlink"; \
	else \
		echo "  ~/.config/nvim not linked to this repository"; \
	fi
	@echo "Neovim configuration cleanup complete."