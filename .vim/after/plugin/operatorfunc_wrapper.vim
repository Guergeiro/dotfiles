" Execute operatorfunc
function! <sid>operator(type, operator) abort
  let w:view = winsaveview()
  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . "`>" . a:operator
  elseif a:type == "line"
    silent exe "normal! '[V']" . a:operator
  elseif a:type == "block"
    silent exe "normal! `[\<C-V>`]" . a:operator
  else
    silent exe "normal! `[v`]" . a:operator
  endif
  if v:shell_error > 0
    let format_error = join(getline(line("'["), line("']")), "\n")
    undo
    echo format_error
  end
  call winrestview(w:view)
  unlet w:view
endfunction
" Wrapper for formatprg
function! <sid>FormatPrg(type, ...) abort
  call <sid>operator(a:type, "gq")
endfunction
" Wrapper for indentprg
function! <sid>IndentPrg(type, ...) abort
  call <sid>operator(a:type, "=")
endfunction
vnoremap <silent> gq :<c-u>call <sid>FormatPrg(visualmode(), 1)<cr>
nnoremap <silent> gq :setlocal operatorfunc=<sid>FormatPrg<cr>g@
vnoremap <silent> = :<c-u>call <sid>IndentPrg(visualmode(), 1)<cr>
nnoremap <silent> = :setlocal operatorfunc=<sid>IndentPrg<cr>g@
