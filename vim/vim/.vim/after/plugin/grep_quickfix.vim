" Grep+Quickfix https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if exists('g:loaded_grep_quickfix')
	finish
endif
if !exists('GrepFunction')
	function! GrepFunction(args)
		return system(join([&grepprg] + [a:args], ' '))
	endfunction
endif
if !exists('*s:ExpandArgs')
	function! s:ExpandArgs(...)
		return expandcmd(join(a:000, ' '))
	endfunction
endif
if !exists(':Grep')
	command! -nargs=+ -complete=file_in_path -bar Grep
				\ cgetexpr GrepFunction(<sid>ExpandArgs(<f-args>))
endif
if !exists(':LGrep')
	command! -nargs=+ -complete=file_in_path -bar LGrep
				\ lgetexpr GrepFunction(<sid>ExpandArgs(<f-args>))
endif
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

augroup Grep
	autocmd!
	" Add GrepQuickfix window
	autocmd QuickFixCmdPost cgetexpr cwindow
	autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
let g:loaded_grep_quickfix = 1
