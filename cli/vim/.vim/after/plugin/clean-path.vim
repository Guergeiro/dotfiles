if get(g:, 'loaded_cleanpath', 0) != 0
	finish
endif

packadd clean-path.vim

let &path.=cleanpath#setpath()
let &wildignore.=cleanpath#setwildignore()
