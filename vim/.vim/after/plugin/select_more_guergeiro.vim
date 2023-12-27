if exists('g:loaded_select_more_guergeiro')
  finish
endif
if exists('g:loaded_plugins')
  if executable('rg')
    let g:select_info = get(g:, "select_info", {})

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

    let g:select_info.my_grep = {}
    let g:select_info.my_grep.data = {"job": 'rg --vimgrep'}
    let g:select_info.my_grep.sink = {
            \ "transform": {p, v -> fnameescape(p..'"'..v..'"')},
            \ "special": {state, _ -> s:special_save_project(state)},
            \ "action": "edit %s",
            \ "action2": "split %s",
            \ "action3": "vsplit %s",
            \ "action4": "tab split %s"
            \ }
    let g:select_info.my_grep.highlight = {"GrepPrefix": ['^.\{-}:\d\+:\d\+:', 'Comment']}
    let g:select_info.my_grep.prompt = "Grep> "

    let g:loaded_select_more_guergeiro = 1
  endif
endif
