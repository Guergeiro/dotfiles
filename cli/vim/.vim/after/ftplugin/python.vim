if has('nvim')
lua << EOF
vim.lsp.enable({
	'pyright',
	'pylsp'
})
EOF
endif
