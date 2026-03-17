# Dotfiles Overhaul — Phase 1: Stow Migration & Repo Restructure

## Context

This dotfiles repo was started ~5 years ago and never finished or tested end-to-end. It currently uses a bare git repo approach, has a bootstrap script that destructively removes files without backup, a 950-line untested macOS defaults script, stale Brewfile entries, and an outdated git identity. The goal is to make it safe to run on the current machine and portable to future Macs.

This spec covers **Phase 1 only**: migrating from a bare git repo to GNU Stow and restructuring the repo. Later phases (in separate specs) will handle:
- Phase 2: Modernize configs (.zshrc aliases, Brewfile updates)
- Phase 3: Rebuild .macos from scratch
- Phase 4: Populate new topic folders (vim, ssh, claude)

## New Repo Structure

```
dotfiles/
├── zsh/
│   ├── .zshrc
│   └── .zprofile
├── git/
│   ├── .gitconfig              # base config, no email
│   ├── .gitconfig-personal     # personal email
│   ├── .gitconfig-work         # work email
│   └── .gitignore_global       # renamed from current .gitignore
├── bat/
│   └── .config/
│       └── bat/
│           └── config
├── vim/                         # placeholder, populated in Phase 4
├── ssh/                         # placeholder, populated in Phase 4
│   └── .ssh/
│       └── config
├── claude/                      # placeholder, populated in Phase 4
│   └── .claude/
│       └── CLAUDE.md
├── macos/
│   └── .macos                   # not stowed — run manually
├── brew/
│   └── Brewfile                 # not stowed — run via Makefile
├── bootstrap.sh
├── Makefile
├── README.md
└── docs/
```

### Stow Mechanics

Each topic folder mirrors the home directory structure. Running `stow zsh` from the repo root creates:
- `~/.zshrc` → `dotfiles/zsh/.zshrc`
- `~/.zprofile` → `dotfiles/zsh/.zprofile`

Topics stowed automatically: `zsh`, `git`, `bat`
Topics with placeholders (stowed when populated): `vim`, `ssh`, `claude`
Topics not stowed (run manually): `macos`, `brew`

## Bootstrap Script (`bootstrap.sh`)

Replaces the current `fresh.sh`. Key behaviors:

1. **Backup existing files** — before any stow operation, copies conflicting files to `~/.dotfiles-backup/<YYYY-MM-DD-HHMMSS>/`
2. **Dry-run mode** — `./bootstrap.sh --dry-run` prints what would happen without doing it
3. **Idempotent** — safe to run multiple times
4. **No `rm -rf`** — never destructively removes files
5. **Phased execution:**
   - Check/install Xcode CLI tools
   - Check/install Homebrew
   - `brew install stow` (if not present)
   - Check/install Oh My Zsh
   - Back up conflicting files
   - `stow` each topic folder
   - `brew bundle --file=brew/Brewfile`

### Error Handling

- Each step checks for success before proceeding
- Failures print a clear message and exit (no silent continuation)
- Backup directory is preserved even if bootstrap fails partway

## Makefile

Provides shorthand commands:

```makefile
STOW_FOLDERS = zsh git bat
STOW_FLAGS = --target=$(HOME) --restow

install:       ## Full bootstrap
stow:          ## Symlink all topic folders
unstow:        ## Remove all symlinks
restow:        ## Re-symlink (useful after adding files)
brew:          ## Run brew bundle
macos:         ## Run .macos with confirmation prompt
```

## Git Identity (Conditional Includes)

Base `.gitconfig` sets name but no email:

```gitconfig
[user]
    name = Josh Clayton

[includeIf "gitdir:~/code/work/"]
    path = .gitconfig-work

[includeIf "gitdir:~/code/personal/"]
    path = .gitconfig-personal
```

`.gitconfig-work` and `.gitconfig-personal` each set `user.email` (and optionally `user.signingkey`).

**Prerequisite:** Repos should live in `~/code/work/` or `~/code/personal/`. The README will document this convention. Moving `~/code/amalgamet/` to `~/code/personal/amalgamet/` is a manual step outside this automation.

## Current `.gitignore` Becomes `.gitignore_global`

The current `.gitignore` in the repo root contains patterns for the user's home directory (`.aws/config`, `.dotfiles.git`, etc.). This gets:
1. Renamed to `.gitignore_global` and moved into the `git/` stow folder
2. Referenced from `.gitconfig` via `core.excludesFile`
3. A new repo-level `.gitignore` is created for the dotfiles repo itself (ignoring `docs/`, `.DS_Store`, etc.)

## `path.zsh` Integration

The current `path.zsh` adds `$DOTFILES/bin` to PATH, but no `bin/` directory exists. In Phase 1:
- Fold the PATH additions from `path.zsh` directly into `.zshrc`
- Remove `path.zsh` as a separate file
- Remove the `$DOTFILES/bin` PATH entry (no bin directory exists)
- Keep `$HOME/.node/bin` and `$HOME/node_modules/.bin` if still needed

## Oh My Zsh Integration

The current `.zshrc` sets `ZSH_CUSTOM=$DOTFILES` which means Oh My Zsh looks for custom plugins/themes in the dotfiles root. After restructure:
- `ZSH_CUSTOM` should point to a dedicated location (e.g., `$HOME/.oh-my-zsh/custom` default, or a `zsh/custom/` folder in the repo if custom plugins are needed)
- For Phase 1, reset to the Oh My Zsh default unless custom plugins exist

## What Does NOT Change in Phase 1

- `.zshrc` content (aliases, settings) — stays as-is, just moves to `zsh/.zshrc`
- `.macos` content — moves to `macos/.macos` but is not modified
- Brewfile content — moves to `brew/Brewfile` but is not modified
- bat config — moves to `bat/.config/bat/config` but is not modified

## Verification

After Phase 1 implementation:

1. **Structure check:** All files in correct topic folders, no files at repo root except bootstrap.sh, Makefile, README.md
2. **Stow dry-run:** `stow -n -v zsh git bat` from repo root shows correct symlink targets
3. **Bootstrap dry-run:** `./bootstrap.sh --dry-run` prints expected actions without modifying anything
4. **Actual stow:** Run `stow zsh git bat`, verify symlinks point to repo files
5. **Shell test:** Open new terminal, confirm zsh loads correctly with aliases working
6. **Git identity test:** Create test repos in `~/code/work/` and `~/code/personal/`, run `git config user.email` in each to verify conditional includes
7. **Unstow test:** `make unstow` removes symlinks, originals restored from backup
8. **Idempotency:** Run `make stow` twice, no errors on second run
