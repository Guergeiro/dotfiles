let &l:formatprg='pnpm --silent dlx prettier --stdin-filepath %'
let &l:equalprg=&l:formatprg
if has('eval')
  setlocal formatexpr=
endif
if !exists('g:smartpairs_loaded')
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
