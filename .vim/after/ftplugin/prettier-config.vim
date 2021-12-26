setlocal formatprg=npx\ prettier\ --stdin-filepath\ %
if has('eval')
  setlocal formatexpr=
endif
let g:smartpairs_pairs[&filetype] = {
      \ '(': ')',
      \ '[': ']',
      \ '{': '}',
      \ "'": "'",
      \ '`': '`',
      \ '"': '"',
      \ '*': '*',
      \ '_': '_'
      \ }
