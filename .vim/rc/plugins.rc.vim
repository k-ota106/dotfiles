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

""""""""""""""""""""""""""""""""""""""""""""""""" cargo-make
" For makers (cargo-make), search Makefile.toml up to 4 parent directory.
function! s:Makers(...)
    :let c = 1
    :let prefix = ""
    :if a:0 > 0
    :  let args = join(a:000, " ")
    :else
    :  let args = "default"
    :endif
    :while c <= 4
    :    echom prefix
    :  if filereadable(prefix . "Makefile.toml")
    :    if c == 1
    :      let cwd = ""
    :    else
    :      let cwd = "--cwd " . prefix
    :    endif
    :    let cmd = "Job makers " . cwd . " " . args
    :    echom cmd
    :    exe cmd
    :    break
    :  endif
    :  if isdirectory(prefix . ".git")
    :    break
    :  endif
    :  let prefix = "../" . prefix
    :  let c += 1
    :endwhile
endfunction
command! -nargs=* -complete=file  Makers call s:Makers(<f-args>)

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
    let s:priv_toml = s:rc_dir . '/dein.private.toml'
    let s:priv_lazy_toml = s:rc_dir . '/dein_lazy.private.toml'
    let s:priv_ddu_toml = s:rc_dir . '/ddu.private.toml'

    call dein#load_toml(s:toml, {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy' : 1})
    call dein#load_toml(s:ddu_toml, {'lazy' : 1})

    if filereadable(s:priv_toml)
        call dein#load_toml(s:priv_toml, {'lazy': 0})
    endif
    if filereadable(s:priv_lazy_toml)
        call dein#load_toml(s:priv_lazy_toml, {'lazy' : 1})
    endif
    if filereadable(s:priv_ddu_toml)
        call dein#load_toml(s:priv_ddu_toml, {'lazy' : 1})
    endif

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

autocmd VimEnter * call dein#call_hook('post_source')

filetype plugin indent on
syntax enable


