" if has('eval')
"   setlocal formatexpr=
" endif
" setlocal formatprg=go\ fmt\ -
"
" if !exists('*s:projectDir')
"   function! s:projectDir() abort
"     let l:projectDir = getcwd()
"     let l:isGitDir = system('git rev-parse --is-inside-work-tree')
"     if (l:isGitDir)
"       let l:projectDir = system('git rev-parse --show-toplevel')
"       let l:projectDir = substitute(l:projectDir, '\n', '', 'g')
"     endif
"     return ':' . l:projectDir
"   endfunction
" endif

" let $GOPATH .= <sid>projectDir()
