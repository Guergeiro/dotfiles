if exists('g:loaded_select_more_guergeiro')
  finish
endif
if !exists('*s:floaterm_source')
  function! s:floaterm_source() abort
    let candidates = []
    let bufs = floaterm#buflist#gather()
    for bufnr in bufs
      let bufinfo = getbufinfo(bufnr)[0]
      let name = bufinfo['name']
      let title = getbufvar(bufnr, 'term_title')
      let line = printf('%s: %s %s', bufnr, name, title)
      call add(candidates, line)
    endfor
    return candidates
  endfunction
endif
if !exists('*s:floaterm_sink')
  function! s:floaterm_sink(curline) abort
    let bufnr = str2nr(matchstr(a:curline, '\S'))
    call floaterm#terminal#open_existing(bufnr)
  endfunction
endif
let g:select_info = get(g:, 'select_info', {})

let g:select_info.floaterm = {}
let g:select_info.floaterm.data = {-> s:floaterm_source()}
let g:select_info.floaterm.sink = {
      \ 'action': {v -> s:floaterm_sink(v)},
      \ }
let g:select_info.floaterm.prompt = 'Floaterm Terminal >'
let g:select_info.floaterm.highlight = {
      \ 'PrependBufNr': ['^\(\s*\d\+:\)', 'Identifier']
      \ }

if executable('rg')
  let g:select_info.note = {}
  let g:select_info.note.data = {"job": 'rg --vimgrep "(NOTE):" .'}
  let g:select_info.note.sink = {
        \ "action": {v -> s:note_sink(v, 'edit')},
        \ "action2": {v -> s:note_sink(v, 'split')},
        \ "action3": {v -> s:note_sink(v, 'vsplit')},
        \ "action4": {v -> s:note_sink(v, 'tab split')}
        \ }
  let g:select_info.note.highlight = {"GrepPrefix": ['^.\{-}:\d\+:\d\+:', 'Comment']}
  let g:select_info.note.prompt = "NOTE> "
endif

let g:loaded_select_more_guergeiro = 1
