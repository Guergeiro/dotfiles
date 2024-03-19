if has('eval')
 setlocal formatexpr=
endif
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
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
