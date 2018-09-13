"""""""""""""""""""""""""""""""""""""""
" Guillermo Blanco Vimrc configuration
"""""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on
set wrap
set encoding=utf8

""" Start Vundle configuration

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

"""" Utility plugins
Plugin 'scrooloose/nerdtree'                                     " Tree explorer
Plugin 'https://github.com/ctrlpvim/ctrlp.vim'                   " Nice fuzzy search
Plugin 'Raimondi/delimitMate.git'                                " Auto closing braces, parens..., like sublime text
Plugin 'junegunn/fzf.vim'
Plugin 'junegunn/fzf'
Plugin 'godlygeek/tabular'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'} " Status line
Plugin 'chaoren/vim-wordmotion'                                  " Move in camelCase and snake_oil motions
Plugin 'junegunn/limelight.vim'                                  " Focused writting
Plugin 'junegunn/goyo.vim'                                       " Focused writting
Plugin 'bilalq/lite-dfm'                                       " Focused writting
" Plugin 'SirVer/ultisnips'                                        " Snippets engine, NEEDS Deoplete for menus
" Plugin 'ludovicchabant/vim-gutentags'                            " Automatic, powerful tags
" Plugin 'ervandew/supertab'
""" Project management
Plugin 'https://github.com/vimwiki/vimwiki'
Plugin 'https://github.com/tbabej/taskwiki'
""" Programming utilities
" Plugin 'honza/vim-snippets'       " Snippets are separated from the engine
" Plugin 'szw/vim-tags'
Plugin 'majutsushi/tagbar'
"""" Themes and appearance
Plugin 'crusoexia/vim-monokai'    " Provides Monokai
Plugin 'ryanoasis/vim-devicons'   " Pretty icons on the tree
"""" Completion
"" The rpc plugin fails because of python shared symbols, better compile
"" python with --shared symbols
" Plugin 'Shougo/deoplete.nvim.git'
" Plugin 'roxma/nvim-yarp.git'
" Plugin 'roxma/vim-hug-neovim-rpc.git'
" Plugin 'rkulla/pydiction.git'         " python dictionary completion
Plugin 'pangloss/vim-javascript'
Plugin 'crusoexia/vim-javascript-lib' " Better js completions
Plugin 'vim-scripts/AutoComplPop'     " Autocompletion on tab

"""" Programming languages
Plugin 'maksimr/vim-jsbeautify'
Plugin 'lervag/vimtex.git'            " TeX Plugin
Plugin 'vim-syntastic/syntastic'      " Syntax checking
" Column increment (must be downloaded by hand)
" https://vim.sourceforge.io/scripts/script.php?script_id=670
"Plugin 'https://github.com/Shougo/deoplete.nvim.git'
Plugin 'm0n0l0c0/vim-repl.git'        " python/nodejs repl

call vundle#end()            " required
filetype plugin indent on
""" End Vundle configuration

"""""""""""""""""""""""""""""""""""""""
" Vim Configuration section
"""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2
set softtabstop=2
set t_Co=256
set number
set ruler                      " show the cursor position all the time
set showcmd                    " display incomplete commands
set incsearch                  " do incremental searching
"set autoindent                " always set autoindenting on
set mouse=n                    " allow mouse interaction
set foldmethod=indent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set splitbelow                 " more natural splits
set splitright
set history=50                 " keep 50 lines of command line history
set undodir=~/.vim/undo//
set directory=~/.vim/swap//
set backupdir=~/.vim/backup//

" overwrite default
autocmd FileType python setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete

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

"""""""""""""""""""""""""""""""""""""""
" Plugins Configuration section
"""""""""""""""""""""""""""""""""""""""
""" powerline
set laststatus=2
set term=xterm-256color
set termencoding=utf-8
set guifont=Ubuntu\ Mono\ derivative\ Powerline:8
let g:Powerline_symbols = 'fancy'
""" ctrlp
let g:ctrlp_map = '<F3>'
""" latex
let g:vimtex_view_method = 'zathura'
" autoresize main tex window, too much log window from vimtex
autocmd VimResized *.tex exe 'resize ' . float2nr((&lines -1) * 0.8)
""" gutentags
"let g:gutentags_cache_dir = $HOME .'/.cache/guten_tags'
let g:gutentags_ctags_exclude = ['*.session.vim']
""" diction path
let g:pydiction_location = '/home/gb/.vim/bundle/pydiction/complete-dict' 
""" completor jedi path
let g:completor_python_binary = '/usr/lib/python2.7/site-packages/jedi/'
""" deoplete
let g:deoplete#enable_at_startup = 1
""" repl
let g:repl_ipython = 1
let g:repl_vertical = 1
""" Util Snippets
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
""" fzf
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }
" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
" Customize fzf colors to match your color scheme
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
""" Insertion Tabularize, by now it tabs on |, could be extended to anything
" inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
""" syntastic, ToDo := Test this out
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_loc_list_height=2
""" Ctags
let g:vim_tags_auto_generate  = 0
""" vimwiki
let g:taskwiki_use_python2 = 1
"""""""""""""""""""""""""""""""""""""""
" Appearance & Misc
"""""""""""""""""""""""""""""""""""""""
colorscheme monokai
""" Player function
function! Player(cmd)
  execute 'silent !playerctl ' . a:cmd | execute 'redraw!'
endfunction
" ALWAYS highlight todos
autocmd VimEnter,WinEnter * call TodoSyntax()
function TodoSyntax()
  syn match mTodo "\c\s*todo\s*\([:=]\{1,2}\)\?\s*" containedin=ALL
  hi def link mTodo Todo
endfunction
"""""""""""""""""""""""""""""""""""""""
" Keyboard maps
"""""""""""""""""""""""""""""""""""""""
""" nerdtree
map <F2> : NERDTreeToggle<CR>
""" move between tabs
nnoremap <C-Right> gT
nnoremap <C-Left> gT
""" split lines, like J to join
nnoremap K i<CR><Esc>
""" mpris play, pause, next, prev song
nnoremap <leader>ps :call Player('play-pause') <CR>
nnoremap <leader>>s :call Player('next') <CR>
nnoremap <leader><s :call Player('previous') <CR>
""" nice vertical terminal (defaults to horizontal split)
nnoremap <C-W>t :vertical term <CR>
" Shortcuts
nnoremap <leader>o :Files<CR>
nnoremap <leader>O :CtrlP<CR>
nnoremap <leader>w :w<CR>
"""" ToDo:= Test this out
" Mapping selecting Mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

"" Enable Elite mode, no arrows
let g:elite_mode=1
" Disable arrow movement, resize splits instead.
if get(g:, 'elite_mode')
  nnoremap <Up>    :resize -2<CR>
  nnoremap <Down>  :resize +2<CR>
  nnoremap <Left>  :vertical resize -2<CR>
  nnoremap <Right> :vertical resize +2<CR>
endif

