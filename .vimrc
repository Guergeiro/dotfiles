" Enter current millenium
set nocompatible

" Enable syntax highlighting and plugins
syntax on
filetype plugin on

" Allow vim's own fuzzy find to work
set path+=**

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
nnoremap ,fmt :gg=G<CR>
