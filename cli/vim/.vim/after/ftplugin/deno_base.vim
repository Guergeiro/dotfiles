if has('eval')
	setlocal formatexpr=
endif
let &l:formatprg='deno fmt --unstable-component --ext ' . expand('%:e') . ' -'
let &l:equalprg=&l:formatprg
