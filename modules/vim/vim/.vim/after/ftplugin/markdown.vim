source <sfile>:h/deno_base.vim

command! -nargs=+ -complete=file_in_path -bar -buffer GrepTag
			\ cgetexpr GrepFunction('\\[_metadata_:' . <q-args> . '\\]')
command! -nargs=+ -complete=file_in_path -bar -buffer LGrepTag
			\ lgetexpr GrepFunction('\\[_metadata_:' . <q-args> . '\\]')

cnoreabbrev <expr> <buffer> greptag (getcmdtype() ==# ':' && getcmdline() ==# 'greptag') ? 'GrepTag' : 'grep'
cnoreabbrev <expr> <buffer> lgreptag (getcmdtype() ==# ':' && getcmdline() ==# 'lgreptag') ? 'LGrepTag' : 'lgrep'

if get(g:, 'smartpairs_loaded', 0) != 0
endif

let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs[&filetype] = get(g:smartpairs_pairs, &filetype, get(g:, "smartpairs_default_pairs", {}))
let g:smartpairs_pairs[&filetype] = extendnew(g:smartpairs_pairs[&filetype], {
			\ '`': '`',
			\ })
