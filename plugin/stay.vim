" A LESS SIMPLISTIC TAKE ON RESTORE_VIEW.VIM
" Maintainer: Martin Kopischke <martin@kopischke.net>
" License:    MIT (see LICENSE.md)
" Version:    1.0.0
if &compatible || !has('autocmd') || !has('mksession') || v:version < 700
  finish
endif

let s:cpo = &cpo
set cpo&vim

" Set defaults:
let s:defaults = {}
let s:defaults.volatile_ftypes = ['gitcommit', 'gitrebase', 'netrw']
for [s:key, s:val] in items(s:defaults)
  execute 'let g:'.s:key. '= get(g:, "'.s:key.'", '.string(s:val).')'
  unlet! s:key s:val
endfor

" Set up autocommands:
augroup stay
  autocmd!
  " default buffer handling
  autocmd BufLeave,BufWinLeave ?*
        \ if stay#ispersistent(str2nr(expand('<abuf>')), g:volatile_ftypes) |
        \   call stay#view#make(bufwinnr(str2nr(expand('<abuf>')))) |
        \ endif
  autocmd BufWinEnter ?*
        \ if stay#ispersistent(str2nr(expand('<abuf>')), g:volatile_ftypes) |
        \   call stay#view#load(bufwinnr(str2nr(expand('<abuf>')))) |
        \ endif
  " vim-fetch integration
  autocmd User BufFetchPosPost
        \ let b:stay_atpos = b:fetch_lastpos
augroup END

let &cpo = s:cpo
unlet! s:cpo

" vim:set sw=2 sts=2 ts=2 et fdm=marker fmr={{{,}}}:
