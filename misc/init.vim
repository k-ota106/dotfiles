" init.vim for Windows (nvim-qt)
"
" Hierarchy: 
"   C:\Users\XXX\AppData\Local\nvim -- nvim root
"     |-- init.vim                  -- copy this file here
"     |-- dotfiles/                 -- clone this repository here
"           |-- .vimrc
"           |-- .vim/
"           |-- misc/init.vim       -- this file in this repository

let g:_rc_root_dir_ = stdpath('config') . "/dotfiles/.vim"
execute "source " . stdpath('config') . "/dotfiles/.vimrc"
