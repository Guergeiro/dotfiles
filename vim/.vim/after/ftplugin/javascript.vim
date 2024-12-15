let &l:makeprg = 'deno lint --compact --fix --quiet'
setlocal autoread
nnoremap <buffer> <leader>m :make % <bar> cwindow<cr>
if has('quickfix')
	setlocal errorformat=file://%f:\ line\ %l\\,\ col\ %c\ -\ %m
endif
source <sfile>:h/deno_base.vim
set path-=node_modules/**
set path-=./node_modules/**
if !exists('g:smartpairs_loaded')
  finish
endif
let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs[&filetype] = get(g:smartpairs_pairs, &filetype, g:smartpairs_default_pairs)
let g:smartpairs_pairs[&filetype] = extendnew(g:smartpairs_pairs[&filetype], {
			\ '`': '`',
			\ })
