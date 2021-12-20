#!/bin/sh

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
# shellcheck disable=SC2046
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
# shellcheck disable=SC2046
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # shellcheck disable=SC2016
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME"/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf "$HOME"/.zshrc
ln -s "$HOME"/.dotfiles/.zshrc "$HOME"/.zshrc

# Update Homebrew recipes
brew update

# Install all dependencies with bundle (see Brewfile)
brew tap homebrew/bundle
brew bundle --file "$DOTFILES"/Brewfile

# Set macOS preferences, which will reload the shell
# shellcheck disable=SC1091
. "$DOTFILES"/.macos