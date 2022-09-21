if !exists('s:cwd')
  let s:cwd = getcwd()
endif
if filereadable(s:cwd . '/angular.json')
  let g:lsp_settings_filetype_html = [
        \ 'html-languageserver',
        \ 'angular-language-server'
        \ ]
endif
if filereadable(s:cwd . '/package.json')
  let g:lsp_settings_filetype_typescript = ['typescript-language-server']
elseif isdirectory(s:cwd . '/node_modules')
  let g:lsp_settings_filetype_typescript = ['typescript-language-server']
else
  let g:lsp_settings_filetype_typescript = ['deno']
endif
