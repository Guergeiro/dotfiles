if !exists('*s:projectFmt')
  function! s:projectFmt() abort
    let l:projectDir = getcwd()
    let projectfmt = 'deno fmt -'
    if &filetype == 'javascript'
      let projectfmt .= ' --ext js'
    endif
    let projectfmt .= ' -'
    if filereadable(l:projectDir . '/package.json')
      let projectfmt = 'pnpm --silent dlx prettier --stdin-filepath %'
    endif
    if isdirectory(l:projectDir . '/node_modules/')
      let projectfmt = 'pnpm --silent dlx prettier --stdin-filepath %'
    endif
    return projectfmt
  endfunction
endif

let &l:makeprg = 'pnpm --silent dlx eslint --format compact --fix'
setlocal autoread
nnoremap <buffer> <leader>m :make % <bar> cwindow<cr>
if has('quickfix')
  setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
endif
if has('eval')
  setlocal formatexpr=
endif
let &l:formatprg=<sid>projectFmt()
let &l:equalprg=&l:formatprg
set path-=node_modules/**
set path-=./node_modules/**
if !exists('g:smartpairs_loaded')
  finish
endif
let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs[&filetype] = {
      \ '(': ')',
      \ '[': ']',
      \ '{': '}',
      \ "'": "'",
      \ '`': '`',
      \ '"': '"'
      \ }
