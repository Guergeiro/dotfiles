if get(g:, 'loaded_lsp_config', 0) != 0
	finish
endif

if has('nvim')

lua << EOF
vim.lsp.enable({
	'gopls',
	'jdtls',
	'denols',
	'jdtls',
	'kotlin_language_server',
	'nixd',
	'pyright',
	'pylsp',
	'terraformls',
})

_G.custom_lsp_hover = function()
	vim.lsp.buf.hover()
end
vim.cmd([[
function! g:CustomLspHover()
	lua _G.custom_lsp_hover()
endfunction
]])

local group = vim.api.nvim_create_augroup('VimLsp', { clear = true })

vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
	group = group,
	callback = function(args)
		vim.diagnostic.open_float({ focus=false })
	end,
})

vim.api.nvim_create_autocmd('LspAttach', {
	group = group,
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

vim.lsp.config('*', {
	on_init = function(client, result)
		vim.g.lsp_server_loaded = 1
	end
})
EOF

endif

let g:loaded_lsp_config = 1
