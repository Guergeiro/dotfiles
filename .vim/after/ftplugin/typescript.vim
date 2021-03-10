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
