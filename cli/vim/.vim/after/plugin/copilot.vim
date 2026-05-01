if get(g:, 'loaded_copilot', 0) != 0
	finish
endif

let g:copilot_no_tab_map = v:true
packadd copilot.vim
imap <silent><script><expr> <c-y> copilot#Accept()
