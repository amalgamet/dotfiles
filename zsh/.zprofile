# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -f ~/.zshrc ]] && . ~/.zshrc

[ -d "$HOME/.sc-tools" ] && source "$HOME/.sc-tools/dotfiles/env.zsh" #sc-tools-setup

# Setting PATH for Python 2.7
# The original version is saved in .zprofile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH
