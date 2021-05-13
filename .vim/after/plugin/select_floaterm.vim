if exists('g:loaded_select_floaterm')
  finish
endif
if !exists('s:floaterm')
  let s:floaterm = {}
endif
if !exists('*s:floaterm.source')
  function! s:floaterm.source() abort
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
if !exists('*s:floaterm.sink')
  function! s:floaterm.sink(curline) abort
    let bufnr = str2nr(matchstr(a:curline, '\S'))
    call floaterm#terminal#open_existing(bufnr)
  endfunction
endif
let g:select_info = get(g:, 'select_info', {})
let g:select_info.floaterm = {}
let g:select_info.floaterm.data = {-> s:floaterm.source()}
let g:select_info.floaterm.sink = {
      \ 'action': {v -> s:floaterm.sink(v)},
      \ }
let g:select_info.floaterm.prompt = 'Floaterm Terminal >'
let g:select_info.floaterm.highlight = {
      \ 'PrependBufNr': ['^\(\s*\d\+:\)', 'Identifier']
      \ }
let g:loaded_select_floaterm = 1
