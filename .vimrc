
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
syntax on

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Plugin 'tpope/vim-fugitive'
" Tree explorer
Plugin 'https://github.com/scrooloose/nerdtree'
" Nice fuzzy search
Plugin 'https://github.com/kien/ctrlp.vim'
" Provides Monokai
" Plugin 'https://github.com/flazz/vim-colorschemes'
Plugin 'crusoexia/vim-monokai'
" Better js indentation
Plugin 'https://github.com/pangloss/vim-javascript'
" Better js completions 
Plugin 'crusoexia/vim-javascript-lib'
" Autocompletion on tab
Plugin 'https://github.com/vim-scripts/AutoComplPop'
" Status line
Plugin 'https://github.com/powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
" Better cpp highlight
Plugin 'https://github.com/octol/vim-cpp-enhanced-highlight'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
let g:ctrlp_map = '<F3>'
map <F2> : NERDTreeToggle<CR>

colorscheme monokai
set t_Co=256

set number

nnoremap <C-Right> gT
nnoremap <C-Left> gT

" powerline settings
set laststatus=2
set term=xterm-256color
set termencoding=utf-8
set guifont=Ubuntu\ Mono\ derivative\ Powerline:8
let g:Powerline_symbols = 'fancy'

" show existing tab with 2 spaces width
set tabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
" On pressing tab, insert 4 spaces
set expandtab

set history=50    " keep 50 lines of command line history
set ruler   " show the cursor position all the time
set showcmd   " display incomplete commands
set incsearch   " do incremental searching
"set autoindent   " always set autoindenting on
set foldmethod=indent

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup    " keep a backup file (restore to previous version)
  set undofile    " keep an undo file (undo changes after closing)
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  set hlsearch
endif


if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif
