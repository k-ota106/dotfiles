#!/bin/bash

# Install awesome tools
#
# = Usage =
# $ install.sh     # user install only  
# $ install.sh all # install required package (sudo required) 
#
# = Required =
# export HOME=
# export http_proxy=
# export https_proxy=
#
# = Maybe required =
# sudo -E apt-get update  -y
# sudo -E apt-get upgrade -y
# sudo -E apt-get install -y git unzip wget curl pkg-config libssl-dev libncurses-dev python3 python3-pip


set -e

cargo=cargo
if [ -z $(command -v sudo) ];then
    sudo=""
else
    sudo="sudo -E"
fi
if [ -f /etc/redhat-release ];then
    INSTALL="$sudo yum install -y"
else
    INSTALL="$sudo apt-get install -y"
fi

function install_package() {
    $INSTALL git unzip wget curl pkg-config libssl-dev libncurses-dev python3 python3-pip
}

function is_not_installed() {
    mkdir -p $HOME/.local/bin
    test -z "$(command -v $* $HOME/.local/bin/$1 $HOME/.cargo/bin/$1)"
}

function install_fzf() {
    if is_not_installed fzf $HOME/.fzf/bin/fzf; then
        git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
        $HOME/.fzf/install --no-update-rc --no-bash --no-zsh
    fi
}

function install_nvim() {
    if is_not_installed nvim ;then
        wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim.appimage
        chmod +x nvim.appimage
        ./nvim.appimage --appimage-extract
        cp -r ./squashfs-root/usr/* $HOME/.local
    fi
}

function install_starship() {
    if is_not_installed starship ;then
        sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -b $HOME/.local/bin -y
    fi
}

function install_cargo() {
    if is_not_installed cargo ;then
        bash  <(curl https://sh.rustup.rs -sSf) -y
        cargo=$HOME/.cargo/bin/cargo
    
        if [ "$http_proxy" != "" ];then
            for proxy in http:$http_proxy https:$https_proxy;do
                url=${proxy#*:}
                if [ "$url" != "" ];then
                    cat <<EOF >> $HOME/.cargo/config
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

    if [ -f $HOME/.cargo/bin/cargo ];then
        cargo=$HOME/.cargo/bin/cargo
    else
        cargo=cargo
    fi

    if is_not_installed $cargo ;then
        return
    fi

    if is_not_installed rg;then
        $cargo install ripgrep
    fi
    
    if is_not_installed bat;then
        $cargo install bat
    fi
    
    if is_not_installed fd;then
        $cargo install fd-find
    fi
    
    if is_not_installed delta;then
        $cargo install git-delta
    fi

    if is_not_installed makers;then
        $cargo install cargo-make
    fi

    if is_not_installed rust-script;then
        $cargo install rust-script
    fi

    if is_not_installed fx;then
        $cargo install felix
    fi
}    

function install_deno() {
    #if ! type $cargo > /dev/null 2>&1 ;then
    #    return
    #fi
    #if ! type deno > /dev/null 2>&1 ;then
    #    $cargo install deno --locked
    #fi
    if is_not_installed deno;then
        curl -fsSL https://deno.land/install.sh | sh
    fi
}

function install_yad() {
    if is_not_installed yad;then
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

if [ "$1" == all ];then
    all=1
else
    all=0
fi

if [ $all -eq 1 ];then
    install_package
fi

install_fzf
install_nvim
install_starship
install_cargo
install_cargo_tools
install_deno

if [ $all -eq 1 ];then
    install_yad
fi

#update_git
#update_vim
