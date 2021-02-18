setlocal makeprg=npx\ eslint\ --format\ compact\ --fix
setlocal autoread
nnoremap <buffer> <leader>m :make %<bar>cwindow<cr>
if has("quickfix")
  setlocal errorformat+=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
endif
setlocal formatprg=prettier\ --stdin-filepath\ %
if has("eval")
  setlocal formatexpr=
endif
setlocal equalprg=prettier\ --stdin-filepath\ %
set path-=node_modules/**
set path-=./node_modules/**
" if !exists("*s:cocAction")
"   function! s:cocAction(action) abort
"     execute(a:action . ' coc-deno')
"     execute("CocRestart")
"   endfunction
" endif
" if !exists("*s:deactivateDeno")
"   function! s:deactivateDeno() abort
"     call <sid>cocAction("CocUninstall")
"     execute("CocCommand deno.types")
"     execute("CocCommand deno.cache")
"   endfunction
" endif
" if !exists("*s:activateDeno")
"   function! s:activateDeno() abort
"     call <sid>cocAction("CocInstall -sync")
"   endfunction
" endif
" if !exists("*s:setupEnvironment")
"   function! s:setupEnvironment() abort
"     let l:gitDir = system("git rev-parse --show-toplevel")
"     let l:gitDir = substitute(l:gitDir, '\n', '', 'g')
"     if filereadable(l:gitDir . '/package.json')
"       call <sid>deactivateDeno()
"     else
"       call <sid>activateDeno()
"     endif
"   endfunction
" endif
" augroup DenoOrNode
"   autocmd!
"   autocmd User CocNvimInit call <sid>setupEnvironment()
" augroup END
