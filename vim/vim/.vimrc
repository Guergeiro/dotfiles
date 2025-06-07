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
			execute 'LspHover'
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
let g:packages_home = expand('$HOME') . '/.vim/plugged'
" Install plugins automatically
if empty(glob(expand('$HOME') . '/.vim/autoload/plug.vim'))
	if has('dialog_con')
		let choice = confirm("Install VimPlug?", "&Yes\n&No", 2)
		if choice == 1
			silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		endif
	else
		echo 'Install VimPlug to ~/.vim/autoload/plug.vim'
	endif
else
	" Vim-Polyglot {{{
	let g:polyglot_disabled = ['autoindent']
	" Vim-Polyglot }}}
	call plug#begin(g:packages_home)
	Plug 'christoomey/vim-tmux-navigator', { 'on':
				\ [
				\	 'TmuxNavigateLeft',
				\	 'TmuxNavigateDown',
				\	 'TmuxNavigateUp',
				\	 'TmuxNavigateRight',
				\	 'TmuxNavigatePrevious'
				\ ] }
	Plug 'dracula/vim', { 'as': 'dracula' }
	Plug 'fcpg/vim-altscreen'
	Plug 'ferrine/md-img-paste.vim', { 'for': 'markdown' }
	Plug 'Guergeiro/clean-path.vim'
	Plug 'gosukiwi/vim-smartpairs'
	Plug 'gruvbox-community/gruvbox'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'itchyny/lightline.vim'
	Plug 'itchyny/vim-gitbranch'
	Plug 'lambdalisue/fern.vim', { 'on': 'Fern' }
	Plug 'lambdalisue/fern-git-status.vim', { 'on': 'Fern' }
	Plug 'lambdalisue/fern-hijack.vim'
	Plug 'lambdalisue/fern-renderer-nerdfont.vim', { 'on': 'Fern' }
	Plug 'lambdalisue/nerdfont.vim'
	Plug 'lervag/vimtex', { 'for': 'tex' }
	Plug 'machakann/vim-highlightedyank'
	Plug 'mattn/emmet-vim', { 'for':
				\ [
				\	 'html',
				\	 'typescriptreact',
				\	 'javascriptreact',
				\	 'tex',
				\	 'astro'
				\ ] }
	Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
	Plug 'puremourning/vimspector'
	Plug 'rafamadriz/friendly-snippets'
	Plug 'rhysd/committia.vim'
	Plug 'romainl/vim-cool'
	Plug 'tpope/vim-commentary'
	Plug 'tpope/vim-surround'
	Plug 'sheerun/vim-polyglot'
	Plug 'srcery-colors/srcery-vim'
	Plug 'whiteinge/diffconflicts'
	Plug 'wincent/scalpel', { 'on': '<plug>(Scalpel)' }
	Plug 'wuelnerdotexe/vim-astro'

	Plug 'mattn/vim-lsp-settings'
	Plug 'prabirshrestha/vim-lsp'
	Plug 'prabirshrestha/async.vim'

	Plug 'LumaKernel/ddc-file'
	Plug 'matsui54/ddc-buffer'
	Plug 'matsui54/denops-popup-preview.vim'
	Plug 'Shougo/ddc.vim'
	Plug 'Shougo/ddc-filter-converter_remove_overlap'
	Plug 'Shougo/ddc-filter-matcher_head'
	Plug 'Shougo/ddc-filter-sorter_rank'
	Plug 'Shougo/ddc-source-around'
	Plug 'Shougo/ddc-source-rg'
	Plug 'Shougo/ddc-ui-pum'
	Plug 'Shougo/pum.vim'
	Plug 'shun/ddc-vim-lsp'
	Plug 'tani/ddc-fuzzy'
	Plug 'uga-rosa/ddc-source-vsnip'
	Plug 'vim-denops/denops.vim'


	if has('nvim')
		Plug 'github/copilot.vim', { 'on': [] }

		Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
		Plug 'nvim-lua/plenary.nvim'
		Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
	endif
	call plug#end()

	source $HOME/.vim/vimrc/plugins.vim
endif
