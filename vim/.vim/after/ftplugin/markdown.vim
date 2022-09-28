source <sfile>:h/prettier-config.vim
let &l:formatprg='deno fmt --ext md  -'
let &l:equalprg=&l:formatprg
if !exists(':GrepTag')
  command! -nargs=+ -complete=file_in_path -bar -buffer GrepTag
        \ cgetexpr GrepFunction('\\[_metadata_:' . <q-args> . '\\]')
endif
if !exists(':LGrepTag')
  command! -nargs=+ -complete=file_in_path -bar -buffer LGrepTag
        \ lgetexpr GrepFunction('\\[_metadata_:' . <q-args> . '\\]')
endif
cnoreabbrev <expr> <buffer> greptag (getcmdtype() ==# ':' && getcmdline() ==# 'greptag') ? 'GrepTag' : 'grep'
cnoreabbrev <expr> <buffer> lgreptag (getcmdtype() ==# ':' && getcmdline() ==# 'lgreptag') ? 'LGrepTag' : 'lgrep'
