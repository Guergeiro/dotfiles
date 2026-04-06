let g:copilot_no_tab_map = v:true
packadd copilot.vim
imap <silent><script><expr> <c-y> copilot#Accept()
