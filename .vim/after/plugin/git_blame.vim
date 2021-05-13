" Git blame https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
if exists('g:loaded_git_blame')
  finish
endif
if !exists(':GB')
  command! -range GB echo join(systemlist('git -C ' . shellescape(expand('%:p:h')) . ' blame -L <line1>,<line2> ' . expand('%:t')), '\n')
endif
nnoremap <leader>gb :GB<cr>
vnoremap <leader>gb :GB<cr>
let g:loaded_git_blame = 1
