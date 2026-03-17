DOTFILES_DIR := $(shell cd $(dir $(lastword $(MAKEFILE_LIST))) && pwd)
STOW_FOLDERS := zsh git bat ssh claude

.PHONY: help install stow unstow restow brew macos

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Full bootstrap (runs bootstrap.sh)
	@bash $(DOTFILES_DIR)/bootstrap.sh

stow: ## Symlink all topic folders to home
	@for folder in $(STOW_FOLDERS); do \
		stow --target=$(HOME) --dir=$(DOTFILES_DIR) --restow $$folder; \
	done

unstow: ## Remove all symlinks
	@for folder in $(STOW_FOLDERS); do \
		stow --target=$(HOME) --dir=$(DOTFILES_DIR) --delete $$folder; \
	done

restow: stow ## Re-symlink (alias for stow)

brew: ## Install packages from Brewfile
	brew bundle --file=$(DOTFILES_DIR)/brew/Brewfile

macos: ## Run .macos preferences script (with confirmation)
	@echo "This will modify macOS system preferences. Continue? [y/N]" && \
	read ans && [ "$$ans" = "y" ] && bash $(DOTFILES_DIR)/macos/.macos
