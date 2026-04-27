if exists('g:loaded_plugins')
	finish
endif

if has('nvim')
lua << EOF
require("nvim-treesitter.install").prefer_git = true

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.tbl_contains(require("nvim-treesitter").get_installed(), lang) then
			require("nvim-treesitter").update(lang):await(function()
				vim.treesitter.start()
			end)
		elseif vim.tbl_contains(require("nvim-treesitter").get_available(), lang) then
			require("nvim-treesitter").install(lang):await(function()
				vim.treesitter.start()
			end)
		end
	end
})
EOF
endif

" lsp {{{
if has('nvim')
lua << EOF
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '',
			[vim.diagnostic.severity.HINT] = '',
		},
	},
})
EOF
	nnoremap gd <cmd>lua vim.lsp.buf.type_definition()<cr>
	nnoremap gr <cmd>lua vim.lsp.buf.references()<cr>
	nnoremap gi <cmd>lua vim.lsp.buf.implementation()<cr>
	nnoremap gt <cmd>lua vim.lsp.buf.type_definition()<cr>
	nnoremap <c-space> <cmd>lua vim.lsp.buf.code_action()<cr>
	nnoremap <f2> <cmd>lua vim.lsp.buf.rename()<cr>
endif
" lsp }}}

" pum.vim {{{
call pum#set_option(
	\ {
	\	 'max_height': 10,
	\	 'padding': v:true
	\ })
" pum.vim }}}


" ddc.vim {{{
if !exists('*s:ddcinit')
	function! s:ddcinit() abort

		call ddc#custom#patch_global('ui', 'pum')
		call ddc#custom#patch_global('sources',
					\	[
					\		'lsp',
					\		'buffer',
					\		'around',
					\		'file',
					\		'rg',
					\		'vsnip'
					\	])
		call ddc#custom#patch_global('sourceOptions', {
					\	'_': {
					\		'sorters': ['sorter_fuzzy', 'sorter_rank'],
					\		'matchers': ['matcher_fuzzy', 'matcher_head'],
					\		'converters': ['converter_fuzzy', 'converter_remove_overlap']
					\	},
					\	'lsp': {
					\		'mark': 'lsp',
					\		'isVolatile': v:true,
					\	},
					\	'file': {
					\		'maxItems': 5,
					\		'mark': 'file',
					\		'isVolatile': v:true,
					\	},
					\	'buffer': {
					\		'maxItems': 5,
					\		'mark': 'b',
					\	},
					\	'around': {
					\		'maxItems': 5,
					\		'mark': 'a',
					\	},
					\	'omni': {
					\		'maxItems': 5,
					\		'mark': 'o',
					\	},
					\	'rg': {
					\		'maxItems': 5,
					\		'mark': 'rg',
					\	},
					\	'tabnine': {
					\		'maxItems': 5,
					\		'mark': 'tab',
					\		'isVolatile': v:true,
					\	},
					\	'vsnip': {
					\		'maxItems': 5,
					\		'mark': 'vsnip',
					\		'dup': 'keep'
					\	}
					\})
		call ddc#custom#patch_global('sourceParams', {
					\	'lsp': {
					\		'lspEngine': has('nvim') ? 'nvim-lsp' : 'vim-lsp',
					\	}
					\})

		if has('nvim')
lua << EOF
vim.lsp.config('*', {
	capabilities = require("ddc_source_lsp").make_client_capabilities(),
})
EOF
		endif

		inoremap <silent> <expr> <tab>
					\ pum#visible() ?
					\ '<cmd>call pum#map#select_relative(+1)<cr>' :
					\ vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' :
					\ '<tab>'
		inoremap <silent> <expr> <s-tab>
					\ pum#visible() ?
					\ '<cmd>call pum#map#select_relative(-1)<cr>' :
					\ vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' :
					\ '<s-tab>'
		inoremap <silent> <expr> <cr>
					\ pum#visible() ?
					\ '<cmd>call pum#map#confirm()<cr>' : '<cr>'

		if has('nvim')
			inoremap <silent> <expr> <c-space> ddc#map#manual_complete()
		else
			inoremap <silent> <expr> <c-@> ddc#map#manual_complete()
		endif

		snoremap <silent> <expr> <tab> vsnip#jumpable(1) ?
					\ '<plug>(vsnip-jump-next)' :
					\ '<tab>'
		snoremap <silent> <expr> <s-tab> vsnip#jumpable(-1) ?
					\ '<plug>(vsnip-jump-prev)' :
					\ '<s-tab>'
		nnoremap <silent> <expr> <tab> vsnip#jumpable(1) ?
					\ '<plug>(vsnip-jump-next)' :
					\ '<tab>'
		nnoremap <silent> <expr> <s-tab> vsnip#jumpable(-1) ?
					\ '<plug>(vsnip-jump-prev)' :
					\ '<s-tab>'
		call ddc#enable()
	endfunction
endif

augroup Autocomplete
	autocmd!
	autocmd User DenopsReady call s:ddcinit()
augroup END
" ddc.vim }}}

" AI {{{
if has('nvim')
lua << EOF
-- require('render-markdown').setup({
-- 	opts = {
-- 		anti_conceal = { enabled = false },
-- 		file_types = { 'markdown', 'opencode_output' },
-- 	},
-- 	ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
-- })
-- require("opencode").setup({
-- 	preferred_picker = 'telescope',
--	default_global_keymaps = false,
-- 	ui = {
-- 		position = 'current',
-- 	},
-- 	quick_chat = {
-- 		default_model = 'gpt-5.4-mini',
-- 	}
-- })
EOF
endif
" AI }}}

let g:loaded_plugins = 1
