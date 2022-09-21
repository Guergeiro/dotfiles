function! s:lsp_server_commands() abort
  let g:lsp_server_loaded = 1
endfunction
" AutoCommands
augroup General
  autocmd!
  " Execute commands when Lsp is ready
  autocmd User lsp_server_init call <sid>lsp_server_commands()
augroup END
