if !exists('*s:getcwd')
  function! s:getcwd() abort
    let l:projectDir = system('git rev-parse --show-toplevel')
    let l:projectDir = substitute(l:projectDir, '\n', '', 'g')
    if (l:projectDir == '')
      let l:projectDir = getcwd()
    endif
    return l:projectDir
  endfunction
endif
if !exists('s:cwd')
  let s:cwd = s:getcwd()
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
