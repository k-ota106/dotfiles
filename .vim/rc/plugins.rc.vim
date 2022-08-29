" Plugin settings.
"
" To update installed plugins:
"   :call dein#update()
" To remove cache:
"   :call dein#recache_runtimepath()

let mapleader = "\<Space>"

if has('nvim')
    let s:rc_root_dir = stdpath('config')
else
    if version < 802
        finish
    endif
    let s:rc_root_dir = $HOME.'/.vim'
    " Open nvim from vim.
    command! -complete=file -nargs=* Nvim    :!unset VIM MYVIMRC VIMRUNTIME && nvim <args>
endif

""""""""""""""""""""""""""""""""""""""""""""""""" eda_utils
" synchronize current line and loclist
nnoremap <silent> <leader>i :call eda_utils#ShowLoclistOnCurrLine()<CR>
" view table
nnoremap <silent> <leader>v :call eda_utils#ViewTable()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""" dein

let s:dein_dir = s:rc_root_dir . '/.cache/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    let s:rc_dir = s:rc_root_dir . '/rc'
    if !isdirectory(s:rc_dir)
        call mkdir(s:rc_dir, 'p')
    endif
    let s:toml = s:rc_dir . '/dein.toml'
    let s:lazy_toml = s:rc_dir . '/dein_lazy.toml'
    let s:ddu_toml = s:rc_dir . '/ddu.toml'

    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy' : 1})
    call dein#load_toml(s:ddu_toml, {'lazy' : 1})

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

let s:removed_plugins = dein#check_clean()
if len(s:removed_plugins) > 0
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
endif

filetype plugin indent on
syntax enable


