if !exists('*s:getFormatter')
	function! s:getFormatter() abort
		let l:formatprg = 'terraform fmt -'
		return l:formatprg
	endfunction
endif

let &l:formatprg=<sid>getFormatter()

if has('nvim')
lua << EOF
vim.lsp.enable({
	'terraformls',
})
EOF
endif
