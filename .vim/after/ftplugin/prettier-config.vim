setlocal formatprg=npx\ prettier\ --stdin-filepath\ %
if has('eval')
  setlocal formatexpr=
endif
if exists('g:smartpairs_loaded')
  finish
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
