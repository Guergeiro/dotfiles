" Install VimPlug automatically
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Let's load plugins
call plug#begin('~/.vim/plugged')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'tpope/vim-fugitive'
    Plug 'preservim/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
    Plug 'vim-airline/vim-airline'
    Plug 'gruvbox-community/gruvbox'
call plug#end()

if !isdirectory($HOME . "/.config/coc/extensions")
    call mkdir($HOME . "/.config/coc/extensions", "p")
    autocmd VimEnter * CocInstall
                \ coc-css
                \ coc-html
                \ coc-java
                \ coc-json
                \ coc-markdownlint
                \ coc-phpls
                \ coc-python
                \ coc-sh
                \ coc-tsserver
                \ coc-vimlsp
                \ coc-yaml
                \--sync | source $MYVIMRC
endif

" Enter current millenium
set nocompatible
set encoding=UTF-8

" Changes weird behaviour with VIM starting in REPLACE Mode (only happens on
" WSL for me)
if system("uname -r") =~ "microsoft"
    set ambw=double
endif

" Sets backspace to work in case it doesn't
set backspace=indent,eol,start

" Enable syntax highlighting and plugins
syntax on
filetype plugin on

" Sets backup folder to undodir
set nobackup
set noautowrite
set undofile
set undodir=$HOME/.vim/undodir//
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/backup//

" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" Disable error bells
set noerrorbells

" Allow vim's own fuzzy find to work
set path+=**

" Ignores stuff from fuzzy search
set wildignore+=**/node_modules/**,**/__pycache__/**

" Display all matching files when tab complete
set wildmenu

" Make default clipboard the OS X clipboard (and unnamedplus for Linux)
set clipboard=unnamed,unnamedplus

" Enable line numbers
set number
set numberwidth=1
set relativenumber

" Enable mouse support
set mouse=a

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
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smarttab

" RipGrep to the rescue!
if executable('rg')
    set grepprg=rg\ --color=auto\ --vimgrep\ --hidden\ --glob\ '!.git'
    set grepformat=%f:%l:%c:%m
endif

" Fuzzy Finder in CTRL+p
inoremap <C-p> <Esc>:find<Space>
nnoremap <C-p> :find<Space>

" Open a new 'tab' (buffer) with CTRL+t
inoremap <C-t> <Esc>:enew<CR>
nnoremap <C-t> :enew<CR>

" Close current 'tab' (buffer) with CTRL+w (with fix to work with NERDTree)
inoremap <C-w> <Esc>:bp<Bar>bd #<CR>
nnoremap <C-w> :bp<Bar>bd #<CR>

" Move between 'tabs' using CTRL+h and CTRL+l keys
inoremap <C-h> <Esc>:bprev<CR>
nnoremap <C-h> :bprev<CR>
inoremap <C-l> <Esc>:bnext<CR>
nnoremap <C-l> :bnext<CR>

" Scrolls up/down but keeps cursor position
inoremap <C-j> <Esc><C-D>
nnoremap <C-j> <C-D>
inoremap <C-k> <Esc><C-U>
nnoremap <C-k> <C-U>

" Auto closes brackets
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i

" Auto closes marks
inoremap " ""<Esc>i
inoremap ` ``<Esc>i

" Auto starts docs block using snippets
inoremap /** <Esc>:-1read $HOME/.vim/snippets/.skeleton-docs<CR>jA
nnoremap ,doc :-1read $HOME/.vim/snippets/.skeleton-docs<CR>jA

" Searchs for selection
vnoremap <C-f> y/<C-R>=escape(@",'/\')<CR><CR>

" Finds and Replaces selection
vnoremap <C-r> y:%s/<C-R>=escape(@",'/\')<CR>//gc<Left><Left><Left>

" Remove extra white spaces
function! <SID>TrimWhitespace()
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfunction

" Loads all packs
packloadall

" Gruvbox Config Starts
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_number_column = "red"
" Gruvbox Config Ends

" VIM Fugitive Config Starts
" Add branch to status line
set statusline+=fugitive#statusline()
" VIM Fugitive Config Ends

" Prettier Config Starts
" Auto format code
nnoremap ,fmt :PrettierAsync<CR>

" Auto format without prettier pragma
let g:prettier#autoformat_require_pragma = 0

" Prettier Config Ends

" NERDTree Configs Start
" Command to open NERDTree and Refresh it
inoremap <C-b> <Esc>:NERDTreeToggle<bar>:NERDTreeRefreshRoot<CR>
nnoremap <C-b> :NERDTreeToggle<bar>:NERDTreeRefreshRoot<CR>

" Show git status
let g:NERDTreeGitStatusWithFlags = 1

" Show hidden files by default
let g:NERDTreeShowHidden=1

" Ignore based on wildignore (still shows the folders but not it's content)
let g:NERDTreeRespectWildIgnore=1

" Auto deletes opened buffer when deleting a file
let g:NERDTreeAutoDeleteBuffer=1

" Close on file open
let g:NERDTreeQuitOnOpen=1

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable  file, and we're not in vimdiff
function! SyncTree()
    if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
        NERDTreeFind
        wincmd p
    endif
endfunction
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

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif

" Auto organizes import
nnoremap ,or :CocCommand editor.action.organizeImport<CR>

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Search for word in all cwd
inoremap <C-F> <Esc>:CocSearch<Space>
nnoremap <C-F> :CocSearch<Space>

" Use K to show documentation in preview window.
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
nnoremap <silent> K :call <SID>show_documentation()<CR>

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
" CoC Configs End

" Airline Configs Start
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Airline Configs End

" AutoCommands
augroup General
    autocmd!

    " Copy to Windows Clipboard
    if system("uname -r") =~ "microsoft"
            autocmd TextYankPost * :call system('clip.exe ',@")
    endif

    " Prevent from opening a new buffer if it already exists
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                          \ exe "normal g'\"" | endif

    " Highlight currently open buffer in NERDTree
    autocmd BufRead * call SyncTree()

    " Refresh NERDTree on file save
    autocmd BufWritePre * normal :NERDTreeRefreshRoot<CR>

    " Remove whitespaces on save
    autocmd BufWritePre * :call <SID>TrimWhitespace()

    " Format on save
    autocmd BufWritePre * normal ,fmt

    " Auto organizes import on save
    autocmd BufWritePre * normal ,or

    " Close the preview window when completion is done.
    autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
