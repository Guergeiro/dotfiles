setlocal makeprg=npx\ eslint\ --format\ compact\ --fix
setlocal autoread
nnoremap <buffer> <leader>m :make %<bar>cwindow<cr>
setlocal formatprg=prettier\ --stdin-filepath\ %
setlocal formatexpr=
setlocal equalprg=prettier\ --stdin-filepath\ %
