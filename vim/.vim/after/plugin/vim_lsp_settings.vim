vim9script
def Getcwd(): string
  var projectDir = getcwd()
  var isGitDir = substitute(system('git rev-parse --is-inside-work-tree'), '\n', '', 'g') == 'true'
  if (isGitDir)
    projectDir = system('git rev-parse --show-toplevel')
    projectDir = substitute(projectDir, '\n', '', 'g')
  endif
  return projectDir
enddef
var cwd = Getcwd()
if filereadable(cwd .. '/angular.json')
  g:lsp_settings_filetype_html = [
    'html-languageserver',
    'angular-language-server'
  ]
endif
if filereadable(cwd .. '/package.json')
  g:lsp_settings_filetype_typescript = ['typescript-language-server']
elseif isdirectory(cwd .. '/node_modules')
  g:lsp_settings_filetype_typescript = ['typescript-language-server']
else
  g:lsp_settings_filetype_typescript = ['deno']
endif
