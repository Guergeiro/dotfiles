if get(g:, 'loaded_fern', 0) != 0
	finish
endif


function! s:fern(args) abort
	delcommand! Fern
	let g:fern#disable_default_mappings = 1
	let g:fern#default_hidden = 1
	let g:fern#renderer = 'nerdfont'

	packadd fern.vim
	packadd fern-git-status.vim
	packadd fern-renderer-nerdfont.vim

	execute 'Fern ' . a:args
endfunction

inoremap <silent><c-b>b <esc>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>b :Fern . -reveal=%<cr>
inoremap <silent><c-b>v <esc>:wincmd v<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>v :wincmd v<cr>:Fern . -reveal=%<cr>
inoremap <silent><c-b>s <esc>:wincmd s<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>s :wincmd s<cr>:Fern . -reveal=%<cr>

command! -nargs=* -complete=dir Fern call s:fern(<q-args>)
