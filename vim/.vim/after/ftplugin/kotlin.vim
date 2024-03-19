let &l:makeprg = 'ktlint --log-level=none 2> /dev/null'
setlocal autoread
nnoremap <buffer> <leader>m :make % <bar> cwindow<cr>
if has('quickfix')
  setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
endif

if has('eval')
 setlocal formatexpr=
endif
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

let &l:formatprg='ktlint --log-level=none --stdin --format ' . expand('%') . ' 2> /dev/null'
let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs[&filetype] = {
      \ '(': ')',
      \ '[': ']',
      \ '{': '}',
      \ '"': '"'
      \ }
