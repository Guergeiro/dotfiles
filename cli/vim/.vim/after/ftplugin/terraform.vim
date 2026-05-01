if has('eval')
	setlocal formatexpr=
endif
let l:formatprg='terraform fmt -'
let &l:equalprg=&l:formatprg

if has('nvim')
lua << EOF
vim.lsp.enable({
	'terraformls',
})
EOF
endif
