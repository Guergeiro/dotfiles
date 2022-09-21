if has('eval')
 setlocal formatexpr=
endif
let &l:formatprg='gofmt ' . expand('%')
