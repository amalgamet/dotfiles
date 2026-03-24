export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.node/bin:$PATH"
export PATH="$HOME/node_modules/.bin:$PATH"
export PATH="/usr/bin/openssl:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$(go env GOPATH)/bin
export GOPRIVATE=github.com/soundcloud/gokit
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=eu-central-1
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
HIST_STAMPS="%y/%m/%d %T"
plugins=(
  git
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh

# Starship
export STARSHIP_CONFIG=${HOME}/.config/starship.toml
command -v starship &>/dev/null && eval "$(starship init zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init - zsh)"

# vault
export VAULT_ADDR="https://vault.int.s-cloud.net"

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
  alias ls='eza -G'
  alias l='eza -lah'
  alias la='eza -lah'
  alias ll='eza -lh'
  alias lsa='eza -lah'
else
  alias ls='ls -G'
  alias l='ls -lah'
  alias la='ls -lAh'
  alias ll='ls -lh'
  alias lsa='ls -lah'
fi

[ -d "$HOME/.sc-tools" ] && source "$HOME/.sc-tools/dotfiles/env.zsh" #sc-tools-setup
source "${HOME}/.config/op/plugins.sh"

# pnpm
export PNPM_HOME="${HOME}/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "${HOME}/.bun/_bun" ] && source "${HOME}/.bun/_bun"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/google-cloud-sdk/path.zsh.inc" ]; then
  . "${HOME}/google-cloud-sdk/path.zsh.inc"
fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/google-cloud-sdk/completion.zsh.inc" ]; then
  . "${HOME}/google-cloud-sdk/completion.zsh.inc"
fi

. "$HOME/.local/bin/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
