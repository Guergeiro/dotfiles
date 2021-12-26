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
" Allow not saved buffers
set hidden
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable delays and poor user experience.
set updatetime=250
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Will not redraw the screen while running macros (goes faster)
set lazyredraw
" Prevents inserting two spaces after punctuation on a join
set nojoinspaces
" Complete menu options
set completeopt=menuone,noinsert,noselect,preview
" Custom quit command
if !exists(':Q')
  command! Q q!
endif
" Search for the word under the cursor (but don't advance to the first match)
map <silent> * :let @/="\\<<c-r><c-w>\\>"<cr>:set hls<cr>
" Remove defaults I don't like
noremap <F1> <nop>
nnoremap Q <nop>
" Keeps n and N centered
nnoremap n nzzzv
nnoremap N Nzzzv
" Keeps the J in the same spot
nnoremap J mzJ`z
" Undo break points
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ; ;<c-g>u
inoremap : :<c-g>u
inoremap ? ?<c-g>u
inoremap ! !<c-g>u
" Y yanks to the end of the line
nnoremap Y y$
" ctrl+d & ctrl+u feels weird, so remap for ctrl+j & ctrl+k
noremap <c-j> m`<c-d>
noremap <c-k> m`<c-u>
noremap <c-d> <nop>
noremap <c-u> <nop>
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
function! <sid>show_documentation()
  if (index(['vim', 'help'], &filetype) >= 0)
    execute 'h ' . expand('<cword>')
  elseif get(g:, 'lsp_server_loaded', 0) == 1
    execute 'LspHover'
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction
nnoremap <silent> K :call <sid>show_documentation()<cr>
" AutoCommands {{{ "
augroup Autocmd
  autocmd!
  " Remove extra spaces on save
  autocmd BufWritePre,FileWritePre * :call <sid>trimWhitespace()
  " Close the completion window when done
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
" AutoCommands }}} "
" Install minpac automatically
if !isdirectory(expand('$HOME') . '/.vim/pack/minpac/opt/minpac')
  if has('dialog_con')
    let choice = confirm("Install minpac?", "&Yes\n&No", 2)
    if choice == 1
      silent !git clone https://github.com/k-takata/minpac.git
            \ ~/.vim/pack/minpac/opt/minpac
    endif
  else
    echo 'Install mincpac to ~/.vim/pack/minpac/opt/minpac'
  endif
else
  function! PackInit() abort
    packadd minpac

    call minpac#init()
    call minpac#add('k-takata/minpac', {'type': 'opt'})

    " Additional plugins here
    call minpac#add('christoomey/vim-tmux-navigator')
    call minpac#add('fcpg/vim-altscreen')
    call minpac#add('Guergeiro/clean-path.vim')
    call minpac#add('Guergeiro/vim-smartpairs')
    call minpac#add('gruvbox-community/gruvbox')
    call minpac#add('habamax/vim-select')
    call minpac#add('habamax/vim-select-more')
    call minpac#add('itchyny/lightline.vim')
    call minpac#add('itchyny/vim-gitbranch')
    call minpac#add('lambdalisue/fern.vim')
    call minpac#add('lambdalisue/fern-git-status.vim')
    call minpac#add('lambdalisue/fern-hijack.vim')
    call minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
    call minpac#add('lambdalisue/nerdfont.vim')
    call minpac#add('machakann/vim-highlightedyank')
    call minpac#add('mbbill/undotree')
    call minpac#add('rhysd/committia.vim')
    call minpac#add('romainl/vim-cool')
    call minpac#add('tommcdo/vim-exchange')
    call minpac#add('tpope/vim-commentary')
    call minpac#add('tpope/vim-obsession')
    call minpac#add('tpope/vim-surround')
    call minpac#add('sheerun/vim-polyglot')
    call minpac#add('srcery-colors/srcery-vim')
    call minpac#add('voldikss/vim-floaterm')
    call minpac#add('whiteinge/diffconflicts')
    call minpac#add('wincent/scalpel')

    call minpac#add('mattn/emmet-vim')
    call minpac#add('mattn/vim-lsp-settings')
    call minpac#add('prabirshrestha/vim-lsp')
    call minpac#add('prabirshrestha/async.vim')

    call minpac#add('SirVer/ultisnips')
    call minpac#add('honza/vim-snippets')

    call minpac#add('Shougo/ddc.vim')
    call minpac#add('Shougo/ddc-around')
    call minpac#add('Shougo/ddc-matcher_head')
    call minpac#add('Shougo/ddc-sorter_rank')
    call minpac#add('Shougo/ddc-converter_remove_overlap')
    call minpac#add('Shougo/ddc-rg')
    call minpac#add('LumaKernel/ddc-file')
    call minpac#add('matsui54/ddc-buffer')
    call minpac#add('matsui54/ddc-matcher_fuzzy')
    call minpac#add('matsui54/ddc-ultisnips')
    call minpac#add('matsui54/denops-popup-preview.vim')
    call minpac#add('shun/ddc-vim-lsp')
    call minpac#add('vim-denops/denops.vim')
  endfunction
  function! PackList(...) abort
    call PackInit()
    return join(sort(keys(minpac#getpluglist())), "\n")
  endfunction

  command! -nargs=1 -complete=custom,PackList
        \ PackOpenDir call PackInit() | call term_start(&shell,
        \    {'cwd': minpac#getpluginfo(<q-args>).dir,
        \     'term_finish': 'close'})
  command! PackUpdate source $MYVIMRC | call PackInit() | call minpac#update()
  command! PackClean  source $MYVIMRC | call PackInit() | call minpac#clean()
  command! PackStatus call PackInit() | call minpac#status()

  source $HOME/.vim/vimrc/plugins.vim
endif
