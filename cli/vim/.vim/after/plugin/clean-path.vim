packadd clean-path.vim

let &path.=cleanpath#setpath()
let &wildignore.=cleanpath#setwildignore()
