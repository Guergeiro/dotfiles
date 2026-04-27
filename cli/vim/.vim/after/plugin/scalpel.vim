function! s:scalpel() abort
	nunmap <leader><f2>
	let g:ScalpelMap=0

	packadd scalpel
	nmap <leader><f2> <plug>(Scalpel)

	call feedkeys("\<leader>\<f2>", 'm')
endfunction

nnoremap <silent> <leader><f2> <cmd>call <sid>scalpel()<cr>
