" Install VimPlug automatically
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Let's load plugins
call plug#begin('~/.vim/plugged')
Plug 'fcpg/vim-altscreen'
Plug 'gruvbox-community/gruvbox'
Plug 'Guergeiro/clean-path.vim'
Plug 'honza/vim-snippets'
Plug 'itchyny/vim-gitbranch'
Plug 'itchyny/lightline.vim'
Plug 'mbbill/undotree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
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
                \ coc-snippets
                \ coc-tsserver
                \ coc-vimlsp
                \ coc-yaml
                \ --sync | source $MYVIMRC
endif
" Enter current millenium
set nocompatible
set encoding=utf-8
" Backups and stuff
if (exists("$SUDO_USER"))
    set nobackup
    set nowritebackup
else
    set backupdir=$HOME/.vim/backup//
    if !isdirectory(expand(&backupdir))
        call mkdir(expand(&backupdir), "p")
    endif
endif
if (exists("$SUDO_USER"))
    set noswapfile
else
    set directory=$HOME/.vim/swapfiles//
    if !isdirectory(expand(&directory))
        call mkdir(expand(&directory), "p")
    endif
endif
if (has("persistent_undo"))
    if (exists("$SUDO_USER"))
        set noundofile
    else
        set undofile
        set undodir=$HOME/.vim/undodir//
        if !isdirectory(expand(&undodir))
            call mkdir(expand(&undodir), "p")
        endif
    endif
endif
" Changes weird behaviour with VIM starting in REPLACE Mode (only happens on WSL for me)
if system("uname -r") =~ "microsoft"
    set ambw=double
endif
" Sets backspace to work in case it doesn't
set backspace=indent,eol,start
let g:mapleader = "\\"
let loaded_netrwPlugin=1
" Enable syntax highlighting
syntax on
filetype plugin on
if (has("syntax"))
    set cursorline
endif
" Make default clipboard the OS X clipboard (and unnamedplus for Linux)
if (has("clipboard"))
    set clipboard=unnamed,unnamedplus
endif
" Formats stuff as I want, TAB=4spaces, but intelligent
set autoindent
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set smarttab
set autoindent
" Start scrolling 5 lines before the end
set scrolloff=5
" Folding
if (has("folding"))
    set foldmethod=indent
    set foldlevelstart=3
endif
" Highlight current line number
set highlight+=N:DiffText
" List stuff
set list
set listchars=nbsp:⦸
set listchars+=trail:⋅
" Split stuff
if (has("windows"))
    set splitbelow
endif
if (has("vertsplit"))
    set splitright
endif
" Pretty terminal
if (has("termguicolors"))
    set termguicolors
endif
" Allow cursor to move where there is no text in visual block mode
if (has("virtualedit"))
    set virtualedit=block
endif
" Disable error bells
if (exists("&noerrorbells"))
    set noerrorbells
endif
" Display all matching files when tab complete
if (has("wildmenu"))
    set wildmenu
endif
" Enable line numbers
set number
if (exists("&relativenumber"))
    set relativenumber
endif
" Enable mouse support
if (has("mouse"))
    set mouse=a
endif
" Enable statusline
if (has("statusline"))
    set laststatus=2
endif

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
" RipGrep to the rescue!
if (executable("rg"))
    set grepprg=rg\ --smart-case\ --vimgrep\ --hidden
    set grepformat=%f:%l:%c:%m
endif
" Instant grep + quickfix https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
function! <sid>Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr <sid>Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr <sid>Grep(<f-args>)
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'
" Super cheap git blame https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
command! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")
inoremap <leader>gb <esc>:GB<left><left>
nnoremap <leader>gb :GB<left><left>
" Closes all buffers but the current one ands asks for save/discard for the closed ones
function! <sid>BufferWipeout() abort
    return execute("confirm %bd|e#|bd#")
