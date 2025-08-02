if !exists('*s:getFormatter')
	function! s:getFormatter() abort
		let l:formatprg = 'terraform fmt -'
		return l:formatprg
	endfunction
endif

let &l:formatprg=<sid>getFormatter()
