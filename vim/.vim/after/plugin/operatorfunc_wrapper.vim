if exists('g:loaded_operatorfunc_wrapper')
  finish
endif
" https://gist.github.com/romainl/d2ad868afd7520519057475bd8e9db0c
if !exists('*s:operator')
  " Execute operatorfunc
  function! s:operator(type, operator) abort
    if a:0  " Invoked from Visual mode, use '< and '> marks.
      silent exe "normal! `<" . a:type . "`>" . a:operator
    elseif a:type == "line"
      silent exe "normal! '[V']" . a:operator
    elseif a:type == "block"
      silent exe "normal! `[\<C-V>`]" . a:operator
    else
      silent exe "normal! `[v`]" . a:operator
    endif
    if &formatprg != ''
      " Only check for errors if a formatprg is set
      if v:shell_error > 0
        let format_error = join(getline(line("'["), line("']")), "\n")
        undo
        echo format_error
      endif
    endif
  endfunction
endif
if !exists('*s:FormatPrg')
  " Wrapper for formatprg
  function! s:FormatPrg(type, ...) abort
    call <sid>operator(a:type, 'gq')
  endfunction
endif
if !exists('*s:IndentPrg')
  " Wrapper for indentprg
  function! s:IndentPrg(type, ...) abort
    call <sid>operator(a:type, '=')
  endfunction
endif
vnoremap <silent> gq :<c-u>call <sid>FormatPrg(visualmode(), 1)<cr>
nnoremap <silent> gq :setlocal operatorfunc=<sid>FormatPrg<cr>g@
vnoremap <silent> = :<c-u>call <sid>IndentPrg(visualmode(), 1)<cr>
nnoremap <silent> = :setlocal operatorfunc=<sid>IndentPrg<cr>g@

" https://gist.github.com/george-b/4a03da0be21e4f39e72d66ad8340d131
function! OpfuncSteady() abort
  let w:opfuncview = winsaveview()
  autocmd OpfuncSteady CursorMoved,TextYankPost *
    \ call winrestview(w:opfuncview)
    \ | unlet w:opfuncview
    \ | noautocmd set operatorfunc=
    \ | autocmd! OpfuncSteady CursorMoved,TextYankPost *
endfunction

augroup OpfuncSteady
  autocmd!
  autocmd OptionSet operatorfunc call OpfuncSteady()
augroup END

let g:loaded_operatorfunc_wrapper = 1
