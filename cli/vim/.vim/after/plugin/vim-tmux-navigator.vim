" if get(g:, 'loaded_tmux_navigator', 0) != 0
" 	finish
" endif

" function! s:tmux_navigator_init() abort
" 	delcommand! TmuxNavigateLeft
" 	delcommand! TmuxNavigateDown
" 	delcommand! TmuxNavigateUp
" 	delcommand! TmuxNavigateRight
" 	delcommand! TmuxNavigatePrevious

" 	let g:tmux_navigator_no_mappings = 1

" 	packadd vim-tmux-navigator
" endfunction

" function! s:tmux_navigate_left(args) abort
" 	call s:tmux_navigator_init()
" 	execute 'TmuxNavigateLeft ' . a:args
" endfunction

" function! s:tmux_navigate_down(args) abort
" 	call s:tmux_navigator_init()
" 	execute 'TmuxNavigateDown ' . a:args
" endfunction

" function! s:tmux_navigate_up(args) abort
" 	call s:tmux_navigator_init()
" 	execute 'TmuxNavigateUp ' . a:args
" endfunction

" function! s:tmux_navigate_right(args) abort
" 	call s:tmux_navigator_init()
" 	execute 'TmuxNavigateRight ' . a:args
" endfunction

" function! s:tmux_navigate_previous(args) abort
" 	call s:tmux_navigator_init()
" 	execute 'TmuxNavigatePrevious ' . a:args
" endfunction


" nnoremap <silent> <c-w>h :TmuxNavigateLeft<cr>
" nnoremap <silent> <c-w>j :TmuxNavigateDown<cr>
" nnoremap <silent> <c-w>k :TmuxNavigateUp<cr>
" nnoremap <silent> <c-w>l :TmuxNavigateRight<cr>
" nnoremap <silent> <c-w>\ :TmuxNavigatePrevious<cr>

" command! -nargs=* -complete=dir TmuxNavigateLeft call s:tmux_navigate_left(<q-args>)
" command! -nargs=* -complete=dir TmuxNavigateDown call s:tmux_navigate_down(<q-args>)
" command! -nargs=* -complete=dir TmuxNavigateUp call s:tmux_navigate_up(<q-args>)
" command! -nargs=* -complete=dir TmuxNavigateRight call s:tmux_navigate_right(<q-args>)
" command! -nargs=* -complete=dir TmuxNavigatePrevious call s:tmux_navigate_previous(<q-args>)
