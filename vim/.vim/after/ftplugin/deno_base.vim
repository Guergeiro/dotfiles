if has('eval')
  setlocal formatexpr=
endif
let &l:formatprg='deno fmt --ext ' . &filetype . ' -'
let &l:equalprg=&l:formatprg
