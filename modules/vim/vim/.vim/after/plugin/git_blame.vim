" Git blame https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
if get(g:, 'loaded_git_blame', 0) != 0
	finish
endif

command! -range GB echo join(systemlist('git -C ' . shellescape(expand('%:p:h')) . ' blame -L <line1>,<line2> ' . expand('%:t')), '\n')
nnoremap <leader>gb :GB<cr>
vnoremap <leader>gb :GB<cr>
let g:loaded_git_blame = 1
