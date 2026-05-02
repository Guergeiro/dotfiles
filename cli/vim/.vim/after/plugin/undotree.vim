if get(g:, 'loaded_undotree', 0) != 0
	finish
endif

function! s:undotree(args) abort
	delcommand! UndotreeToggle
	packadd undotree

	execute 'UndotreeToggle ' . a:args
endfunction

inoremap <silent> <leader>u <esc>:UndotreeToggle<cr>
nnoremap <silent> <leader>u :UndotreeToggle<cr>

command! -nargs=* -complete=dir UndotreeToggle call s:undotree(<q-args>)
