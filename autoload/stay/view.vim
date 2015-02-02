" AUTOLOAD FUNCTION LIBRARY FOR VIM-STAY
" View session handling functions
let s:cpo = &cpo
set cpo&vim

" Make a persistent view for window {winnr}:
" @signature:  stay#view#make({winnr:Number})
" @returns:    Boolean
function! stay#view#make(winnr) abort
  if a:winnr is -1
    return 0
  endif

  try
    let l:lazyredraw = &lazyredraw
    set lazyredraw
    if !s:win.goto(a:winnr)
      return 0
    endif
    unlet! b:stay_atpos
    mkview
    call s:win.back()
    return 1
  finally
    let &lazyredraw = l:lazyredraw
  endtry
endfunction

" Load a persistent view for window {winnr}:
" @signature:  stay#view#load({winnr:Number})
" @returns:    Boolean
function! stay#view#load(winnr) abort
  if a:winnr is -1 || !s:win.goto(a:winnr)
    return 0
  endif

  noautocmd silent loadview
  if exists('b:stay_atpos')
    call cursor(b:stay_atpos[0], b:stay_atpos[1])
    silent! normal! zOzz
  endif
  call s:win.back()
  return 1
endfunction

" Private helper functions:
" - window navigation stack
let s:win = {'stack': []}

function! s:win.gocmd(winnr) abort
  execute 'noautocmd keepjumps keepalt silent' a:winnr.'wincmd w'
endfunction

function! s:win.goto(winnr) abort
  let l:oldwinnr = winnr()
  if a:winnr isnot l:oldwinnr
    call self.gocmd(a:winnr)
  endif
  call add(self.stack, l:oldwinnr)
  return winnr() is a:winnr
endfunction

function! s:win.back() abort
  let l:backitem = len(self.stack) > 0
  if l:backitem
    call self.gocmd(remove(self.stack, -1))
  endif
  return l:backitem
endfunction

let &cpo = s:cpo
unlet! s:cpo

" vim:set sw=2 sts=2 ts=2 et fdm=marker fmr={{{,}}}:
