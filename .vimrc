if exists('g:_rc_root_dir_')
    let s:rc_root_dir = g:_rc_root_dir_
else
    if has('nvim')
        let s:rc_root_dir = stdpath('config')
    else
        let s:rc_root_dir = $HOME.'/.vim'
    endif
endif
let s:rc_dir = s:rc_root_dir.'/rc'

function! s:source_rc(rc_file_name)
    let rc_file = expand(s:rc_dir . '/' . a:rc_file_name)
    if filereadable(rc_file)
        :execute 'source' rc_file
    endif
endfunction

call s:source_rc('option.rc.vim')
call s:source_rc('option.private.vim')
call s:source_rc('plugins.rc.vim')
call s:source_rc('plugins.private.vim')

if isdirectory(s:rc_root_dir.'/doc')
    execute ':helptags '.s:rc_root_dir.'/doc'
endif
