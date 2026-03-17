#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y-%m-%d-%H%M%S)"
STOW_FOLDERS=(zsh git bat)
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "[dry-run] No changes will be made."
  echo ""
fi

info() { echo "[info] $*"; }
warn() { echo "[warn] $*"; }
fail() { echo "[error] $*" >&2; exit 1; }

# --- Xcode CLI Tools ---
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  if [[ "$DRY_RUN" == false ]]; then
    xcode-select --install
    echo "Press any key after Xcode CLI tools finish installing..."
    read -r -n 1
  fi
else
  info "Xcode CLI tools already installed."
fi

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  if [[ "$DRY_RUN" == false ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  info "Homebrew already installed."
fi

# --- Stow ---
if ! command -v stow &>/dev/null; then
  info "Installing stow via Homebrew..."
  if [[ "$DRY_RUN" == false ]]; then
    brew install stow
  fi
else
  info "stow already installed."
fi

# --- Oh My Zsh ---
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "Installing Oh My Zsh..."
  if [[ "$DRY_RUN" == false ]]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
  fi
else
  info "Oh My Zsh already installed."
fi

# --- Backup conflicting files ---
backup_if_exists() {
  local target="$1"
  if [[ -e "$target" && ! -L "$target" ]]; then
    info "Backing up $target -> $BACKUP_DIR/"
    if [[ "$DRY_RUN" == false ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "${target#$HOME/}")"
      mv "$target" "$BACKUP_DIR/${target#$HOME/}"
    fi
  elif [[ -L "$target" ]]; then
    info "Removing existing symlink $target"
    if [[ "$DRY_RUN" == false ]]; then
      rm "$target"
    fi
  fi
}

info "Checking for conflicting files..."
for folder in "${STOW_FOLDERS[@]}"; do
  while IFS= read -r -d '' file; do
    relative="${file#$DOTFILES_DIR/$folder/}"
    target="$HOME/$relative"
    backup_if_exists "$target"
  done < <(find "$DOTFILES_DIR/$folder" -type f -print0)
done

# --- Stow ---
info "Stowing configs: ${STOW_FOLDERS[*]}"
if [[ "$DRY_RUN" == false ]]; then
  for folder in "${STOW_FOLDERS[@]}"; do
    stow --target="$HOME" --dir="$DOTFILES_DIR" --restow "$folder"
  done
else
  for folder in "${STOW_FOLDERS[@]}"; do
    stow --target="$HOME" --dir="$DOTFILES_DIR" --restow --simulate "$folder" 2>&1 || true
  done
fi

# --- Brew Bundle ---
if command -v brew &>/dev/null; then
  info "Installing packages from Brewfile..."
  if [[ "$DRY_RUN" == false ]]; then
    brew bundle --file="$DOTFILES_DIR/brew/Brewfile"
  else
    info "[dry-run] Would run: brew bundle --file=$DOTFILES_DIR/brew/Brewfile"
  fi
fi

# --- Set DOTFILES env for current session ---
export DOTFILES="$DOTFILES_DIR"

echo ""
info "Done! Open a new terminal to load the updated shell config."
if [[ -d "$BACKUP_DIR" ]]; then
  info "Backups saved to: $BACKUP_DIR"
fi
