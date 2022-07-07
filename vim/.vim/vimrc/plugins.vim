vim9script
if exists('g:loaded_plugins')
  finish
endif
# ColorScheme {{{
g:srcery_italic = 1
g:gruvbox_italic = 1
set background=dark
colorscheme srcery
# ColorScheme }}}

# vim-tmux-navigator {{{
g:tmux_navigator_no_mappings = 1
nnoremap <silent> <c-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <c-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <c-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <c-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <c-w>\ :TmuxNavigatePrevious<cr>
# vim-tmux-navigator }}}

# vim-cool {{{
g:CoolTotalMatches = 1
# vim-cool }}}

# Undotree {{{
inoremap <silent> <leader>u <esc>:UndotreeToggle<cr>
nnoremap <silent> <leader>u :UndotreeToggle<cr>
# Undotree }}}

# Vim-select {{{
g:select_no_ignore_vcs = 0
# A bunch of fuzzy
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
# Vim-select }}}

# Scalpel {{{
g:ScalpelMap = 0
nmap <leader><f2> <plug>(Scalpel)
# Scalpel }}}

# Vim-smartpairs {{{
# Removes basic autoclose
iunmap {
iunmap (
iunmap [
iunmap "
iunmap `
# Vim-smartpairs }}}

# Fern {{{
g:fern#disable_default_mappings = 1
g:fern#default_hidden = 1
g:fern#renderer = 'nerdfont'
inoremap <silent><c-b>b <esc>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>b :Fern . -reveal=%<cr>
inoremap <silent><c-b>v <esc>:wincmd v<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>v :wincmd v<cr>:Fern . -reveal=%<cr>
inoremap <silent><c-b>s <esc>:wincmd s<cr>:Fern . -reveal=%<cr>
nnoremap <silent><c-b>s :wincmd s<cr>:Fern . -reveal=%<cr>
# Fern }}}

# vim-highlightedyank {{{
g:highlightedyank_highlight_duration = 250
# vim-highlightedyank }}}

# vim-lsp {{{
g:lsp_fold_enabled = 0
g:lsp_use_event_queue = 1
g:lsp_untitled_buffer_enabled = 0
g:lsp_document_highlight_enabled = 0
g:lsp_document_code_action_signs_enabled = 0
g:lsp_diagnostics_float_cursor = 1
g:lsp_diagnostics_float_delay = 250
g:lsp_diagnostics_highlights_enabled = 0
g:lsp_diagnostics_signs_error = {'text': ''}
g:lsp_diagnostics_signs_warning = {'text': ''}
g:lsp_diagnostics_signs_info = {'text': ''}
g:lsp_diagnostics_signs_hint = {'text': ''}
g:lsp_diagnostics_signs_delay = 250
nmap gd <plug>(lsp-definition)
nmap gr <plug>(lsp-references)
nmap gi <plug>(lsp-implementation)
nmap gt <plug>(lsp-type-definition)
nmap <c-@> <plug>(lsp-code-action)
nmap <f2> <plug>(lsp-rename)
nmap <silent> <c-h> <plug>(lsp-previous-diagnostic)
nmap <silent> <c-l> <plug>(lsp-next-diagnostic)
# vim-lsp }}}

# Lightline {{{
g:lightline = {
  'active': {
    'left': [
      ['mode', 'paste'],
      ['gitbranch', 'readonly', 'filename', 'modified']
    ],
  },
  'component_function': {
    'gitbranch': 'gitbranch#name',
  },
}
g:lightline.colorscheme = g:colors_name
# Lightline }}}

# clean-path.vim {{{
&path = &path .. cleanpath#setpath()
&wildignore = &wildignore .. cleanpath#setwildignore()
# clean-path.vim }}}

# ddc.vim {{{
if !exists('*Ddcinit')
   def Ddcinit()
    ddc#custom#patch_global('completionMenu', 'pum.vim')
    ddc#custom#patch_global('sources',
          [
            'vim-lsp',
            'buffer',
            'around',
            'file',
            'rg',
            'tabnine'
          ])
    ddc#custom#patch_global('sourceOptions', {
          '_': {
            'smartCase': true,
            'minAutoCompleteLength': 1,
            'sorters': ['sorter_rank'],
            'matchers': ['matcher_fuzzy'],
            'converters': ['converter_remove_overlap']
            },
          'vim-lsp': {
            'mark': 'lsp',
            'minAutoCompleteLength': 4,
            'matchers': ['matcher_head']
            },
          'file': {
            'mark': 'file',
            'maxCandidates': 5,
            'isVolatile': true,
            },
          'buffer': {
            'mark': 'b',
            'maxCandidates': 5
            },
          'around': {
            'mark': 'a',
            'maxCandidates': 5
            },
          'rg': {
            'mark': 'rg',
            'maxCandidates': 5,
            'minAutoCompleteLength': 2,
            },
          'tabnine': {
            'mark': 'tab',
            'maxCandidates': 5,
            'isVolatile': true
            }
          })

    ddc#custom#patch_global('filterParams', {
          'matcher_fuzzy': {
            'camelcase': true
            },
          })
    ddc#custom#patch_global('postFilters', [
          'postfilter_score'
          ])
    inoremap <silent> <expr> <tab>
          \ pum#visible() ?
          \ '<cmd>call pum#map#select_relative(+1)<cr>' : '<tab>'
    inoremap <silent> <expr> <s-tab>
          \ pum#visible() ?
          \ '<cmd>call pum#map#select_relative(-1)<cr>' : '<s-tab>'
    inoremap <silent> <expr> <cr>
          \ pum#visible() ?
          \ '<cmd>call pum#map#confirm()<cr>' : '<cr>'
    inoremap <silent> <expr> <c-@> ddc#manual_complete()
    ddc#enable()
  enddef
  defcompile
endif

augroup Ddc
  autocmd!
  autocmd User DenopsReady {
    Ddcinit()
  }
augroup END
# ddc.vim }}}

g:loaded_plugins = 1
