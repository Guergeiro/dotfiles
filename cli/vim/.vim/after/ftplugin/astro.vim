source <sfile>:h/deno_base.vim

if get(g:, 'smartpairs_loaded', 0) != 0
	let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
	let g:smartpairs_pairs[&filetype] = get(g:smartpairs_pairs, &filetype, g:smartpairs_default_pairs)
	let g:smartpairs_pairs[&filetype] = extendnew(g:smartpairs_pairs[&filetype], {
				\ '`': '`',
				\ })
endif
