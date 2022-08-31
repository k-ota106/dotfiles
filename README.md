# dotfiles

* bash
* bvi
* cargo and awesome rust tools (ripgrep, bat, etc...)
* deno
* starship
* tmux 2.9a or later
* vim 8.2/nvim

## How to install

Run the follwing command.

```bash
./bin/install.sh
```

## Backup your dotfiles

```bash
./bin/install_dotfiles.sh backup_only
```

This command copies your dotfiles to ./backup.
This command does not install dotfiles in this repository.

## Try this repository without installing

```bash
export HOME=$PWD
./bin/install.sh
source ./.bashrc
```

## Private files

Private files are configuration files that are not managed by this repository.
The user can extend some settings without editting dotfiles in this repository.

* .zshrc -> .zshrc.private
* .bashrc -> .zshrc.private
* .zshrc_bashrc -> .zshrc_bashrc.private

