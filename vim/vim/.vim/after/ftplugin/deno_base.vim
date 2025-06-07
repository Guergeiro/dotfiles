if has('eval')
	setlocal formatexpr=
endif
let &l:formatprg='deno fmt --ext ' . expand('%:e') . ' -'
let &l:equalprg=&l:formatprg
