if has('nvim')
	if get(g:, 'loaded_telescope', 0) != 0
		finish
	endif

	function! s:telescope(args) abort
		delcommand! Telescope
		packadd plenary.nvim
		packadd telescope.nvim

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


		execute 'Telescope ' . a:args
	endfunction

	inoremap <silent><leader>sp <esc>:Telescope find_files<cr>
	nnoremap <silent><leader>sp :Telescope find_files<cr>
	inoremap <silent><leader>sb <esc>:Telescope buffers<cr>
	nnoremap <silent><leader>sb :Telescope buffers<cr>
	inoremap <silent><leader>sg <esc>:Telescope git_files<cr>
	nnoremap <silent><leader>sg :Telescope git_files<cr>
	inoremap <silent><leader>sG <esc>:Telescope live_grep<cr>
	nnoremap <silent><leader>sG :Telescope live_grep<cr>

	command! -nargs=* -complete=dir Telescope call s:telescope(<q-args>)

endif
