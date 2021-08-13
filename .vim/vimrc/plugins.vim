if exists('g:loaded_plugins')
  finish
endif

" Vim-Polyglot Config Start {{{
let g:polyglot_disabled = ['autoindent', 'sensible']
" }}}

" ColorScheme {{{
let g:srcery_italic=1
let g:gruvbox_italic=1
set background=dark
colorscheme srcery
" }}}

" vim-tmux-navigator Config Start{{{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <c-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <c-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <c-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <c-w>\ :TmuxNavigatePrevious<cr>
" }}}

" vim-cool Config Starts {{{
let g:CoolTotalMatches = 1
" }}}

" Undotree Config Start {{{
inoremap <silent> <leader>u <esc>:UndotreeToggle<cr>
nnoremap <silent> <leader>u :UndotreeToggle<cr>
" }}}

" Floaterm Config Start {{{
let g:floaterm_wintype = 'vsplit'
let g:floaterm_width = 0.5
nnoremap <leader>tt :FloatermToggle<cr>
inoremap <leader>tt <esc>:FloatermToggle<cr>
nnoremap <leader>nt :FloatermNew<cr>
inoremap <leader>nt <esc>:FloatermNew<cr>
" }}}

" Vim-select Config Start {{{
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
" }}}

" Scalpel Config Start {{{
let g:ScalpelMap=0
nmap <leader><f2> <plug>(Scalpel)
" }}}

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
" }}}

" vim-highlightedyank Config Start {{{
let g:highlightedyank_highlight_duration = 250
" }}}

" vim-lsp Config Starts {{{
if !isdirectory(expand('/home/breno/.local/vim-lsp-settings/servers'))
  call mkdir(expand('/home/breno/.local/vim-lsp-settings/servers'), 'p')
endif
let g:lsp_settings_servers_dir='/home/breno/.local/vim-lsp-settings/servers'
let g:lsp_fold_enabled = 0
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_float_delay = 250
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_signs_error = {'text': ''}
let g:lsp_diagnostics_signs_warning = {'text': ''}
let g:lsp_diagnostics_signs_info = {'text': ''}
let g:lsp_diagnostics_signs_hint = {'text': ''}
let g:lsp_diagnostics_signs_delay = 250
nmap gd <plug>(lsp-definition)
nmap gr <plug>(lsp-references)
nmap gi <plug>(lsp-implementation)
nmap gt <plug>(lsp-type-definition)
nmap <c-@> <plug>(lsp-code-action)
nmap <f2> <plug>(lsp-rename)
nmap <silent> <c-h> <plug>(lsp-previous-diagnostic)
nmap <silent> <c-l> <plug>(lsp-next-diagnostic)
" }}}

" Lightline Config Start {{{
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
" }}}

" clean-path.vim Config Start {{{
packadd clean-path.vim
let &path.=cleanpath#setpath()
let &wildignore.=cleanpath#setwildignore()
" }}}

" Deoplete Config Start {{{
function! s:custom_expand() abort
  if !pumvisible()
    return "\<cr>"
  endif
  return "\<c-y>"
endfunction
packadd deoplete.nvim
call deoplete#custom#option('on_insert_enter', v:false)
call deoplete#custom#option('num_processes', 4)
call deoplete#custom#option('refresh_always', v:false)
let g:deoplete#enable_at_startup = 1
inoremap <silent> <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent> <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent> <cr> <c-r>=<sid>custom_expand()<cr>
inoremap <silent> <expr> <c-@> deoplete#manual_complete()
" }}}
let g:loaded_plugins = 1
