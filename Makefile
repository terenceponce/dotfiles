# Dotfiles Makefile
.PHONY: all git clean clean-git

# Default target - runs all configuration
all: git

# Clean all symlinks
clean: clean-git

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