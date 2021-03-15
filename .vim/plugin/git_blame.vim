" Git blame https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
if exists('g:loaded_git_blame')
  finish
endif
if !exists(':GB')
  command! -range GB echo join(systemlist('git -C ' . shellescape(expand('%:p:h')) . ' blame -L <line1>,<line2> ' . expand('%:t')), '\n')
endif
inoremap <leader>gb <esc>:GB<left><left>
nnoremap <leader>gb :GB<left><left>
let g:loaded_git_blame = 1
