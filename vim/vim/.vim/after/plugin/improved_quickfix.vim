if exists('g:loaded_improved_quickfix')
	finish
endif
" Navigate through quickfix elements
if !exists('*s:WrapCommand')
	function! s:WrapCommand(qf_action)
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
endif
if !exists('*s:PrevNext')
	function! s:PrevNext(qf_action, lsp_action)
		if &buftype == 'quickfix'
			call <sid>WrapCommand(a:qf_action)
		elseif len(filter(tabpagebuflist(), 'getbufvar(v:val, "&buftype") is "quickfix"')) > 0
			call <sid>WrapCommand(a:qf_action)
		elseif get(g:, 'lsp_server_loaded', 0) == 1
			silent execute a:lsp_action
		else
			call <sid>WrapCommand(a:qf_action)
		endif
	endfunction
endif
nnoremap <silent> <c-h> :call <sid>PrevNext('cprev', 'LspPreviousDiagnostic')<cr>
nnoremap <silent> <c-l> :call <sid>PrevNext('cnext', 'LspNextDiagnostic')<cr>
let g:loaded_improved_quickfix = 1
