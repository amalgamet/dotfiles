export DOTFILES=${DOTFILES:-$HOME/.dotfiles}

# Oh My Zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
HIST_STAMPS="yyyy/mm/dd"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Environment
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -w'
fi

# Aliases
alias c='clear'

if hash python3 2>/dev/null; then
  alias python=python3
fi

if hash bat 2>/dev/null; then
  alias cat=bat
fi

if hash rg 2>/dev/null; then
  alias rg='rg --colors path:fg:212 --colors line:fg:141 --colors match:fg:203'
fi

if hash eza 2>/dev/null; then
  alias ls='eza -G'
  alias l='eza -lah'
  alias la='eza -lAh'
  alias ll='eza -lh'
  alias lsa='eza -lah'
else
  alias ls='ls -G'
  alias l='ls -lah'
  alias la='ls -lAh'
  alias ll='ls -lh'
  alias lsa='ls -lah'
fi
