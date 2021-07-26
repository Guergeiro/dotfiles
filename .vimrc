" General {{{
" Enter current millenium
set nocompatible
set encoding=utf-8
" Backups and stuff
if exists('$SUDO_USER')
  set nobackup
  set nowritebackup
  set noswapfile
  if has('persistent_undo')
    set noundofile
  endif
else
  set backup
  set writebackup
  let &backupdir=expand('/tmp/.vimtrash/backup//')
  if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), 'p')
  endif
  set swapfile
  let &directory=expand('/tmp/.vimtrash/swapfiles//')
  if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), 'p')
  endif
  if has('persistent_undo')
    set undofile
    let &undodir=expand('/tmp/.vimtrash/undodir//')
    if !isdirectory(expand(&undodir))
      call mkdir(expand(&undodir), 'p')
    endif
  endif
endif
" Sets backspace to work in case it doesn't
set backspace=indent,eol,start
let g:mapleader = '`'
" Clears path
set path-=/usr/include
" Enable syntax highlighting
syntax on
filetype plugin indent on
if has('syntax')
  set cursorline
  set colorcolumn=80
endif
" Make default clipboard the OS X clipboard (and unnamedplus for Linux)
if has('clipboard')
  set clipboard=unnamed,unnamedplus
endif
" Formats stuff as I want, TAB=2spaces, but intelligent
set autoindent
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab
if has('smartindent')
  set smartindent
endif
" Start scrolling 10 lines before the end
set scrolloff=10
" Folding
if has('folding')
  set foldmethod=indent
  set foldlevelstart=3
endif
" Highlight current line number
set highlight+=N:DiffText
" List stuff
set list
set listchars=
set listchars+=nbsp:⦸,trail:·,tab:»·,eol:↲
" Split stuff
if has('windows')
  set splitbelow
endif
if has('vertsplit')
  set splitright
endif
" Pretty terminal
set t_Co=256
" Allow cursor to move where there is no text in visual block mode
if has('virtualedit')
  set virtualedit=block
endif
" Disable error bells
if exists('&noerrorbells')
  set noerrorbells
endif
" Display all matching files when tab complete
if has('wildmenu')
  set wildmenu
endif
" Enable line numbers
set number
if exists('&relativenumber')
  set relativenumber
endif
if has('signs')
  set signcolumn=yes
endif
" Enable mouse support
if has('mouse')
  set mouse=a
endif
" Enable statusline
if has('statusline')
  set laststatus=2
endif
" Highlight matching pairs as you type: (), [], {}
set showmatch
if has('extra_search')
  " Search-as-you-type
  set incsearch
  " Use highlighting for search matches (:nohlsearch to clear [or :noh])
  set hlsearch
endif
" Disable emoji weird width (https://youtu.be/F91VWOelFNE)
set noemoji
" Case-insensitive searching
set ignorecase
" Case-sensitive if expression contains a capital letter
set smartcase
" Disable showmode
set noshowmode
" TextEdit might fail if hidden is not set.
set hidden
" Give more space for displaying messages.
set cmdheight=1
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=250
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Will not redraw the screen while running macros (goes faster)
set lazyredraw
" Prevents inserting two spaces after punctuation on a join
set nojoinspaces
" Search for the word under the cursor (but don't advance to the first match)
map <silent> * :let @/="\\<<c-r><c-w>\\>"<cr>:set hls<cr>
" RipGrep to the rescue!
if executable('rg')
  set grepprg=rg\ --smart-case\ --vimgrep\ --hidden
  set grepformat=%f:%l:%c:%m
endif
" Remove extra white spaces
function! <sid>trimWhitespace() abort
  let l = line('.')
  let c = col('.')
  keepp %s/\s\+$//e
  call cursor(l, c)
endfunction
" Sudo write
command! Write write !sudo tee % >/dev/null
" Y yanks to the end of the line
map Y y$
" ctrl+d & ctrl+u feels weird, so remap for ctrl+j & ctrl+k
noremap <c-j> <c-d>
noremap <c-k> <c-u>
noremap <c-d> <nop>
noremap <c-u> <nop>
" Auto closes brackets
inoremap { {}<esc>i
inoremap ( ()<esc>i
inoremap [ []<esc>i
" Auto closes marks
inoremap " ""<esc>i
inoremap ` ``<esc>i
" Terminal escape
tnoremap <leader><esc> <c-\><c-n>
" Show documentation
function! <sid>show_documentation(serverLoaded)
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif (a:serverLoaded)
    execute 'LspHover'
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction
let g:serverLoaded = 0
nnoremap <silent> <leader>k :call <sid>show_documentation(g:lsp_server_loaded)<cr>
" Install VimPlug automatically
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  augroup VimPlug
    autocmd!
    autocmd VimEnter * PlugUpdate --sync | source $MYVIMRC
  augroup END
endif
" Vim-Polyglot Config Start {{{
let g:polyglot_disabled = ['autoindent']
" }}}
" Let's load plugins
call plug#begin('~/.vim/plugged')
Plug 'christoomey/vim-tmux-navigator'
Plug 'fcpg/vim-altscreen'
Plug 'Guergeiro/clean-path.vim'
Plug 'gruvbox-community/gruvbox'
Plug 'habamax/vim-select'
Plug 'habamax/vim-select-more'
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-hijack.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'mbbill/undotree'
Plug 'rhysd/committia.vim'
Plug 'romainl/vim-cool'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'srcery-colors/srcery-vim'
Plug 'voldikss/vim-floaterm'
Plug 'whiteinge/diffconflicts'
Plug 'wincent/scalpel'

Plug 'mattn/emmet-vim'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'lighttiger2505/deoplete-vim-lsp'
call plug#end()
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
" clean-path.vim Config Start {{{
let &path.=cleanpath#setpath()
let &wildignore.=cleanpath#setwildignore()
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
inoremap <silent><leader>st <esc>:Select floaterm<cr>
nnoremap <silent><leader>st :Select floaterm<cr>
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
let g:fern#drawer_width = 40
let g:fern#renderer = 'nerdfont'
inoremap <silent><c-b> <esc>:Fern . -drawer -toggle -reveal=%<cr>
nnoremap <silent><c-b> :Fern . -drawer -toggle -reveal=%<cr>
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
" Deoplete Config Start {{{
function! s:custom_expand() abort
  if !pumvisible()
    return "\<cr>"
  endif
  return "\<c-y>"
endfunction
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('num_processes', 2)
call deoplete#custom#option('on_insert_enter', v:false)
set completeopt=menuone,noinsert,noselect,preview
inoremap <silent> <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <silent> <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
inoremap <silent> <cr> <c-r>=<sid>custom_expand()<cr>
inoremap <silent> <expr> <c-@> deoplete#manual_complete()
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
function! s:lsp_server_commands() abort
  let g:lsp_server_loaded = 1
endfunction
" AutoCommands {{{
augroup General
  autocmd!
  " Remove extra spaces on save
  autocmd BufWritePre,FileWritePre * :call <sid>trimWhitespace()
  " Add GrepQuickfix window
  autocmd QuickFixCmdPost cgetexpr cwindow
  autocmd QuickFixCmdPost lgetexpr lwindow
  " Change documentation to also allow lsp docs
  autocmd User lsp_server_init call <sid>lsp_server_commands()
  " Close the completion window when done
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
" }}}
