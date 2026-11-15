if !exists('*s:getFormatter')
	function! s:getFormatter() abort
		let l:formatprg = 'google-java-format --skip-reflowing-long-strings -'
		return l:formatprg
	endfunction
endif

let &l:formatprg=<sid>getFormatter()
