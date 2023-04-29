if exists('g:loaded_plugins')
  finish
endif

" Vimtex {{{
let g:vimtex_format_enabled = 1
" }}}

" vim-astro {{{
let g:astro_typescript = 'enable'
" }}}

" Scorpeon {{{
let g:scorpeon_extensions_path = [
      \ g:packages_home . '/vscode/extensions',
      \ g:packages_home . '/vscode-dracula'
      \ ]
let g:scorpeon_highlight = {
      \ 'enable': v:true
      \}
augroup Scorpeon
  autocmd!
  autocmd InsertEnter * ScorpeonHighlightDisable
  autocmd InsertLeave * ScorpeonHighlightEnable
augroup END
" }}}

" ColorScheme {{{
let g:srcery_italic = 1
let g:gruvbox_italic = 1
let g:dracula_colorterm = 0
let g:dracula_full_special_attrs_support = 1
set background=dark
colorscheme dracula
" ColorScheme }}}

" vim-tmux-navigator {{{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <c-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <c-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <c-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <c-w>\ :TmuxNavigatePrevious<cr>
" vim-tmux-navigator }}}

" vim-cool {{{
let g:CoolTotalMatches = 1
" vim-cool }}}

" md-img-paste {{{
let g:mdip_imgdir = '.assets'
" }}}

" Undotree {{{
inoremap <silent> <leader>u <esc>:UndotreeToggle<cr>
nnoremap <silent> <leader>u :UndotreeToggle<cr>
" Undotree }}}

" vim-vsnip {{{
let g:vsnip_snippet_dirs = [
  \ expand('$HOME') . '/.vim/snippets',
  \ g:packages_home . '/friendly-snippets/snippets'
  \ ]
" }}}

" Vim-select {{{
let g:select_no_ignore_vcs = 0
" A bunch of fuzzy
inoremap <silent><leader>sp <esc>:Select projectfile<cr>
nnoremap <silent><leader>sp :Select projectfile<cr>
inoremap <silent><leader>sb <esc>:Select buffer<cr>
nnoremap <silent><leader>sb :Select buffer<cr>
inoremap <silent><leader>sd <esc>:Select todo<cr>
nnoremap <silent><leader>sd :Select todo<cr>
inoremap <silent><leader>sg <esc>:Select gitfile<cr>
nnoremap <silent><leader>sg :Select gitfile<cr>
inoremap <silent><leader>s/ <esc>:Select bufline<cr>
nnoremap <silent><leader>s/ :Select bufline<cr>
inoremap <silent><leader>sn <esc>:Select note<cr>
nnoremap <silent><leader>sn :Select note<cr>
" Vim-select }}}

" Scalpel {{{
let g:ScalpelMap=0
nmap <leader><f2> <plug>(Scalpel)
" Scalpel }}}

