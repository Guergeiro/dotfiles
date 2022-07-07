vim9script
augroup General
  autocmd!
  # Execute commands when Lsp is ready
  autocmd User lsp_server_init {
    g:lsp_server_loaded = 1
  }
augroup END
