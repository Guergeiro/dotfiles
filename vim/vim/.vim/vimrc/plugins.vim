if exists('g:loaded_plugins')
	finish
endif

" Emmet {{{
augroup Emmet
	autocmd!
	" autocmd FileType html,typescriptreact,javascriptreact,text,astro imap
augroup END
" }}}

" Vimtex {{{
let g:vimtex_format_enabled = 1
" }}}

" vim-astro {{{
let g:astro_typescript = 'enable'
" }}}

" ColorScheme {{{
let g:srcery_italic = 1
let g:gruvbox_italic = 1
let g:dracula_colorterm = 0
let g:dracula_full_special_attrs_support = 1
set background=dark
colorscheme dracula
" }}}

" vim-tmux-navigator {{{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <c-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <c-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <c-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <c-w>\ :TmuxNavigatePrevious<cr>
" }}}

" vim-cool {{{
let g:CoolTotalMatches = 1
" }}}

" md-img-paste {{{
let g:mdip_imgdir = '.assets'
" }}}

" Vimspector {{{
nmap <leader>dc <plug>VimspectorContinue
nmap <leader>ds <plug>VimspectorStop
nmap <leader>dr <plug>VimspectorRestart
nmap <leader>db <plug>VimspectorToggleBreakpoint
nmap <leader>dj <plug>VimspectorStepOver
nmap <leader>dl <plug>VimspectorStepInto
nmap <leader>dh <plug>VimspectorStepOut
nmap <leader>di <plug>VimspectorBalloonEval
xmap <leader>di <plug>VimspectorBalloonEval
" }}}

" Undotree {{{
inoremap <silent> <leader>u <esc>:UndotreeToggle<cr>
nnoremap <silent> <leader>u :UndotreeToggle<cr>
" }}}

" vim-vsnip {{{
let g:vsnip_snippet_dirs = [
	\ expand('$HOME') . '/.vim/snippets',
	\ g:packages_home . '/friendly-snippets/snippets'
	\ ]
" }}}

" Scalpel {{{
let g:ScalpelMap=0
nmap <leader><f2> <plug>(Scalpel)
" }}}

