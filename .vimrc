" Enter current millenium
set nocompatible
set encoding=UTF-8

" Enable syntax highlighting and plugins
syntax on
filetype plugin on

" Allow vim's own fuzzy find to work
set path+=**

" Ignores stuff from fuzzy search
set wildignore+=**/node_modules/**

" Display all matching files when tab complete
set wildmenu

" Setup colors
colorscheme monokai-bold

" Make default clipboard the OS X clipboard (and unnamedplus for Linux)
set clipboard=unnamed,unnamedplus

" Enable line numbers
set number
set numberwidth=1

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

set autoindent
set tabstop=8
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

" Auto format code
nnoremap ,fmt gg=G<CR>

" Auto closes brackets
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i

" Auto closes marks
inoremap " ""<Esc>i
inoremap ` ``<Esc>i

" Auto starts NERDTree if `vim` is used without a file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Command to open NERDTree
nnoremap <C-b> :NERDTreeToggle<CR>

" Show hidden files by default
let NERDTreeShowHidden=1

" Close NERDTree with `:q` if it is the only thing open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
