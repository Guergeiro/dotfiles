if get(g:, 'loaded_lightline', 0) != 0
	finish
endif


let g:lightline = {
			\ 'active': {
				\	 'left': [
				\			['mode', 'paste'],
				\			['gitbranch', 'readonly', 'filename', 'modified']
				\	],
			\	 },
			\ 'component_function': {
				\	 'gitbranch': 'gitbranch#name',
			\	 },
			\ 'colorscheme': g:colors_name
		\ }

packadd vim-gitbranch
packadd lightline.vim
