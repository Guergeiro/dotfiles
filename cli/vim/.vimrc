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
set guicursor=
" Make default clipboard the OS X clipboard (and unnamedplus for Linux)
if has('clipboard')
	set clipboard=unnamed,unnamedplus
endif
" Formats stuff as I want, TAB=2spaces, but intelligent
" set expandtab
set autoindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
if has('smartindent')
	set smartindent
endif
" Start scrolling 10 lines before the end
set scrolloff=10
" Fill
set fillchars=vert:\|,fold:-,eob:~,lastline:@
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
" Allow vim to use interactive shell (loads user .bashrc)
" set shellcmdflag=-ic
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
if !exists('*s:TrimWhitespace')
	function! s:TrimWhitespace() abort
		let l = line('.')
		let c = col('.')
		keepp %s/\s\+$//e
		call cursor(l, c)
	endfunction
endif
" Sudo write
command! Write write !sudo tee % >/dev/null
" Auto closes brackets
inoremap { {}<esc>i
inoremap ( ()<esc>i
inoremap [ []<esc>i
" Auto closes marks
inoremap " ""<esc>i
inoremap ` ``<esc>i
" Show documentation
if !exists('*s:ShowDocumentation')
	function! s:ShowDocumentation()
		if (index(['vim', 'help'], &filetype) >= 0)
			execute 'h ' . expand('<cword>')
		elseif get(g:, 'lsp_server_loaded', 0) == 1
			call g:CustomLspHover()
		else
			execute '!' . &keywordprg . ' ' . expand('<cword>')
		endif
	endfunction
endif
nnoremap <silent> K :call <sid>ShowDocumentation()<cr>
" AutoCommands {{{
augroup Autocmd
	autocmd!
	" Remove extra spaces on save
	autocmd BufWritePre,FileWritePre * :call <sid>TrimWhitespace()
	" Close the completion window when done
	autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
" AutoCommands }}}

let g:no_minpac_maps = 1
set packpath^=~/.vim

packadd minpac

call minpac#init()
call minpac#add('k-takata/minpac', { 'type': 'opt' , 'frozen': v:true })

" Additional plugins here.
" Vim-Polyglot {{{
let g:polyglot_disabled = ['autoindent']
" Vim-Polyglot }}}

call minpac#add('vim-jp/syntax-vim-ex')
call minpac#add('tyru/open-browser.vim')

call minpac#add('christoomey/vim-tmux-navigator')
call minpac#add('dracula/vim', { 'name': 'dracula' })
call minpac#add('fcpg/vim-altscreen')
call minpac#add('ferrine/md-img-paste.vim', { 'type': 'opt' })
call minpac#add('Guergeiro/clean-path.vim')
call minpac#add('gosukiwi/vim-smartpairs')
call minpac#add('gruvbox-community/gruvbox')
call minpac#add('hrsh7th/vim-vsnip')
call minpac#add('itchyny/lightline.vim')
call minpac#add('itchyny/vim-gitbranch')
call minpac#add('lambdalisue/fern.vim')
call minpac#add('lambdalisue/fern-git-status.vim')
call minpac#add('lambdalisue/fern-hijack.vim')
call minpac#add('lambdalisue/fern-renderer-nerdfont.vim')
call minpac#add('lambdalisue/nerdfont.vim')
call minpac#add('machakann/vim-highlightedyank')
call minpac#add('mattn/emmet-vim', { 'type': 'opt' })
call minpac#add('mbbill/undotree')
call minpac#add('rafamadriz/friendly-snippets')
call minpac#add('rhysd/committia.vim')
call minpac#add('romainl/vim-cool')
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-surround')
call minpac#add('sheerun/vim-polyglot')
call minpac#add('whiteinge/diffconflicts')
call minpac#add('wincent/scalpel')

call minpac#add('LumaKernel/ddc-file')
call minpac#add('matsui54/ddc-buffer')
call minpac#add('Shougo/ddc.vim', { 'rev': '*' })
call minpac#add('Shougo/ddc-filter-converter_remove_overlap')
call minpac#add('Shougo/ddc-filter-matcher_head')
call minpac#add('Shougo/ddc-filter-sorter_rank')
call minpac#add('Shougo/ddc-source-around')
call minpac#add('Shougo/ddc-source-rg')
call minpac#add('Shougo/ddc-source-lsp')
call minpac#add('Shougo/ddc-ui-pum')
call minpac#add('Shougo/pum.vim')
call minpac#add('tani/ddc-fuzzy')
call minpac#add('uga-rosa/ddc-source-vsnip')
call minpac#add('vim-denops/denops.vim', { 'rev': '*' })
call minpac#add('github/copilot.vim', { 'rev': '*' })

if has('nvim')
	call minpac#add('nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate', 'branch': 'main' })
	call minpac#add('nvim-lua/plenary.nvim')
	call minpac#add('nvim-telescope/telescope.nvim', { 'rev': '*' })
	call minpac#add('neovim/nvim-lspconfig')
	call minpac#add('mfussenegger/nvim-jdtls')
endif

command! PackUpdate call minpac#update()
command! PackClean  call minpac#clean()
command! PackStatus call minpac#status()
source $HOME/.vim/vimrc/plugins.vim
