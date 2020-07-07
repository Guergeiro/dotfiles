" Enter current millenium
set nocompatible
set encoding=UTF-8

" Changes weird behaviour with VIM starting in REPLACE Mode (only happens on
" WSL for me)
set ambw=double

" Sets backspace to work in case it doesn't
set backspace=indent,eol,start

" Enable syntax highlighting and plugins
syntax on
filetype plugin on

" Sets backup folder to undodir
set nobackup
set undodir=$HOME/.vim/undodir
set undofile

" Move swp files to the same directory
set directory=$HOME/.vim/swapfiles//

" Disable error bells
set noerrorbells

" Allow vim's own fuzzy find to work
set path+=**

" Ignores stuff from fuzzy search
set wildignore+=*/node_modules/*,*/__pycache__/*

" Display all matching files when tab complete
set wildmenu

" Setup colors
colorscheme codedark

" Make default clipboard the OS X clipboard (and unnamedplus for Linux)
set clipboard=unnamed,unnamedplus

" Enable line numbers
set number
set numberwidth=1
set relativenumber

" Highlight matching pairs as you type: (), [], {}
set showmatch

" Search-as-you-type
set incsearch

" Case-insensitive searching
set ignorecase

" Case-sensitive if expression contains a capital letter
set smartcase

" Use highlighting for search matches (:nohlsearch to clear [or :noh])
set hlsearch

" Formats stuff as I want, TAB=4spaces, but intelligent
set autoindent
set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

" Loads all packs
packloadall

" Add branch to status line
set statusline+=fugitive#statusline()

" Auto format code
nnoremap ,fmt :PrettierAsync<CR>

" Auto format without prettier pragma
let g:prettier#autoformat_require_pragma = 0

" Format on save
autocmd BufWritePost * normal ,fmt

" Auto closes brackets
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i

" Auto closes marks
inoremap " ""<Esc>i
inoremap ` ``<Esc>i

" Fuzzy Finder like VSCode in a new tab
inoremap <C-p> <Esc>:tabfind<Space>
nnoremap <C-p> :tabfind<Space>

" Close current tab
inoremap <C-w> <Esc>:tabclose<CR>
nnoremap <C-w> :tabclose<CR>

" Move between tabs using CTRL+Left and CTRL+Right keys
inoremap <C-l> <Esc>gt
nnoremap <C-l> gt
inoremap <C-h> <Esc>gT
nnoremap <C-h> gT

" Searchs for selection
vnoremap <C-f> y/<C-R>=escape(@",'/\')<CR><CR>

" Finds and Replaces selection
vnoremap <C-r> y:%s/<C-R>=escape(@",'/\')<CR>//g

" Remove extra white spaces on save
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

" NERDTree Configs Start
" Auto starts NERDTree if `vim` is used without a file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Command to open NERDTree
inoremap <C-b> <Esc>:NERDTreeToggle<CR>
nnoremap <C-b> :NERDTreeToggle<CR>

" Show hidden files by default
let NERDTreeShowHidden=1

" Close NERDTree with `:q` if it is the only thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERDTree Configs End

" CoC Configs Start
" TextEdit might fail if hidden is not set.
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Auto organizes import
nnoremap ,or :CocCommand editor.action.organizeImport<CR>

" Auto organizes import on save
autocmd BufWritePost * normal ,or

" GoTo code navigation.
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nnoremap <F2> <Plug>(coc-rename)

" Auto Complete VSCode like
" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Close the preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" CoC Configs End
