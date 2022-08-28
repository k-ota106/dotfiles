#!/bin/bash

# install awesome tools
#
# = Required =
# export http_proxy=
# export https_proxy=
#
# = Maybe required =
# sudo -E apt-get update  -y
# sudo -E apt-get upgrade -y
# sudo -E apt-get install -y wget curl pkg-config libssl-dev libncurses-dev python3 python3-pip


set -e

cargo=cargo
if [ -f /etc/redhat-release ];then
    INSTALL="sudo -E yum install"
else
    INSTALL="sudo -E apt-get install"
fi

function install_fzf() {
    if ! type fzf > /dev/null 2>&1 || test ! -e ~/.fzf ;then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --no-update-rc --no-bash --no-zsh
    fi
}

function install_nvim() {
    mkdir -p $HOME/.local/bin
    if ! type nvim > /dev/null 2>&1 ;then
        wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim.appimage
        chmod +x nvim.appimage
        ./nvim.appimage --appimage-extract
        cp -r ./squashfs-root/usr/* $HOME/.local
    fi
}

function install_starship() {
    mkdir -p $HOME/.local/bin
    if ! type starship > /dev/null 2>&1 ;then
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b $HOME/.local/bin
    fi
}

function install_cargo() {
    if ! type cargo > /dev/null 2>&1 || test ! -e ~/.cargo ;then
        curl https://sh.rustup.rs -sSf | sh
        cargo=~/.cargo/bin/cargo
    
        if [ "$http_proxy" != "" ];then
            for proxy in http:$http_proxy https:$https_proxy;do
                url=${proxy#*:}
                if [ "$url" != "" ];then
                    cat <<EOF >> ~/.cargo/config
[${proxy%%:*}]
    proxy = "$url"
EOF
                fi
            done
        fi 
    else
        cargo=cargo
    fi
}

function install_cargo_tools() {
    if ! type $cargo > /dev/null 2>&1 ;then
        return
    fi

    if ! type rg > /dev/null 2>&1 ;then
        $cargo install ripgrep
    fi
    
    if ! type bat > /dev/null 2>&1 ;then
        $cargo install bat
    fi
    
    if ! type fd > /dev/null 2>&1 ;then
        $cargo install fd-find
    fi
    
    if ! type delta > /dev/null 2>&1 ;then
        $cargo install git-delta
    fi

    if ! type makers > /dev/null 2>&1 ;then
        $cargo install cargo-make
    fi

    if ! type rust-script > /dev/null 2>&1 ;then
        $cargo install rust-script
    fi

    if ! type fx > /dev/null 2>&1 ;then
        $cargo install felix
    fi
}    

function install_deno() {
    if ! type $cargo > /dev/null 2>&1 ;then
        return
    fi

    if ! type deno > /dev/null 2>&1 ;then
        $cargo install deno --locked
    fi
}

function install_yad() {
    if ! type deno > /dev/null 2>&1 ;then
        $INSTALL yad
    fi
}

function update_git() {
    if [ ! -d git ];then
        git clone https://github.com/git/git.git
    fi
    pushd git
    $INSTALL libcurl-devel
    $INSTALL libcurl
    $INSTALL asciidoc
    $INSTALL xmlto
    autoconf
    ./configure --prefix=$HOME/.local
    make
    make install
    popd
}

function update_vim() {
    if [ ! -d vim ];then
        git clone https://github.com/vim/vim.git
    fi
    cd vim
    ./configure --prefix=$HOME/.local --enable-python3interp=yes --with-python3-config-dir=$(python3 -c "import distutils.sysconfig; print(distutils.sysconfig.get_config_var('LIBPL'))") --enable-fail-if-missing
    make
    make install
}

install_fzf
install_nvim
install_starship
install_cargo
install_cargo_tools
install_deno

#update_git
