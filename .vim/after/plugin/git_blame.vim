" Git blame https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
command! -range GB echo join(systemlist("git -C " . shellescape(expand("%:p:h")) . " blame -L <line1>,<line2> " . expand("%:t")), "\n")
inoremap <leader>gb <esc>:GB<left><left>
nnoremap <leader>gb :GB<left><left>