" Vim-smartpairs {{{
" Removes basic autoclose
iunmap {
iunmap (
iunmap [
iunmap "
iunmap `
" Vim-smartpairs }}}

" Fern {{{
let g:fern#disable_default_mappings = 1
let g:fern#default_hidden = 1
let g:fern#renderer = 'nerdfont'
inoremap <silent><c-b>b <esc>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>b :Fern . -reveal=%<cr>
inoremap <silent><c-b>v <esc>:wincmd v<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>v :wincmd v<cr>:Fern . -reveal=%<cr>
inoremap <silent><c-b>s <esc>:wincmd s<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>s :wincmd s<cr>:Fern . -reveal=%<cr>
" Fern }}}

" vim-highlightedyank {{{
let g:highlightedyank_highlight_duration = 250
" vim-highlightedyank }}}

" vim-lsp {{{
let g:lsp_fold_enabled = 0
let g:lsp_use_event_queue = 1
let g:lsp_use_native_client = 1
let g:lsp_untitled_buffer_enabled = 0
let g:lsp_document_highlight_enabled = 0
let g:lsp_document_code_action_signs_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_insert_mode_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_signs_error = {'text': ''}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_diagnostics_signs_info = {'text': ''}
let g:lsp_diagnostics_signs_hint = {'text': ''}
nmap gd <plug>(lsp-definition)
nmap gr <plug>(lsp-references)
nmap gi <plug>(lsp-implementation)
nmap gt <plug>(lsp-type-definition)
nmap <c-@> <plug>(lsp-code-action)
nmap <f2> <plug>(lsp-rename)
nmap <silent> <c-h> <plug>(lsp-previous-diagnostic)
nmap <silent> <c-l> <plug>(lsp-next-diagnostic)
" vim-lsp }}}

" vim-lsp-settings {{{
let g:markdown_fenced_languages = ['ts=typescript']
let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server', 'deno']
" }}}

" Lightline {{{
let g:lightline = {
      \ 'active': {
        \   'left': [['mode', 'paste'],
        \           ['gitbranch', 'readonly', 'filename', 'modified']],
        \   },
        \ 'component_function': {
          \   'gitbranch': 'gitbranch#name',
          \   },
          \ }
let g:lightline.colorscheme = g:colors_name
" Lightline }}}

" clean-path.vim {{{
let &path.=cleanpath#setpath()
let &wildignore.=cleanpath#setwildignore()
" clean-path.vim }}}

" copilot.vim {{{
let g:copilot_enabled = v:false
let g:copilot_no_maps = v:true
let g:copilot_node_command = '/usr/bin/node'
" }}}


" pum.vim {{{
call pum#set_option(
  \ {
  \   'max_height': 10,
  \   'padding': v:true
  \ })
" }}}

" ddc.vim {{{
if !exists('*s:ddcinit')
  function! s:ddcinit() abort

    call ddc#custom#patch_global('ui', 'pum')
    call ddc#custom#patch_global('sources',
          \ [
          \   'vim-lsp',
          \   'buffer',
          \   'around',
          \   'file',
          \   'rg',
          \   'tabnine',
          \   'copilot',
          \   'vsnip'
          \ ])
    call ddc#custom#patch_global('sourceOptions', {
          \ '_': {
          \   'minAutoCompleteLength': 1,
          \   'maxItems': 5,
          \   'sorters': ['sorter_rank', 'sorter_fuzzy'],
          \   'matchers': ['matcher_fuzzy'],
          \   'converters': ['converter_remove_overlap', 'converter_fuzzy']
          \   },
          \ 'vim-lsp': {
          \   'mark': 'lsp',
          \   'minAutoCompleteLength': 4,
          \   'matchers': ['matcher_head']
          \   },
          \ 'file': {
          \   'mark': 'file',
          \   'isVolatile': v:true,
          \   },
          \ 'buffer': {
          \   'mark': 'b',
          \   },
          \ 'around': {
          \   'mark': 'a',
          \   },
          \ 'rg': {
          \   'mark': 'rg',
          \   'minAutoCompleteLength': 2,
          \   },
          \ 'tabnine': {
          \   'mark': 'tab',
          \   'isVolatile': v:true
          \   },
          \ 'input': {
          \   'mark': 'gh',
          \   'matchers': [],
          \   'minAutoCompleteLength': 0,
          \   },
          \ 'vsnip': {
          \   'mark': 'vsnip',
          \   'dup': 'keep'
          \   }
          \ })

    call ddc#custom#patch_global('postFilters', [
          \ "postfilter_score"
          \ ])
    inoremap <silent> <expr> <tab>
          \ pum#visible() ?
          \ '<cmd>call pum#map#select_relative(+1)<cr>' :
          \ vsnip#jumpable(1) ? '<plug>(vsnip-jump-next)' :
          \ '<tab>'
    inoremap <silent> <expr> <s-tab>
          \ pum#visible() ?
          \ '<cmd>call pum#map#select_relative(-1)<cr>' :
          \ vsnip#jumpable(-1) ? '<plug>(vsnip-jump-prev)' :
          \ '<s-tab>'
    inoremap <silent> <expr> <cr>
          \ pum#visible() ?
          \ '<cmd>call pum#map#confirm()<cr>' : '<cr>'
    inoremap <silent> <expr> <c-@> ddc#map#manual_complete()
    snoremap <silent> <expr> <tab> vsnip#jumpable(1) ?
          \ '<plug>(vsnip-jump-next)' :
          \ '<tab>'
    snoremap <silent> <expr> <s-tab> vsnip#jumpable(-1) ?
          \ '<plug>(vsnip-jump-prev)' :
          \ '<s-tab>'
    nnoremap <silent> <expr> <tab> vsnip#jumpable(1) ?
          \ '<plug>(vsnip-jump-next)' :
          \ '<tab>'
    nnoremap <silent> <expr> <s-tab> vsnip#jumpable(-1) ?
          \ '<plug>(vsnip-jump-prev)' :
          \ '<s-tab>'
    call ddc#enable()
  endfunction
endif
" ddc.vim }}}
augroup Autocomplete
  autocmd!
  autocmd User DenopsReady call s:ddcinit()
  autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
augroup END

let g:loaded_plugins = 1
