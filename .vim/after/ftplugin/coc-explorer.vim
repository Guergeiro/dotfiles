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
setlocal number
if exists("&relativenumber")
  setlocal relativenumber
endif
