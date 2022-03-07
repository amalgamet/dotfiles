# Josh's dotfiles

## Getting Started

Set things up with a bare git repository. This technique has been described in many different ways:

- [Manage dotfiles with a git bare repository](https://harfangk.github.io/2016/09/18/manage-dotfiles-with-a-git-bare-repository.html)
- [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles)
- [Google](https://www.google.com/search?q=dotfiles+bare+git+repo).

First, create your bare repository

```bash
git clone --bare git@github.com:amalgamet/.dotfiles.git ~/.dotfiles.git
```

Then create an alias to use git with this bare repository. You'll also want to hide untracked files, since the dotfiles live in your `$HOME` directory.

```bash
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
```

With this newly-created `dotfiles` alias, you can perform normal git commands without passing the `--git-dir` and `--work-tree` flags.

```bash
dotfiles checkout
dotfiles submodule update --init --recursive
dotfiles status
```
