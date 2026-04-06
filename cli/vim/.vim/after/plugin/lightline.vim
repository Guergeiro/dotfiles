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

packadd lightline.vim
packadd vim-gitbranch
