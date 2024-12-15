source <sfile>:h/deno_base.vim
if !exists(':GrepTag')
	command! -nargs=+ -complete=file_in_path -bar -buffer GrepTag
				\ cgetexpr GrepFunction('\\[_metadata_:' . <q-args> . '\\]')
endif
if !exists(':LGrepTag')
	command! -nargs=+ -complete=file_in_path -bar -buffer LGrepTag
				\ lgetexpr GrepFunction('\\[_metadata_:' . <q-args> . '\\]')
endif
cnoreabbrev <expr> <buffer> greptag (getcmdtype() ==# ':' && getcmdline() ==# 'greptag') ? 'GrepTag' : 'grep'
cnoreabbrev <expr> <buffer> lgreptag (getcmdtype() ==# ':' && getcmdline() ==# 'lgreptag') ? 'LGrepTag' : 'lgrep'

nnoremap <buffer><leader>p :call mdip#MarkdownClipboardImage()<cr>

if !exists('g:smartpairs_loaded')
	finish
endif
let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs[&filetype] = get(g:smartpairs_pairs, &filetype, g:smartpairs_default_pairs)
let g:smartpairs_pairs[&filetype] = extendnew(g:smartpairs_pairs[&filetype], {
			\ '`': '`',
			\ })
