if get(g:, 'loaded_highlightedyank', 0) != 0
	finish
endif

let g:highlightedyank_highlight_duration = 250

packadd vim-highlightedyank
