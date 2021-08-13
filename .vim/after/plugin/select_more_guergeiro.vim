if exists('g:loaded_select_more_guergeiro')
  finish
endif
if exists('g:loaded_plugins')
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

    let g:loaded_select_more_guergeiro = 1
  endif
endif
