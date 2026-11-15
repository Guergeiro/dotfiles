if get(g:, 'loaded_improved_quickfix', 0) != 0
	finish
endif
" Navigate through quickfix elements
function! s:wrap_command(qf_action) abort
	try
		silent execute a:qf_action
	catch /^Vim\%((\a\+)\)\=:E553/
		if a:qf_action == 'cnext'
			silent execute 'cfirst'
		elseif a:qf_action == 'cprev'
			silent execute 'clast'
		endif
	endtry
endfunction

function g:LspJumpNext() abort
	if has('nvim')
lua << EOF
vim.diagnostic.jump({
count = 1
})
EOF
	endif
endfunction

function g:LspJumpPrev() abort
	if has('nvim')
lua << EOF
vim.diagnostic.jump({
count = -1
})
EOF
	endif
endfunction

function! s:prev_next(qf_action) abort
	if &buftype == 'quickfix'
		call <sid>wrap_command(a:qf_action)
	elseif len(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is "quickfix"')) > 0
		call <sid>wrap_command(a:qf_action)
	elseif get(g:, 'lsp_server_loaded', 0) == 1
		if a:qf_action == 'cprev'
			call g:LspJumpPrev()
		elseif a:qf_action == 'cnext'
			call g:LspJumpNext()
		endif
	else
		call <sid>wrap_command(a:qf_action)
	endif
endfunction

nnoremap <silent> <c-h> :call <sid>prev_next('cprev')<cr>
nnoremap <silent> <c-l> :call <sid>prev_next('cnext')<cr>

let g:loaded_improved_quickfix = 1
