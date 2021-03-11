if !exists('*s:startWorkspace')
  function! s:startWorkspace() abort
    let l:projectDir = system('git rev-parse --show-toplevel')
    let l:projectDir = substitute(l:projectDir, '\n', '', 'g')
    if l:projectDir == ''
      let l:projectDir = getcwd()
    endif
    if filereadable(l:projectDir . '/package.json')
      return ['tsserver']
    endif
    if isdirectory(l:projectDir . '/node_modules')
      return ['tsserver']
    endif
    return ['deno']
  endfunction
endif
let b:ale_linters = s:startWorkspace()
