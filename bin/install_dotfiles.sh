#!/bin/bash

# Install dot files in this repository to the HOME directory.

set -e


if [ "$1" == backup_only ];then
    backup_only=1
else
    backup_only=0
fi

this_dir=$(dirname ${BASH_SOURCE:-$0})/..
this_dir=$(cd $(dirname $this_dir) && pwd)/$(basename $this_dir)
backup_dir=$this_dir/backup
cd $this_dir

if [ -d $backup_dir ];then
    echo "ERROR: backup directory already exists: $backup_dir"
    exit 1
fi

mkdir -p $backup_dir

# Create backup of dotfiles.
# $1: path in this repository
function do_backup()
{
    local f=$1
    local is_copy=0
    local is_same=0
    local kind="file"

    if [ -f $HOME/$f ];then
        is_copy=1
        if cmp -s $HOME/$f $f ;then
            is_same=1
        fi
        if [ -L $HOME/$f ];then
            kind="link"
        fi
    fi

    # Backup target
    if [ $is_copy -eq 1 ];then
        echo "BACKUP($kind) same=$is_same: $HOME/$f"
        local dest=$backup_dir/$f
        mkdir -p $(dirname $dest)
        cp -L $HOME/$f $dest
    fi
}

# Create a symbolic link of dotfiles into the home directory
# $1: path in this repository
function do_symlink()
{
    local f=$1

    # Create target directory
    local tdir=$(dirname $HOME/$f)
    if [ -e $tdir -a ! -d $tdir ];then
        echo "ERROR: $tdir is not a directory. Target:$(basename $f)"
        return
    fi
    mkdir -p $tdir
    if [ -e $HOME/$f ];then
        rm -rf $HOME/$f 
    fi
    ln -s $this_dir/$f $HOME/$f 
}

for f in $(git ls-files);do
    do_backup $f
done

echo "INFO: Create backup to $backup_dir" 

if [ $backup_only -eq 1 ];then
    echo "INFO: Run '${BASH_SOURCE:-$0} 1' to install dotfiles in this repository into your home directory." 
    exit
fi

for f in $(git ls-files);do
    if [[ $f =~ ^bin/install.*\.sh ]];then
        continue
    elif [[ $f =~ ^misc/ ]];then
        continue
    elif [ $f == ".suggestion" -a -f $HOME/.suggestion ];then
        continue
    elif [[ $f =~ \.md$ ]];then
        continue
    fi
    do_symlink $f
done

