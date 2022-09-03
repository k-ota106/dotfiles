" vim: set ts=4 sw=4 sts=0:

"============================================================================== Settings
" No highlight cursor
"set cursorline
"set cursorcolumn

" Show previous line when page scroll
set scrolloff=1
" Keep column position when page scroll
set nostartofline

set history=1000

" Highligh parenthesis for 1 seconds
set showmatch
set matchtime=1

set autoindent

" Search settings.
set ignorecase
set smartcase
set nowrapscan
set incsearch
set hlsearch

" No wrap at end of line.
set nowrap
set textwidth=0

set nohidden

set number

" Tab and Cursoor view.
set listchars=tab:\ \ 
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" Tab settings.
set tabstop=4
set shiftwidth=4
set expandtab

" Status line settings.
set showcmd
set laststatus=2
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).(&bomb?':BOM':'').']['.&ff.']'}%=%l,%c%V%8P

" grep command.
set grepprg=grep\ -nH

" Ignore white space in diff mode.
set diffopt=iwhite

" include search path (verilog, C)
set include=\s*[`#]\s*include

set wildmenu

" Default shell.
if !has('win32')
    "set shell=/usr/bin/zsh
    set shell=/bin/bash
endif

" Search tags in parent da directory. 
set tags=./tags;,tags

" Save bakcup if ~/tmp exists.
let s:backupdir = $HOME . "/tmp"
if isdirectory(s:backupdir)
    set backup
    let &backupdir = s:backupdir
endif

" Check UTF-8 -> EUC-JP -> Shift-JIS in that order.
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,sjis
set fileformats=unix,dos,mac
if !exists('g:vscode')
    if exists('&ambiwidth')
	    set ambiwidth=double
    endif
endif

" Eanble syntax highlihgt.
if has("syntax")
	syntax on
    set background=dark
    silent! colorscheme  iceberg
    "colorscheme  review
    "colorscheme  summerfruit256
    if !exists('g:vscode')
        " Mark full-width space (　,\u3000), non-break space( , \u00a0)
        autocmd WinEnter,BufEnter,VimEnter,ColorScheme *
            \   :hi default DoubleByteSpace ctermbg=darkgray guibg=darkgray
            \ | :hi default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta
            \ | :call matchadd('DoubleByteSpace', "　")
            \ | :call matchadd('ExtraWhitespace', "[\u2000-\u200B\u00a0]")
        autocmd WinEnter,BufEnter,VimEnter,ColorScheme *.txt,*.md,TODO,README
            \   :hi clear DoubleByteSpace
    endif
endif

"============================================================================== Mapping
" Motion: display lines.
nnoremap j gj
nnoremap k gk

" Motion: paragraphs.
noremap <C-j> }
noremap <C-k> {

" Motion: pages.
map <Space> <PageDown>
map <C-Space> <PageUp>

" Motion: QuickFix and Location List
" - prev/next: move to a next/prev item in the list.
" - before/afterm: move to a next/prev item from the current line.
noremap [Q  :cprev<CR>
noremap ]Q  :cnext<CR>
noremap [q  :cbefore<CR>
noremap ]q  :cafter<CR>
noremap [L  :lprev<CR>
noremap ]L  :lnext<CR>
noremap [l  :lbefore<CR>
noremap ]l  :lafter<CR>

" Jump by 'filename:number' text
nnoremap gf gF

" Replace by the current word.
nnoremap <expr> s* ':%s/\<' . expand('<cword>') . '\>/'
vnoremap <expr> s* ':s/\<' . expand('<cword>') . '\>/'

" Workaround regarding a backsapce key.
map!  
imap <CSI> <Nop>

" Repace by yanked word.
nnoremap <C-p> viw"0p 
vnoremap <C-p> "0p 

""============================================================================== netrw
let g:netrw_liststyle = 1
let g:netrw_list_hide = '.*\.swp'
" 'v': open selected file to the right window (default is left).
let g:netrw_altv = 1
" 'o': open selected file to the bottom window (defualt is top).
let g:netrw_alto = 1
" File size unit: 'K,M,G'
let g:netrw_sizestyle="H"
" Display format: yyyy/mm/dd(day of week) hh:mm:ss
let g:netrw_timefmt=" %Y/%m/%d(%a) %H:%M:%S"
" Display latest file at top line.
let g:netrw_sort_by = "time"
let g:netrw_sort_direction = "reverse"
" To show long file name.
let g:netrw_maxfilenamelen = 85
let g:netrw_wiw = 1
let g:netrw_list_cmd = "ls -l"
" Open 85% of window width when splitting.
let g:netrw_winsize = 85

" h: move to parent directory
" l: move to child directory or open selected file
function! s:ConfigureNetrw()
    nmap <buffer> h -
    nmap <buffer> l <Enter>
endfunction

augroup netrw_configuration
  autocmd!
  autocmd FileType netrw call s:ConfigureNetrw()
augroup end

if executable('chrome.exe')
    " Use google-chrome.
    let g:netrw_browsex_viewer='chrome.exe'
endif

" Use ripgrep.
if executable('rg')
    let &grepprg = 'rg --vimgrep --hidden -g "!tags"'
    set grepformat=%f:%l:%c:%m
endif

"============================================================================== autocmd
" Open non-text files.
augroup OpenBinary
	autocmd!

    " Read only to avoid unexpected editing.
    autocmd BufRead *.zip,*.gz,*.bz2,*.xz,*.pdf setlocal readonly nolist

    " Binary mode, invoked by:
    " - vim -b XXX or vim XXX.bin
    " - :set binary, :e
	autocmd BufReadPre  *.bin let &binary =1
	autocmd BufReadPost * if &binary | silent %!xxd -g 1
	autocmd BufReadPost * set ft=xxd | endif
	autocmd BufWritePre * if &binary | exe '%!xxd -r' | endif
	autocmd BufWritePost * if &binary | silent %!xxd -g 1
	autocmd BufWritePost * set nomod | endif

    " Open PDF
    if executable('pdftotext')
        autocmd BufRead *.pdf let s:a = expand("%").".txt" | :enew | :exec '0read !pdftotext -layout -nopgbrk "#" -' | setlocal readonly | :exec ":file ". s:a
    endif

augroup END

" Startup
augroup vimStartup
	autocmd!

    " Starts from the last cusor position.
    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

    " Move to the directory of the file being edited
    if has('win32')
        set autochdir
    else
        "  The directory of unnamed buffer depends on the previous
        "  buffer if set autochdir is used, so I decided to use 'lcd' command.
        au BufEnter * if &buftype !=# 'terminal' | silent! lcd %:p:h | endif
    endif

    " Open frequently used files regardless of the current file type.
    au BufEnter * set suffixesadd=.v,.sv,.svh,.c,.cpp,.h,.e,.rb,.sfc,.tsv,.py

    if has("syntax")
        " Mark full-width space (　,\u3000), non-break space( , \u00a0)
        autocmd WinEnter,BufEnter,VimEnter,ColorScheme *
            \   :hi default DoubleByteSpace ctermbg=darkgray guibg=darkgray
            \ | :hi default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta
            \ | :call matchadd('DoubleByteSpace', "　")
            \ | :call matchadd('ExtraWhitespace', "[\u2000-\u200B\u00a0]")
        autocmd WinEnter,BufEnter,VimEnter,ColorScheme *.txt,*.md,TODO,README
            \   :hi clear DoubleByteSpace
    endif

augroup END

"============================================================================== Utility
map <F7> <ESC>:execute "GGrep ".expand('<cword>')<CR>
map <F8> <ESC>:Makers<CR>
nnoremap <F11> :make <CR>
nnoremap <F12> :grep <cword><CR>


" Align json text.
command! -range Json <line1>,<line2>:!python3 -c 'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4,ensure_ascii=False))' 

" Diff between saved data and current buffer.
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis

" Copy quickfix to loclist
command! CopyQflistToLoclist :call setloclist(0, [], ' ', {'items': get(getqflist({'items': 1}), 'items')})

function! s:source_rc(rc_file)
    if filereadable(a:rc_file)
        :execute 'source ' . a:rc_file
    endif
endfunction

let s:dir = fnamemodify(expand('<sfile>'), ':p:h') . "/"

if has('nvim')
    call s:source_rc(s:dir.'option_nvim.rc.vim')
    call s:source_rc(s:dir.'option_nvim.private.vim')
else
    call s:source_rc(s:dir.'option_vim.rc.vim')
    call s:source_rc(s:dir.'option_vim.private.vim')
endif

