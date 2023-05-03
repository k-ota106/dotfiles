# dotfiles

* bash
* bvi
* cargo and awesome rust tools (ripgrep, bat, etc...)
* deno
* starship
* tmux 2.9a or later
* vim 8.2/nvim

## Configuration

* .vim/rc/plugins.vim (Enable ddu & denops)  

    ```
    let s:disable_ddu = 0
    ```

* bin/install_tool.sh (Full utility tools)

    ```
    simple_=0
    ```

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
* .vimrc
    * option.private.vim
    * plugins.private.vim
* .vim/rc/option.rc.vim
    * option_nvim.private.vim
    * option_vim.private.vim
* .vim/rc/plugins.rc.vim
    * dein.private.toml
    * dein_lazy.private.toml
    * ddu.private.toml

## Install unstable (latest) NeoVim for ubuntu 18.04

```
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get install neovim
```

Binary builds are no longer supported since neovim v0.8.1
(GLIBC version no longer matches) and must be installed manually.

