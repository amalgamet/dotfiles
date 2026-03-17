# Environment
export DOTFILES=${DOTFILES:-$HOME/.dotfiles}
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Oh My Zsh
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
HIST_STAMPS="%y/%m/%d %T"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Starship
export STARSHIP_CONFIG=${HOME}/.config/starship.toml
command -v starship &>/dev/null && eval "$(starship init zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init - zsh)"

# Rust
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# Google Cloud SDK
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then
  . "${HOME}/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then
  . "${HOME}/google-cloud-sdk/completion.zsh.inc"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='cursor -w'
fi

# Aliases
alias c='clear'
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

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
  alias ls='eza'
  alias l='eza -lah'
  alias la='eza -lah'
  alias ll='eza -lh'
  alias lsa='eza -lah'
else
  alias l='ls -lah'
  alias la='ls -lah'
  alias ll='ls -lh'
  alias lsa='ls -lah'
fi
