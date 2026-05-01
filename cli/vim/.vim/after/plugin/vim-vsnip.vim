if get(g:, 'loaded_vsnip', 0) != 0
	finish
endif

let g:vsnip_snippet_dirs = [
	\ expand('$HOME') . '/.vim/snippets',
	\ expand('$HOME') . '/.vim/pack/minpac/opt/friendly-snippets/snippets'
	\ ]

packadd vim-vsnip
