" nnoremap <buffer> <leader>m :w! \| !textype '%:p'<cr>
if !exists('g:loaded_vimtex')
	finish
endif
nmap <buffer> <leader>m <plug>(vimtex-compile-ss)
