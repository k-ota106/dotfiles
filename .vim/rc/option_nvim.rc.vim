"set mouse=
let g:previm_enable_realtime = 1
"let g:eda_utils_disable_keymap = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""

" Connect clipboard and unnamed register.
set clipboard+=unnamed
" When using tab in command mode to complete a filename, the first time is the
" maximum common string, and the next time the filename is fully completed in order.
set wildmode=longest,full
" Do repalce with preview
set inccommand=nosplit

"To use `ALT+{h,j,k,l}` to navigate windows from any mode: >
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l

" Paste in the terminal mode: <C-R><register>
tnoremap <expr> <C-R> '<C-\><C-N>"'.nr2char(getchar()).'pi'

augroup nvimStartup
    au!

    " Start terminal with insert mode.
    autocmd! TermOpen * setlocal statusline=%{b:term_title}
    autocmd  TermOpen term://* startinsert
    "autocmd! BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END 

