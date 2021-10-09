if !exists('*s:getFormatter')
  function! s:getFormatter() abort
    let l:formatprg = 'java -jar ' .
          \ '--add-exports jdk.compiler/com.sun.tools.javac.api=ALL-UNNAMED ' .
          \ '--add-exports jdk.compiler/com.sun.tools.javac.file=ALL-UNNAMED ' .
          \ '--add-exports jdk.compiler/com.sun.tools.javac.parser=ALL-UNNAMED ' .
          \ '--add-exports jdk.compiler/com.sun.tools.javac.tree=ALL-UNNAMED ' .
          \ '--add-exports jdk.compiler/com.sun.tools.javac.util=ALL-UNNAMED ' .
          \ expand('$HOME') .
          \ '/.local/formatters/google-java-format.jar -'
    return l:formatprg
  endfunction
endif

let &l:formatprg=<sid>getFormatter()
