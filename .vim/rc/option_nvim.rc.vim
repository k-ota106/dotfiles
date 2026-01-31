set mouse=
let g:previm_enable_realtime = 1
"let g:eda_utils_disable_keymap = 1
"""""""""""""""""""""""""""""""""""""""""""""""""""

" Connect clipboard and unnamed register (require: xclip, xsel).
if executable('xclip') && executable('xsel')
    set clipboard+=unnamedplus
endif
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
        \ | :call clearmatches()
        \ | setlocal ambiwidth=single
    autocmd  TermOpen term://* startinsert
    autocmd BufEnter * call s:MakeTerminalModifiable()
    "autocmd! BufEnter * if &buftype == 'terminal' | :startinsert | endif
augroup END 

" Don't automatically close terminal
function! s:MakeTerminalModifiable() abort
  "echom "MakeTerminalModifiable buftype=" . &buftype . " exists(terminal_job_id)=" .  exists('b:terminal_job_id')
  if &buftype ==# 'nofile'
    setlocal ambiwidth=single
  else
    silent! setlocal ambiwidth=double
  endif

  if &buftype !=# 'terminal' || !exists('b:terminal_job_id')
    return
  endif

  "echom jobwait([b:terminal_job_id], 0)
  if jobwait([b:terminal_job_id], 0) == [-3]
    echom "change terminal state"
    "setlocal modifiable
    "setlocal noreadonly
    let lines = getline(1, '$')
    bwipeout!
    new
    setlocal buftype=nofile bufhidden=hide noswapfile
    call setline(1, lines)
    setlocal modifiable
  endif
endfunction

