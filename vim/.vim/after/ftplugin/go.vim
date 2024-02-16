if has('eval')
 setlocal formatexpr=
endif
let &l:formatprg='gofmt ' . expand('%')
let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs[&filetype] = {
      \ '(': ')',
      \ '[': ']',
      \ '{': '}',
      \ "'": "'",
      \ '`': '`',
      \ '"': '"'
      \ }
