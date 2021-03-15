" Grep+Quickfix https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if exists('g:loaded_grep_quickfix')
  finish
endif
if !exists('*s:Grep')
  function! s:Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
  endfunction
endif
if !exists(':Grep')
  command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr <sid>Grep(<f-args>)
endif
if !exists(':LGrep')
  command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr <sid>Grep(<f-args>)
endif
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'
let g:loaded_grep_quickfix = 1
