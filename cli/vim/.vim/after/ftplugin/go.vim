if has('eval')
	setlocal formatexpr=
endif
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
let &l:formatprg='gofmt -s'

if get(g:, 'smartpairs_loaded', 0) != 0
	let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
	let g:smartpairs_pairs[&filetype] = get(g:smartpairs_pairs, &filetype, g:smartpairs_default_pairs)
	let g:smartpairs_pairs[&filetype] = extendnew(g:smartpairs_pairs[&filetype], {
				\ '`': '`',
				\ })
endif

if has('nvim')
lua << EOF
vim.lsp.enable({
	'gopls',
})
EOF
endif
