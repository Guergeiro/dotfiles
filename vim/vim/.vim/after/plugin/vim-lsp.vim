if exists('g:lsp_server_loaded')
	finish
endif

if !exists('*g:LspInit')
	function! g:LspInit() abort
		if has('nvim')
lua << EOF
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		-- Unset 'formatexpr'
		vim.bo[args.buf].formatexpr = nil
		-- Unset 'omnifunc'
		vim.bo[args.buf].omnifunc = nil
	end,
})
for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
  vim.api.nvim_set_hl(0, group, {})
end
EOF
			augroup DiagnosticHover
				autocmd!
				" Execute commands when Lsp is ready
				autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float({ focus=false })
			augroup END
		endif
		let g:lsp_server_loaded = 1
	endfunction
endif


if !exists('*g:CustomLspHover')
	function! g:CustomLspHover() abort
		if has('nvim')
lua << EOF
vim.lsp.buf.hover()
EOF
		else
			execute 'LspHover'
		endif
	endfunction
endif

" AutoCommands
if has('nvim')
lua << EOF
vim.lsp.config('*', {
	on_init = function(client, result)
		vim.api.nvim_call_function('g:LspInit', {})
	end
})
EOF
else
	augroup General
		autocmd!
		" Execute commands when Lsp is ready
		autocmd User lsp_server_init call g:LspInit()
	augroup END
endif