" Vim-smartpairs {{{
" Removes basic autoclose
iunmap {
iunmap (
iunmap [
iunmap "
iunmap `
let g:smartpairs_hijack_return = 0
" }}}

" Fern {{{
let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'
inoremap <silent><c-b>b <esc>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>b :Fern . -reveal=%<cr>
inoremap <silent><c-b>v <esc>:wincmd v<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>v :wincmd v<cr>:Fern . -reveal=%<cr>
inoremap <silent><c-b>s <esc>:wincmd s<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>s :wincmd s<cr>:Fern . -reveal=%<cr>
" Fern }}}

" vim-highlightedyank {{{
let g:highlightedyank_highlight_duration = 250
" vim-highlightedyank }}}

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
vim.lsp.enable({
	'jdtls',
	'denols',
	'gopls',
	'kotlin_language_server',
	'terraformls',
	'pyright',
	'pylsp'
})
EOF
	nnoremap gd <cmd>lua vim.lsp.buf.type_definition()<cr>
	nnoremap gr <cmd>lua vim.lsp.buf.references()<cr>
	nnoremap gi <cmd>lua vim.lsp.buf.implementation()<cr>
	nnoremap gt <cmd>lua vim.lsp.buf.type_definition()<cr>
	nnoremap <c-space> <cmd>lua vim.lsp.buf.code_action()<cr>
	nnoremap <f2> <cmd>lua vim.lsp.buf.rename()<cr>
else
	let g:lsp_fold_enabled = 0
	let g:lsp_use_event_queue = 1
	let g:lsp_use_native_client = 1
	let g:lsp_untitled_buffer_enabled = 0
	let g:lsp_document_highlight_enabled = 0
	let g:lsp_document_code_action_signs_enabled = 0
	let g:lsp_diagnostics_float_cursor = 1
	let g:lsp_diagnostics_float_insert_mode_enabled = 0
	let g:lsp_diagnostics_virtual_text_enabled = 0
	let g:lsp_diagnostics_signs_error = {'text': ''}
	let g:lsp_diagnostics_signs_warning = {'text': ''}
	let g:lsp_diagnostics_signs_info = {'text': ''}
	let g:lsp_diagnostics_signs_hint = {'text': ''}
	let g:lsp_semantic_enabled = 0
	let g:lsp_format_sync_timeout = 1000

	nmap gd <plug>(lsp-definition)
	nmap gr <plug>(lsp-references)
	nmap gi <plug>(lsp-implementation)
	nmap gt <plug>(lsp-type-definition)
	nmap <c-@> <plug>(lsp-code-action)
	nmap <f2> <plug>(lsp-rename)
	let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'deno']
endif
" lsp }}}

" Lightline {{{
let g:lightline = {
			\ 'active': {
				\	 'left': [['mode', 'paste'],
				\					 ['gitbranch', 'readonly', 'filename', 'modified']],
				\	 },
				\ 'component_function': {
					\	 'gitbranch': 'gitbranch#name',
					\	 },
					\ }
let g:lightline.colorscheme = g:colors_name
" Lightline }}}

" clean-path.vim {{{
let &path.=cleanpath#setpath()
let &wildignore.=cleanpath#setwildignore()
" clean-path.vim }}}

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

" Telescope {{{
if has('nvim')
	inoremap <silent><leader>sp <esc>:Telescope find_files<cr>
	nnoremap <silent><leader>sp :Telescope find_files<cr>
	inoremap <silent><leader>sb <esc>:Telescope buffers<cr>
	nnoremap <silent><leader>sb :Telescope buffers<cr>
	inoremap <silent><leader>sg <esc>:Telescope git_files<cr>
	nnoremap <silent><leader>sg :Telescope git_files<cr>
	inoremap <silent><leader>sG <esc>:Telescope live_grep<cr>
	nnoremap <silent><leader>sG :Telescope live_grep<cr>

lua << EOF
local actions = require("telescope.actions")
local actions_layout = require("telescope.actions.layout")
require('telescope').setup({
	defaults = {
		layout_strategy='vertical',
		layout_config={
			prompt_position='bottom',
			width=0.95,
			height=0.5,
			anchor='S',
		},
		dynamic_preview_title = true,
		results_title = false,
		prompt_title = false,
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim"
		},
		preview = {
			hide_on_startup = true
		},
		default_mappings = {
			i = {
				["<tab>"] = actions.move_selection_next,
				["<s-tab>"] = actions.move_selection_previous,
				["<cr>"] = actions.select_default,
				["<c-s>"] = actions.select_horizontal,
				["<c-v>"] = actions.select_vertical,
				["<c-u>"] = actions.preview_scrolling_up,
				["<c-d>"] = actions.preview_scrolling_down,
				["<c-j>"] = actions.results_scrolling_up,
				["<c-k>"] = actions.results_scrolling_down,
				["<esc>"] = actions.close,
				["<c-p>"] = actions_layout.toggle_preview,
				["<c-q>"] = actions.send_to_qflist + actions.open_qflist
			},
		},
	}
})
EOF
endif
" Telescope }}}

	" Treesitter {{{
if has('nvim')
lua << EOF
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
" Treesitter }}}

" AI {{{
if has('nvim')
	if !exists('*s:loadAI')
		function! s:loadAI(...)
			for ai in a:000
				if ai == 'copilot'
					let g:copilot_no_tab_map = v:true
					call plug#load('copilot.vim')
					call plug#load('CopilotChat.nvim')
					imap <silent><script><expr> <c-y> copilot#Accept("\<CR>")
lua << EOF
require("CopilotChat").setup {
	-- See Configuration section for options
mappings = {
		complete = {
			insert = '<c-y>',
		},
		close = {
			normal = 'q',
			insert = '<esc>',
		},
		reset = {
			normal = '<C-l>',
			insert = '<C-l>',
		},
		submit_prompt = {
			normal = '<CR>',
			insert = '<C-s>',
		},
	},
}
EOF
				endif
			endfor
		endfunction
	endif

	if !exists(':LoadAI')
		command! -nargs=+ LoadAI call <sid>loadAI(<f-args>)
	endif
endif
" AI }}}

let g:loaded_plugins = 1
