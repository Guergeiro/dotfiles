if !exists('*s:projectDir')
  function! s:projectDir() abort
    let l:projectDir = system('git rev-parse --show-toplevel')
    let l:projectDir = substitute(l:projectDir, '\n', '', 'g')
    if (l:projectDir == '')
      let l:projectDir = getcwd()
    endif
    return l:projectDir
  endfunction
endif

if !exists('*s:projectFmt')
  function! s:projectFmt() abort
    let l:projectDir = <sid>projectDir()
    let l:formatprg = 'deno fmt -'
    if filereadable(l:projectDir . '/package.json')
      let l:formatprg = 'npx prettier --stdin-filepath %'
    endif
    if isdirectory(l:projectDir . '/node_modules/')
      let l:formatprg = 'npx prettier --stdin-filepath %'
    endif
    return l:formatprg
  endfunction
endif

let &l:makeprg = 'npx eslint --format compact --fix'
setlocal autoread
nnoremap <buffer> <leader>m :make %<bar>cwindow<cr>
if has('quickfix')
  setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
endif
if has('eval')
  setlocal formatexpr=
endif
let &l:formatprg=<sid>projectFmt()
set path-=node_modules/**
set path-=./node_modules/**
