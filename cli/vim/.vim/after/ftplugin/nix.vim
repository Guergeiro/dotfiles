if has('eval')
	setlocal formatexpr=
endif
let &l:formatprg='nixfmt -'
let &l:equalprg=&l:formatprg
if has('nvim')
lua << EOF
vim.lsp.enable({
	'nixd'
})
EOF
endif
