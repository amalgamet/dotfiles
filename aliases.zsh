alias c='clear'

if hash python3 2>/dev/null && alias python=python3

if hash bat 2>/dev/null && alias cat=bat

if hash rg 2>/dev/null && alias rg='rg --colors path:fg:212 --colors line:fg:141 --colors match:fg:203'

if hash exa 2>/dev/null; then
  alias ls='exa -G'
  alias l='exa -lah'
  alias la='exa -lAh'
  alias ll='exa -lh'
  alias lsa='exa -lah'
else
  alias ls='ls -G'
  alias l='ls -lah'
  alias la='ls -lAh'
  alias ll='ls -lh'
  alias lsa='ls -lah'
fi
