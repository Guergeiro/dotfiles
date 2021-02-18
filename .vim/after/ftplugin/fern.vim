" Simple resize function for explorer
if !exists("*s:resize")
  function! s:resize() abort
    let l:execute = "vertical resize "
    let l:currentSize = winwidth(0)
    if l:currentSize == 40
      execute(l:execute . "120")
    else
      execute(l:execute . "40")
    endif
  endfunction
endif
nnoremap <silent><buffer> A :call <sid>resize()<cr>
nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>
nmap <silent><buffer> <c-s> <plug>(fern-action-open:split)<bar><plug>(fern-close-drawer)
nmap <silent><buffer> <c-v> <plug>(fern-action-open:vsplit)<bar><plug>(fern-close-drawer)
nmap <buffer> r <plug>(fern-action-reload:all)
nmap <buffer> yy <plug>(fern-action-copy)
nmap <buffer> dd <plug>(fern-action-trash)
nmap <buffer> <f2> <plug>(fern-action-rename)
nmap <silent><buffer><expr>
      \ <Plug>(fern-my-open-or-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<plug>(fern-action-open)<bar><plug>(fern-close-drawer)",
      \   "\<plug>(fern-action-expand)",
      \   "\<plug>(fern-action-collapse)",
      \ )
nmap <buffer> <cr> <plug>(fern-my-open-or-expand-or-collapse)
nmap <buffer> a <plug>(fern-action-choice)
setlocal number
if exists("&relativenumber")
  setlocal relativenumber
endif
