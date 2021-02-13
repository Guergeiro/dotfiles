" Copied from https://github.com/habamax/vim-select-more/blob/master/after/plugin/select_more.vim
let g:select_info = get(g:, "select_info", {})

let g:select_info.bufline = {}
let g:select_info.bufline.data = {_, v ->
            \ getbufline(v.bufnr, 1, "$")->map({i, ln -> printf("%*d: %s", len(line('$', v.winid)), i+1, ln)})
            \ }
let g:select_info.bufline.sink = {
            \ "transform": {_, v -> matchstr(v, '^\s*\zs\d\+')},
            \ "action": "normal! %sG"
            \ }
let g:select_info.bufline.highlight = {
      \ "PrependLineNr": ['^\(\s*\d\+:\)', 'LineNr']
      \ }
