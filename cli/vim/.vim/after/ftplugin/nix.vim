if has('eval')
	setlocal formatexpr=
endif
let &l:formatprg='nixfmt -'
let &l:equalprg=&l:formatprg
