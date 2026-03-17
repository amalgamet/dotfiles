# Josh's Dotfiles

macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick Start

```bash
git clone git@github.com:amalgamet/dotfiles.git ~/code/personal/amalgamet/dotfiles
cd ~/code/personal/amalgamet/dotfiles
./bootstrap.sh
```

Use `--dry-run` to preview what will happen without making changes:

```bash
./bootstrap.sh --dry-run
```

## What It Does

`bootstrap.sh` will:

1. Install Xcode CLI tools (if missing)
2. Install Homebrew (if missing)
3. Install `stow` (if missing)
4. Install Oh My Zsh (if missing)
5. Back up any conflicting files to `~/.dotfiles-backup/<timestamp>/`
6. Symlink configs to your home directory via `stow`
7. Install packages from the Brewfile

## Structure

Each folder is a Stow "package" that mirrors the home directory:

| Folder   | What it manages           | Stowed? |
|----------|---------------------------|---------|
| `zsh/`   | `.zshrc`, `.zprofile`     | Yes     |
| `git/`   | `.gitconfig`, identities  | Yes     |
| `bat/`   | `.config/bat/config`      | Yes     |
| `vim/`   | vim/neovim config         | Planned |
| `ssh/`   | SSH config                | Planned |
| `claude/`| Claude Code config        | Planned |
| `macos/` | macOS defaults script     | Manual  |
| `brew/`  | Homebrew Brewfile         | Manual  |

## Make Targets

```bash
make help      # Show all available commands
make install   # Full bootstrap
make stow      # Symlink all configs
make unstow    # Remove all symlinks
make brew      # Install Homebrew packages
make macos     # Run macOS preferences (with confirmation)
```

## Git Identity

Git uses [conditional includes](https://git-scm.com/docs/git-config#_conditional_includes) to set the correct email per directory:

- `~/code/work/` — uses work email
- `~/code/personal/` — uses personal email

## Adding New Configs

1. Create a new folder (e.g., `tmux/`)
2. Mirror the home directory structure inside it (e.g., `tmux/.tmux.conf`)
3. Add the folder name to `STOW_FOLDERS` in the Makefile
4. Run `make stow`
