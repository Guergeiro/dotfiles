if !exists('g:smartpairs_loaded')
  finish
endif
let g:smartpairs_pairs = get(g:, "smartpairs_pairs", {})
let g:smartpairs_pairs.vim = { '(': ')', '[': ']', '{': '}', "'": "'" }
