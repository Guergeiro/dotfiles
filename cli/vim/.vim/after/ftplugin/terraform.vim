if has('eval')
	setlocal formatexpr=
endif
let &l:formatprg='terraform fmt -'
let &l:equalprg=&l:formatprg