endfunction
command! Bwipeout call <sid>BufferWipeout()<cr>
nmap <silent><c-w>o :call <sid>BufferWipeout()<cr>
" Find next occurence of <++>, remove it and edit in it's place
inoremap <silent> <leader><leader> <esc>/<++><cr>4xi
nnoremap <silent> <leader><leader> /<++><cr>4xi
" Y yanks to the end of the line
nnoremap Y y$
" Fuzzy Finder in CTRL+p
inoremap <c-p> <esc>:sfind<space>
nnoremap <c-p> :sfind<space>
" Scrolls up/down but keeps cursor position
nnoremap J <C-D>
nnoremap K <C-U>
" Auto closes brackets
inoremap { {}<esc>i
inoremap ( ()<esc>i
inoremap [ []<esc>i
" Auto closes marks
inoremap " ""<esc>i
inoremap ` ``<esc>i
" Finds and Replaces selection
vnoremap <c-r> y:%s/<c-r>=escape(@",'/\')<cr>//gc<left><left><left>
" Remove extra white spaces
function! <sid>TrimWhitespace() abort
    let l = line(".")
    let c = col(".")
    keepp %s/\s\+$//e
    call cursor(l, c)
endfunction
function! <sid>Formatter() abort
    let l:formatter = "Prettier"
    if (v:version >= 800)
        let l:formatter.="Async"
    endif
    let l:message = execute(l:formatter)
endfunction
"" Gruvbox Config Starts
let g:gruvbox_contrast_dark = "hard"
colorscheme gruvbox
set background=dark
"" Clean-path Config Starts
let g:clean_path_wildignore = 1
"" Lightline Config Starts
let g:lightline = {
            \ 'colorscheme': 'seoul256',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ }
"" Prettier Config Starts
" Auto format code
nnoremap ,fmt :call <sid>Formatter()<cr>
" Auto format without prettier pragma
let g:prettier#autoformat_require_pragma = 0
"" NERDTree Configs Start
" Command to open NERDTree and Refresh it
inoremap <silent> <c-b> <esc>:NERDTreeToggle<bar>:NERDTreeRefreshRoot<cr>
nnoremap <silent> <c-b> :NERDTreeToggle<bar>:NERDTreeRefreshRoot<cr>
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
" avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window
let g:plug_window = 'noautocmd vertical topleft new'
"" CoC Configs Start
" TextEdit might fail if hidden is not set.
set hidden
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time diagnostics appear/become resolved.
if has("patch-8.1.1564")
    " Recently vim can merge signcolumn and number column into one
    set signcolumn=number
else
    set signcolumn=yes
endif
" Auto organizes import
nnoremap ,or :CocCommand editor.action.organizeImport<cr>
" GoTo code navigation.
nmap <silent> gd <plug>(coc-definition)
nmap <silent> gy <plug>(coc-type-definition)
nmap <silent> gi <plug>(coc-implementation)
nmap <silent> gr <plug>(coc-references)
" Remap for rename current word
nmap <f2> <plug>(coc-rename)
" Make <tab> used for trigger completion, completion confirm, snippet expand and jump like VSCode
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
inoremap <silent><expr> <TAB>
            \ pumvisible() ? coc#_select_confirm() :
            \ coc#expandableOrJumpable() ? "\<c-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" :
            \ <SID>check_back_space() ? "\<tab>" :
            \ coc#refresh()
let g:coc_snippet_next = "<leader><leader>"
" Use <tab> and <S-Tab> to navigate the completion list
inoremap <expr> <tab> pumvisible() ? "\<c-n>" : "\<tab>"
inoremap <expr> <s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" Use <cr> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
" Use <c-space>for trigger completion
inoremap <silent><expr> <c-space> coc#refresh()
"" Airline Configs Start
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#coc#enabled = 1
"" Undotree Configs Start
inoremap <silent> <leader>u <esc>:UndotreeToggle<cr>
nnoremap <silent> <leader>u :UndotreeToggle<cr>
" AutoCommands
augroup General
    autocmd!
    " Copy to Windows Clipboard
    if system("uname -r") =~ "microsoft"
        if (executable("clip.exe"))
            autocmd TextYankPost * if v:event.operator ==# "y" | call system("clip.exe", @0) | endif
        endif
    endif
    " Better focus on windows
    if (has("syntax"))
        autocmd BufEnter,FocusGained,VimEnter,WinEnter * setlocal cursorline
        autocmd FocusLost,WinLeave * setlocal nocursorline
    endif
    if (exists("&relativenumber"))
        autocmd BufEnter,FocusGained,VimEnter,WinEnter * setlocal relativenumber
        autocmd FocusLost,WinLeave * setlocal norelativenumber
    endif
    " Close the coc preview window when completion is done.
    autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
augroup NERDTree
    autocmd!
    " Refresh NERDTree on file save
    autocmd BufWritePre * normal :NERDTreeRefreshRoot<cr>
    " If more than one window and previous buffer was NERDTree, go back to it.
    autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
augroup END
augroup Format
    autocmd!
    " Remove whitespaces on save
    autocmd BufWritePre * :call <sid>TrimWhitespace()
    " Format on save
    autocmd BufWritePre * :call <sid>Formatter()
    " Auto organizes import on save
    autocmd BufWritePre * :CocCommand editor.action.organizeImport
augroup END
augroup GrepQuickfix
    autocmd!
    " Add GrepQuickfix window
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END
