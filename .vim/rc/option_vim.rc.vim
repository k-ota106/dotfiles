" <C-R><regsiter>: Insert register in the terminal mode
tnoremap <expr> <C-R> '<C-W>"'

" terminal -> normal
tnoremap <C-R><C-R> '<C-W>N'

" Move windows in the same way in terminal mode and normal mode.
tnoremap <A-h> <C-w>h
tnoremap <A-j> <C-w>j
tnoremap <A-k> <C-w>k
tnoremap <A-l> <C-w>l
inoremap <A-h> <C-w>h
inoremap <A-j> <C-w>j
inoremap <A-k> <C-w>k
inoremap <A-l> <C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" Detect Alt-key mapping
for c in ['h', 'j', 'k', 'l']
    exec "set <A-".c.">=\e".c
    exec "imap \e".c." <A-".c.">"
endfor
set timeout ttimeoutlen=50

